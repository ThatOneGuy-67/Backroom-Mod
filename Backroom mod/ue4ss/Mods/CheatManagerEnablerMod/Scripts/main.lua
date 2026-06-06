NotifyOnNewObject("/Script/Engine.PlayerController",
---@param ConstructedObject RemoteUnrealParam<APlayerController>
function(ConstructedObject)
    local CheatManagerClass = ConstructedObject.CheatClass
    if not CheatManagerClass:IsValid() then
        print("[CheatManagerEnabler] Controller:CheatClass is nullptr, using default CheatClass instead\n")
        
        CheatManagerClass = StaticFindObject("/Script/Engine.CheatManager") --[[@as UClass]]
    end
    
    if not CheatManagerClass:IsValid() then
        print("[CheatManagerEnabler] Couldn't find default CheatClass, therefore, could not enable Cheat Manager\n")
        return
    end
    
    local CreatedCheatManager = StaticConstructObject(CheatManagerClass, ConstructedObject)
    if CreatedCheatManager:IsValid() then
        print(string.format("[CheatManagerEnabler] Constructed CheatManager [0x%X]\n", CreatedCheatManager:GetAddress()))
        
        ConstructedObject.CheatManager = CreatedCheatManager
        print("[CheatManagerEnabler] Enabled CheatManager\n")
    else
        print("[CheatManagerEnabler] Was unable to construct CheatManager, therefore, could not enable Cheat Manager\n")
    end
end)