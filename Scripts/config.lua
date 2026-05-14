-- ============================================================
--  Retro Rewind - Sidewalk Sign QoL
--  CONFIGURATION FILE
--
--  The sidewalk sign lets you advertise one bonus at a time.
--  This mod lets you override the bonus value for each ad type
--  individually -- raise it above the default, or lower it.
--
--  HOW IT WORKS:
--  The game polls the active sign bonus every ~1 second and
--  feeds it into the AI Director's customer spawn calculation.
--  This mod intercepts that poll and returns your configured
--  value instead of the one stored in the game's data table.
--
--  BONUS VALUES:
--  The valid range is 0.0 to 1.0.
--
--    0.0  = no effect  (disables the bonus entirely)
--    0.2  = default for MoreCustomers
--    0.25 = default for NewRelease
--    0.5  = default for Concessions, Snacks, ClearanceSale
--    1.0  = maximum    (the strongest possible effect)
--
--  Values above 1.0 are technically accepted but untested.
--  Values below 0.0 are clamped to 0.0 automatically.
--
--  WHICH BONUS IS ACTIVE:
--  Only the bonus for the currently selected ad type has any
--  effect. You switch ad types in-game at the sidewalk sign.
--  Setting a value here for an inactive type has no effect
--  until you switch the sign to that type in-game.
--
--  AD TYPES AND WHAT THEY AFFECT:
--    MoreCustomers  --  increases customer spawn rate
--    NewRelease     --  bonus for renting new release films
--    Concessions    --  bonus for concession stand sales
--    Snacks         --  bonus for snack shelf sales
--    ClearanceSale  --  bonus for clearance bin purchases
--
--  TO RESTORE DEFAULT BEHAVIOUR:
--  Set a value back to 0.2, or remove the entry entirely.
--  Missing entries fall back to the game's native value.
--
--  EXAMPLE - raise two types, leave the rest at default:
--
--  return {
--      bonuses = {
--          MoreCustomers = 0.8,
--          Concessions   = 1.0,
--      }
--  }
-- ============================================================

return {
    bonuses = {
        MoreCustomers = 0.2,    -- default: 0.2  (20%)
        NewRelease    = 0.25,   -- default: 0.25 (25%)
        Concessions   = 0.5,    -- default: 0.5  (50%)
        Snacks        = 0.5,    -- default: 0.5  (50%)
        ClearanceSale = 0.5,    -- default: 0.5  (50%)
    }
}