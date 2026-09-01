#include maps\mp\_utility;

init()
{
	// 1. Precache your custom design assets
	precacheShader("val_iron_1");
	precacheShader("val_iron_2");
	precacheShader("val_iron_3");
	precacheShader("val_bronze_1");
	precacheShader("val_bronze_2");
	precacheShader("val_bronze_3");
	precacheShader("val_silver_1");
	precacheShader("val_silver_2");
	precacheShader("val_silver_3");
	precacheShader("val_gold_1");
	precacheShader("val_gold_2");
	precacheShader("val_gold_3");
	precacheShader("val_plat_1");
	precacheShader("val_plat_2");
	precacheShader("val_plat_3");
	precacheShader("val_diamond");
	precacheShader("val_radiant");

	for( ;; )
	{
		level waittill( "connected", player );
		player thread onPlayerConnect();
	}
}

onPlayerConnect()
{
	self endon( "disconnect" );

	// Load XP from two byte slots
	thousands = self getStat( 61 );
	remainder = self getStat( 62 );

	if( !isdefined( thousands ) || thousands < 0 )
		thousands = 0;
	if( !isdefined( remainder ) || remainder < 0 )
		remainder = 0;

	self.pers["xp"] = ( thousands * 255 ) + remainder;

	self setClientDvar("ui_ls_rank_icon", getRankIcon(self.pers["xp"]));
	self setClientDvar("ui_ls_rank_name", getRankName(self.pers["xp"]));
	self setClientDvar("ui_ls_rr", self.pers["xp"]);
	self setClientDvar("ui_ls_rr_next", getNextRankXP(self.pers["xp"]));
	self setClientDvar("ui_ls_rr_prev", getPrevRankXP(self.pers["xp"]));

	// Create the clean HUD elements for the player
	self thread createRankHUD();
	self thread showRankOnSpawn();
}

createRankHUD()
{
	self endon("disconnect");

	if(isdefined(self.rankHUD)) self.rankHUD destroy();
	if(isdefined(self.rankIconHUD)) self.rankIconHUD destroy();

	// CREATE THE RANK ICON HUD (Your preferred working placement)
	self.rankIconHUD = newClientHudElem(self);
	self.rankIconHUD.elemType = "icon";
	self.rankIconHUD.alignX = "right";
	self.rankIconHUD.alignY = "top";
	self.rankIconHUD.horzAlign = "right";
	self.rankIconHUD.vertAlign = "top";
	self.rankIconHUD.x = -20; 
	self.rankIconHUD.y = 29;  
	self.rankIconHUD.width = 18;
	self.rankIconHUD.height = 18;
	self.rankIconHUD.hidewheninmenu = true;

	// CREATE THE RANK TEXT HUD (Your preferred working placement)
	self.rankHUD = newClientHudElem(self);
	self.rankHUD.elemType = "font";
	self.rankHUD.font = "objective";
	self.rankHUD.fontScale = 1.4;
	self.rankHUD.alignX = "right";
	self.rankHUD.alignY = "top";
	self.rankHUD.horzAlign = "right";
	self.rankHUD.vertAlign = "top";
	self.rankHUD.x = -45; 
	self.rankHUD.y = 30;
	self.rankHUD.glowColor = (0.2, 0.3, 0.7); 
	self.rankHUD.glowAlpha = 0.6;
	self.rankHUD.hidewheninmenu = true;

	xp = self.pers["xp"];
	rankName = getRankName(xp);
	
	self.rankIconHUD setShader( getRankIcon(xp), 18, 18 );
	self.rankHUD setText( "^9RANK: ^7" + rankName + " ^9| ^7" + xp + " ^9RR" );
}

