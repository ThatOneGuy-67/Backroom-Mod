local EngineKeys = {
    A = {KeyName = FName("A")},
    B = {KeyName = FName("B")},
    C = {KeyName = FName("C")},
    D = {KeyName = FName("D")},
    E = {KeyName = FName("E")},
    F = {KeyName = FName("F")},
    G = {KeyName = FName("G")},
    H = {KeyName = FName("H")},
    I = {KeyName = FName("I")},
    J = {KeyName = FName("J")},
    K = {KeyName = FName("K")},
    L = {KeyName = FName("L")},
    M = {KeyName = FName("M")},
    N = {KeyName = FName("N")},
    O = {KeyName = FName("O")},
    P = {KeyName = FName("P")},
    Q = {KeyName = FName("Q")},
    R = {KeyName = FName("R")},
    S = {KeyName = FName("S")},
    T = {KeyName = FName("T")},
    U = {KeyName = FName("U")},
    V = {KeyName = FName("V")},
    W = {KeyName = FName("W")},
    X = {KeyName = FName("X")},
    Y = {KeyName = FName("Y")},
    Z = {KeyName = FName("Z")},
    Left = {KeyName = FName("Left")},
    Up = {KeyName = FName("Up")},
    Right = {KeyName = FName("Right")},
    Down = {KeyName = FName("Down")},
    Zero = {KeyName = FName("Zero")},
    One = {KeyName = FName("One")},
    Two = {KeyName = FName("Two")},
    Three = {KeyName = FName("Three")},
    Four = {KeyName = FName("Four")},
    Five = {KeyName = FName("Five")},
    Six = {KeyName = FName("Six")},
    Seven = {KeyName = FName("Seven")},
    Eight = {KeyName = FName("Eight")},
    Nine = {KeyName = FName("Nine")},
    NumPadZero = {KeyName = FName("NumPadZero")},
    NumPadOne = {KeyName = FName("NumPadOne")},
    NumPadTwo = {KeyName = FName("NumPadTwo")},
    NumPadThree = {KeyName = FName("NumPadThree")},
    NumPadFour = {KeyName = FName("NumPadFour")},
    NumPadFive = {KeyName = FName("NumPadFive")},
    NumPadSix = {KeyName = FName("NumPadSix")},
    NumPadSeven = {KeyName = FName("NumPadSeven")},
    NumPadEight = {KeyName = FName("NumPadEight")},
    NumPadNine = {KeyName = FName("NumPadNine")},
    Multiply = {KeyName = FName("Multiply")},
    Add = {KeyName = FName("Add")},
    Subtract = {KeyName = FName("Subtract")},
    Decimal = {KeyName = FName("Decimal")},
    Divide = {KeyName = FName("Divide")},
    BackSpace = {KeyName = FName("BackSpace")},
    Tab = {KeyName = FName("Tab")},
    Enter = {KeyName = FName("Enter")},
    Pause = {KeyName = FName("Pause")},
    NumLock = {KeyName = FName("NumLock")},
    ScrollLock = {KeyName = FName("ScrollLock")},
    CapsLock = {KeyName = FName("CapsLock")},
    Escape = {KeyName = FName("Escape")},
    SpaceBar = {KeyName = FName("SpaceBar")},
    PageUp = {KeyName = FName("PageUp")},
    PageDown = {KeyName = FName("PageDown")},
    End = {KeyName = FName("End")},
    Home = {KeyName = FName("Home")},
    Insert = {KeyName = FName("Insert")},
    Delete = {KeyName = FName("Delete")},
    F1 = {KeyName = FName("F1")},
    F2 = {KeyName = FName("F2")},
    F3 = {KeyName = FName("F3")},
    F4 = {KeyName = FName("F4")},
    F5 = {KeyName = FName("F5")},
    F6 = {KeyName = FName("F6")},
    F7 = {KeyName = FName("F7")},
    F8 = {KeyName = FName("F8")},
    F9 = {KeyName = FName("F9")},
    F10 = {KeyName = FName("F10")},
    F11 = {KeyName = FName("F11")},
    F12 = {KeyName = FName("F12")},
    LeftShift = {KeyName = FName("LeftShift")},
    RightShift = {KeyName = FName("RightShift")},
    LeftControl = {KeyName = FName("LeftControl")},
    RightControl = {KeyName = FName("RightControl")},
    LeftAlt = {KeyName = FName("LeftAlt")},
    RightAlt = {KeyName = FName("RightAlt")},
    LeftCommand = {KeyName = FName("LeftCommand")},
    RightCommand = {KeyName = FName("RightCommand")},
    Semicolon = {KeyName = FName("Semicolon")},
    Equals = {KeyName = FName("Equals")},
    Comma = {KeyName = FName("Comma")},
    Underscore = {KeyName = FName("Underscore")},
    Period = {KeyName = FName("Period")},
    Slash = {KeyName = FName("Slash")},
    Tilde = {KeyName = FName("Tilde")},
    LeftBracket = {KeyName = FName("LeftBracket")},
    Backslash = {KeyName = FName("Backslash")},
    RightBracket = {KeyName = FName("RightBracket")},
    Quote = {KeyName = FName("Quote")},
    MouseScrollUp = {KeyName = FName("MouseScrollUp")},
    MouseScrollDown = {KeyName = FName("MouseScrollDown")},
    MouseWheelSpin = {KeyName = FName("MouseWheelSpin")},
    LeftMouseButton = {KeyName = FName("LeftMouseButton")},
    RightMouseButton = {KeyName = FName("RightMouseButton")},
    MiddleMouseButton = {KeyName = FName("MiddleMouseButton")},
    ThumbMouseButton = {KeyName = FName("ThumbMouseButton")},
    ThumbMouseButton2 = {KeyName = FName("ThumbMouseButton2")},
    Gamepad_Special_Left = {KeyName = FName("Gamepad_Special_Left")},
    Gamepad_Special_Right = {KeyName = FName("Gamepad_Special_Right")},
    Gamepad_FaceButton_Bottom = {KeyName = FName("Gamepad_FaceButton_Bottom")},
    Gamepad_FaceButton_Right = {KeyName = FName("Gamepad_FaceButton_Right")},
    Gamepad_FaceButton_Left = {KeyName = FName("Gamepad_FaceButton_Left")},
    Gamepad_FaceButton_Top = {KeyName = FName("Gamepad_FaceButton_Top")},
    Gamepad_LeftShoulder = {KeyName = FName("Gamepad_LeftShoulder")},
    Gamepad_RightShoulder = {KeyName = FName("Gamepad_RightShoulder")},
    Gamepad_LeftTrigger = {KeyName = FName("Gamepad_LeftTrigger")},
    Gamepad_RightTrigger = {KeyName = FName("Gamepad_RightTrigger")},
    Gamepad_DPad_Up = {KeyName = FName("Gamepad_DPad_Up")},
    Gamepad_DPad_Down = {KeyName = FName("Gamepad_DPad_Down")},
    Gamepad_DPad_Right = {KeyName = FName("Gamepad_DPad_Right")},
    Gamepad_DPad_Left = {KeyName = FName("Gamepad_DPad_Left")},
}

