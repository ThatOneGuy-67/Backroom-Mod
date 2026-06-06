local UEHelpers = require("UEHelpers")

local MOD_NAME = "DropAlmondWaterSpammer"

local KeyNames = {
    F5 = Key.F5,
    F6 = Key.F6,
    F7 = Key.F7,
    F8 = Key.F8,
    F9 = Key.F9,
    F10 = Key.F10,
}

local EngineKeys = {
    F5 = {KeyName = FName("F5")},
    F6 = {KeyName = FName("F6")},
    F7 = {KeyName = FName("F7")},
    F8 = {KeyName = FName("F8")},
    F9 = {KeyName = FName("F9")},
    F10 = {KeyName = FName("F10")},
}

local ItemAliases = {
    aw = "almondwater",
    almondwater = "almondwater",
    almondbottle = "almondconcentrate",
    eb = "energybar",
    fw = "firework",
    fg = "flaregun",
    j = "juice",
    lp = "liquidpain",
    jelly = "mothjelly",
    mj = "mothjelly",
    m = "mothjelly",
    r = "rope",
    t = "toy",
}

local MonsterClasses = {
    BP_Roaming_Smiler_C = true,
    Howler_BP_C = true,
    Bacteria_Roaming_BP_C = true,
    BP_SkinStealer_C = true,
    BP_Hound_C = true,
    BP_Moth_C = true,
}

local PlayerClasses = {
    BPCharacter_Demo_C = true,
    VRCharacter_Demo_Client_C = true,
    BP_BasePlayerController_C = true,
}

local Config = {
    command = "drop aw",
    amount = 1,
    speed_ms = 100,
    mode = "toggle",
    key = "F9",
    esp_monsters = false,
    esp_players = false,
    esp_exits = false,
}

local enabled = false
local last_drop_time = 0
local last_config_reload_time = os.clock() * 1000
local reload_interval_ms = 500

local function log(message)
    print(string.format("[%s] %s\n", MOD_NAME, message))
end

local function current_mod_dir()
    local src = debug.getinfo(1, "S").source
    if src:sub(1, 1) == "@" then
        src = src:sub(2)
    end

    local scripts_dir = src:match("^(.*[\\/])") or "./"
    return scripts_dir:gsub("[Ss][Cc][Rr][Ii][Pp][Tt][Ss][/\\]?$", "")
end

local function config_path()
    return current_mod_dir() .. "config.cfg"
end

local function trim(value)
    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function clamp_number(value, min_value, max_value, fallback)
    value = tonumber(value)
    if not value then
        return fallback
    end

    if value < min_value then
        return min_value
    end

    if value > max_value then
        return max_value
    end

    return math.floor(value)
end

local function to_boolean(value)
    if value == nil then
        return false
    end

    value = tostring(value):lower()
    return value == "true" or value == "1"
end

local function save_config()
    local file, err = io.open(config_path(), "w")
    if not file then
        log("Could not save config: " .. tostring(err))
        return
    end

    file:write("command=", Config.command, "\n")
    file:write("amount=", tostring(Config.amount), "\n")
    file:write("speed_ms=", tostring(Config.speed_ms), "\n")
    file:write("mode=", Config.mode, "\n")
    file:write("key=", Config.key, "\n")
    file:write("esp_monsters=", tostring(Config.esp_monsters), "\n")
    file:write("esp_players=", tostring(Config.esp_players), "\n")
    file:write("esp_exits=", tostring(Config.esp_exits), "\n")
    file:close()
end

local function load_config()
    local file = io.open(config_path(), "r")
    if not file then
        save_config()
        return
    end

    for line in file:lines() do
        local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
        if key and value then
            if key == "command" and value ~= "" then
                Config.command = value
            elseif key == "amount" then
                Config.amount = clamp_number(value, 1, 50, Config.amount)
            elseif key == "speed_ms" then
                Config.speed_ms = clamp_number(value, 10, 5000, Config.speed_ms)
            elseif key == "mode" and (value == "toggle" or value == "hold") then
                Config.mode = value
            elseif key == "key" and KeyNames[value:upper()] then
                Config.key = value:upper()
            elseif key == "esp_monsters" then
                Config.esp_monsters = to_boolean(value)
            elseif key == "esp_players" then
                Config.esp_players = to_boolean(value)
            elseif key == "esp_exits" then
                Config.esp_exits = to_boolean(value)
            end
        end
    end

    file:close()
end

local function get_player_controller()
    local game_instance = UEHelpers.GetGameInstance()
    if not game_instance or not game_instance:IsValid() then
        return nil
    end

    local local_player = game_instance.LocalPlayers[1]
    if not local_player or not local_player:IsValid() then
        return nil
    end

    local player_controller = local_player.PlayerController
    if not player_controller or not player_controller:IsValid() then
        return nil
    end

    return player_controller
end

local function get_player_character()
    local player_controller = get_player_controller()
    if not player_controller then
        return nil
    end

    local character = player_controller.Character
    if not character or not character:IsValid() then
        return nil
    end

    return character
end

local function normalize_item(item)
    item = trim(item or ""):lower()
    return ItemAliases[item] or item
end

local function run_direct_drop_or_give(command)
    local action, item = command:lower():match("^(%S+)%s+(%S+)")
    if action ~= "drop" and action ~= "d" and action ~= "give" and action ~= "g" then
        return false
    end

    item = normalize_item(item)
    local character = get_player_character()
    if not character then
        return true
    end

    if not character:IsA("/Game/Game/BPCharacter_Demo.BPCharacter_Demo_C") then
        return true
    end

    if action == "give" or action == "g" then
        character:InvAddByName(FName(item))
    else
        character:DropItem_SERVER(FName(item))
    end

    return true
end

local function run_console_command(command)
    local player_controller = get_player_controller()
    if not player_controller then
        return
    end

    local kismet_system_library = UEHelpers.GetKismetSystemLibrary(false)
    if not kismet_system_library or not kismet_system_library:IsValid() then
        return
    end

    kismet_system_library:ExecuteConsoleCommand(nil, FString(command), player_controller)
end

local function run_spam_command()
    for _ = 1, Config.amount do
        if not run_direct_drop_or_give(Config.command) then
            run_console_command(Config.command)
        end
    end
end

local function get_actor_name(actor)
    if not actor or not actor:IsValid() then
        return "Unknown"
    end

    local ok, name = pcall(function()
        return actor:GetName()
    end)

    if ok and name and name ~= "" then
        return name
    end

    return tostring(actor)
end

local function get_actor_class_name(actor)
    if not actor or not actor:IsValid() then
        return ""
    end

    local ok, cls = pcall(function()
        return actor:GetClass()
    end)
    if not ok or not cls or not cls:IsValid() then
        return ""
    end

    local ok2, class_name = pcall(function()
        return cls:GetName()
    end)
    if not ok2 or not class_name then
        return ""
    end

    return class_name
end

local function is_local_player(actor)
    local player = get_player_character()
    return actor and player and actor == player
end

local function is_player_actor(actor)
    if not actor or not actor:IsValid() or is_local_player(actor) then
        return false
    end

    local class_name = get_actor_class_name(actor)
    if PlayerClasses[class_name] then
        return true
    end

    if actor:IsA("/Script/Engine.Pawn") and not is_local_player(actor) then
        return true
    end

    return false
end

local function is_monster(actor)
    if not actor or not actor:IsValid() or is_local_player(actor) then
        return false
    end

    local class_name = get_actor_class_name(actor)
    if MonsterClasses[class_name] then
        return true
    end

    local name = get_actor_name(actor):lower()
    if name:find("smiler", 1, true) or name:find("howler", 1, true) or name:find("bacteria", 1, true) or name:find("skinst", 1, true) or name:find("hound", 1, true) or name:find("moth", 1, true) then
        return true
    end

    return false
end

local function is_exit(actor)
    if not actor or not actor:IsValid() then
        return false
    end

    local class_name = get_actor_class_name(actor)
    if class_name:find("Exit", 1, true) or class_name:find("Door", 1, true) or class_name:find("Portal", 1, true) then
        return true
    end

    local name = get_actor_name(actor):lower()
    return name:find("exit", 1, true) or name:find("door", 1, true) or name:find("portal", 1, true) or name:find("teleport", 1, true)
end

local function draw_debug_string(world, location, text, color, duration)
    if not world or not world:IsValid() then
        return
    end

    pcall(function()
        UEHelpers.GetKismetSystemLibrary(false):DrawDebugString(world, location, FString(text), nil, color, duration, true)
    end)
end

local function draw_esp()
    if not (Config.esp_monsters or Config.esp_players or Config.esp_exits) then
        return
    end

    local world = UEHelpers.GetWorld()
    if not world or not world:IsValid() then
        return
    end

    local actors = FindAllOf("Actor")
    if not actors then
        return
    end

    for _, actor in ipairs(actors) do
        if actor and actor:IsValid() then
            local location = nil
            pcall(function()
                location = actor:K2_GetActorLocation()
            end)

            if location then
                if Config.esp_players and is_player_actor(actor) then
                    draw_debug_string(world, location, "PLAYER", FLinearColor(0, 1, 1, 1), 0.12)
                end

                if Config.esp_monsters and is_monster(actor) then
                    draw_debug_string(world, location, "MONSTER", FLinearColor(1, 0, 0, 1), 0.12)
                end

                if Config.esp_exits and is_exit(actor) then
                    draw_debug_string(world, location, "EXIT", FLinearColor(0, 1, 0, 1), 0.12)
                end
            end
        end
    end
end

local function esp_loop()
    draw_esp()
end

local function spam_key_is_down()
    local player_controller = get_player_controller()
    if not player_controller then
        return false
    end

    local engine_key = EngineKeys[Config.key]
    if not engine_key then
        return false
    end

    local ok, result = pcall(function()
        return player_controller:IsInputKeyDown(engine_key)
    end)

    return ok and result
end