addXP( amount )
{
	if( !isdefined( self.pers["xp"] ) )
		self.pers["xp"] = 0;

	oldName = getRankName( self.pers["xp"] );
	self.pers["xp"] += amount;
	if (self.pers["xp"] < 0) self.pers["xp"] = 0;
	newName = getRankName( self.pers["xp"] );

	self thread saveXP();
	self setClientDvar("ui_ls_rank_icon", getRankIcon(self.pers["xp"]));
	self setClientDvar("ui_ls_rank_name", newName);
	self setClientDvar("ui_ls_rr", self.pers["xp"]);
	self setClientDvar("ui_ls_rr_next", getNextRankXP(self.pers["xp"]));
	self setClientDvar("ui_ls_rr_prev", getPrevRankXP(self.pers["xp"]));
	//self thread updateScoreboardRank();

	// Update HUD elements live using your strict scale requirements
	if(isdefined(self.rankHUD) && isdefined(self.rankIconHUD))
	{
		self.rankHUD setText( "^9RANK: ^7" + newName + " ^9| ^7" + self.pers["xp"] + " ^9RR" );
		self.rankIconHUD setShader( getRankIcon(self.pers["xp"]), 18, 18 );
		
		// Fixed alignment constraint pulse sequence
		self.rankHUD.fontScale = 1.5;
		wait 0.15;
		if(isdefined(self.rankHUD) && isdefined(self.rankIconHUD))
		{
			self.rankHUD.fontScale = 1.4;
			self.rankIconHUD.width = 18;
			self.rankIconHUD.height = 18;
		}
	}

	self iprintln( "^2+" + amount + " RR ^7| Total: ^3" + self.pers["xp"] + " ^7| " + newName );

	if( oldName != newName )
	{
		self iprintlnbold( "^2RANK UP! ^7You are now ^3" + newName );
		self thread rankUpCinematicAnimation( newName, getRankIcon( self.pers["xp"] ), false );
	}
}

applyEndGameRR()
{
	self endon("disconnect");

	if ( !isDefined( self.pers["xp"] ) )
		self.pers["xp"] = 0;

	// 1. Check if the player has played at least 8 rounds in the match
	if (!isDefined(self.pers["roundsPlayed"]) || self.pers["roundsPlayed"] < 8)
	{
		roundsPlayed = 0;
		if (isDefined(self.pers["roundsPlayed"]))
			roundsPlayed = self.pers["roundsPlayed"];
			
		self iprintln("^1Ranked Rating skipped: ^7You played " + roundsPlayed + " rounds (minimum 8 required).");
		self.pers["rrChange"] = 0;
		self.pers["rrSkipped"] = true;
		
		// Still set current dvars so the HUD is populated correctly
		self setClientDvar("ui_ls_rank_icon", getRankIcon(self.pers["xp"]));
		self setClientDvar("ui_ls_rank_name", getRankName(self.pers["xp"]));
		self setClientDvar("ui_ls_rr", self.pers["xp"]);
	self setClientDvar("ui_ls_rr_next", getNextRankXP(self.pers["xp"]));
	self setClientDvar("ui_ls_rr_prev", getPrevRankXP(self.pers["xp"]));
		return;
	}

	kills = 0;
	if (isDefined(self.pers["kills"]))
		kills = self.pers["kills"];
		
	deaths = 0;
	if (isDefined(self.pers["deaths"]))
		deaths = self.pers["deaths"];
		
	if (deaths == 0)
		kd = kills;
	else
		kd = kills / deaths;
		
	kd_tenths = int(kd * 10);
	rr_change = 0;
	if(kd_tenths >= 10)
	{
		rr_change = kd_tenths * 10;
		if(rr_change > 500) rr_change = 500;
	}
	else
	{
		rr_change = (kd_tenths * 10) - 100;
	}

	plants = 0;
	if (isDefined(self.pers["plants"])) plants = self.pers["plants"];
	defuses = 0;
	if (isDefined(self.pers["defuses"])) defuses = self.pers["defuses"];
	score = 0;
	if (isDefined(self.pers["score"])) score = self.pers["score"];
	
	// Base actions
	rr_change += (kills * 5);
	rr_change += (plants * 5);
	rr_change += (defuses * 50);

	// Match MVP / Most Stats
	highestKills = 0; highestDeaths = 0; highestPlants = 0; highestDefuses = 0; highestScore = 0;
	for(i=0; i<level.players.size; i++)
	{
		p = level.players[i];
		if(!isDefined(p) || !isDefined(p.pers)) continue;
		if(isDefined(p.pers["kills"]) && p.pers["kills"] > highestKills) highestKills = p.pers["kills"];
		if(isDefined(p.pers["deaths"]) && p.pers["deaths"] > highestDeaths) highestDeaths = p.pers["deaths"];
		if(isDefined(p.pers["plants"]) && p.pers["plants"] > highestPlants) highestPlants = p.pers["plants"];
		if(isDefined(p.pers["defuses"]) && p.pers["defuses"] > highestDefuses) highestDefuses = p.pers["defuses"];
		if(isDefined(p.pers["score"]) && p.pers["score"] > highestScore) highestScore = p.pers["score"];
	}
	
	if(highestKills > 0 && kills == highestKills) rr_change += 50;
	if(highestDeaths > 0 && deaths == highestDeaths) rr_change -= 50;
	if(highestPlants > 0 && plants == highestPlants) rr_change += 50;
	if(highestDefuses > 0 && defuses == highestDefuses) rr_change += 100;
	if(highestScore > 0 && score == highestScore) rr_change += 150;
		
	self.pers["rrChange"] = rr_change;
	self.pers["rrSkipped"] = undefined;
		
	if (!isDefined(self.pers["xp"]))
		self.pers["xp"] = 0;
		
	old_xp = self.pers["xp"];
	new_xp = old_xp + rr_change;
	if (new_xp < 0)
		new_xp = 0; // Prevent negative RR
		
	self.pers["xp"] = new_xp;
	self thread saveXP();
	
	self setClientDvar("ui_ls_rank_icon", getRankIcon(new_xp));
	self setClientDvar("ui_ls_rank_name", getRankName(new_xp));
	self setClientDvar("ui_ls_rr", new_xp);
	self setClientDvar("ui_ls_rr_next", getNextRankXP(new_xp));
	self setClientDvar("ui_ls_rr_prev", getPrevRankXP(new_xp));
	
	if (isdefined(self.rankHUD) && isdefined(self.rankIconHUD))
	{
		self.rankHUD setText("^9RANK: ^7" + getRankName(new_xp) + " ^9| ^7" + new_xp + " ^9RR");
		self.rankIconHUD setShader(getRankIcon(new_xp), 18, 18);
	}
	
	if (rr_change > 0)
		self iprintln("^2+" + rr_change + " RR ^7| Total: ^3" + new_xp + " ^7RR");
	else
		self iprintln("^1" + rr_change + " RR ^7| Total: ^3" + new_xp + " ^7RR");
		
	oldRankName = getRankName(old_xp);
	newRankName = getRankName(new_xp);
	
	if (oldRankName != newRankName)
	{
		if (new_xp > old_xp)
		{
			self iprintlnbold("^2RANK UP! ^7You are now ^3" + newRankName);
			self thread rankUpCinematicAnimation(newRankName, getRankIcon(new_xp), false);
		}
		else
		{
			self iprintlnbold("^1RANK DEMOTED! ^7You are now ^3" + newRankName);
			self thread rankUpCinematicAnimation(newRankName, getRankIcon(new_xp), true);
		}
	}
}

