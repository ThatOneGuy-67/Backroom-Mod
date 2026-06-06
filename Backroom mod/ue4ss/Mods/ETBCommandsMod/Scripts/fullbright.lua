local enabled = false

local function ProcessFullbright(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    InitMod()

    if not enabled then
        enabled = true
        UEHelpers.GetKismetSystemLibrary(false):ExecuteConsoleCommand(nil, FString("PREVVIEWMODE"), LocalPlayerCache.PlayerController)
    else
        enabled = false
        UEHelpers.GetKismetSystemLibrary(false):ExecuteConsoleCommand(nil, FString("NEXTVIEWMODE"), LocalPlayerCache.PlayerController)
    end

    return true
end

RegisterConsoleCommandHandler("fullbright", ProcessFullbright)
RegisterConsoleCommandHandler("fb", ProcessFullbright)