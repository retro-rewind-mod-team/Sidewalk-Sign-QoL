-- ============================================================
--  Retro Rewind - Sidewalk Sign QoL
--  CONFIGURATION FILE
--
--  Set the bonus strength for each sidewalk sign ad type.
--  Valid range: 0.0 to 1.0
--
--    0.0  = disables the bonus entirely
--    0.2  = game default for MoreCustomers
--    0.25 = game default for NewRelease
--    0.5  = game default for Concessions, Snacks, ClearanceSale
--    1.0  = maximum effect
--
--  Only the active ad type has any effect.
--  Switch ad types at the sidewalk sign in-game.
-- ============================================================

return {

    Debug = false,

    bonusMoreCustomers = 0.2,    -- increases customer spawn rate
    bonusNewRelease    = 0.25,   -- bonus for renting new releases
    bonusConcessions   = 0.5,    -- bonus for concession stand sales
    bonusSnacks        = 0.5,    -- bonus for snack shelf sales
    bonusClearanceSale = 0.5,    -- bonus for clearance bin purchases

}
