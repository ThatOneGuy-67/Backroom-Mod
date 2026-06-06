local function ProcessSanityCommand(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    InitMod()

    if LocalPlayerCache.PlayerController.Character:IsA("/Game/Game/BPCharacter_Demo.BPCharacter_Demo_C") then
        StartHook()
        return ProcessSanity(LocalPlayerCache.PlayerController.PlayerState, true)
    else
        Log("Couldn't find player character (wrong map or not controlling character).")
        return true
    end
end

function ProcessSanity(PlayerState, bPrint)
    if not PlayerState:IsValid() then
        Log("Player State is invalid.")
        return true
    end

    if not SanityActive or not bPrint then
        SanityActive = true
        PlayerState.ShouldLowerSanity = false
        PlayerState.Sanity = 100.0
        if bPrint then Log("Infinite sanity on") end
    else
        SanityActive = false
        PlayerState.ShouldLowerSanity = true
        if bPrint then Log("Infinite sanity off") end
    end

    return true
end

RegisterConsoleCommandHandler("sanity", ProcessSanityCommand)