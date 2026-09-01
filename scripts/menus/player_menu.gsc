#include scripts\utility\common;

player(response)
{
	self endon("disconnect");

	// Process the custom sub-menu routing responses passed from your .menu file
	switch(response)
	{
				case "open_gloves":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("gloves");
			break;

		case "open_sprays":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("sprays");
			break;

		case "open_player":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("player");
			break;

		case "open_vip":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("vip");
			break;

		case "open_customization":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("customization");
			break;



		case "open_kill_effects":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("kill_effects");
			break;

		case "open_character":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("character");
			break;

		case "open_knife_customization":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("knife_customization");
			break;

		case "open_trg_ranks":
			self closeMenu();
			self closeInGameMenu();
			self openMenu("trg_ranks");
			break;

		case "open_admin":
			// Optional structural safety check: checks if player is designated as server developer/admin
			if(isDefined(self.pers["isAdmin"]) && self.pers["isAdmin"])
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu("admin");
			}
			else
			{
				self iprintlnBold("^1Access Denied: ^7Admins Only!");
			}
			break;

		case "emote":
			self thread scripts\dance::playDance();
			break;

		case "spray":
			self thread maps\mp\gametypes\_globallogic::doSpray();
			break;

		case "inspect":
			self thread scripts\inspect::triggerInspect();
			break;

	}
}
