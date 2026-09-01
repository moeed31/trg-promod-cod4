player(response)
{
	self endon("disconnect");
	
	if (response == "open_character")
	{
		self thread spawnCharacterPreview();
		self thread autoCloseMenuMonitor();
		return;
	}
	else if (response == "close_character")
	{
		self notify("end customization");
		if (isDefined(self.char_previewmodel))
			self.char_previewmodel delete();
		return;
	}
	
	charId = int(response);
	if (charId > 0)
	{
		self.previewCharId = charId;
		
		if (isDefined(self.char_previewmodel))
		{
			modelName = self getCharacterModel(charId);
			if (modelName != "")
			{
				self.char_previewmodel setModel(modelName);
				self.char_previewmodel showtoplayer(self);
			}
			else
			{
				self.char_previewmodel hide();
			}
		}

		if (charId == 1)
		{
			self setStat(981, 0);
			self iPrintLnBold("Character removed!");
		}
		else
		{
			if (self checkCharacterRequirements(charId))
			{
				self setStat(981, charId);
				self iPrintLnBold("Character selected!");
			}
		}
	}
}

checkCharacterRequirements(charId)
{
    if (charId <= 1) return true;
    
    prestige = self getStat(2326);
    req_p = 0;
    
    switch(charId)
    {
        case 2: req_p = 1; break; // Deadpool
        case 3: req_p = 2; break; // Duke
        case 4: req_p = 3; break; // Hitler
        case 5: req_p = 4; break; // Ghost Rider
        case 6: req_p = 5; break; // Leon
        case 7: req_p = 6; break; // Boba Fett
        case 8: req_p = 7; break; // Darth Maul
        case 9: req_p = 8; break; // Goku
        case 10: req_p = 9; break; // Octane
        case 11: req_p = 10; break; // Phoenix
        case 12: req_p = 11; break; // Redbeard
        case 13: req_p = 12; break; // Miku
    }
    
    if (prestige >= req_p) return true;
    
    self iPrintLnBold("^1LOCKED! ^7Requires Prestige ^3" + req_p);
    return false;
}

getCharacterModel(charId)
{
    switch(charId)
    {
        case 2: return "deadpool";
        case 3: return "playermodel_dnf_duke";
        case 4: return "plr_adolf_hitler";
        case 5: return "ghost_rider";
        case 6: return "leon";
        case 7: return "boba_fett";
        case 8: return "darth_maul";
        case 9: return "goku";
        case 10: return "octane";
        case 11: return "pheonix";
        case 12: return "redbeard";
        case 13: return "miku";
        default: return "";
    }
}

autoCloseMenuMonitor()
{
    self endon("disconnect");
    self endon("end customization");
    
    level waittill("game_ended");
    
    self setClientDvar("cg_drawGun", 1);
    self closeMenu();
    self closeInGameMenu();
    self notify("end customization");
}

spawnCharacterPreview()
{
	self endon( "disconnect" );
	self endon( "end customization" );
	self notify( "stop preview rotation" );
	self endon( "stop preview rotation" );

	angles = self getPlayerAngles();
	self setplayerangles((0, angles[1], 0));
	
	// Spawn on the right side: 100 units forward, 40 units right (adjust as needed for character models)
	eye = self getEye();
	if (!isAlive(self))
		eye = self.origin + (0, 0, 60);

	forward = anglesToForward(self getPlayerAngles()) * 100;
	right = anglesToRight(self getPlayerAngles()) * 40;
	// Lower the Z by 40 units so the character feet are roughly on the floor
	model_spawn = eye + forward + right - (0, 0, 40);

	if (isDefined(self.char_previewmodel))
		self.char_previewmodel delete();

	self.char_previewmodel = spawn("script_model", model_spawn);
	self.char_previewmodel hide();
	
	// Set initial model if they already have one selected
	charId = self getStat(981);
	if (isDefined(self.previewCharId))
		charId = self.previewCharId;
		
	modelName = self getCharacterModel(charId);
	if (modelName != "")
	{
		self.char_previewmodel setModel(modelName);
		self.char_previewmodel showtoplayer(self);
	}
	else
	{
		self.char_previewmodel setModel("tag_origin");
		self.char_previewmodel hide();
	}

	// Rotate it continuously
	self thread rotatePreviewModel();
}

rotatePreviewModel()
{
	self endon( "disconnect" );
	self endon( "end customization" );
	self notify( "stop preview rotation thread" );
	self endon( "stop preview rotation thread" );

	while(isDefined(self.char_previewmodel))
	{
		self.char_previewmodel rotateYaw(360, 4);
		wait 4;
	}
}
