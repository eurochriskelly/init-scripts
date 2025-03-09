local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("xquery", {
    s("lll", {
        t("let $_ := xdmp:log(('LLLL', 'hello'))")
    }),
})
