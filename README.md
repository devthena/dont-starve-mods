# Don't Starve Mods

A collection of Don't Starve Together mods by Athena.

## Mods

### Chesters for Everyone (CFE)

Spawns a personal Eye Bone for each player entering the world, giving everyone their own Chester.

- Rename your Chester with `/rename_chester <name>` or `/rc <name>`
- Chester inventory can be set to public or private per server
- Snow and Shadow Chester transformations still work as normal — the player is responsible for triggering them

### Hutches for Everyone (HFE) - Beta

Spawns a personal Star-Sky for each player entering the Caves, giving everyone their own Hutch.

- Rename your Hutch with `/rename_hutch <name>` or `/rh <name>`
- Hutch inventory can be set to public or private per server
- Fugu and Music Box Hutch transformations still work as normal — the player is responsible for triggering them

## Configuration

Both mods expose two options in the mod settings menu:

| Option           | Values             | Default | Description                                                                         |
| ---------------- | ------------------ | ------- | ----------------------------------------------------------------------------------- |
| Allow Rename     | Enabled / Disabled | Enabled | Whether players can rename their companion                                          |
| Inventory Access | Public / Private   | Public  | Public allows any player to open any companion; Private restricts to the owner only |

## Localization

Both mods support localization. English strings are defined in `scripts/strings.lua` per mod. To add a new language, create a file at `scripts/locale/<lang>.lua` returning a table that overrides any keys from `strings.lua`.

Currently supported languages: **English**, **Simplified Chinese** (`zh`)

Example locale file structure:

```lua
return {
    system = {
        companion_missing = "...",
    },
    name_taken = {
        DEFAULT = "...",
        wilson = "...",
    },
    private = {
        DEFAULT = "...",
    },
    rename = {
        DEFAULT = "... {name} ...",
    },
}
```

Use `{name}` as the placeholder in `rename` strings where the companion's new name should appear. Only keys you provide will be overridden — any missing keys fall back to English automatically.

## Development

No build or test commands. Mods are written in Lua and loaded directly by the DST game engine.

**Tools:**

- VS Code with the [Lua language server](https://github.com/LuaLS/lua-language-server)
- [Stylua](https://github.com/JohnnyMorganz/StyLua) for formatting

**Local installation:** Copy the mod folder into your DST `mods/` directory and enable it from the in-game mod menu.
