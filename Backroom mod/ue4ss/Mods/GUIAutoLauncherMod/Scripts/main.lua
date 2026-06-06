local function log(message)
    print(string.format("[GUIAutoLauncherMod] %s", message))
end

local function current_mod_dir()
    local src = debug.getinfo(1, "S").source
    if src:sub(1, 1) == "@" then
        src = src:sub(2)
    end
    return src:match("^(.*[\\/])") or "./"
end

local EngineKeys = {
    Insert = {KeyName = FName("Insert")},
}

local LocalPlayerCache = nil
local GameInstance = nil
local started = false

local function launch_gui()
    local base_dir = current_mod_dir()
    local gui_script = base_dir .. "..\\..\\GUI\\awspam_gui.py"
    local command = string.format('cmd.exe /c start "" /B "C:\\Users\\Carso\\AppData\\Local\\Programs\\Python\\Python311\\pythonw.exe" "%s"', gui_script)

    local p = io.popen(command)
    if p then
        p:close()
        log("Sent launch command to GUI")
    else
        log("Failed to launch GUI: io.popen returned nil")
    end
end

local function update_cache()
    if not GameInstance or not GameInstance:IsValid() then
        GameInstance = FindFirstOf("GameInstance")
    end
    if GameInstance and GameInstance:IsValid() and not LocalPlayerCache then
        LocalPlayerCache = GameInstance.LocalPlayers[1]
    end
end

local function loop()
    update_cache()
    if not LocalPlayerCache or not LocalPlayerCache:IsValid() then
        return
    end

    local player_controller = LocalPlayerCache.PlayerController
    if player_controller and player_controller:IsValid() then
        if player_controller:WasInputKeyJustPressed(EngineKeys.Insert) then
            launch_gui()
        end
    end
end

local function init()
    if started then
        return
    end
    started = true

    launch_gui()
    LoopInGameThreadAfterFrames(1, loop)
end

init()