local function should_spam()
    if Config.mode == "hold" then
        return spam_key_is_down()
    end

    return enabled
end

local function spam_loop()
    local now = os.clock() * 1000
    if now - last_config_reload_time >= reload_interval_ms then
        last_config_reload_time = now
        load_config()
    end

    if not should_spam() then
        return
    end

    if now - last_drop_time < Config.speed_ms then
        return
    end

    last_drop_time = now
    run_spam_command()
end

local function toggle_spammer_from_key(key_name)
    if key_name ~= Config.key then
        return
    end

    if Config.mode == "hold" then
        return
    end

    enabled = not enabled
    log(enabled and "ON." or "OFF.")
end

local function print_menu()
    log("Commands:")
    log("  awspam menu")
    log("  awspam status")
    log("  awspam command drop aw")
    log("  awspam amount 1-50")
    log("  awspam speed 10-5000")
    log("  awspam mode toggle|hold")
    log("  awspam key F5|F6|F7|F8|F9|F10")
    log("  awspam esp monsters on|off")
    log("  awspam esp players on|off")
    log("  awspam esp exits on|off")
    log("  awspam on / awspam off")
end

local function print_status()
    log(string.format("command=%s", Config.command))
    log(string.format("amount=%d", Config.amount))
    log(string.format("speed_ms=%d", Config.speed_ms))
    log(string.format("mode=%s", Config.mode))
    log(string.format("key=%s", Config.key))
    log(string.format("esp_monsters=%s", tostring(Config.esp_monsters)))
    log(string.format("esp_players=%s", tostring(Config.esp_players)))
    log(string.format("esp_exits=%s", tostring(Config.esp_exits)))
    log(string.format("enabled=%s", tostring(enabled)))
end

local function process_awspam(full_command, parameters, ar)
    local subcommand = (parameters[1] or "menu"):lower()

    if subcommand == "menu" or subcommand == "help" then
        print_menu()
        print_status()
        return true
    end

    if subcommand == "status" then
        print_status()
        return true
    end

    if subcommand == "on" then
        enabled = true
        log("ON.")
        return true
    end

    if subcommand == "off" then
        enabled = false
        log("OFF.")
        return true
    end

    if subcommand == "command" then
        local command = full_command:gsub("^%s*awspam%s+command%s+", "")
        if command == full_command or trim(command) == "" then
            log("Usage: awspam command drop aw")
            return true
        end

        Config.command = trim(command)
        save_config()
        log("Command set to: " .. Config.command)
        return true
    end

    if subcommand == "amount" then
        Config.amount = clamp_number(parameters[2], 1, 50, Config.amount)
        save_config()
        log("Amount set to: " .. tostring(Config.amount))
        return true
    end

    if subcommand == "speed" then
        Config.speed_ms = clamp_number(parameters[2], 10, 5000, Config.speed_ms)
        save_config()
        log("Speed set to: " .. tostring(Config.speed_ms) .. " ms")
        return true
    end

    if subcommand == "mode" then
        local mode = (parameters[2] or ""):lower()
        if mode ~= "toggle" and mode ~= "hold" then
            log("Usage: awspam mode toggle|hold")
            return true
        end

        Config.mode = mode
        enabled = false
        save_config()
        log("Mode set to: " .. Config.mode)
        return true
    end

    if subcommand == "key" then
        local key = (parameters[2] or ""):upper()
        if not KeyNames[key] then
            log("Usage: awspam key F5|F6|F7|F8|F9|F10")
            return true
        end

        Config.key = key
        enabled = false
        save_config()
        log("Key set to: " .. Config.key)
        return true
    end

    if subcommand == "esp" then
        local target = (parameters[2] or ""):lower()
        local action = (parameters[3] or ""):lower()
        if (target == "monsters" or target == "players" or target == "exits") and (action == "on" or action == "off") then
            local value = action == "on"
            if target == "monsters" then
                Config.esp_monsters = value
            elseif target == "players" then
                Config.esp_players = value
            elseif target == "exits" then
                Config.esp_exits = value
            end
            save_config()
            log(string.format("ESP %s set to %s", target, tostring(value)))
            return true
        end
        log("Usage: awspam esp monsters|players|exits on|off")
        return true
    end

    print_menu()
    return true
end

local function register_spam_key(key_name)
    local key = KeyNames[key_name]
    if not key then
        return
    end

    if IsKeyBindRegistered(key) then
        log(key_name .. " is already registered by another mod.")
        return
    end

    RegisterKeyBind(key, function() toggle_spammer_from_key(key_name) end)
end


load_config()

register_spam_key("F5")
register_spam_key("F6")
register_spam_key("F7")
register_spam_key("F8")
register_spam_key("F9")
register_spam_key("F10")

RegisterConsoleCommandHandler("awspam", process_awspam)
LoopInGameThreadWithDelay(20, spam_loop)
LoopInGameThreadWithDelay(100, esp_loop)

log("Loaded. Type 'awspam menu' in the UE4SS console.")
log("Current spam key: " .. Config.key)