rankUpCinematicAnimation( rankName, iconShader, isDemotion )
{
	self endon("disconnect");

	rankText = newClientHudElem(self);
	rankText.elemType = "font";
	rankText.font = "objective";
	rankText.fontScale = 2.2;
	rankText.alignX = "center";
	rankText.alignY = "middle";
	rankText.horzAlign = "center";
	rankText.vertAlign = "middle"; 
	rankText.y = 35; 
	if(isDefined(isDemotion) && isDemotion)
		rankText.glowColor = (0.7, 0.2, 0.2); // Red for demotion
	else
		rankText.glowColor = (0.2, 0.7, 0.3); // Green for rank up
	rankText.glowAlpha = 0.7;
	rankText.alpha = 0;
	rankText.hidewheninmenu = true;
	
	if(isDefined(isDemotion) && isDemotion)
		rankText setText("^1RANK DEMOTED! ^7You are now ^3" + rankName);
	else
		rankText setText("^2RANK UP! ^7You are now ^3" + rankName);

	rankIcon = newClientHudElem(self);
	rankIcon.elemType = "icon";
	rankIcon.alignX = "center";
	rankIcon.alignY = "middle";
	rankIcon.horzAlign = "center";
	rankIcon.vertAlign = "middle"; 
	rankIcon.y = -30; 
	rankIcon.width = 2; 
	rankIcon.height = 2;
	rankIcon.alpha = 0;
	rankIcon.hidewheninmenu = true;
	rankIcon setShader(iconShader, 64, 64);

	rankText fadeOverTime(0.25);
	rankText.alpha = 1;
	
	rankIcon fadeOverTime(0.25);
	rankIcon.alpha = 1;
	rankIcon scaleOverTime(0.25, 72, 72);
	wait 0.25;
	
	if(isDefined(rankIcon))
		rankIcon scaleOverTime(0.15, 56, 56);
	
	wait 2.5;

	if(isDefined(rankText))
	{
		rankText fadeOverTime(0.5);
		rankText.alpha = 0;
	}
	if(isDefined(rankIcon))
	{
		rankIcon fadeOverTime(0.5);
		rankIcon.alpha = 0;
	}
	wait 0.5;

	if(isDefined(rankText)) rankText destroy();
	if(isDefined(rankIcon)) rankIcon destroy();
}

