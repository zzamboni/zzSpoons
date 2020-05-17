--- === TurboBoost ===
---
--- A spoon to load/unload the Turbo Boost Disable kernel extension
--- from https://github.com/rugarciap/Turbo-Boost-Switcher.
---
--- Note: this uses sudo to load/unlos the kernel extension, so for it
--- to work from Hammerspoon, you need to configure sudo to be able to
--- load/unload the extension without a password, or configure the
--- load_kext_cmd and unload_kext_cmd variables to use some other
--- mechanism that prompts you for the credentials.
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/TurboBoost.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/TurboBoost.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "TurboBoost"
obj.version = "0.1"
obj.author = "Diego Zamboni <diego@zzamboni.org>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- TurboBoost.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('TurboBoost')

obj.menuBarItem = nil

--- TurboBoost.kext_path
--- Variable
--- Where the DisableTurboBoost.kext file is located.
obj.kext_path = "/Applications/Turbo Boost Switcher.app/Contents/Resources/DisableTurboBoost.64bits.kext"

--- TurboBoost.load_kext_cmd
--- Variable
--- Command to execute to load the DisableTurboBoost kernel
--- extension. This command must execute with root privileges and
--- either query the user for the credentials, or be configured
--- (e.g. with sudo) to run without prompting. The string "%s" in this
--- variable gets replaced with the value of
--- TurboBoost.kext_path
obj.load_kext_cmd = "/usr/bin/sudo /usr/bin/kextutil -v '%s'"

--- TurboBoost.unload_kext_cmd
--- Variable
--- Command to execute to unload the DisableTurboBoost kernel
--- extension. This command must execute with root privileges and
--- either query the user for the credentials, or be configured
--- (e.g. with sudo) to run without prompting. The string "%s" in this
--- variable gets replaced with the value of
--- TurboBoost.kext_path
obj.unload_kext_cmd = "/usr/bin/sudo /sbin/kextunload -v '%s'"

--- TurboBoost.check_kext_cmd
--- Variable
--- Command to execute to check whether the DisableTurboBoost kernel
--- extension is loaded.
obj.check_kext_cmd = "/usr/sbin/kextstat | grep com.rugarciap.DisableTurboBoost"

--- TurboBoost.notify
--- Variable
--- Boolean indicating whether notifications should be generated when
--- Turbo Boost is enabled/disabled.
obj.notify = true

--- TurboBoost.enabled_icon_path
--- Variable
--- Where to find the icon to use for the "Enabled" icon. Defaults to
--- using the one from the Turbo Boost application.
obj.enabled_icon_path = "/Applications/Turbo Boost Switcher.app/Contents/Resources/icon.tiff"

--- TurboBoost.disabled_icon_path
--- Variable
--- Where to find the icon to use for the "Disabled" icon. Defaults to
--- using the one from the Turbo Boost application.
obj.disabled_icon_path = "/Applications/Turbo Boost Switcher.app/Contents/Resources/icon_off.tiff"

--- TurboBoost:setState(state)
--- Method
--- Sets whether Turbo Boost should be disabled (kernel extension
--- loaded) or enabled (normal state, kernel extension not loaded).
---
--- Parameters:
---  * state - A boolean, false if Turbo Boost should be disabled
---    (load kernel extension), true if it should be enabled (unload
---    kernel extension if loaded).
---  * notify - Optional boolean indicating whether a notification
---    should be produced. If not given, the value of
---    TurboBoost.notify is used.
---
--- Returns:
---  * Boolean indicating new state
function obj:setState(state, notify)
  local curstatus = self:status()
  if curstatus ~= state then
    local cmd = string.format(obj.load_kext_cmd, obj.kext_path)
    if state then
      cmd = string.format(obj.unload_kext_cmd, obj.kext_path)
    end
    if notify == nil then
      notify = obj.notify
    end
    out,st,ty,rc = hs.execute(cmd)
    if not st then
      self.logger.ef("Error executing '%s'. Output: %s", cmd, out)
    else
      self:setDisplay(state)
      if notify then
        hs.notify.new({
            title = "Turbo Boost " .. (state and "enabled" or "disabled"),
            subTitle = "",
            informativeText = "",
            setIdImage = hs.image.imageFromPath(self.iconPathForState(state))
        }):send()
      end
    end
  end
  return self:status()
end

--- TurboBoost:status()
--- Method
--- Check whether Turbo Boost is enabled
---
--- Returns:
---  * true if TurboBoost is enabled (kernel ext not loaded), false otherwise.
function obj:status()
  local cmd = obj.check_kext_cmd
  out,st,ty,rc = hs.execute(cmd)
  return (not st)
end

--- TurboBoost:toggle()
--- Method
--- Toggle TurboBoost status
---
--- Returns:
---  * New TurboBoost status, after the toggle
function obj:toggle()
  self:setState(not self:status())
  return self:status()
end

--- TurboBoost:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for TurboBoost
---
--- Parameters:
---  * mapping - A table containing hotkey objifier/key details for the following items:
---   * hello - Say Hello
function obj:bindHotkeys(mapping)
  local spec = { toggle = self.toggle }
  hs.spoons.bindHotkeysToSpec(spec, mapping)
end

--- TurboBoost:start()
--- Method
--- Starts TurboBoost
---
--- Parameters:
---  * None
---
--- Returns:
---  * The TurboBoost object
function obj:start()
    if self.menuBarItem then self:stop() end
    self.menuBarItem = hs.menubar.new()
    self.menuBarItem:setClickCallback(self.clicked)
    self:setDisplay(self:status())

    return self
end

--- TurboBoost:stop()
--- Method
--- Stops TurboBoost
---
--- Parameters:
---  * None
---
--- Returns:
---  * The TurboBoost object
function obj:stop()
    if self.menuBarItem then self.menuBarItem:delete() end
    self.menuBarItem = nil
    return self
end

function obj.iconPathForState(state)
  if state then
    return obj.enabled_icon_path
  else
    return obj.disabled_icon_path
  end
end

function obj:setDisplay(state)
  obj.menuBarItem:setIcon(obj.iconPathForState(state))
end

function obj:clicked()
  obj:setDisplay(obj:toggle())
end

return obj
