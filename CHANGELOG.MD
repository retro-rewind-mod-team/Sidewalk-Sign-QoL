# Changelog

## 1.1
- Added `Sidewalk-Sign-QoL.yaml` with full config definition for RRMM
- Added `Debug` mode — logs the active bonus value for each ad type on hook registration
- `bonuses` nested table restructured to flat top-level keys (`bonusMoreCustomers`, `bonusNewRelease`, etc.) to align with the RRMM config model
- `SALE_TYPE_MAP` extended with config key references; `buildBonusTable` and `validateConfig` updated accordingly

## 1.0.1
- Added nexus_id and nexus_file_id to YAML for update checking

## 1.0
- Initial release
