# cmp-symfony-router

[symfony routes](https://symfony.com/doc/current/routing.html#debugging-routes) source for [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

## Dependencies

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) is required

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "fbuchlak/cmp-symfony-router",
    dependencies = { "nvim-lua/plenary.nvim" }
},
```

## Setup

Add `symfony_router` as cmp source

```lua
require("cmp").setup {
    sources = {
        {
            name = "symfony_router",
            -- these options are default, you don't need to include them in setup
            option = {
                console_command = { "php", "bin/console" }, -- see Configuration section
                cwd = nil, -- string|nil Defaults to vim.loop.cwd()
                cwd_files = { "composer.json", "bin/console" }, -- all these files must exist in cwd to trigger completion
                filetypes = { "php", "twig" },
            }
        },
    },
}
```

## Configuration

### console_command

Defines symfony console executable

```lua
-- examples
{ "bin/console" } -- call console executable directly
{ "symfony", "console" } -- using symfony cli
{ "docker", "exec", "CONTAINER_NAME", "php", "bin/console" } -- docker
{ "docker", "compose", "exec", "SERVICE_NAME", "php", "bin/console" } -- docker compose
```
