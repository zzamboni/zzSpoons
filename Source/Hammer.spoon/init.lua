--- === Hammer ===
---
--- Automate some Hammerspoon configuration tasks
---
--- Download: https://github.com/zzamboni/zzSpoons/raw/master/Spoons/Hammer.spoon.zip

local obj={}
obj.__index = obj

-- Metadata
obj.name = "Hammer"
obj.version = "0.1"
obj.author = "Diego Zamboni <diego@zzamboni.org>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.key_reload_config = nil
obj.key_toggle_console = nil
obj.configFileWatcher = nil

--- Hammer.auto_reload_config
--- Variable
--- If true, automatically reload Hammerspoon config when any `.lua` files inside `hs.configdir` changes
obj.auto_reload_config = true

--- Hammer.install_cli
--- Variable
--- If true, install the `hs` command line tool
obj.install_cli = true

--- Hammer.spoon_action_mappings
--- Variable
--- Table containing mappings from action names to functions, for binding hotkeys and BTT triggers
obj.spoon_action_mappings = {
  config_reload = function() hs.reload() end,
  toggle_console = hs.toggleConsole,
}

--- Hammer:reloadConfig()
--- Method
--- Manually reload configuration (wrapper around `hs.reload`)
function obj:reloadConfig(param)
   hs.reload()
   return self
end

--- Hammer:autoReloadConfig(files)
--- Method
--- Reload config only if any of the Lua files in `files` have changed
function obj:autoReloadConfig(files)
   local doReload = false
   for _,file in pairs(files) do
      if file:sub(-4) == ".lua" and (not string.match(file, '/[.]#')) then
         doReload = true
      end
   end
   if doReload then
      self:reloadConfig()
   end
   return self
end

--- Hammer:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for Hammer
---
--- Parameters:
---  * mapping - A table containing hotkey objifier/key details for the following items:
---   * config_reload - Manually trigger a config reload
function obj:bindHotkeys(mapping)
  hs.spoons.bindHotkeysToSpec(obj.spoon_action_mappings, mapping)
end

--- Hammer:start()
--- Method
--- Start the Spoon. At the moment this includes:
---  * Set up the file watcher for auto-config-reload
function obj:start()
   if self.auto_reload_config then
      self.configFileWatcher = hs.pathwatcher.new(hs.configdir, function(paths) self:autoReloadConfig(paths) end)
      self.configFileWatcher:start()
   end
end

function obj:init()
   if self.install_cli then
      hs.ipc.cliInstall()
   end
   return self
end

return obj
