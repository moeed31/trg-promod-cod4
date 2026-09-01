map()
{
	if (level.players.size == 0)
	{
		exitLevel(false);
		return;
	}

	level.votetime = 15;

	// Parse map rotation
	maprotation = strTok(getDvar("sv_maprotation"), " ");
	level.voteablemaps = [];
	
	current_gt = getDvar("g_gametype");
	for(i=0; i<maprotation.size; i++)
	{
		if(maprotation[i] == "gametype")
		{
			if(isDefined(maprotation[i+1]))
				current_gt = maprotation[i+1];
			i++;
		}
		else if(maprotation[i] == "map")
		{
			if(isDefined(maprotation[i+1]))
			{
				index = level.voteablemaps.size;
				level.voteablemaps[index] = spawnStruct();
				level.voteablemaps[index].map = maprotation[i+1];
				level.voteablemaps[index].gt = current_gt;
			}
			i++;
		}
	}

	if(level.voteablemaps.size < 1)
	{
		iprintlnbold("^1Error: No maps found in sv_mapRotation!");
		wait 5;
		exitLevel(false);
		return;
	}

	// Separate SD and SR maps
	sd_maps = [];
	sr_maps = [];
	
	for(i=0; i<level.voteablemaps.size; i++)
	{
		m = level.voteablemaps[i];
		duplicate = false;
		
		if (m.gt == "sd")
		{
			for(k=0; k<sd_maps.size; k++)
				if(sd_maps[k].map == m.map) duplicate = true;
			if(!duplicate) sd_maps[sd_maps.size] = m;
		}
		else if (m.gt == "sr")
		{
			for(k=0; k<sr_maps.size; k++)
				if(sr_maps[k].map == m.map) duplicate = true;
			if(!duplicate) sr_maps[sr_maps.size] = m;
		}
	}
	
	// Shuffle sd_maps
	for(i=0; i<sd_maps.size; i++)
	{
		r = randomInt(sd_maps.size);
		temp = sd_maps[i];
		sd_maps[i] = sd_maps[r];
		sd_maps[r] = temp;
	}
	
	// Shuffle sr_maps
	for(i=0; i<sr_maps.size; i++)
	{
		r = randomInt(sr_maps.size);
		temp = sr_maps[i];
		sr_maps[i] = sr_maps[r];
		sr_maps[r] = temp;
	}
	
	level.selected_maps = [];
	
	// Fill Slots 1-8 (Index 0-7) with SD Maps
	for(i=0; i<8; i++)
	{
		index = level.selected_maps.size;
		level.selected_maps[index] = spawnStruct();
		if(i < sd_maps.size)
		{
			level.selected_maps[index].map = sd_maps[i].map;
			level.selected_maps[index].gt = sd_maps[i].gt;
		}
		else
		{
			level.selected_maps[index].map = "map_restart";
			level.selected_maps[index].gt = "sd";
		}
	}
	
	// Fill Slots 9-16 (Index 8-15) with SR Maps
	for(i=0; i<8; i++)
	{
		index = level.selected_maps.size;
		level.selected_maps[index] = spawnStruct();
		if(i < sr_maps.size)
		{
			level.selected_maps[index].map = sr_maps[i].map;
			level.selected_maps[index].gt = sr_maps[i].gt;
		}
		else
		{
			level.selected_maps[index].map = "map_restart";
			level.selected_maps[index].gt = "sr";
		}
	}

	// Initialize dvar slots
	for(i=1; i<=16; i++)
	{
		m = level.selected_maps[i-1];
		if(m.map == "map_restart")
		{
			level.map["map" + i] = "loadscreen_" + getDvar("mapname");
			level.map["map" + i + "_realname"] = "Map Restart (" + getCleanGTName(m.gt) + ")";
			level.map["map" + i + "_material"] = "loadscreen_" + getDvar("mapname");
			level.map["map" + i + "_gt_fullname"] = getFullGTName(m.gt);
		}
		else
		{
			level.map["map" + i] = "loadscreen_" + m.map;
			level.map["map" + i + "_realname"] = getRealMapName(m.map) + " (" + getCleanGTName(m.gt) + ")";
			level.map["map" + i + "_material"] = "loadscreen_" + m.map;
			level.map["map" + i + "_gt_fullname"] = getFullGTName(m.gt);
		}
		level.map["map" + i + "_votes"] = 0;
	}
	level.map["map0_votes"] = 0;
	level.voting = true;

	// Play Endround Music (respecting player preferences) concurrently
	thread playEndroundMusic();

	// Show End Match Stats First
	showEndMatchStats();

	// Open Map Vote Menu for all players
	for(i=0; i<level.players.size; i++)
	{
		player = level.players[i];
		if(!isDefined(player))
			continue;
			
		for(k=1; k<=16; k++)
		{
			player setClientDvar("map" + k + "_realname", level.map["map" + k + "_realname"]);
			player setClientDvar("map" + k, level.map["map" + k + "_material"]);
			player setClientDvar("map" + k + "_gt_fullname", level.map["map" + k + "_gt_fullname"]);
		}
		player setClientDvar("selected_map", 1337);
		player.lastvoted = 0;
		player.specate = undefined;
		
		player closeMenu();
		player closeInGameMenu();
		player thread updateVotes();
		player thread voteMenuResponse();
		
		wait 0.05;
		player openMenu("votemap");
	}

	time = level.votetime;
	for(i=0; i<time; i++)
	{
		wait 1;
		level.votetime -= 1;
	}

	level.voting = undefined;
	winner = level getMostVotedForMap();
	name = getRealMapName(winner.map) + " (" + getCleanGTName(winner.gt) + ")";
	allClientDvar("votetime", "Winner Map: ^2" + name);
	allClientDvar("selected_map", level.winner_index);
	allClientDvar("cl_bypassmouseinput", 0);
	
	// Close all menus so winner map doesn't display behind the votemenu
	for(i=0; i<level.players.size; i++) {
		level.players[i] closeMenu();
		level.players[i] closeInGameMenu();
		level.players[i] setClientDvar("r_blur", 5);
	}
	
	// Display Winner Map Centrally
	winnerImage = "";
	if(winner.map == "map_restart") winnerImage = "loadscreen_" + getDvar("mapname");
	else winnerImage = "loadscreen_" + winner.map;
	
	darkOverlay = scripts\utility\common::addTextHud(level, 0, 0, 0.7, "left", "top", "fullscreen", "fullscreen", 0, 98);
	darkOverlay setShader("black", 640, 480);

	winnerTitle = scripts\utility\common::addTextHud(level, 0, -100, 1, "center", "middle", "center", "middle", 2.0, 101);
	winnerTitle setText("^2Next Map");

	winnerBorder = scripts\utility\common::addTextHud(level, 0, 0, 1, "center", "middle", "center", "middle", 0, 99);
	winnerBorder setShader("white", 244, 164);
  
	winnerBg = scripts\utility\common::addTextHud(level, 0, 0, 1, "center", "middle", "center", "middle", 0, 100);
	winnerBg setShader(winnerImage, 240, 160);
	
	winnerNameTxt = scripts\utility\common::addTextHud(level, 0, 100, 1, "center", "middle", "center", "middle", 1.8, 101);
	winnerNameTxt setText(name);
	
	freezeall();
	changelevel(winner.map, winner.gt, 2, false);
}

