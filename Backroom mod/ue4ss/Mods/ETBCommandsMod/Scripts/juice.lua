local function ProcessJuiceCommand(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    InitMod()

    if LocalPlayerCache.PlayerController.Character:IsA("/Game/Game/BPCharacter_Demo.BPCharacter_Demo_C") then
        StartHook()
        return ProcessJuice(LocalPlayerCache.PlayerController.Character, true)
    else
        Log("Couldn't find player character (wrong map or not controlling character).")
        return true
    end
end

function ProcessJuice(Character, bPrint)
    if not Character:IsValid() then
        Log("Player Character is invalid.")
        return true
    end

    if not JuiceActive or not bPrint then
        JuiceActive = true
        Character.CharacterMovement.MaxWalkSpeed = 675
        Character.IsBurnedOut = true
        if bPrint then Log("Infinite juice effect on") end
    else
        JuiceActive = false
        Character.CharacterMovement.MaxWalkSpeed = Character.WalkSpeed
        Character.IsBurnedOut = false
        if bPrint then Log("Infinite juice effect off") end
    end

    return true
end

RegisterConsoleCommandHandler("juice", ProcessJuiceCommand)
RegisterConsoleCommandHandler("j", ProcessJuiceCommand)