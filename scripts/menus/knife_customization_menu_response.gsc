player(response)
{
	self endon("disconnect");
	
	if (response == "open_trails")
	{
		self thread spawnFxPreview();
		self thread autoCloseMenuMonitor();
		return;
	}
	else if (response == "close_trails")
	{
		self notify("end customization");
		if (isDefined(self.previewmodel))
			self.previewmodel delete();
		if (isDefined(self.previewFxEnt))
			self.previewFxEnt delete();
		return;
	}
	
	trailId = int(response);
	if (trailId > 0)
	{
		self.previewTrailId = trailId;
		self spawnFxPreview();

		if (trailId == 1)
		{
			self setStat(978, 0);
			self notify("stop_trail");
			self iPrintLnBold("Trail removed!");
		}
		else
		{
			if (self checkTrailRequirements(trailId))
			{
				self setStat(978, trailId);
				self iPrintLnBold("Knife Round Trail selected!");
			}
		}
	}
}

checkTrailRequirements(trailId)
{
    if (trailId <= 1) return true;
    
    prestige = self getStat(2326);
    rank = self getStat(252);
    
    req_p = 0;
    req_r = 0;
    
    switch(trailId)
    {
        case 2: req_p = 0; req_r = 24; break;
        case 3: req_p = 0; req_r = 49; break;
        case 4: req_p = 1; req_r = 24; break;
        case 5: req_p = 1; req_r = 49; break;
        case 6: req_p = 2; req_r = 24; break;
        case 7: req_p = 2; req_r = 49; break;
        case 8: req_p = 3; req_r = 24; break;
        case 9: req_p = 3; req_r = 49; break;
        case 10: req_p = 4; req_r = 24; break;
        case 11: req_p = 4; req_r = 49; break;
        case 12: req_p = 5; req_r = 24; break;
        case 13: req_p = 5; req_r = 49; break;
        case 14: req_p = 6; req_r = 24; break;
        case 15: req_p = 6; req_r = 49; break;
        case 16: req_p = 7; req_r = 24; break;
        case 17: req_p = 7; req_r = 49; break;
        case 18: req_p = 8; req_r = 24; break;
        case 19: req_p = 8; req_r = 49; break;
        case 20: req_p = 9; req_r = 24; break;
    }
    
    if (prestige > req_p) return true;
    if (prestige == req_p && rank >= req_r) return true;
    
    self iPrintLnBold("^1LOCKED! ^7Requires Prestige ^3" + req_p + "^7 Level ^3" + (req_r + 1));
    return false;
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

spawnFxPreview()
{
	self endon( "disconnect" );
	self endon( "end customization" );
	self notify( "stop preview rotation" );
	self endon( "stop preview rotation" );

	angles = self getPlayerAngles();
	self setplayerangles((0, angles[1], 0));
	
	eye = self getEye();
	if (!isAlive(self))
		eye = self.origin + (0, 0, 60);
		
	// Spawn on the right side: 150 units forward, 90 units right
	forward = anglesToForward(self getPlayerAngles()) * 150;
	right = anglesToRight(self getPlayerAngles()) * 90;
	model_spawn = eye + forward + right;

	if (isDefined(self.previewmodel))
		self.previewmodel delete();
	if (isDefined(self.previewFxEnt))
		self.previewFxEnt delete();

	self.previewmodel = spawn("script_model", model_spawn);
	self.previewmodel setmodel("tag_origin");
	self.previewmodel hide();
	self.previewmodel showtoplayer(self);

	wait 0.05;

	self thread movePreview(self.previewmodel);
}

movePreview(ent)
{
	self endon( "disconnect" );
	self endon( "end customization" );
	self notify( "stop preview" );
	wait 0.05;
	self endon( "stop preview" );

	eye = self getEye();
	forward = anglesToForward(self getPlayerAngles()) * 150;
	// Sweep on the right side: from 135 units right to 45 units right (scaled from 45/15)
	sweepRight = anglesToRight(self getPlayerAngles()) * 135;
	sweepLeft = anglesToRight(self getPlayerAngles()) * 45;

	oriRight = forward + sweepRight + eye;
	oriLeft = forward + sweepLeft + eye;
	
	self thread loopPreviewTrail();

	while (isDefined(ent))
	{
		if (isDefined(ent))
			ent moveTo(oriRight, 1, 0.15, 0.15);
		wait 1;
		if (isDefined(ent))
			ent moveTo(oriLeft, 1, 0.15, 0.15);
		wait 1;
	}
}

loopPreviewTrail()
{
	self endon( "disconnect" );
	self endon( "end customization" );
	self endon( "stop preview" );

	while (true)
	{
		trailId = self getStat(978);
		if (isDefined(self.previewTrailId))
			trailId = self.previewTrailId;
			
		if (trailId > 1 && isDefined(self.previewmodel))
		{
			if (isDefined(level.trailInfo[trailId]) && isDefined(level.trailInfo[trailId]["effect"]))
			{
				if (!isDefined(self.previewFxEnt) || !isDefined(self.previewFxId) || self.previewFxId != trailId)
				{
					if (isDefined(self.previewFxEnt))
						self.previewFxEnt delete();
						
					self.previewFxId = trailId;
					self.previewFxEnt = spawnFx(level.trailInfo[trailId]["effect"], self.previewmodel.origin);
					self.previewFxEnt hide();
					self.previewFxEnt showToPlayer(self);
					triggerFx(self.previewFxEnt);
					self thread trackFxOrigin(self.previewFxEnt, self.previewmodel);
				}
			}
			else
			{
				if (isDefined(self.previewFxEnt))
					self.previewFxEnt delete();
			}
		}
		wait 0.15;
	}
}

trackFxOrigin(fxEnt, model)
{
	self endon( "disconnect" );
	self endon( "end customization" );
	self endon( "stop preview" );
	
	while(isDefined(fxEnt) && isDefined(model))
	{
		fxEnt.origin = model.origin;
		wait 0.05;
	}
}