showEndMatchStats()
{
	killsText = getHighestStatText("kills", "Most Kills");
	deathsText = getHighestStatText("deaths", "Most Deaths");
	assistsText = getHighestStatText("assists", "Most Assists");
	headshotsText = getHighestStatText("headshots", "Most Headshots");
	plantsText = getHighestStatText("plants", "Most Plants");
	defusesText = getHighestStatText("defuses", "Most Defuses");
	mvpText = getMVPText();

	// Background container
	bg = scripts\utility\common::addTextHud(level, 0, -60, 0.75, "center", "middle", "center", "middle", 0, 99);
	bg setShader("white", 420, 220);
	bg.color = (0, 0, 0); // Black theme bg
	bg thread scripts\utility\common::fadeIn(0.5);

	// Card Top Accent Line
	topLine = scripts\utility\common::addTextHud(level, 0, -170, 0.9, "center", "middle", "center", "middle", 0, 100);
	topLine setShader("white", 420, 3);
	topLine.color = (0.95, 0.72, 0.21); // Golden Yellow
	topLine thread scripts\utility\common::fadeIn(0.5);

	// Title
	title = scripts\utility\common::addTextHud(level, 0, -126, 1, "center", "middle", "center", "middle", 1.8, 100);
	title setText("^3MATCH HIGHLIGHTS");
	title thread scripts\utility\common::fadeIn(0.5);

	// Semtex Logo on top of Title
	logo = scripts\utility\common::addTextHud(level, 0, -148, 0.85, "center", "middle", "center", "middle", 0, 100);
	logo setShader("semtex_logo", 30, 30);
	logo thread scripts\utility\common::fadeIn(0.5);

	// MVP Title
	mvpHdr = scripts\utility\common::addTextHud(level, 0, -108, 0.85, "center", "middle", "center", "middle", 1.4, 100);
	mvpHdr setText("^3MVP OF THE MATCH");
	mvpHdr thread scripts\utility\common::fadeIn(0.5);

	// MVP Value
	mvpVal = scripts\utility\common::addTextHud(level, 0, -93, 1, "center", "middle", "center", "middle", 1.6, 100);
	mvpVal setText(mvpText);
	mvpVal thread scripts\utility\common::fadeIn(0.5);

	// MVP Badge Icon (left of MVP Value)
	mvpBadge = scripts\utility\common::addTextHud(level, -140, -93, 1, "center", "middle", "center", "middle", 0, 100);
	mvpBadge setShader("sles_hud_medals_score", 20, 20);
	mvpBadge thread scripts\utility\common::fadeIn(0.5);

	// Divider line below MVP
	divider = scripts\utility\common::addTextHud(level, 0, -80, 0.3, "center", "middle", "center", "middle", 0, 100);
	divider setShader("white", 380, 1);
	divider.color = (0.95, 0.72, 0.21); // Golden Yellow
	divider thread scripts\utility\common::fadeIn(0.5);

	// Column 1 Stats (Left side)
	y_offset = -60;
	stat1 = scripts\utility\common::addTextHud(level, -180, y_offset, 1, "left", "middle", "center", "middle", 1.4, 100);
	stat1 setText(killsText);
	stat1 thread scripts\utility\common::fadeIn(0.5);

	badge1 = scripts\utility\common::addTextHud(level, -200, y_offset, 1, "center", "middle", "center", "middle", 0, 100);
	badge1 setShader("sles_hud_medals_kills", 20, 20);
	badge1 thread scripts\utility\common::fadeIn(0.5);
	
	stat2 = scripts\utility\common::addTextHud(level, -180, y_offset + 25, 1, "left", "middle", "center", "middle", 1.4, 100);
	stat2 setText(deathsText);
	stat2 thread scripts\utility\common::fadeIn(0.5);

	badge2 = scripts\utility\common::addTextHud(level, -200, y_offset + 25, 1, "center", "middle", "center", "middle", 0, 100);
	badge2 setShader("sles_hud_medals_deaths", 20, 20);
	badge2 thread scripts\utility\common::fadeIn(0.5);

	stat3 = scripts\utility\common::addTextHud(level, -180, y_offset + 50, 1, "left", "middle", "center", "middle", 1.4, 100);
	stat3 setText(plantsText);
	stat3 thread scripts\utility\common::fadeIn(0.5);

	badge3 = scripts\utility\common::addTextHud(level, -200, y_offset + 50, 1, "center", "middle", "center", "middle", 0, 100);
	badge3 setShader("sles_hud_medals_plants", 20, 20);
	badge3 thread scripts\utility\common::fadeIn(0.5);

	// Column 2 Stats (Right side)
	stat4 = scripts\utility\common::addTextHud(level, 10, y_offset, 1, "left", "middle", "center", "middle", 1.4, 100);
	stat4 setText(assistsText);
	stat4 thread scripts\utility\common::fadeIn(0.5);

	badge4 = scripts\utility\common::addTextHud(level, -10, y_offset, 1, "center", "middle", "center", "middle", 0, 100);
	badge4 setShader("sles_hud_medals_assists", 20, 20);
	badge4 thread scripts\utility\common::fadeIn(0.5);

	stat5 = scripts\utility\common::addTextHud(level, 10, y_offset + 25, 1, "left", "middle", "center", "middle", 1.4, 100);
	stat5 setText(headshotsText);
	stat5 thread scripts\utility\common::fadeIn(0.5);

	badge5 = scripts\utility\common::addTextHud(level, -10, y_offset + 25, 1, "center", "middle", "center", "middle", 0, 100);
	badge5 setShader("sles_hud_medals_headshots", 20, 20);
	badge5 thread scripts\utility\common::fadeIn(0.5);

	stat6 = scripts\utility\common::addTextHud(level, 10, y_offset + 50, 1, "left", "middle", "center", "middle", 1.4, 100);
	stat6 setText(defusesText);
	stat6 thread scripts\utility\common::fadeIn(0.5);

	badge6 = scripts\utility\common::addTextHud(level, -10, y_offset + 50, 1, "center", "middle", "center", "middle", 0, 100);
	badge6 setShader("sles_hud_medals_defuses", 20, 20);
	badge6 thread scripts\utility\common::fadeIn(0.5);

	// Display player-specific Rank HUDs (icon, total RR, match RR)
	for(i=0; i<level.players.size; i++)
	{
		player = level.players[i];
		if(isDefined(player))
			player thread promod\ls_ranks::showPlayerEndRankHUD();
	}

	wait 8;

	bg thread scripts\utility\common::fadeOut(0.5);
	topLine thread scripts\utility\common::fadeOut(0.5);
	title thread scripts\utility\common::fadeOut(0.5);
	logo thread scripts\utility\common::fadeOut(0.5);
	mvpHdr thread scripts\utility\common::fadeOut(0.5);
	mvpVal thread scripts\utility\common::fadeOut(0.5);
	mvpBadge thread scripts\utility\common::fadeOut(0.5);
	divider thread scripts\utility\common::fadeOut(0.5);
	stat1 thread scripts\utility\common::fadeOut(0.5);
	badge1 thread scripts\utility\common::fadeOut(0.5);
	stat2 thread scripts\utility\common::fadeOut(0.5);
	badge2 thread scripts\utility\common::fadeOut(0.5);
	stat3 thread scripts\utility\common::fadeOut(0.5);
	badge3 thread scripts\utility\common::fadeOut(0.5);
	stat4 thread scripts\utility\common::fadeOut(0.5);
	badge4 thread scripts\utility\common::fadeOut(0.5);
	stat5 thread scripts\utility\common::fadeOut(0.5);
	badge5 thread scripts\utility\common::fadeOut(0.5);
	stat6 thread scripts\utility\common::fadeOut(0.5);
	badge6 thread scripts\utility\common::fadeOut(0.5);
	wait 0.5;
}

