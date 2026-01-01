---
paths: programs/starship*
---

# Starship Configuration Rules

## Nerd Font Handling

Claude cannot correctly process Nerd Font special characters (Unicode Private Use Area, e.g., U+E0B0 for powerline symbols). These characters will be corrupted or lost when passed through Claude's string processing.

### Required Approach

1. **Use external TOML file**: Store starship configuration in `starship.toml` and load it with `builtins.fromTOML (builtins.readFile ./starship.toml)` in the Nix file

2. **Generate presets via shell**: Use `starship preset <name> -o starship.toml` to generate configuration with Nerd Font symbols intact

3. **Edit via shell commands**: When modifying lines containing Nerd Font symbols, use `sed` or `grep` instead of Edit tool:
   ```bash
   # Extract symbol from source file
   SYMBOL=$(sed -n 's/.*symbol = "\([^"]*\)".*/\1/p' source.nix)
   # Replace in target file
   sed -i "s/^symbol = .*/symbol = \"$SYMBOL\"/" target.toml
   ```

4. **Always create backups**: Before any modification, backup files that contain Nerd Font symbols:
   ```bash
   cp starship.nix starship.nix.backup
   cp starship.toml starship.toml.original
   ```

5. **Never delete backup files**: Keep `.backup` and `.original` files for reference

### File Structure

```
programs/
├── starship.nix          # Loads TOML via builtins.fromTOML
├── starship.toml         # Actual configuration with Nerd Font symbols
├── starship.nix.backup   # Backup of original Nix config
└── starship.toml.original # Backup of preset TOML
```

### Verification

After editing, verify Nerd Font symbols are preserved:
```bash
# Check encoding of powerline symbols
sed -n '4p' starship.toml | od -c | head -1
# Should show octal like: 356 202 260 (for U+E0B0)
```
