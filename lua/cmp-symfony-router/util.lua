local Util = {}
local H = {}

---@param routes cmp_symfony_router.Routes
function Util.create_items(routes)
    local resolved = {}
    for name, route in pairs(routes) do
        local route_name = route.defaults._canonical_route or name
        resolved[route_name] = resolved[route_name] or route

        resolved[route_name]._controller = route.defaults._controller
        resolved[route_name]._paths = resolved[route_name]._paths or {}
        if not vim.tbl_contains(resolved[route_name]._paths, route.path) then
            resolved[route_name]._paths[#resolved[route_name]._paths + 1] = route.path
        end

        resolved[route_name]._methods = resolved[route_name]._methods or {}
        for method in route.method:gmatch("%w+") do
            if not vim.tbl_contains(resolved[route_name]._methods, method) then
                resolved[route_name]._methods[#resolved[route_name]._methods + 1] = method
            end
        end
    end

    local items = {}
    for name, route in pairs(resolved) do
        items[#items + 1] = H.create_item(name, route)
    end

    return items
end

---@param name string
---@param route cmp_symfony_router.ResolvedRoute
function H.create_item(name, route)
    local documentation = { ("# %s"):format(name) }
    if route._controller ~= nil then
        vim.list_extend(documentation, { "", "## Controller", ("- `%s`"):format(route._controller) })
    end
    vim.list_extend(documentation, H.create_description_item_values("## Paths", route._paths))
    vim.list_extend(documentation, H.create_description_item_key_to_values("## Requirements", route.requirements))
    route.defaults._canonical_route = nil
    route.defaults._controller = nil
    route.defaults._locale = nil
    vim.list_extend(documentation, H.create_description_item_key_to_values("## Defaults", route.defaults))
    vim.list_extend(documentation, H.create_description_item_values("## Methods", route._methods))

    return {
        label = name,
        documentation = {
            kind = "markdown",
            value = table.concat(documentation, "\n"),
        },
    }
end

---@param n string
---@param tbl table
---@return string[]
function H.create_description_item_values(n, tbl)
    tbl = "table" == type(tbl) and tbl or {}
    local ret = {}
    for _, v in pairs(tbl) do
        ret[#ret + 1] = ("- `%s`"):format(v)
    end
    if 0 == #ret then
        return {}
    end
    return vim.tbl_flatten({ "", n, ret })
end

---@param n string
---@param tbl table
---@return string[]
function H.create_description_item_key_to_values(n, tbl)
    tbl = "table" == type(tbl) and tbl or {}
    local ret = {}
    for k, v in pairs(tbl) do
        ret[#ret + 1] = ("- `%s`: `%s`"):format(k, v)
    end
    if 0 == #ret then
        return {}
    end
    return vim.tbl_flatten({ "", n, ret })
end

return Util
