init()
{	
    precacheItem("default_dance_mp");
    level.HoldTime = 0.8;
    thread onPlayerConnect();
}

onPlayerConnect()
{
    while(1)
    {
        level waittill("connected", player);
        player thread onPlayerSpawn();
    }
}

onPlayerSpawn()
{
    self endon("disconnect");
    while(1)
    {
        self waittill("spawned_player");
        self unlink();
        self setClientDvar( "cg_thirdperson", 0 );
        self setClientDvar( "cg_thirdpersonangle", 0 );
        self.isDancing = false;
    }
}

playDance()
{
    self endon("disconnect");
    self endon("death");

    if (isDefined(self.isDancing) && self.isDancing)
        return;

    self.isDancing = true;
    currentweap = self getCurrentWeapon();
    
    // Spawn anchor to lock player's position
    anchor = spawn("script_origin", self.origin);
    self linkTo(anchor);
    self thread deleteAnchorOnDeath(anchor);
    
    // Give and switch to our renamed custom dummy weapon
    self giveWeapon("default_dance_mp");
    self switchToWeapon("default_dance_mp");
    
    wait 0.2;
    
    self setClientDvar( "cg_thirdperson", 1 );
    self setClientDvar( "cg_thirdpersonangle", 180 );
    
    // Poll for button presses during the 7 seconds dance duration
    for (i = 0; i < 7.0; i += 0.05)
    {
        if (self attackButtonPressed() || self useButtonPressed() || self jumpButtonPressed())
            break;
        wait 0.05;
    }
    
    self notify("dance_finished");
    
    if (isAlive(self))
    {
        self takeWeapon("default_dance_mp");
        if (self hasWeapon(currentweap))
            self switchToWeapon(currentweap);
        
        self setClientDvar( "cg_thirdperson", 0 );
        self setClientDvar( "cg_thirdpersonangle", 0 );
    }
    
    if (isDefined(anchor))
    {
        self unlink();
        anchor delete();
    }
    
    self.isDancing = false;
}

deleteAnchorOnDeath(anchor)
{
    self endon("dance_finished");
    self waittill("death");
    if (isDefined(anchor))
        anchor delete();
}