local Binds = {}
local hooked = false
local temphandle

local GlobalAr = nil

local LocalPlayerCache = nil ---@type UObject|nil
local KismetSystemLibrary = nil ---@type UObject|nil

local function Log(Message)
    if type(GlobalAr) == "userdata" and GlobalAr:type() == "FOutputDevice" then
        GlobalAr:Log(Message)
    else
        print("[ConsoleKeybindsMod] " .. Message .. "\n")
    end
end

local function current_mod_dir()
    local src = debug.getinfo(1, "S").source
    if src:sub(1, 1) == "@" then
        src = src:sub(2)
    end
    local scripts = src:match("^(.*[\\/])") or "./"
    return (scripts:gsub("[Ss][Cc][Rr][Ii][Pp][Tt][Ss][/\\]?$", ""))
end

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function loop()
    for key, command in pairs(Binds) do
        if LocalPlayerCache.PlayerController:WasInputKeyJustPressed(EngineKeys[key]) then
            KismetSystemLibrary:ExecuteConsoleCommand(nil, FString(command), LocalPlayerCache.PlayerController)
        end
    end
end

local function setup_loop()
    if not hooked then
        hooked = true
        LoopInGameThreadAfterFrames(1, loop)
    end
end

local function load()
    local file, err = io.open(current_mod_dir() .. "binds.cfg", "r")
    if not file then
        assert(err:sub(-25) == "No such file or directory", "Couldn't open binds.cfg - " .. err)
        return
    end

    for line in file:lines() do
        line = trim(line)

        if line ~= "" then
            local sepStart, sepEnd = line:find(":|:", 1, true)
            if sepStart then
                local key = trim(line:sub(1, sepStart - 1))
                local command = trim(line:sub(sepEnd + 1))

                if key ~= "" and command ~= "" then
                    Binds[key] = command
                end
            end
        end
    end

    file:close()

    for _ in pairs(Binds) do
        setup_loop()
        break
    end
