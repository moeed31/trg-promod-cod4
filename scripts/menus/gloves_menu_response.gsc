player(response)
{
    self endon("disconnect");
    
    if (response == "open_gloves")
    {
        self thread spawnGlovePreview();
        self thread autoCloseMenuMonitor();
        return;
    }
    else if (response == "close_gloves")
    {
        self notify("end customization");
        if (isDefined(self.glove_previewmodel))
            self.glove_previewmodel delete();
        return;
    }
    
    if (isSubStr(response, "select_"))
    {
        charId = int(getSubStr(response, 7, response.size)) - 40;
        
        if (charId > 0)
        {
            if (self checkGloveRequirements(charId))
            {
                self setStat(980, charId - 1);
                self iPrintLnBold("Gloves equipped!");
            }
            
            if (isDefined(self.glove_previewmodel))
            {
                if (charId == 1) 
                {
                    self.glove_previewmodel setModel("tag_origin");
                    self.glove_previewmodel hide();
                }
                else 
                {
                    modelName = self getGloveModel(charId);
                    if (modelName != "")
                    {
                        self.glove_previewmodel setModel(modelName);
                        self.glove_previewmodel showtoplayer(self);
                    }
                }
            }
        }
        return;
    }
}

checkGloveRequirements(charId)
{
    prestige = self getStat(2326);
    raw_req = tableLookup("mp/characterTable.csv", 0, charId, 2);
    
    // If it's completely blank in the CSV, it's default unlocked
    if (raw_req == "")
        return true;
        
    req_p = int(raw_req) - 1;
    if (req_p < 0) req_p = 0;
    
    if (prestige >= req_p) return true;
    
    self iPrintLnBold("^1LOCKED! ^7Requires Prestige ^3" + req_p);
    return false;
}

getGloveModel(charId)
{
    model = tableLookup("mp/characterTable.csv", 0, charId, 4);
    if (model != "") return model;
    return "tag_origin";
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

spawnGlovePreview()
{
    self endon( "disconnect" );
    self endon( "end customization" );
    self notify( "stop preview rotation" );
    self endon( "stop preview rotation" );

    angles = self getPlayerAngles();
    self setplayerangles((0, angles[1], 0));
    
    // Z lowered by 20 units (55 -> 35)
    eye = self getEye();
    if (!isAlive(self))
        eye = self.origin + (0, 0, 60);

    forward = anglesToForward(self getPlayerAngles()) * 50;
    right = anglesToRight(self getPlayerAngles()) * 20;
    model_spawn = eye + forward + right + (0, 0, 35);

    if (isDefined(self.glove_previewmodel))
        self.glove_previewmodel delete();

    self.glove_previewmodel = spawn("script_model", model_spawn);
    self.glove_previewmodel hide();

    charId = self getStat(980) + 1;
        
    if (charId == 1) 
    {
        self.glove_previewmodel setModel("tag_origin");
        self.glove_previewmodel hide();
    }
    else 
    {
        modelName = self getGloveModel(charId);
        if (modelName != "")
        {
            self.glove_previewmodel setModel(modelName);
            self.glove_previewmodel showtoplayer(self);
        }
        else
        {
            self.glove_previewmodel setModel("tag_origin");
            self.glove_previewmodel hide();
        }
    }

    self thread rotatePreviewModel();
}

rotatePreviewModel()
{
    self endon( "disconnect" );
    self endon( "end customization" );
    self notify( "stop preview rotation thread" );
    self endon( "stop preview rotation thread" );

    while(isDefined(self.glove_previewmodel))
    {
        self.glove_previewmodel rotateYaw(360, 4);
        wait 4;
    }
}