getRankIcon( xp )
{
	if( xp >= 100000 ) return "val_radiant";
	if( xp >= 75000 )  return "val_diamond";  
	if( xp >= 57000 )  return "val_plat_3";
	if( xp >= 45000 )  return "val_plat_2";  
	if( xp >= 35000 )  return "val_plat_1";
	if( xp >= 28000 )  return "val_gold_3";  
	if( xp >= 22000 )  return "val_gold_2";
	if( xp >= 17000 )  return "val_gold_1";  
	if( xp >= 13000 )  return "val_silver_3";
	if( xp >= 10000 )  return "val_silver_2";  
	if( xp >= 7500 )   return "val_silver_1";
	if( xp >= 5000 )   return "val_bronze_3";   
	if( xp >= 3500 )   return "val_bronze_2";
	if( xp >= 2000 )   return "val_bronze_1";   
	if( xp >= 1000 )   return "val_iron_3";
	if( xp >= 500 )    return "val_iron_2"; 
	return "val_iron_1";
}

saveXP()
{
	xp        = self.pers["xp"];
	thousands = int( xp / 255 );
	remainder = xp - ( thousands * 255 );

	self setStat( 61, thousands );
	self setStat( 62, remainder );
}

showRankOnSpawn()
{
	self endon( "disconnect" );

	for( ;; )
	{
		self waittill( "spawned_player" );
		wait 1;
		// Keeps center screen completely clean of loop text spam
		//self thread updateScoreboardRank();
	}
}


getNextRankXP( xp )
{
	if( xp >= 100000 ) return 100000;
	if( xp >= 75000 )  return 100000;
	if( xp >= 57000 )  return 75000;
	if( xp >= 45000 )  return 57000;
	if( xp >= 35000 )  return 45000;
	if( xp >= 28000 )  return 35000;
	if( xp >= 22000 )  return 28000;
	if( xp >= 17000 )  return 22000;
	if( xp >= 13000 )  return 17000;
	if( xp >= 10000 )  return 13000;
	if( xp >= 7500 )   return 10000;
	if( xp >= 5000 )   return 7500;
	if( xp >= 3500 )   return 5000;
	if( xp >= 2000 )   return 3500;
	if( xp >= 1000 )   return 2000;
	if( xp >= 500 )    return 1000;
	return 500;
}

getPrevRankXP( xp )
{
	if( xp >= 100000 ) return 75000;
	if( xp >= 75000 )  return 57000;
	if( xp >= 57000 )  return 45000;
	if( xp >= 45000 )  return 35000;
	if( xp >= 35000 )  return 28000;
	if( xp >= 28000 )  return 22000;
	if( xp >= 22000 )  return 17000;
	if( xp >= 17000 )  return 13000;
	if( xp >= 13000 )  return 10000;
	if( xp >= 10000 )  return 7500;
	if( xp >= 7500 )   return 5000;
	if( xp >= 5000 )   return 3500;
	if( xp >= 3500 )   return 2000;
	if( xp >= 2000 )   return 1000;
	if( xp >= 1000 )   return 500;
	if( xp >= 500 )    return 0;
	return 0;
}

getRankName( xp )
{
	if( xp >= 100000 ) return "The Ripper Elite";
	if( xp >= 75000 )  return "TRG Legend";
	if( xp >= 57000 )  return "TRG Champion";
	if( xp >= 45000 )  return "Elite III";
	if( xp >= 35000 )  return "Elite II";
	if( xp >= 28000 )  return "Elite I";
	if( xp >= 22000 )  return "Apex III";
	if( xp >= 17000 )  return "Apex II";
	if( xp >= 13000 )  return "Apex I";
	if( xp >= 10000 )  return "Vanguard III";
	if( xp >= 7500 )   return "Vanguard II";
	if( xp >= 5000 )   return "Vanguard I";
	if( xp >= 3500 )   return "Rogue III";
	if( xp >= 2000 )   return "Rogue II";
	if( xp >= 1000 )   return "Rogue I";
	if( xp >= 500 )    return "Outcast";
	return "Recruit";
}

