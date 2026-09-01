loadCustomizations()
{
	self endon("disconnect");

	// 1. Restore Hit Icons (stat 1225)
	hit_icon = self getStat(1225);
	if (hit_icon >= 0 && hit_icon <= 5)
	{
		self.pers["hit_icon"] = hit_icon;
		self setClientDvar("ui_hit_icon", hit_icon);
	}
	else
	{
		self.pers["hit_icon"] = 0;
		self setClientDvar("ui_hit_icon", 0);
	}

	// 2. Restore Killcam HUDs (stat 1226)
	kc_hud = self getStat(1226);
	kc_hud_name = "default";
	switch(kc_hud)
	{
		case 1: kc_hud_name = "killcam1"; break;
		case 2: kc_hud_name = "killcam2"; break;
		case 3: kc_hud_name = "killcam3"; break;
		case 4: kc_hud_name = "killcam4"; break;
		default: kc_hud = 0; break;
	}
	self.pers["killcam_hud"] = kc_hud;
	self setClientDvar("ui_killcam_hud", kc_hud_name);

	// 3. Restore Killcards (stat 1227)
	kcard = self getStat(1227);
	kcard_name = "Default";
	switch(kcard)
	{
		case 1: kcard_name = "Blue"; break;
		case 2: kcard_name = "Red"; break;
		case 3: kcard_name = "Green"; break;
		case 4: kcard_name = "Yellow"; break;
		case 5: kcard_name = "Member"; break;
		case 6: kcard_name = "killcard"; break;
		case 7: kcard_name = "killcard_ct"; break;
		case 8: kcard_name = "killcard_gl"; break;
		case 9: kcard_name = "killcard_in"; break;
		case 10: kcard_name = "killcard_jk"; break;
		case 11: kcard_name = "killcard_mw"; break;
		case 12: kcard_name = "killcard_ns"; break;
		case 13: kcard_name = "killcard_pg"; break;
		case 14: kcard_name = "killcard_sl"; break;
		case 15: kcard_name = "killcard_yk"; break;
		default: kcard = 0; break;
	}
	
	// Wait a brief moment for duffman\killcard script to finish initializing its arrays
	wait 0.5;
	if (isDefined(self))
	{
		self duffman\killcard::setDesign(kcard_name, 1);
		self setClientDvar("ui_killcard", kcard_name);
	}
}
