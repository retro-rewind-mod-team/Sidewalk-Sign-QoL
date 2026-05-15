# Sidewalk Sign QoL

Lets you configure the bonus value for each sidewalk sign ad type individually.

---

## The Problem

The sidewalk sign advertises one bonus at a time — more customers, new releases, concessions, snacks, or clearance sales. The game's built-in bonus values are fixed and cannot be changed without a mod. Depending on your store's focus, some ad types may feel too weak to be worth using.

## How It Works

The AI Director polls the active sign bonus every second to factor it into customer behaviour. This mod intercepts that poll and returns your configured value instead of the one stored in the game's data table. The save file and data table are never modified — the override only exists in memory while the store is open.

## Default Values

These are the game's unmodified bonus values, which the mod uses as a baseline:

| Ad Type       | Default |
|---------------|---------|
| MoreCustomers | 0.20    |
| NewRelease    | 0.25    |
| Concessions   | 0.50    |
| Snacks        | 0.50    |
| ClearanceSale | 0.50    |

## Requirements

- [UE4SS v3.0.1](https://www.nexusmods.com/retrorewindvideostoresimulator/mods/52)

## Installation

1. Navigate to your UE4SS Mods folder:
   `Retro Rewind\Binaries\Win64\Mods\`
2. Extract the mod folder here.

## Configuration

Open `config.lua` and set a value between `0.0` and `1.0` for each ad type:

- `0.0` disables the bonus entirely
- `0.2` / `0.25` / `0.5` are the game defaults depending on type
- `1.0` is the maximum

You only need to include the types you want to change. Any type you leave out will use the game's native value automatically.

**Example — only change two types:**
```lua
return {
    bonuses = {
        MoreCustomers = 0.8,
        Concessions   = 1.0,
    }
}
```

## Usage

Edit `config.lua`, load your save, open the store. Changes take effect within one second of opening.

Switch ad types in-game at the sidewalk sign as normal — only the active type affects anything at a given time.

## Compatibility

Compatible with all other mods. Does not modify the save file or any game data tables.

## Changelog

### 1.0
- Initial release


## License
Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg
