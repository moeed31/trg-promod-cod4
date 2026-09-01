player(response)
{
	self endon("disconnect");

	switch(response)
	{
		// AK-47 CellShading (Assault, P10)
		case "equip_codo_ak47cell":
			if(self.pers["prestige"] >= 10)
			{
				self setStat(985, 1);
				self maps\mp\gametypes\_promod::setClassChoice("assault");
				if(isDefined(self.pers["assault"]))
				{
					self.pers["assault"]["loadout_primary"] = "codo_ak47cell";
					self setClientDvar("loadout_primary", "codo_ak47cell");
					self thread maps\mp\gametypes\_class::preserveClass("assault");
				}
				if(isAlive(self))
					self iprintlnbold(game["strings"]["change_class"]);
				self iprintln("Equipped Custom Weapon: ^5AK-47 CellShading^7!");
			}
			else
			{
				self iprintlnBold("^1Error: ^7Requires Prestige 10!");
			}
			break;

		case "unequip_codo_ak47cell":
			self setStat(985, 0);
			if(isDefined(self.pers["assault"]) && isDefined(self.pers["assault"]["loadout_primary"]) && self.pers["assault"]["loadout_primary"] == "codo_ak47cell")
			{
				self.pers["assault"]["loadout_primary"] = "ak47";
				self setClientDvar("loadout_primary", "ak47");
				self thread maps\mp\gametypes\_class::preserveClass("assault");
			}
			if(isAlive(self))
				self iprintlnbold(game["strings"]["change_class"]);
			self iprintln("Unequipped Custom Weapon: ^5AK-47 CellShading^7.");
			break;

		// Sniper: Intervention CellShading (Sniper, P1)


		// Demolition: Model 1887 CellShading (Demolition, P2)


		// Assault: M4A1 Tech CellShading (Assault, P3)
		case "equip_codo_m4a1techcell":
			if(self.pers["prestige"] >= 3)
			{
				self setStat(985, 1);
				self maps\mp\gametypes\_promod::setClassChoice("assault");
				if(isDefined(self.pers["assault"]))
				{
					self.pers["assault"]["loadout_primary"] = "codo_m4a1techcell";
					self setClientDvar("loadout_primary", "codo_m4a1techcell");
					self thread maps\mp\gametypes\_class::preserveClass("assault");
				}
				if(isAlive(self))
					self iprintlnbold(game["strings"]["change_class"]);
				self iprintln("Equipped Custom Weapon: ^5M4A1 Tech CellShading^7!");
			}
			else
			{
				self iprintlnBold("^1Error: ^7Requires Prestige 3!");
			}
			break;

		case "unequip_codo_m4a1techcell":
			self setStat(985, 0);
			if(isDefined(self.pers["assault"]) && isDefined(self.pers["assault"]["loadout_primary"]) && self.pers["assault"]["loadout_primary"] == "codo_m4a1techcell")
			{
				self.pers["assault"]["loadout_primary"] = "ak47";
				self setClientDvar("loadout_primary", "ak47");
				self thread maps\mp\gametypes\_class::preserveClass("assault");
			}
			if(isAlive(self))
				self iprintlnbold(game["strings"]["change_class"]);
			self iprintln("Unequipped Custom Weapon: ^5M4A1 Tech CellShading^7.");
			break;

		// Assault: AK117 CellShading (Assault, P4)
		case "equip_codo_ak117cell":
			if(self.pers["prestige"] >= 4)
			{
				self setStat(985, 1);
				self maps\mp\gametypes\_promod::setClassChoice("assault");
				if(isDefined(self.pers["assault"]))
				{
					self.pers["assault"]["loadout_primary"] = "codo_ak117cell";
					self setClientDvar("loadout_primary", "codo_ak117cell");
					self thread maps\mp\gametypes\_class::preserveClass("assault");
				}
				if(isAlive(self))
					self iprintlnbold(game["strings"]["change_class"]);
				self iprintln("Equipped Custom Weapon: ^5AK117 CellShading^7!");
			}
			else
			{
				self iprintlnBold("^1Error: ^7Requires Prestige 4!");
			}
			break;

		case "unequip_codo_ak117cell":
			self setStat(985, 0);
			if(isDefined(self.pers["assault"]) && isDefined(self.pers["assault"]["loadout_primary"]) && self.pers["assault"]["loadout_primary"] == "codo_ak117cell")
			{
				self.pers["assault"]["loadout_primary"] = "ak47";
				self setClientDvar("loadout_primary", "ak47");
				self thread maps\mp\gametypes\_class::preserveClass("assault");
			}
			if(isAlive(self))
				self iprintlnbold(game["strings"]["change_class"]);
			self iprintln("Unequipped Custom Weapon: ^5AK117 CellShading^7.");
			break;

		// Assault: MR23 CellShading (Assault, P5)


		// SMG: MP5SD CellShading (SMG, P6)
		case "equip_codo_mp5sdcell":
			if(self.pers["prestige"] >= 6)
			{
				self setStat(985, 1);
				self maps\mp\gametypes\_promod::setClassChoice("specops");
				if(isDefined(self.pers["specops"]))
				{
					self.pers["specops"]["loadout_primary"] = "codo_mp5sdcell";
					self setClientDvar("loadout_primary", "codo_mp5sdcell");
					self thread maps\mp\gametypes\_class::preserveClass("specops");
				}
				if(isAlive(self))
					self iprintlnbold(game["strings"]["change_class"]);
				self iprintln("Equipped Custom Weapon: ^5MP5SD CellShading^7!");
			}
			else
			{
				self iprintlnBold("^1Error: ^7Requires Prestige 6!");
			}
			break;

		case "unequip_codo_mp5sdcell":
			self setStat(985, 0);
			if(isDefined(self.pers["specops"]) && isDefined(self.pers["specops"]["loadout_primary"]) && self.pers["specops"]["loadout_primary"] == "codo_mp5sdcell")
			{
				self.pers["specops"]["loadout_primary"] = "ak74u";
				self setClientDvar("loadout_primary", "ak74u");
				self thread maps\mp\gametypes\_class::preserveClass("specops");
			}
			if(isAlive(self))
				self iprintlnbold(game["strings"]["change_class"]);
			self iprintln("Unequipped Custom Weapon: ^5MP5SD CellShading^7.");
			break;

		// SMG: PDW-2000 CellShading (SMG, P7)
		case "equip_codo_pdw2000cell":
			if(self.pers["prestige"] >= 7)
			{
				self setStat(985, 1);
				self maps\mp\gametypes\_promod::setClassChoice("specops");
				if(isDefined(self.pers["specops"]))
				{
					self.pers["specops"]["loadout_primary"] = "codo_pdw2000cell";
					self setClientDvar("loadout_primary", "codo_pdw2000cell");
					self thread maps\mp\gametypes\_class::preserveClass("specops");
				}
				if(isAlive(self))
					self iprintlnbold(game["strings"]["change_class"]);
				self iprintln("Equipped Custom Weapon: ^5PDW-2000 CellShading^7!");
			}
			else
			{
				self iprintlnBold("^1Error: ^7Requires Prestige 7!");
			}
			break;

		case "unequip_codo_pdw2000cell":
			self setStat(985, 0);
			if(isDefined(self.pers["specops"]) && isDefined(self.pers["specops"]["loadout_primary"]) && self.pers["specops"]["loadout_primary"] == "codo_pdw2000cell")
			{
				self.pers["specops"]["loadout_primary"] = "ak74u";
				self setClientDvar("loadout_primary", "ak74u");
				self thread maps\mp\gametypes\_class::preserveClass("specops");
			}
			if(isAlive(self))
				self iprintlnbold(game["strings"]["change_class"]);
			self iprintln("Unequipped Custom Weapon: ^5PDW-2000 CellShading^7.");
			break;
	}
}