end

local function save()
    local file, err = io.open(current_mod_dir() .. "binds.cfg", "w")
    if not file then
        error("Couldn't open binds.cfg - " .. err)
        return
    end

    local keys = {}
    for key in pairs(Binds) do
        keys[#keys + 1] = key
    end
    table.sort(keys)

    for _, key in ipairs(keys) do
        local command = Binds[key]
        file:write(key, ":|:", command, "\n")
    end

    file:close()
end

local function InitMod()
    local GameInstance = FindFirstOf("GameInstance")
    LocalPlayerCache = GameInstance.LocalPlayers[1]
    if not GameInstance:IsValid() or not LocalPlayerCache:IsValid() then
        return
    end
    KismetSystemLibrary = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")

    CancelDelayedAction(temphandle)
    ExecuteAsync(load)
end

local function ProcessBind(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    if #Parameters == 0 then
        Log("Usage: bind <Key> <Command>")
    elseif #Parameters == 1 then
        local key = Parameters[1]:upper()
        if EngineKeys[key] then
            Log(string.format("\'%s\' : \"%s\"", key, Binds[key]))
        else
            Log("Invalid key. Use \"listkeys\" to get all possible keys.")
        end
    else
        if FullCommand:match("[^A-Za-z0-9_%-. ]") then
            Log("Command cannot contain special symbols.")
            return true
        end

        local key = Parameters[1]:upper()
        if not EngineKeys[key] then
            Log("Invalid key. Use \"listkeys\" to get all possible keys.")
            return true
        end

        local command = FullCommand:gsub("^bind " .. Parameters[1] .. "%s+", ""):match("^%s*(.-)%s*$")

        Binds[key] = command
        save()
        setup_loop()
        Log(string.format("Set \'%s\' to execute \"%s\"", key, command))
    end

    return true
end

local function ProcessBinds(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    local keys = {}
    for key in pairs(Binds) do
        keys[#keys + 1] = key
    end
    table.sort(keys)

    Log("Current custom keybinds:")
    for _, key in ipairs(keys) do
        local command = Binds[key]
        Log(string.format("    \'%s\' : \"%s\"", key, command))
    end

    return true
end

local function ProcessUnBind(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    if #Parameters == 1 then
        local key = Parameters[1]:upper()
        if EngineKeys[key] then
            Binds[key] = nil
            save()
            Log(string.format("Removed keybind \'%s\'", key))
        else
            Log("Invalid key. Use \"listkeys\" to get all possible keys.")
        end        
    else
        Log("Usage: unbind <Key>")
    end

    return true
end

local function ProcessUnBindAll(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    for key in pairs(Binds) do
        Binds[key] = nil
    end

    save()
    Log("Removed all binds")

    return true
end

-- TODO: Somehow fix this function freezing the game for an insane amount of time
local function ProcessListKeys(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    local p = io.popen("clip", "w")
    if p then
        p:write("https://gist.github.com/Reokin/cd7f113c2b405e35e8f0afe7d92443a4")
        p:close()
        Log("Copied to clipboard: https://gist.github.com/Reokin/cd7f113c2b405e35e8f0afe7d92443a4")
    else
        Log([[Couldn't copy to clipboard, printed to UE4SS console.
        https://gist.github.com/Reokin/cd7f113c2b405e35e8f0afe7d92443a4]])
        print("[ConsoleKeybindsMod] https://gist.github.com/Reokin/cd7f113c2b405e35e8f0afe7d92443a4")
    end

    return true
end

if EngineTickAvailable then

    RegisterConsoleCommandHandler("bind", ProcessBind)
    RegisterConsoleCommandHandler("binds", ProcessBinds)
    RegisterConsoleCommandHandler("unbind", ProcessUnBind)
    RegisterConsoleCommandHandler("unbindall", ProcessUnBindAll)
    RegisterConsoleCommandHandler("listkeys", ProcessListKeys)

    temphandle = LoopInGameThreadAfterFrames(1, InitMod)

else

    error("[ConsoleKeybindsMod] HookEngineTick is required for this mod.")

end