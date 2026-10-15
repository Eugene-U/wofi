# temp-wofi-theme

A simple Dracula-themed setup for [wofi](https://hg.sr.ht/~scoopta/wofi).

It adds app icons, a purple focus style, and a launch script with a blacklist
for apps you don't want to see.

## Requirements

- wofi (1.4+)
- bash
- A Wayland compositor (Hyprland, Sway, ...)
- `gio` (usually comes with GLib)

## Installation

1. Copy everything into your wofi config folder:

   ```sh
   cp -r temp-wofi-theme/* ~/.config/wofi/
   ```

2. Make the launch script executable:

   ```sh
   chmod +x ~/.config/wofi/launch.sh
   ```

3. Run wofi through the script (not `wofi` directly):

   ```sh
   ~/.config/wofi/launch.sh
   ```

4. Optional: add a keybind. In Hyprland:

   ```lua
   bind = "SUPER, R", exec, "sh -c ~/.config/wofi/launch.sh"
   ```

## Files

| File          | What it does                                  |
|---------------|-----------------------------------------------|
| `config`      | wofi options (width, images, dmenu mode)      |
| `style.css`   | Dracula colors and layout                     |
| `launch.sh`   | Starts wofi, hides blacklisted apps, tints icons |
| `icons/`      | One SVG per app, e.g. `brave-browser.svg`     |
| `list.sh`     | Helper that lists apps and matching icons     |

## Customization

- **Blacklist apps** — edit the `BLACKLIST` array at the top of `launch.sh`:

  ```bash
  BLACKLIST=(
      kitty
      pavucontrol
  )
  ```

  Use the app ID (the `.desktop` file name without the extension).

- **Icon color** — one line in `launch.sh`:

  ```bash
  ICON_COLOR="#f8f8f2"
  ```

  Tinted icons are cached in `~/.cache/wofi/icons/`. Delete that folder
  to rebuild the cache.

- **Add an icon** — drop an SVG into `icons/` named after the app ID:
  `brave-browser.desktop` → `icons/brave-browser.svg`.
  Missing icons fall back to `icons/default.svg`.

- **Colors** — edit `style.css` (Dracula palette).

## Uninstall

Remove the config folder:

```sh
rm -rf ~/.config/wofi
rm -rf ~/.cache/wofi
```