getHighestStatText(stat, label)
{
	bestVal = 0;
	bestPlr = undefined;
	for(i=0; i<level.players.size; i++)
	{
		player = level.players[i];
		if(!isDefined(player) || !isDefined(player.pers[stat]))
			continue;
		if(player.pers[stat] > bestVal)
		{
			bestVal = player.pers[stat];
			bestPlr = player;
		}
	}
	if(bestVal > 0 && isDefined(bestPlr))
		return label + ": ^2" + bestPlr.name + " ^7(^1" + bestVal + "^7)";
	return label + ": ^8None";
}

getMVPText()
{
	bestScore = -1;
	bestPlr = undefined;
	for(i=0; i<level.players.size; i++)
	{
		player = level.players[i];
		if(!isDefined(player) || !isDefined(player.pers["score"]))
			continue;
		if(player.pers["score"] > bestScore)
		{
			bestScore = player.pers["score"];
			bestPlr = player;
		}
	}
	if(bestScore > 0 && isDefined(bestPlr))
	{
		kills = 0;
		deaths = 0;
		if(isDefined(bestPlr.pers["kills"]))
			kills = bestPlr.pers["kills"];
		if(isDefined(bestPlr.pers["deaths"]))
			deaths = bestPlr.pers["deaths"];
		return "^5" + bestPlr.name + " ^7(^2" + bestScore + " Score ^7| ^1" + kills + "^7K - ^1" + deaths + "^7D)";
	}
	return "^8None";
}

