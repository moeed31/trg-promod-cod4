main()
{
    level.inspectWeapons = [];
    // addInspectableWeapon("deserteagle_mp");
    // addInspectableWeapon("deserteaglegold_mp");
}

addInspectableWeapon(weapon)
{
    alt = WeaponAltWeaponName(weapon);
    if (alt == "none" || alt == "")
        return;

    precacheItem(alt);
    i = level.inspectWeapons.size;
    level.inspectWeapons[i] = spawnStruct();
    level.inspectWeapons[i].weapon = weapon;
    level.inspectWeapons[i].alt = alt;
}

getInspectAltWeapon(wpn)
{
    for (i = 0; i < level.inspectWeapons.size; i++)
        if (level.inspectWeapons[i].weapon == wpn)
            return level.inspectWeapons[i].alt;
    return "none";
}

triggerInspect()
{
    self endon("disconnect");
    self endon("death");

    if ( !isAlive( self ) )
        return;

    if (isDefined(self.isInspecting) && self.isInspecting)
        return;

    inspectWpn = self getCurrentWeapon();
    temp = getInspectAltWeapon(inspectWpn);
    if (temp == "none")
        return;

    self.isInspecting = true;
    self thread resetInspectOnDeath();

    self giveWeapon(temp);
    wait 0.05;
    self switchToWeapon(temp);
    wait 0.05;
    // setSpawnWeapon saves current animation state but swaps models
    self setSpawnWeapon(inspectWpn);
    self takeWeapon(temp);

    // Wait for the duration of the inspect animation (altDropTime is 3.66s in weapon file)
    for (i = 0; i < 3.66; i += 0.05)
    {
        if (self attackButtonPressed() || self useButtonPressed())
        {
            self switchToWeapon("knife_mp");
            wait 0.05;
            self switchToWeapon(inspectWpn);
            break;
        }
        wait 0.05;
    }

    self notify("inspect_finished");
    self.isInspecting = false;
}

resetInspectOnDeath()
{
    self endon("inspect_finished");
    self waittill("death");
    self.isInspecting = false;
}