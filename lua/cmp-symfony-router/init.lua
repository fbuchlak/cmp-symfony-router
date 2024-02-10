local source = {}

function source.new()
    return setmetatable({}, { __index = source })
end

function source:is_available()
    if not vim.tbl_contains({ "php", "twig", "yaml" }, vim.bo.filetype) then
        return false
    end

    local cwd = vim.loop.cwd()

    local composer_path = cwd .. "/composer.json"
    local has_composer, _ = pcall(vim.loop.fs_stat, composer_path)
    if not has_composer then
        return false
    end

    local console_path = cwd .. "/bin/console"
    local has_console, _ = pcall(vim.loop.fs_stat, console_path)
    if not has_console or 1 ~= vim.fn.executable(console_path) then
        return false
    end

    return true
end

function source:complete(_, callback)
    local error = false

    require("plenary.job")
        :new({
            "bin/console",
            "debug:router",
            "--raw",
            "--no-interaction",
            "--format",
            "json",
            cwd = vim.loop.cwd(),
            on_stderr = function()
                error = true
            end,
            on_exit = function(job)
                if error then
                    return
                end

                local result = job:result()
                if "table" ~= type(result) then
                    return
                end

                local ok, json = pcall(vim.json.decode, table.concat(result))
                if not ok or "table" ~= type(json) then
                    return
                end

                callback({ items = require("cmp-symfony-router.util").create_items(json), isIncomplete = false })
            end,
        })
        :start()
end

return source
