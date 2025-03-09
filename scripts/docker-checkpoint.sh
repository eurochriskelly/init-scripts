#!/bin/bash
# docker-checkpoint: Snapshot & restore a running container (including its volumes)
# Usage:
#   docker-checkpoint --snapshot <snapshot_name>
#   docker-checkpoint --restore <snapshot_name>

SNAPSHOT_DIR_BASE="/tmp/docker-snapshots"

usage() {
    echo "Usage: $0 --snapshot <snapshot_name>"
    echo "       $0 --restore <snapshot_name>"
    exit 1
}

[[ $# -ne 2 ]] && usage

MODE=$1
SNAPSHOT_NAME=$2
SNAPSHOT_DIR="${SNAPSHOT_DIR_BASE}/${SNAPSHOT_NAME}"

if [[ "$MODE" == "--snapshot" ]]; then
    # Create directory to hold snapshot data
    mkdir -p "${SNAPSHOT_DIR}/volumes"

    # Build container list using a while-read loop
    containers=()
    while IFS= read -r line; do
        containers+=("$line")
    done < <(docker ps --format '{{.ID}}: {{.Names}}')

    if [[ ${#containers[@]} -eq 0 ]]; then
        echo "No running containers found."
        exit 1
    fi

    echo "Select a container to snapshot:"
    select container in "${containers[@]}"; do
        if [[ -n "$container" ]]; then
            # Extract container ID (everything before the colon)
            SELECTED_CONTAINER=$(echo "$container" | cut -d':' -f1)
            echo "Selected container: ${SELECTED_CONTAINER}"
            break
        else
            echo "Invalid selection. Try again."
        fi
    done

    # Commit the container state to a new image tag
    SNAPSHOT_IMAGE="snapshot-${SNAPSHOT_NAME}"
    docker commit "${SELECTED_CONTAINER}" "${SNAPSHOT_IMAGE}"

    # Save full container inspect for reference
    docker inspect "${SELECTED_CONTAINER}" > "${SNAPSHOT_DIR}/container_inspect.json"

    # Extract volume mounts (only type "volume")
    VOLUME_MOUNTS=$(docker inspect "${SELECTED_CONTAINER}" | jq '.[0].Mounts | map(select(.Type=="volume"))')
    echo "${VOLUME_MOUNTS}" > "${SNAPSHOT_DIR}/volumes.json"

    COUNT=$(echo "${VOLUME_MOUNTS}" | jq 'length')
    if [[ $COUNT -gt 0 ]]; then
        echo "Found ${COUNT} volume(s). Backing up volumes..."
        for (( i=0; i<COUNT; i++ )); do
            VOLUME_NAME=$(echo "${VOLUME_MOUNTS}" | jq -r ".[$i].Name")
            DESTINATION=$(echo "${VOLUME_MOUNTS}" | jq -r ".[$i].Destination")
            echo "Backing up volume '${VOLUME_NAME}' (mounted at ${DESTINATION})..."
            docker run --rm \
              -v "${VOLUME_NAME}":/volume \
              -v "${SNAPSHOT_DIR}/volumes":/backup \
              alpine:latest sh -c "tar -czf /backup/${VOLUME_NAME}.tar.gz -C /volume ."
        done
    else
        echo "No volumes found for the container."
    fi

    echo "Snapshot saved in ${SNAPSHOT_DIR}."

elif [[ "$MODE" == "--restore" ]]; then
    if [[ ! -d "${SNAPSHOT_DIR}" ]]; then
        echo "Snapshot '${SNAPSHOT_NAME}' not found in ${SNAPSHOT_DIR_BASE}"
        exit 1
    fi

    # Prepare volume restore options
    VOLUME_OPTS=""
    if [[ -f "${SNAPSHOT_DIR}/volumes.json" ]]; then
        VOLUME_MOUNTS=$(cat "${SNAPSHOT_DIR}/volumes.json")
        COUNT=$(echo "${VOLUME_MOUNTS}" | jq 'length')
        if [[ $COUNT -gt 0 ]]; then
            echo "Restoring ${COUNT} volume(s)..."
            for (( i=0; i<COUNT; i++ )); do
                ORIG_VOLUME=$(echo "${VOLUME_MOUNTS}" | jq -r ".[$i].Name")
                DESTINATION=$(echo "${VOLUME_MOUNTS}" | jq -r ".[$i].Destination")
                RESTORE_VOLUME="restore-${SNAPSHOT_NAME}-${ORIG_VOLUME}"
                docker volume rm "${RESTORE_VOLUME}" 2>/dev/null || true
                docker volume create "${RESTORE_VOLUME}"
                echo "Restoring volume '${RESTORE_VOLUME}' for mount point ${DESTINATION}..."
                docker run --rm \
                  -v "${RESTORE_VOLUME}":/volume \
                  -v "${SNAPSHOT_DIR}/volumes":/backup \
                  alpine:latest sh -c "rm -rf /volume/* && tar -xzf /backup/${ORIG_VOLUME}.tar.gz -C /volume"
                VOLUME_OPTS+=" -v ${RESTORE_VOLUME}:${DESTINATION}"
            done
        fi
    fi

    # Run a new container from the snapshot image with the restored volumes attached,
    # specifying --platform linux/amd64 to match the original architecture.
    SNAPSHOT_IMAGE="snapshot-${SNAPSHOT_NAME}"
    echo "Restoring container from image '${SNAPSHOT_IMAGE}'..."
    echo "Note: Using '--platform linux/amd64' to ensure architecture compatibility."
    docker run -d --platform linux/amd64 ${VOLUME_OPTS} "${SNAPSHOT_IMAGE}"
else
    usage
fi
