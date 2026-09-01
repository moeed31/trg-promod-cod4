<div align="center">
  <h1>🎯 TRG Promod - Advanced CoD4 Server Mod</h1>
  <p>A highly customized Call of Duty 4 Promod experience featuring advanced map leaderboards, custom 3D characters, cosmetic trails, kill effects, and prestige systems.</p>
</div>

---

## 🌟 Features Breakdown

- **📊 Dynamic Map Leaderboards:** Real-time tracking of player K/D ratios and total kills per map, fully integrated directly into the in-game UI.
- **🕴️ Custom 3D Character Models:** Players can unlock and equip unique models (Deadpool, Duke Nukem, Ghost Rider, Goku, etc.) that can be viewed in a spinning 3D preview menu before equipping.
- **✨ Cosmetic Trails & Effects:** Over a dozen animated particle trails (Geo, Fire, Dots, Stars) and exclusive kill effects to reward dedicated players.
- **📈 Prestige & Rank System:** A robust progression system that locks exclusive cosmetic features and characters behind playtime and skill milestones.
- **👑 VIP & Admin Menus:** Dedicated built-in menus for Server Admins to manage players and for VIPs to access special perks.

---

## 🛠️ 1. Compiling the Mod (Required First Step)

Before you can run the mod on your server, you **must compile the source code** to generate the required fastfiles (`.ff`) and asset archives (`.iwd`).

1. Download or clone this repository to your computer.
2. Place the entire `trg-promod-cod4` folder inside your Call of Duty 4 `mods/` directory (e.g., `C:\Program Files (x86)\Activision\Call of Duty 4 - Modern Warfare\mods\trg-promod-cod4`).
3. Open the folder and double-click `build_noninteractive.bat`.
4. Wait for the compilation process to finish. The compiler will automatically:
   - Compile all UI and GSC scripts into `mod.ff`
   - Pack all custom images, materials, and weapon files into `TRG.iwd`
5. Once the build script says **"Build complete!"**, you are ready to start the server.

---

## 🚀 2. Running the Mod on Your Server

Once the mod is successfully compiled, you can launch it on your server.

1. Locate your Call of Duty 4 server startup script (usually a `.bat` file or a command line argument on your server host dashboard).
2. Add the following parameters to your startup command to load the mod and its specific configurations:
   ```text
   +set fs_game mods/trg-promod-cod4 +exec server.cfg +map mp_strike
   ```
3. *(Optional)* Open the provided `server.cfg` file and change the RCON password and server name to match your community's needs.
4. Launch your server! Players will automatically download the `mod.ff` and `TRG.iwd` when they join.

---

## 📄 License
This mod is open-sourced for the community to learn from, build upon, and host their own customized Promod experiences. Have fun modifying it!
