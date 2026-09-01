player(response)
{
	self endon("disconnect");
	
    if (response == "open_kill_effects")
    {
        self.kefx_previewId = undefined; // Reset preview to equipped
        self thread spawnKillFxPreview();
        self thread monitorRoundEndForMenu();
        return;
    }
    else if (response == "close_kill_effects")
    {
        self notify("end kill effects");
        if (isDefined(self.kefx_previewmodel))
            self.kefx_previewmodel delete();
        if (isDefined(self.kefx_previewfx))
            self.kefx_previewfx delete();
        self setClientDvar("cg_drawGun", 1);
        return;
    }
    
    effectId = int(response);
    if (effectId >= 1)
    {
        self.kefx_previewId = effectId;
        self spawnKillFxPreview(); // Always preview what they clicked
        
        prestige_req = 0;
        switch(effectId)
        {
            case 2: prestige_req = 1; break;
            case 3: prestige_req = 2; break;
            case 4: prestige_req = 3; break;
            case 5: prestige_req = 4; break;
            case 6: prestige_req = 5; break;
            case 7: prestige_req = 6; break;
            case 8: prestige_req = 7; break;
            case 9: prestige_req = 8; break;
            case 10: prestige_req = 9; break;
            case 11: prestige_req = 10; break;
            case 12: prestige_req = 11; break;
        }
        
        if (self getStat(2326) < prestige_req)
        {
            self iPrintLnBold("Kill Effect ^1Locked! ^7Requires Prestige ^3" + prestige_req);
            return; // Don't equip it
        }
        
        self setStat(979, effectId); // Equip it
        
        switch(effectId)
        {
            case 1:  self iPrintLnBold("Kill Effect: ^7None");        break;
            case 2:  self iPrintLnBold("Kill Effect: ^2Money");       break;
            case 3:  self iPrintLnBold("Kill Effect: ^5Spooderman");  break;
            case 4:  self iPrintLnBold("Kill Effect: ^3Mushroom");    break;
            case 5:  self iPrintLnBold("Kill Effect: ^3Nuke");        break;
            case 6:  self iPrintLnBold("Kill Effect: ^2Pepe");        break;
            case 7:  self iPrintLnBold("Kill Effect: ^2Watermelon");  break;
            case 8:  self iPrintLnBold("Kill Effect: ^3Dolan");       break;
            case 9:  self iPrintLnBold("Kill Effect: ^6Dots");        break;
            case 10: self iPrintLnBold("Kill Effect: ^4Water");       break;
            case 11: self iPrintLnBold("Kill Effect: ^8Smoke");       break;
            case 12: self iPrintLnBold("Kill Effect: ^1Fire");        break;
        }
    }
}

monitorRoundEndForMenu()
{
    self endon("disconnect");
    self endon("end kill effects");
    
    level waittill("game_ended");
    
    self closeMenu();
    self closeInGameMenu();
    self setClientDvar("cg_drawGun", 1);
    self notify("end kill effects");
    
    if (isDefined(self.kefx_previewmodel))
        self.kefx_previewmodel delete();
    if (isDefined(self.kefx_previewfx))
        self.kefx_previewfx delete();
}

getKillFxTrailId(effectId)
{
    switch(effectId)
    {
        case 3:  return 16;
        case 4:  return 19;
        case 5:  return 14;
        case 6:  return 18;
        case 7:  return 20;
        case 8:  return 17;
        case 9:  return 13;
        case 10: return 10;
        case 11: return 11;
        case 12: return 9;
        default: return -1;
    }
}

spawnKillFxPreview()
{
	self endon( "disconnect" );
	self endon( "end kill effects" );
	self notify( "stop kfx preview" );
	self endon( "stop kfx preview" );

	angles = self getPlayerAngles();
	self setplayerangles((0, angles[1], 0));
	
	eye = self getEye();
	if (!isAlive(self))
		eye = self.origin + (0, 0, 60);

	forward = anglesToForward(self getPlayerAngles()) * 65;
	right = anglesToRight(self getPlayerAngles()) * 40;
	model_spawn = eye + forward + right;

	if (isDefined(self.kefx_previewmodel))
		self.kefx_previewmodel delete();
	if (isDefined(self.kefx_previewfx))
		self.kefx_previewfx delete();

	self.kefx_previewmodel = spawn("script_model", model_spawn);
	self.kefx_previewmodel setmodel("tag_origin");
	self.kefx_previewmodel hide();
	self.kefx_previewmodel showtoplayer(self);

	wait 0.05;

	self thread loopKillFxPreview();
}

loopKillFxPreview()
{
	self endon( "disconnect" );
	self endon( "end kill effects" );
	self endon( "stop kfx preview" );

	while (true)
	{
		effectId = self getStat(979);
		if (isDefined(self.kefx_previewId))
			effectId = self.kefx_previewId;
		
		if (isDefined(self.kefx_previewmodel))
		{
			fxToPlay = undefined;
			if (effectId == 2 && isDefined(level.fx_money))
			{
				fxToPlay = level.fx_money;
			}
			else
			{
				trailId = self getKillFxTrailId(effectId);
				if (trailId > 0 && isDefined(level.trailInfo[trailId]) && isDefined(level.trailInfo[trailId]["effect"]))
				{
					fxToPlay = level.trailInfo[trailId]["effect"];
				}
			}
			
			if (isDefined(fxToPlay))
			{
				if (isDefined(self.kefx_previewfx))
					self.kefx_previewfx delete();
					
				self.kefx_previewfx = spawnFx(fxToPlay, self.kefx_previewmodel.origin);
				self.kefx_previewfx hide();
				self.kefx_previewfx showToPlayer(self);
				triggerFx(self.kefx_previewfx);
			}
		}
		wait 1.5;
	}
}
