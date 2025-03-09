local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

ls.add_snippets("xquery", {
    s("lll", {
        t("let $_ := xdmp:log(("),
        t('"LLLL: '),
        i(1, "message"),
        t('", "'),
        rep(1),  -- Reuse the first insert node
        t('"))')
    }),
})
