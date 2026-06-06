UEHelpers = require("UEHelpers")

GlobalAr = nil
LocalPlayerCache = nil ---@type UObject|nil
local HookActive = false
JuiceActive = false
SanityActive = false

function Log(Message)
    if type(GlobalAr) == "userdata" and GlobalAr:type() == "FOutputDevice" then
        GlobalAr:Log(Message)
    else
        print("[ETBCommandsMod] " .. Message .. "\n")
    end
end

function InitMod()
    if LocalPlayerCache == nil or not LocalPlayerCache:IsValid() then
        local GameInstance = UEHelpers.GetGameInstance()
        LocalPlayerCache = GameInstance.LocalPlayers[1]
        if not GameInstance:IsValid() or not LocalPlayerCache:IsValid() then
            error("Couldn't find game instance or local player (game broken?)")
        end
    end
end

function StartHook()
    if not HookActive then
        HookActive = true
        RegisterBeginPlayPostHook(
        ---@param Context RemoteUnrealParam<AActor>
        function(Context)
            local actor = Context:get()
            local actor_name = actor:GetFName():ToString():sub(1, 8)

            if actor_name == "BPCharac" then
                PlayerController = LocalPlayerCache.PlayerController
                if PlayerController:IsValid() and PlayerController.Character:GetAddress() == actor:GetAddress() and JuiceActive then
                    ProcessJuice(PlayerController.Character, false)
                    return
                end
            end
            if actor_name == "MP_PS_C_" then
                PlayerController = LocalPlayerCache.PlayerController
                if PlayerController:IsValid() and PlayerController.PlayerState:GetAddress() == actor:GetAddress() and SanityActive then
                    ProcessSanity(PlayerController.PlayerState, false)
                    return
                end
            end

            if actor_name == "GM_MainM" or actor_name == "Lobby_GM" then
                JuiceActive = false
                SanityActive = false
                return
            end
        end)
    end
end

require("give_drop")
require("juice")
require("sanity")
require("fullbright")
require("noclip")
require("getset_pos")
require("aliases")