playEndroundMusic()
{
	for(i = 0; i < level.players.size; i++) 
	{
		player = level.players[i];
		if(!isDefined(player))
			continue;
		if(player getstat(1223) == 2) // If endround music is disabled (value = 2), skip
			continue;
		number = (1 + randomInt(4));
		player playLocalSound("endmap" + number);
	}
}

voteMenuResponse()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		if(menu == game["votemap"])
			votemap(response);
	}
}

allClientDvar(dvar, value)
{
	for(i=0;i<level.players.size;i++)
	{
		player = level.players[i];
		if(isDefined(player))
			player setClientDvar(dvar, value);
	}
}

getRealMapName(map)
{
	mapname = "";
	switch(map)
	{
		case "map_restart": 	mapname = "Map Restart";	break;
		case "mp_backlot": 		mapname = "Backlot";		break;
		case "mp_backlot_x": 		mapname = "Backlot X";		break;
		case "mp_bloc": 		mapname = "Bloc"; 			break;
		case "mp_bog": 			mapname = "Bog"; 			break;
		case "mp_broadcast": 	mapname = "Broadcast";		break;
		case "mp_cargoship": 	mapname = "Wetwork"; 		break;
		case "mp_citystreets": 	mapname = "District"; 		break;
		case "mp_convoy":		mapname = "Ambush"; 		break;
		case "mp_countdown": 	mapname = "Countdown"; 		break;
		case "mp_crash": 		mapname = "Crash"; 			break;
		case "mp_crossfire": 	mapname = "Crossfire"; 		break;
		case "mp_farm": 		mapname = "Downpour"; 		break;
		case "mp_overgrown": 	mapname = "Overgrown"; 		break;
		case "mp_pipeline": 	mapname = "Pipeline"; 		break;
		case "mp_shipment": 	mapname = "Shipment"; 		break;
		case "mp_showdown": 	mapname = "Showdown"; 		break;
		case "mp_strike": 		mapname = "Strike"; 		break;
		case "mp_vacant": 		mapname = "Vacant"; 		break;
		case "mp_crash_snow": 	mapname = "Winter Crash"; 	break;
		case "mp_creek": 		mapname = "Creek"; 			break;
		case "mp_carentan": 	mapname = "Chinatown"; 		break;
		case "mp_killhouse":	mapname = "Killhouse"; 		break;
		case "mp_marketcenter":	mapname = "Marketcenter"; 	break;
		case "mp_nuketown":		mapname = "Nuketown"; 		break;
	}
	if(mapname == "")
		mapname = getGoodName(map);
	return mapname;
}

