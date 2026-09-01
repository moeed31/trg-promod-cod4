# Call of Duty 4 Promod - Custom Server Mod

This is a custom modification for Call of Duty 4 Promod servers. It introduces an array of advanced features designed to enhance player progression, customization, and server management.

## Features Included
* **Advanced Map Leaderboards:** Real-time tracking of player K/D ratios across the server, fully integrated into the in-game menus.
* **Custom Character Models:** Unique 3D player models (Deadpool, Duke Nukem, Ghost Rider, Goku, etc.) that can be previewed in a spinning 3D UI menu before equipping.
* **Cosmetic Trails & Kill Effects:** Dozens of unique particle trails and custom kill effects designed to reward long-term players.
* **Prestige & Rank System:** A robust prestige tracking system that locks exclusive cosmetic features behind playtime and skill.
* **VIP & Admin Systems:** Dedicated menus for Server Admins and VIP players.

## Installation
1. Extract the contents of this repository to your Call of Duty 4 server's `mods/` directory (e.g. `mods/ebc-pm-main`).
2. Update your server's startup command line to run this mod: `+set fs_game mods/ebc-pm-main`.
3. Start your server. The necessary `.iwd` and `.ff` fastfiles are included in the package.

## Compilation
If you wish to modify the source scripts, a `.bat` build script is included.
1. Run `build_noninteractive.bat` from within the root folder.
2. The script will automatically compile your changes into `mod.ff` and repackage `TRG.iwd`.

Enjoy!
