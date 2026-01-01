---
paths: programs/starship*
---

# Starship Configuration Rules

## Nerd Font Handling

Claude cannot process Nerd Font characters (Unicode Private Use Area). They get corrupted in string processing.

### Architecture

Use native Nix with variable bindings:

```nix
let
  cap = "";    # U+E0B6 - injected via shell
  arrow = "";  # U+E0B0 - injected via shell
in {
  programs.starship.settings = {
    format = "[${cap}](#9A348E)...";
  };
}
```

### Critical: Nix String Limitations

**DO NOT use multiline strings with backslash:**
```nix
# WRONG - causes starship parse error
format = ''
  [](#9A348E)\
  $directory\
'';
```

**USE single-line strings:**
```nix
# CORRECT
format = "[](#9A348E)$directory...";
```

### Workflow

1. Create template with placeholders (`__CAP__`, `__ARROW__`)
2. Inject symbols via shell:
   ```bash
   CAP=$(printf '\ue0b6')
   ARROW=$(printf '\ue0b0')
   sed -i "s/__CAP__/$CAP/g" programs/starship.nix
   ```
3. Format: `nix fmt programs/starship.nix`
4. Verify bytes: `sed -n '3p' programs/starship.nix | od -c`

### Symbol Reference

| Symbol | Unicode | printf | Description |
|--------|---------|--------|-------------|
|  | U+E0B6 | `\ue0b6` | Left half circle |
|  | U+E0B0 | `\ue0b0` | Solid right arrow |
|  | U+E0A0 | `\ue0a0` | Git branch |
| 󰈙 | U+F0219 | `\U000F0219` | Documents |
|  | U+F019 | `\uf019` | Downloads |
|  | U+F001 | `\uf001` | Music |
|  | U+F03E | `\uf03e` | Pictures |
