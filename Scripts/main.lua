-- ============================================================
--  Retro Rewind - Sidewalk Sign QoL
--  Version: 1.0
--
--  Lets you set the bonus value for each sidewalk sign ad type
--  individually. Values can be raised above or lowered below
--  the game default of 0.2.
--
--  HOW IT WORKS:
--  The AI Director polls the active sign bonus every ~1 second
--  via SidewalkSign_C:Return Bonus associated with Sale Ads Data.
--  This mod hooks that function and replaces the return value
--  with the configured amount before the Director receives it.
--  The game's data table and save file are never modified.
--
--  USAGE:
--  Edit config.lua, load your save, open the store.
--  Changes take effect within one second of the store opening.
-- ============================================================

local CONFIG = require("config")

-- ============================================================
-- INTERNAL
-- ============================================================

local P = "[SidewalkSign-QoL] "

local function log(msg)
    print(P .. msg .. "\n")
end

-- Maps the game's sale type byte to config table keys.
-- Confirmed via in-game testing against the native enum values.
local SALE_TYPE_MAP = {
    [1] = "MoreCustomers",
    [2] = "NewRelease",
    [3] = "Concessions",
    [4] = "Snacks",
    [5] = "ClearanceSale",
    -- [0] = "NotSet" intentionally excluded -- no bonus when sign is unset
}

-- ============================================================
-- VALIDATION
-- Runs once at startup to catch config errors early.
-- Invalid entries are skipped; valid ones still apply.
-- ============================================================
local function validateConfig()
    if type(CONFIG.bonuses) ~= "table" then
        log("Config error: 'bonuses' must be a table")
        return false
    end

    -- Build a reverse lookup so we can check for unknown keys
    local validKeys = {}
    for _, name in pairs(SALE_TYPE_MAP) do
        validKeys[name] = true
    end

    local allValid = true
    for key, value in pairs(CONFIG.bonuses) do
        if not validKeys[key] then
            log("Config warning: unknown ad type '" .. tostring(key) .. "' -- entry will be ignored")
            allValid = false
        elseif type(value) ~= "number" then
            log("Config error: value for '" .. key .. "' must be a number -- entry will be ignored")
            allValid = false
        elseif value < 0.0 then
            log("Config warning: value for '" .. key .. "' is below 0.0 -- will be clamped to 0.0")
        end
    end

    return allValid
end

-- ============================================================
-- CORE: Build the final bonus table from config.
-- Clamps values to >= 0.0.
-- Only entries that are present and valid are stored;
-- missing entries fall back to the native game value.
-- ============================================================
local function buildBonusTable()
    local bonuses = {}

    if type(CONFIG.bonuses) ~= "table" then return bonuses end

    local validKeys = {}
    for _, name in pairs(SALE_TYPE_MAP) do
        validKeys[name] = true
    end

    for key, value in pairs(CONFIG.bonuses) do
        if validKeys[key] and type(value) == "number" then
            bonuses[key] = math.max(0.0, value)
        end
    end

    return bonuses
end

-- ============================================================
-- HOOK REGISTRATION
--
-- Direct RegisterHook at startup fails because the Blueprint
-- class is not yet loaded when the mod initialises.
-- NotifyOnNewObject fires as soon as the first SidewalkSign_C
-- instance is created, at which point the class is guaranteed
-- to be available for hooking.
-- ============================================================
local hookRegistered = false

NotifyOnNewObject(
    "/Game/VideoStore/asset/prop/SidewalkSign/SidewalkSign.SidewalkSign_C",
    function(obj)
        -- Guard: only register once across multiple spawns
        if hookRegistered then return end
        hookRegistered = true

        ExecuteWithDelay(500, function()
            -- Build the bonus lookup once at hook registration time.
            -- Config is read-only after this point.
            local bonuses = buildBonusTable()

            local ok, err = pcall(function()
                RegisterHook(
                    "/Game/VideoStore/asset/prop/SidewalkSign/SidewalkSign.SidewalkSign_C:Return Bonus associated with Sale Ads Data",
                    -- Pre-hook: fires before the native function runs.
                    -- We override the bonus Out-param here so the native
                    -- call returns our value to the AI Director.
                    function(self, saleTypeParam, bonusParam)
                        pcall(function()
                            local saleType = saleTypeParam:get()
                            local typeName = SALE_TYPE_MAP[saleType]

                            -- Skip types we don't recognise (e.g. NotSet)
                            if not typeName then return end

                            -- Skip types not present in config;
                            -- the game's native value passes through unchanged
                            local configValue = bonuses[typeName]
                            if configValue == nil then return end

                            bonusParam:set(configValue)
                        end)
                    end
                )
            end)

            if ok then
                -- Log the active overrides so the player can verify config
                log("Hook active -- configured bonuses:")
                local validKeys = {}
                for _, name in pairs(SALE_TYPE_MAP) do
                    validKeys[name] = true
                end
                for _, typeName in pairs(SALE_TYPE_MAP) do
                    local value = buildBonusTable()[typeName]
                    if value ~= nil then
                        log("  " .. typeName .. " = " .. string.format("%.2f", value))
                    else
                        log("  " .. typeName .. " = (native default)")
                    end
                end
            else
                log("Hook error: " .. tostring(err))
            end
        end)
    end
)

-- ============================================================
validateConfig()
log("Sidewalk Sign QoL loaded.")
log("Open the store to activate configured bonuses.")