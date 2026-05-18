-- ============================================================
--  Retro Rewind - Sidewalk Sign QoL
--  Version: 1.0.1
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

local function debug(msg)
    if CONFIG.Debug then
        log(msg)
    end
end

-- Maps the game's sale type byte to type name and config key.
-- Confirmed via in-game testing against the native enum values.
local SALE_TYPE_MAP = {
    [1] = { name = "MoreCustomers",  key = "bonusMoreCustomers"  },
    [2] = { name = "NewRelease",     key = "bonusNewRelease"     },
    [3] = { name = "Concessions",    key = "bonusConcessions"    },
    [4] = { name = "Snacks",         key = "bonusSnacks"         },
    [5] = { name = "ClearanceSale",  key = "bonusClearanceSale"  },
    -- [0] = "NotSet" intentionally excluded -- no bonus when sign is unset
}

-- ============================================================
-- VALIDATION
-- Runs once at startup to catch config errors early.
-- Invalid entries are skipped; valid ones still apply.
-- ============================================================
local function validateConfig()
    local allValid = true
    for _, entry in pairs(SALE_TYPE_MAP) do
        local value = CONFIG[entry.key]
        if value ~= nil then
            if type(value) ~= "number" then
                log("Config error: '" .. entry.key .. "' must be a number -- entry will be ignored")
                allValid = false
            elseif value < 0.0 then
                log("Config warning: '" .. entry.key .. "' is below 0.0 -- will be clamped to 0.0")
            end
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
    for _, entry in pairs(SALE_TYPE_MAP) do
        local value = CONFIG[entry.key]
        if type(value) == "number" then
            bonuses[entry.name] = math.max(0.0, value)
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
                            local saleType  = saleTypeParam:get()
                            local typeEntry = SALE_TYPE_MAP[saleType]

                            -- Skip types we don't recognise (e.g. NotSet)
                            if not typeEntry then return end

                            -- Skip types not present in config;
                            -- the game's native value passes through unchanged
                            local configValue = bonuses[typeEntry.name]
                            if configValue == nil then return end

                            bonusParam:set(configValue)
                        end)
                    end
                )
            end)

            if ok then
                log("Hook active")
                local activeBonuses = buildBonusTable()
                for _, entry in pairs(SALE_TYPE_MAP) do
                    local value = activeBonuses[entry.name]
                    if value ~= nil then
                        debug("  " .. entry.name .. " = " .. string.format("%.2f", value))
                    else
                        debug("  " .. entry.name .. " = (native default)")
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