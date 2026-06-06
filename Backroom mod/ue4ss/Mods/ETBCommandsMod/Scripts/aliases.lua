local PlayerCache = nil ---@type UObject|nil

local commands = {
    ["dc"] = "ToggleDebugCamera",
    ["t"] = "Teleport",
}

local function ProcessAliases(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    InitMod()

    local command = commands[FullCommand:sub(1, 2)]

    UEHelpers.GetKismetSystemLibrary(false):ExecuteConsoleCommand(nil, FString(command), LocalPlayerCache.PlayerController)

    return true
end

local function ProcessHelp(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    InitMod()

    Log([[All custom commands (Command : Alias), case-sensitive:
        give : g (Give an item directly into the inventory)
        drop : d (Drop an item on the ground)
        juice : j (Toggle infinite juice effect)
        sanity (Toggle infinite sanity)
        toggledebugcamera : dc (Toggle debug camera)
        teleport : t (Teleport to where you're looking)
        fullbright : fb (Toggle fullbright)
        noclip : nc (Toggle noclip mode)
        getpos (Copy current coordinates)
        setpos (Teleport to coordinates)
        bind (Bind a command to a key)
        binds (Print all current binds)
        unbind (Remove a custom bind)
        unbindall (Remove all custom binds)
        listkeys (List of all possible keys for bind)
        help : aliases (This message)]])
    return true
end

RegisterConsoleCommandHandler("dc", ProcessAliases)
RegisterConsoleCommandHandler("t", ProcessAliases)
RegisterConsoleCommandHandler("aliases", ProcessHelp)
RegisterConsoleCommandHandler("help", ProcessHelp)