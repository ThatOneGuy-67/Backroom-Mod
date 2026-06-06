local FancyFunctionLibrary = nil ---@type UObject|nil

local function ProcessGetPos(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    InitMod()

    if FancyFunctionLibrary == nil or not FancyFunctionLibrary:IsValid() then
        FancyFunctionLibrary = StaticFindObject("/Script/Backrooms.Default__BackroomsBPFunctionLibrary")
    end

    if LocalPlayerCache.PlayerController.Character:IsA("/Game/Game/BPCharacter_Demo.BPCharacter_Demo_C") then
        local PlayerLocation = LocalPlayerCache.PlayerController.Character:K2_GetActorLocation()
        local PlayerRotation = LocalPlayerCache.PlayerController:GetControlRotation()

        local result = string.format("setpos %f %f %f %f %f", PlayerLocation.X, PlayerLocation.Y, PlayerLocation.Z, PlayerRotation.Pitch, PlayerRotation.Yaw)
        if FancyFunctionLibrary:IsValid() and FullCommand:find("nocopy", 7) == nil then
            FancyFunctionLibrary:SaveToClipboard(result)
            Log("Copied to clipboard: " .. result)
        else
            Log(result)
        end
    else
        Log("Couldn't find player character (wrong map or not controlling character).")
    end

    return true
end

local function ProcessSetPos(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    InitMod()

    if FullCommand:sub(7):match("[^0-9_%-., ]") then
        Log("Command cannot contain letters or special symbols.")
        return true
    end

    if LocalPlayerCache.PlayerController.Character:IsA("/Game/Game/BPCharacter_Demo.BPCharacter_Demo_C") then
        if #Parameters == 3 then
            local NewPlayerLocation = {X = Parameters[1]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Y = Parameters[2]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Z = Parameters[3]:gsub("[,_]", {[","] = ".", ["_"] = ""})}
            LocalPlayerCache.PlayerController.Character:K2_SetActorLocation(NewPlayerLocation, false, {}, true)
        elseif #Parameters == 4 then
            local NewPlayerLocation = {X = Parameters[1]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Y = Parameters[2]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Z = Parameters[3]:gsub("[,_]", {[","] = ".", ["_"] = ""})}
            local OldPlayerRotation = LocalPlayerCache.PlayerController:GetControlRotation()
            local NewPlayerRotation = {Pitch = Parameters[4]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Yaw = OldPlayerRotation.Yaw, Roll = 0.0}
            LocalPlayerCache.PlayerController.Character:K2_SetActorLocation(NewPlayerLocation, false, {}, true)
            LocalPlayerCache.PlayerController:SetControlRotation(NewPlayerRotation)
        elseif #Parameters == 5 then
            local NewPlayerLocation = {X = Parameters[1]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Y = Parameters[2]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Z = Parameters[3]:gsub("[,_]", {[","] = ".", ["_"] = ""})}
            local NewPlayerRotation = {Pitch = Parameters[4]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Yaw = Parameters[5]:gsub("[,_]", {[","] = ".", ["_"] = ""}), Roll = 0.0}
            LocalPlayerCache.PlayerController.Character:K2_SetActorLocation(NewPlayerLocation, false, {}, true)
            LocalPlayerCache.PlayerController:SetControlRotation(NewPlayerRotation)
        else
            Log("Usage: setpos <X> <Y> <Z> <Pitch> <Yaw>")
        end
    else
        Log("Couldn't find player character (wrong map or not controlling character).")
    end
    

    return true
end

RegisterConsoleCommandHandler("getpos", ProcessGetPos)
RegisterConsoleCommandHandler("setpos", ProcessSetPos)