isCustomMap(mapname)
{
	isCustom = true;
	switch(mapname)
	{
		case "mp_backlot":
		case "mp_backlot_x":
		case "mp_bloc":
		case "mp_bog":
		case "mp_broadcast":
		case "mp_cargoship":
		case "mp_citystreets":
		case "mp_convoy":
		case "mp_countdown":
		case "mp_crash":
		case "mp_crossfire":
		case "mp_farm":
		case "mp_overgrown":
		case "mp_pipeline":
		case "mp_shipment":
		case "mp_showdown":
		case "mp_strike":
		case "mp_vacant":
		case "mp_crash_snow":
		case "mp_creek":
		case "mp_carentan":
		case "mp_killhouse":
		case "mp_marketcenter":
		case "mp_nuketown":
			isCustom = false;
			break;
	}
	return isCustom;
}

getGoodName(mapname)
{
	if(getSubStr(mapname, 0, 3) == "mp_")
		mapname = getSubStr(mapname, 3);
		
	mapname += " ";
	newname = "";
	switch(mapname[0])
	{
		case "a": newname += "A"; break;
		case "b": newname += "B"; break;
		case "c": newname += "C"; break;
		case "d": newname += "D"; break;
		case "e": newname += "E"; break;
		case "f": newname += "F"; break;
		case "g": newname += "G"; break;
		case "h": newname += "H"; break;
		case "i": newname += "I"; break;
		case "j": newname += "J"; break;
		case "k": newname += "K"; break;
		case "l": newname += "L"; break;
		case "m": newname += "M"; break;
		case "n": newname += "N"; break;
		case "o": newname += "O"; break;
		case "p": newname += "P"; break;
		case "q": newname += "Q"; break;
		case "r": newname += "R"; break;
		case "s": newname += "S"; break;
		case "t": newname += "T"; break;
		case "u": newname += "U"; break;
		case "v": newname += "V"; break;
		case "w": newname += "W"; break;
		case "x": newname += "X"; break;
		case "y": newname += "Y"; break;
		case "z": newname += "Z"; break;
	}
	for(i=1;i<mapname.size;i++)
	{
		if(mapname[i] == "_")
		{
			newname += " ";
			if(isDefined(mapname[i+1]))
			{
				switch(mapname[i+1])
				{
					case "a": newname += "A"; break;
					case "b": newname += "B"; break;
					case "c": newname += "C"; break;
					case "d": newname += "D"; break;
					case "e": newname += "E"; break;
					case "f": newname += "F"; break;
					case "g": newname += "G"; break;
					case "h": newname += "H"; break;
					case "i": newname += "I"; break;
					case "j": newname += "J"; break;
					case "k": newname += "K"; break;
					case "l": newname += "L"; break;
					case "m": newname += "M"; break;
					case "n": newname += "N"; break;
					case "o": newname += "O"; break;
					case "p": newname += "P"; break;
					case "q": newname += "Q"; break;
					case "r": newname += "R"; break;
					case "s": newname += "S"; break;
					case "t": newname += "T"; break;
					case "u": newname += "U"; break;
					case "v": newname += "V"; break;
					case "w": newname += "W"; break;
					case "x": newname += "X"; break;
					case "y": newname += "Y"; break;
					case "z": newname += "Z"; break;
				}
				i++;
			}
		}
		else if(mapname[i] != "_")
		{
			newname += mapname[i];
		}
	}
	return newname;
}

