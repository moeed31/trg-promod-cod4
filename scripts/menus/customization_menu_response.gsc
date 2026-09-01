customization(response)
{
	self endon("disconnect");
	
	switch(response)
	{
		// HIT ICON SELECTION
		case "hit_default":
			self.pers["hit_icon"] = 0;
			self setstat(1225, 0);
			self setClientDvar("ui_hit_icon", 0);
			break;
		case "hit_1":
			self.pers["hit_icon"] = 1;
			self setstat(1225, 1);
			self setClientDvar("ui_hit_icon", 1);
			break;
		case "hit_2":
			self.pers["hit_icon"] = 2;
			self setstat(1225, 2);
			self setClientDvar("ui_hit_icon", 2);
			break;
		case "hit_3":
			self.pers["hit_icon"] = 3;
			self setstat(1225, 3);
			self setClientDvar("ui_hit_icon", 3);
			break;
		case "hit_4":
			self.pers["hit_icon"] = 4;
			self setstat(1225, 4);
			self setClientDvar("ui_hit_icon", 4);
			break;
		case "hit_5":
			self.pers["hit_icon"] = 5;
			self setstat(1225, 5);
			self setClientDvar("ui_hit_icon", 5);
			break;

		// KILLCAM HUD SELECTION
		case "kc_hud_default":
			self.pers["killcam_hud"] = 0;
			self setstat(1226, 0);
			self setClientDvar("ui_killcam_hud", "default");
			break;
		case "kc_hud_1":
			self.pers["killcam_hud"] = 1;
			self setstat(1226, 1);
			self setClientDvar("ui_killcam_hud", "killcam1");
			break;
		case "kc_hud_2":
			self.pers["killcam_hud"] = 2;
			self setstat(1226, 2);
			self setClientDvar("ui_killcam_hud", "killcam2");
			break;
		case "kc_hud_3":
			self.pers["killcam_hud"] = 3;
			self setstat(1226, 3);
			self setClientDvar("ui_killcam_hud", "killcam3");
			break;
		case "kc_hud_4":
			self.pers["killcam_hud"] = 4;
			self setstat(1226, 4);
			self setClientDvar("ui_killcam_hud", "killcam4");
			break;

		// KILLCARDS SELECTION
		case "kcard_default":
			self duffman\killcard::setDesign("Default", 1);
			self setstat(1227, 0);
			self setClientDvar("ui_killcard", "Default");
			break;
		case "kcard_blue":
			self duffman\killcard::setDesign("Blue", 1);
			self setstat(1227, 1);
			self setClientDvar("ui_killcard", "Blue");
			break;
		case "kcard_red":
			self duffman\killcard::setDesign("Red", 1);
			self setstat(1227, 2);
			self setClientDvar("ui_killcard", "Red");
			break;
		case "kcard_green":
			self duffman\killcard::setDesign("Green", 1);
			self setstat(1227, 3);
			self setClientDvar("ui_killcard", "Green");
			break;
		case "kcard_yellow":
			self duffman\killcard::setDesign("Yellow", 1);
			self setstat(1227, 4);
			self setClientDvar("ui_killcard", "Yellow");
			break;
		case "kcard_member":
			self duffman\killcard::setDesign("Member", 1);
			self setstat(1227, 5);
			self setClientDvar("ui_killcard", "Member");
			break;
		case "kcard_card":
			self duffman\killcard::setDesign("killcard", 1);
			self setstat(1227, 6);
			self setClientDvar("ui_killcard", "killcard");
			break;
		case "kcard_ct":
			self duffman\killcard::setDesign("killcard_ct", 1);
			self setstat(1227, 7);
			self setClientDvar("ui_killcard", "killcard_ct");
			break;
		case "kcard_gl":
			self duffman\killcard::setDesign("killcard_gl", 1);
			self setstat(1227, 8);
			self setClientDvar("ui_killcard", "killcard_gl");
			break;
		case "kcard_in":
			self duffman\killcard::setDesign("killcard_in", 1);
			self setstat(1227, 9);
			self setClientDvar("ui_killcard", "killcard_in");
			break;
		case "kcard_jk":
			self duffman\killcard::setDesign("killcard_jk", 1);
			self setstat(1227, 10);
			self setClientDvar("ui_killcard", "killcard_jk");
			break;
		case "kcard_mw":
			self duffman\killcard::setDesign("killcard_mw", 1);
			self setstat(1227, 11);
			self setClientDvar("ui_killcard", "killcard_mw");
			break;
		case "kcard_ns":
			self duffman\killcard::setDesign("killcard_ns", 1);
			self setstat(1227, 12);
			self setClientDvar("ui_killcard", "killcard_ns");
			break;
		case "kcard_pg":
			self duffman\killcard::setDesign("killcard_pg", 1);
			self setstat(1227, 13);
			self setClientDvar("ui_killcard", "killcard_pg");
			break;
		case "kcard_sl":
			self duffman\killcard::setDesign("killcard_sl", 1);
			self setstat(1227, 14);
			self setClientDvar("ui_killcard", "killcard_sl");
			break;
		case "kcard_yk":
			self duffman\killcard::setDesign("killcard_yk", 1);
			self setstat(1227, 15);
			self setClientDvar("ui_killcard", "killcard_yk");
			break;
	}
}
