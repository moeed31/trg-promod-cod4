# Changelog

## New Features
* **Knife Round Trails:** Added fully customizable visual trails that follow your knife during the Knife Round.
* **Knife Round Characters:** Introduced a system to select and play as custom characters (e.g., Deadpool, Duke, Goku, Boba Fett) during the Knife Round.
* **Kill Effects:** Added unlockable visual kill effects (like Fire, Watermelon, Nuke, Spooderman, etc.) that trigger upon killing an enemy.
* **New Improved Leaderboard:** Redesigned the leaderboard UI to an esports-style full-screen layout featuring both Global and per-Map ranking tabs sorted strictly by Skill Level (K/D).
* **New Improved Admin Menu:** Streamlined the admin menu interface for much easier server management and command execution.
* **New Improved VIP Menu:** Overhauled the VIP menu to improve access to exclusive features like custom gloves, skins, and sprays.

## Bug Fixes
* **Animated Camo:** Fixed critical issues with animated camos not displaying or cycling correctly on weapons.
* **Kill Effect Mappings:** Fixed a bug where selecting an effect in the menu triggered a completely different effect in-game (e.g., selecting Fire previously spawned Watermelon).
* **Preview Menu Visibility:** Fixed an issue where Character, Gloves, Knife Trails, and Kill Effect preview models were globally visible to all players instead of being private to the user browsing the menu.
* **Spectator Preview Positioning:** Fixed a bug where opening a customization menu while spectating would spawn preview models back on the player's dead body instead of directly in front of their current camera.
* **FX Engine Limits:** Patched a severe server crash (`noclass` entity linking error) related to FX trail spawning by writing custom, high-speed origin-tracking threads to safely move FX.
* **UI Overlaps:** Fixed UI overlapping issues and text clipping, completely optimizing the Leaderboard layout to support 4:3 resolutions perfectly without visual artifacts.
* **Various other minor fixes** to optimize server-side script performance, correct string localizations, and improve visual alignment.
