local enabled = false
local hooked = false
local CharacterCache = nil
local MovCompCache = nil
local KismetMathLibrary = nil

local NoClipAccelClampDefault = 2048.0

-- Movement code by ProjectBorealis - https://github.com/ProjectBorealis/PBCharacterMovement/blob/main/Source/PBCharacterMovement/Private/Character/PBPlayerMovement.cpp#L1282
local function MovementCallback()
    if enabled and MovCompCache:IsValid() and MovCompCache.bCheatFlying then
        if MovCompCache.Acceleration.X == 0.0 and MovCompCache.Acceleration.Y == 0.0 and MovCompCache.Acceleration.Z == 0.0 then
            MovCompCache.Velocity = {X = 0.0, Y = 0.0, Z = 0.0}
        else
            local LookRot = CharacterCache:GetControlRotation()
            local LookVec = KismetMathLibrary:GetForwardVector(LookRot)
            local LookVec2D = CharacterCache:GetActorForwardVector()
            LookVec2D.Z = 0.0
            local PerpendicularAccelSum = LookVec2D.X * MovCompCache.Acceleration.X + LookVec2D.Y * MovCompCache.Acceleration.Y
            local PerpendicularAccel = {X = (LookVec2D.X * PerpendicularAccelSum), Y = (LookVec2D.Y * PerpendicularAccelSum), Z = 0.0}
            local TangentialAccel = {X = (MovCompCache.Acceleration.X - PerpendicularAccel.X), Y = (MovCompCache.Acceleration.Y - PerpendicularAccel.Y), Z = (MovCompCache.Acceleration.Z)}
            local UnitAcceleration = MovCompCache.Acceleration
            local Dir = KismetMathLibrary:Vector_CosineAngle2D(UnitAcceleration, LookVec)
            local NoClipAccelClamp = NoClipAccelClampDefault
            CharacterCache.IsBurnedOut = false
            if (MovCompCache.bIsSprinting) then
                CharacterCache.Stamina = 45
                NoClipAccelClamp = NoClipAccelClamp * 2.0
            elseif (MovCompCache.bWantsToCrouch) then
                NoClipAccelClamp = NoClipAccelClamp * 0.5
            end
            local PerpendicularAccelSize2D = KismetMathLibrary:Sqrt(PerpendicularAccel.X * PerpendicularAccel.X + PerpendicularAccel.Y * PerpendicularAccel.Y)
            local VelocityUnclamped = {X = (LookVec.X * Dir * PerpendicularAccelSize2D + TangentialAccel.X), Y = (LookVec.Y * Dir * PerpendicularAccelSize2D + TangentialAccel.Y), Z = (LookVec.Z * Dir * PerpendicularAccelSize2D + TangentialAccel.Z)}
            MovCompCache.Velocity = KismetMathLibrary:ClampVectorSize(VelocityUnclamped, NoClipAccelClamp, NoClipAccelClamp)
        end
    else
        enabled = false
    end
end

local function ProcessNoclip(FullCommand, Parameters, Ar)
    GlobalAr = Ar
    
    InitMod()

    if LocalPlayerCache.PlayerController.Character:IsA("/Game/Game/BPCharacter_Demo.BPCharacter_Demo_C") then
        CharacterCache = LocalPlayerCache.PlayerController.Character
        MovCompCache = CharacterCache.CharacterMovement
        KismetMathLibrary = UEHelpers.GetKismetMathLibrary(false)

        if not enabled then
            enabled = true
            MovCompCache:SetMovementMode(5, 0);
            MovCompCache.bCheatFlying = true;
            CharacterCache:SetIsOverlapOnly(true)
            CharacterCache:SetActorEnableCollision(false);
            CharacterCache:SetMinPitch()
            LocalPlayerCache.PlayerController.PlayerCameraManager.ViewPitchMin = -89.9

            if not hooked then
                hooked = true
                RegisterHook("/Game/Game/BPCharacter_Demo.BPCharacter_Demo_C:CheckForwardMovementInput", MovementCallback)
            end
        
            Log("Noclip mode on")
        else
            enabled = false
            MovCompCache:SetMovementMode(1, 0);
            MovCompCache.bCheatFlying = false;
            CharacterCache:SetIsOverlapOnly(false)
            CharacterCache:SetActorEnableCollision(true);

            Log("Noclip mode off")
        end
    else
        Log("Couldn't find player character (wrong map or not controlling character).")
    end

    return true
end

RegisterConsoleCommandHandler("noclip", ProcessNoclip)
RegisterConsoleCommandHandler("nc", ProcessNoclip)