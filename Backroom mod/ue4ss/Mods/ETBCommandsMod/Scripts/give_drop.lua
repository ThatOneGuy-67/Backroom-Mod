local items = {
    ["almondconcentrate"] = true,
    ["almondwater"] = true,
    ["bugspray"] = true,
    ["camera"] = true,
    ["chainsaw"] = true,
    ["chainsawfast"] = true,
    ["crowbar"] = true,
    ["divinghelmet"] = true,
    ["energybar"] = true,
    ["firework"] = true,
    ["flaregun"] = true,
    ["glowstick"] = true,
    ["glowstickblue"] = true,
    ["glowstickred"] = true,
    ["glowstickyellow"] = true,
    ["juice"] = true,
    ["knife"] = true,
    ["lidar"] = true,
    ["liquidpain"] = true,
    ["mothjelly"] = true,
    ["rope"] = true,
    ["thermometer"] = true,
    ["ticket"] = true,
    ["toy"] = true,
    ["walkietalkie"] = true,
}

local aliases = {
    ["almondbottle"] = "almondconcentrate",
    ["aw"] = "almondwater",
    ["eb"] = "energybar",
    ["fw"] = "firework",
    ["fg"] = "flaregun",
    ["GlowstickGreen"] = "glowstick",
    ["j"] = "juice",
    ["lp"] = "liquidpain",
    ["jelly"] = "mothjelly",
    ["mj"] = "mothjelly",
    ["m"] = "mothjelly",
    ["r"] = "rope",
    ["t"] = "toy",
}

local commands = {
    ["gi"] = "give",
    ["g "] = "give",
    ["g"] = "give",
    ["dr"] = "drop",
    ["d "] = "drop",
    ["d"] = "drop",
}

local function ProcessSpawnItemCommand(FullCommand, Parameters, Ar)
    GlobalAr = Ar

    InitMod()

    local command = FullCommand:sub(1, 2)
    command = commands[command]

    if #Parameters < 1 then
        Log(string.format("Usage: %s <ItemName>\nAlias command: %s\nUse \"%s list\" to get all item names.", command, command:sub(1, 1), command))
        return true
    end

    local arg = Parameters[1]

    if arg:lower() == "list" then
        Log([[Available items (case-insensitive):
        AlmondConcentrate
        AlmondWater (Alias: aw)
        BugSpray
        Camera
        Chainsaw
        ChainsawFast
        Crowbar
        DivingHelmet
        EnergyBar (Alias: eb)
        Firework (Alias: fw)
        FlareGun (Alias: fg)
        GlowstickBlue
        GlowstickGreen
        GlowstickRed
        GlowstickYellow
        Juice (Alias: j)
        Knife
        Lidar
        LiquidPain (Alias: lp)
        MothJelly (Aliases: Jelly, mj, m)
        Rope (Alias: r)
        Thermometer
        Ticket
        Toy (Alias: t)
        WalkieTalkie]])
        return true
    end

    if aliases[arg:lower()] then
        arg = aliases[arg:lower()]
    end

    if not items[arg:lower()] then
        Log(string.format("Item not found.\nUse \"%s list\" to get all item names.", command))
        return true
    end

    if LocalPlayerCache.PlayerController.Character:IsA("/Game/Game/BPCharacter_Demo.BPCharacter_Demo_C") then
        if command:sub(1, 1) == "g" then
            LocalPlayerCache.PlayerController.Character:InvAddByName(FName(arg))
            Log(string.format("Added %s to your inventory.", arg))
        else
            LocalPlayerCache.PlayerController.Character:DropItem_SERVER(FName(arg))
            Log(string.format("Spawned and dropped %s.", arg))
        end

        return true
    else
        Log("Couldn't find player character (wrong map or not controlling character).")
        return true
    end
end

RegisterConsoleCommandHandler("give", ProcessSpawnItemCommand)
RegisterConsoleCommandHandler("g", ProcessSpawnItemCommand)
RegisterConsoleCommandHandler("drop", ProcessSpawnItemCommand)
RegisterConsoleCommandHandler("d", ProcessSpawnItemCommand)