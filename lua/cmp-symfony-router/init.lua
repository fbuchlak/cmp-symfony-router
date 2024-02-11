local source = {}

local path_separator = vim.loop.os_uname().version:match("Windows") and "\\" or "/"

local default_config = {
    console_command = { "php", "bin/console" },
    cwd = nil,
    cwd_files = { "composer.json", "bin/console" },
    filetypes = { "php", "twig" },
}

function source.new()
    return setmetatable({}, { __index = source })
end

function source.complete(_, params, callback)
    local opts = vim.tbl_extend("force", vim.deepcopy(default_config), vim.deepcopy(params.option or {}))
    vim.validate({
        console_command = { opts.console_command, "table" },
        cwd = { opts.cwd, "string", true },
        cwd_files = { opts.cwd_files, "table" },
        filetypes = { opts.filetypes, "table" },
    })

    if not vim.tbl_contains(opts.filetypes, vim.bo.filetype) then
        return callback({ items = {}, isIncomplete = false })
    end

    local cwd = opts.cwd or vim.loop.cwd()
    for _, fname in ipairs(opts.cwd_files) do
        local fpath = cwd .. path_separator .. fname
        local ok, stat = pcall(vim.loop.fs_stat, fpath)
        if not ok or nil == stat then
            return callback({ items = {}, isIncomplete = false })
        end
    end

    local command = table.remove(opts.console_command, 1)
    local args = opts.console_command
    vim.list_extend(args, { "debug:router", "--raw", "--no-interaction", "--format", "json" })

    local stderr = false
    require("plenary.job")
        :new({
            command = command,
            args = args,
            cwd = cwd,
            on_stderr = function()
                stderr = true
            end,
            on_exit = function(job)
                if stderr then
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