getMostVotedForMap()
{
	bestVal = -1;
	bestIdx = 1;
	for(i=1; i<=16; i++)
	{
		if(level.map["map" + i + "_votes"] > bestVal)
		{
			bestVal = level.map["map" + i + "_votes"];
			bestIdx = i;
		}
	}
	level.winner_index = bestIdx;
	return level.selected_maps[bestIdx - 1];
}

freezeall()
{
	for(i=0;i<level.players.size;i++)
	{
		player = level.players[i];
		if(isDefined(player))
			player freezecontrols(true);
	}
}

updateVotes()
{
	self endon("disconnect");
	while(isDefined(level.voting))
	{
		for(i=1; i<=16; i++)
		{
			self setClientDvar("votes_map" + i, level.map["map" + i + "_votes"]);
		}
		if(level.votetime < 4)
			self setClientDvar("votetime", "Vote Map - Time left:^1 " + level.votetime);
		else
			self setClientDvar("votetime", "Vote Map - Time left: " + level.votetime);
		wait 0.05;
	}
}

changelevel(map, gt, delay, persistence)
{
	if(!isDefined(persistence))
		persistence = false;
		
	// Stop endround music
	for(i=0; i<level.players.size; i++)
	{
		player = level.players[i];
		if(isDefined(player))
		{
			for(m=1; m<=4; m++)
				player stopLocalSound("endmap" + m);
		}
	}

	if(map == "map_restart")
	{
		allClientDvar("cl_bypassmouseinput", 0);
		wait delay;
		map_restart(persistence);
		return;
	}

	allClientDvar("cl_bypassmouseinput", 0);
	wait delay;

	old_rotation = strTok(getDvar("sv_mapRotation"), " ");
	new_rotation = "";
	new_rotation += "gametype " + gt + " map " + map + " ";
	for(i=0;i<old_rotation.size;i++)
	{
		if(old_rotation[i] == "map" && isDefined(old_rotation[i+1]) && old_rotation[i+1] == map)
		{
			i++;
			continue;
		}
		if(old_rotation[i] == "gametype" && isDefined(old_rotation[i+1]) && isDefined(old_rotation[i+2]) && old_rotation[i+2] == "map" && isDefined(old_rotation[i+3]) && old_rotation[i+3] == map)
		{
			i += 3;
			continue;
		}
		new_rotation += old_rotation[i] + " ";
	}
	setDvar("sv_maprotationcurrent", "");
	setDvar("sv_maprotation", new_rotation);
	allClientDvar("cl_bypassmouseinput", 0);
	wait delay;
	exitlevel(persistence);
}

votemap(response)
{
	if(isDefined(level.voting))
	{
		if(getSubStr(response, 0, 3) == "map")
		{
			num = int(getSubStr(response, 3));
			if(num >= 1 && num <= 16)
			{
				if(self.lastvoted != num)
				{
					self playLocalSound("mouse_click");
					if(self.lastvoted >= 1 && self.lastvoted <= 16)
						level.map["map" + self.lastvoted + "_votes"] -= 1;
						
					level.map["map" + num + "_votes"] += 1;
					self.lastvoted = num;
					self setClientDvar("selected_map", num);
				}
			}
		}
	}
}

getCleanGTName(gt)
{
	switch(toLower(gt))
	{
		case "war": return "TDM";
		case "sd": return "S&D";
		case "sr": return "S&R";
		case "dm": return "FFA";
		case "koth": return "HQ";
		case "sab": return "SAB";
		case "dom": return "DOM";
		case "kc": return "KC";
		case "crnk": return "Cranked";
	}
	return toUpper(gt);
}

getFullGTName(gt)
{
	switch(toLower(gt))
	{
		case "war": return "Team Deathmatch";
		case "sd": return "Search & Destroy";
		case "sr": return "Search & Rescue";
		case "dm": return "Free For All";
		case "koth": return "Headquarters";
		case "sab": return "Sabotage";
		case "dom": return "Domination";
		case "kc": return "Kill Confirmed";
		case "crnk": return "Cranked";
	}
	return toUpper(gt);
}