showPlayerEndRankHUD()
{
	self endon("disconnect");
	
	if ( !isDefined( self.pers["xp"] ) )
		self.pers["xp"] = 0;
	
	// Background box - Widened to 420px to match Highlights/MVP box above it
	bg = newClientHudElem(self);
	bg.elemType = "icon";
	bg.alignX = "center";
	bg.alignY = "middle";
	bg.horzAlign = "center";
	bg.vertAlign = "middle";
	bg.x = 0;
	bg.y = 85;
	bg.width = 420;
	bg.height = 50;
	bg.sort = 99;
	bg setShader("white", 420, 50);
	bg.color = (0.075, 0.075, 0.086); // Dark Navy theme bg
	bg.alpha = 0;
	bg fadeOverTime(0.5);
	bg.alpha = 0.8;
	
	// Top/border line - Widened to 420px
	top = newClientHudElem(self);
	top.elemType = "icon";
	top.alignX = "center";
	top.alignY = "middle";
	top.horzAlign = "center";
	top.vertAlign = "middle";
	top.x = 0;
	top.y = 60;
	top.width = 420;
	top.height = 2;
	top.sort = 100;
	top setShader("white", 420, 2);
	top.color = (0, 0.48, 1); // Electric Blue
	top.alpha = 0;
	top fadeOverTime(0.5);
	top.alpha = 0.9;
	
	// Rank Icon - Repositioned to left side of the wider box
	icon = newClientHudElem(self);
	icon.elemType = "icon";
	icon.alignX = "center";
	icon.alignY = "middle";
	icon.horzAlign = "center";
	icon.vertAlign = "middle";
	icon.x = -170;
	icon.y = 85;
	icon.width = 32;
	icon.height = 32;
	icon.sort = 100;
	icon setShader(getRankIcon(self.pers["xp"]), 32, 32);
	icon.alpha = 0;
	icon fadeOverTime(0.5);
	icon.alpha = 1;
	
	// Rank Name & Total RR - Set to minimum required fontScale 1.4
	rankName = getRankName(self.pers["xp"]);
	rankText = newClientHudElem(self);
	rankText.elemType = "font";
	rankText.font = "default";
	rankText.fontScale = 1.4;
	rankText.alignX = "left";
	rankText.alignY = "middle";
	rankText.horzAlign = "center";
	rankText.vertAlign = "middle";
	rankText.x = -135;
	rankText.y = 75;
	rankText.sort = 100;
	rankText setText("^5" + rankName + " ^9| ^7" + self.pers["xp"] + " ^9RR");
	rankText.alpha = 0;
	rankText fadeOverTime(0.5);
	rankText.alpha = 1;
	
	// RR Gained/Lost status text - Set to minimum required fontScale 1.4
	statusText = newClientHudElem(self);
	statusText.elemType = "font";
	statusText.font = "default";
	statusText.fontScale = 1.4;
	statusText.alignX = "left";
	statusText.alignY = "middle";
	statusText.horzAlign = "center";
	statusText.vertAlign = "middle";
	statusText.x = -135;
	statusText.y = 95;
	statusText.sort = 100;
	
	rrChange = 0;
	if (isDefined(self.pers["rrChange"]))
		rrChange = self.pers["rrChange"];
		
	if (isDefined(self.pers["rrSkipped"]) && self.pers["rrSkipped"])
	{
		statusText setText("^8Result: ^3Skipped (< 8 rounds)");
	}
	else if (rrChange > 0)
	{
		statusText setText("^8Result: ^2+" + rrChange + " RR");
	}
	else if (rrChange < 0)
	{
		statusText setText("^8Result: ^1" + rrChange + " RR");
	}
	else
	{
		statusText setText("^8Result: ^70 RR");
	}
	
	statusText.alpha = 0;
	statusText fadeOverTime(0.5);
	statusText.alpha = 1;
	
	// Wait 8 seconds matching the Main stats display time
	wait 8;
	
	// Fade out and clean up
	bg fadeOverTime(0.5);
	bg.alpha = 0;
	top fadeOverTime(0.5);
	top.alpha = 0;
	icon fadeOverTime(0.5);
	icon.alpha = 0;
	rankText fadeOverTime(0.5);
	rankText.alpha = 0;
	statusText fadeOverTime(0.5);
	statusText.alpha = 0;
	
	wait 0.5;
	
	if(isDefined(bg)) bg destroy();
	if(isDefined(top)) top destroy();
	if(isDefined(icon)) icon destroy();
	if(isDefined(rankText)) rankText destroy();
	if(isDefined(statusText)) statusText destroy();
}