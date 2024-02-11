---@class cmp_symfony_router.Options
---@field console_command? string[]
---@field cwd? string
---@field cwd_files? string[]
---@field filetypes? string[]

---@class cmp_symfony_router.RouteDefaults: table<string, mixed>
---@field _locale? string
---@field _canonical_route? string
---@field _controller? string

---@class cmp_symfony_router.RouteRequirements: table<string, string>
---@field _locale? string

---@class cmp_symfony_router.RouteOptions
---@field compiler_class string
---@field utf8 boolean

---@class cmp_symfony_router.Route
---@field path string
---@field pathRegex string
---@field host string
---@field hostRegex string
---@field scheme string
---@field method string
---@field class string
---@field defaults cmp_symfony_router.RouteDefaults
---@field requirements cmp_symfony_router.RouteRequirements
---@field options cmp_symfony_router.RouteOptions

---@alias cmp_symfony_router.Routes table<string, cmp_symfony_router.Route>

---@class cmp_symfony_router.ResolvedRoute: cmp_symfony_router.Route
---@field _controller? string
---@field _paths string[]
---@field _methods string[]
