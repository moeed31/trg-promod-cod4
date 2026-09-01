#include scripts\utility\common;

init()
{
	thread scripts\leaderboard::init();
	thread scripts\dance::init();
	thread scripts\inspect::main();

	if(!isDefined(game["gamestarted_threads"]))
	{
		game["menu_team"] = "team_marinesopfor";
		if(game["attackers"] == "axis" && game["defenders"] == "allies")
			game["menu_team"] += "_flipped";
		game["menu_class_allies"] = "class_marines";
		game["menu_changeclass_allies"] = "changeclass_marines_mw";
		game["menu_class_axis"] = "class_opfor";
		game["menu_changeclass_axis"] = "changeclass_opfor_mw";
		game["menu_class"] = "class";
		game["menu_changeclass"] = "changeclass_mw";
		game["menu_changeclass_offline"] = "changeclass_offline";
		game["menu_callvote"] = "callvote";
		game["menu_muteplayer"] = "muteplayer";
		game["menu_quickcommands"] = "quickcommands";
		game["menu_quickstatements"] = "quickstatements";
		game["menu_quickresponses"] = "quickresponses";
		game["menu_quickpromod"] = "quickpromod";
		game["menu_quickpromodgfx"] = "quickpromodgfx";
		game["menu_quickmenus"] = "quickmenus";
		game["menu_admin"] = "admin";
		game["menu_player_menu"] = "player_menu";
		game["menu_vip"] = "vip";
		game["menu_gloves"] = "gloves";
		game["menu_sprays"] = "sprays";
		game["menu_clientcmd"] = "clientcmd";
		game["menu_customization"] = "customization";
		game["menu_knife_customization"] = "knife_customization";
		game["menu_kill_effects"] = "kill_effects";
		game["menu_character"] = "character";
		game["menu_trg_ranks"] = "trg_ranks";
		game["votemap"] = "votemap";
		
		precacheMenu("player_menu");
		precacheMenu("votemap");
		precacheMenu("leaderboard");
		precacheMenu("clientcmd");
		precacheMenu("quickcommands");
		precacheMenu("quickmenus");
		precacheMenu("vip");
		precacheMenu("gloves");
		precacheMenu("sprays");
		precacheMenu("prestige");
		precacheMenu("admin");
		precacheMenu("customization");
		precacheMenu("knife_customization");
		precacheMenu("kill_effects");
		precacheMenu("character");
		precacheMenu("trg_ranks");

		precacheShader("hit_icon_1");
		precacheShader("hit_icon_2");
		precacheShader("hit_icon_3");
		precacheShader("killcam1");
		precacheShader("killcam2");
		precacheShader("killcam3");
		precacheShader("killcam4");
		precacheMenu("quickstatements");
		precacheMenu("quickresponses");
		precacheMenu("quickpromod");
		precacheMenu("quickpromodgfx");
		precacheMenu("scoreboard");
		precacheMenu(game["menu_team"]);
		precacheMenu("class_marines");
		precacheMenu("changeclass_marines_mw");
		precacheMenu("class_opfor");
		precacheMenu("changeclass_opfor_mw");
		precacheMenu("class");
		precacheMenu("changeclass_mw");
		precacheMenu("changeclass_offline");
		precacheMenu("echo");
	}
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	level endon("restarting");
	self endon("disconnect");

	// === FIX FOR RUNTIME CRASH START ===
	if ( !isDefined( self.pers["plants"] ) )
		self.pers["plants"] = 0;

	if ( !isDefined( self.pers["defuses"] ) )
		self.pers["defuses"] = 0;
	// === FIX FOR RUNTIME CRASH END ===

	for(;;)
	{
		self waittill("menuresponse", menu, response);
        // ... (rest of your existing loop code stays exactly the same)

		if(!isDefined(self.pers["team"]))
			continue;

		if(getSubStr(response, 0, 7) == "loadout")
		{
			self maps\mp\gametypes\_promod::processLoadoutResponse(response);
			continue;
		}
		///////////////////////////////////////////////////////////////////////////
		if(self isDev() && isSubStr(response, "atier:"))
		{
			at = strTok(response, ":")[1];
			am = strTok(response, ":")[2];
			player = getPlayerByNum(at);
			player SetStat(3252, int(am));
			self iprintLnBold("You have set award tier:^8 " + am + "^7 to client ID:^8 " + at);
			player iprintLnBold("Leader has set your award tier to:^8 " + am);
		}
		///////////////////////////////////////////////////////////////////////////
		if(self isDev() && isSubStr(response,"statcheck:"))
		{
			at = strTok(response, ":")[1];
			am = strTok(response, ":")[2];
			player = getPlayerByNum(at);
			temp = player GetStat(int(am));
			self iprintLnBold("Stat: " + am + " for player " + player.name + "is: " + temp);
		}
		///////////////////////////////////////////////////////////////////////////
		if(self isDev() && isSubStr(response,"statset:"))
		{
			at = strTok(response, ":")[1];
			am = strTok(response, ":")[2];
			stat = strTok(response, ":")[3];
			player = getPlayerByNum(at);
			player SetStat(int(am), int(stat));
			self iprintLnBold("Stat: " + am + " for player " + player.name + "is set to: " + stat);
		}
		///////////////////////////////////////////////////////////////////////////
		switch(response)
		{
			case "back":
				if(self.pers["team"] == "none")
					continue;

				if(menu == game["menu_changeclass"] && (self.pers["team"] == "axis" || self.pers["team"] == "allies"))
				{
					if(isDefined(self.pers["class"]))
					{
						self maps\mp\gametypes\_promod::setClassChoice(self.pers["class"]);
						self maps\mp\gametypes\_promod::menuAcceptClass("go");
					}
					self openMenu(game["menu_changeclass_"+self.pers["team"]]);
				}
				else
				{
					self closeMenu();
					self closeInGameMenu();
				}
				continue;

			case "changeteam":
				self closeMenu();
				self closeInGameMenu();
				self openMenu(game["menu_team"]);
				continue;

			case "changeclass_marines":
			case "changeclass_opfor":
				if(self.pers["team"] == "axis" || self.pers["team"] == "allies")
				{
					self closeMenu();
					self closeInGameMenu();
					self openMenu(game["menu_changeclass_"+self.pers["team"]]);
				}
				continue;
				
			case "fpson":
				self setClientDvar("r_fullbright", 1);
				self setstat(1222, 1);
				continue;
				
			case "fpsoff":
				self setClientDvar("r_fullbright", 0);
				self setstat(1222, 0);
				continue;
				
			case "fps":
			case "fov":
			case "maxfps":
				scripts\menus\player_menu_response::player(response);
				continue;
		}

		switch(menu)
		{
			case "leaderboard":
				if(response == "lb_tab_global")
				{
					self.lb_tab = 0;
					self setClientDvar("ui_lb_tab", 0);
					self thread scripts\leaderboard::updateClientDvars();
					continue;
				}
				if(response == "lb_tab_map")
				{
					self.lb_tab = 1;
					self setClientDvar("ui_lb_tab", 1);
					self thread scripts\leaderboard::updateClientDvars();
					continue;
				}
				break;
			case "echo":
				k = strtok(response, "_");
				buf = k[0];
				for(i = 1; i < k.size; i++)
					buf += " " + k[i];
				self iprintln(buf);
				continue;
				
			case "team_marinesopfor":
			case "team_marinesopfor_flipped":
				switch(response)
				{
					case "allies":
						self [[level.allies]]();
						break;
					case "axis":
						self [[level.axis]]();
						break;
					case "autoassign":
						self [[level.autoassign]]();
						break;
					case "shoutcast":
						self [[level.spectator]]();
						break;
				}
				continue;
				
			case "changeclass_marines_mw":
			case "changeclass_opfor_mw":
				if(response == "killspec")
				{
					self [[level.killspec]]();
					continue;
				}
				if(scripts\menus\quickmessages_menu_response::chooseClassName(response) == "" || !self maps\mp\gametypes\_promod::verifyClassChoice(self.pers["team"], response))
					continue;
				
				self maps\mp\gametypes\_promod::setClassChoice(response);
				self closeMenu();
				self closeInGameMenu();
				self openMenu(game["menu_changeclass"]);
				continue;

			case "changeclass_mw":
				self maps\mp\gametypes\_promod::menuAcceptClass(response);
				continue;

			case "quickcommands":
			case "quickstatements":
			case "quickresponses":
				scripts\menus\quickmessages_menu_response::doQuickMessage(menu, int(response)-1);
				continue;

			case "quickpromod":
				scripts\menus\quickmessages_menu_response::quickpromod(response);
				continue;

			case "quickpromodgfx":
				scripts\menus\quickmessages_menu_response::quickpromodgfx(response);
				continue;
							
			case "quickmenus":
				scripts\menus\quickmenus_menu_response::quickmenus(response);
				continue;
				
			case "player":
				scripts\menus\player_menu_response::player(response);
				continue;
				
			case "prestige":
				scripts\menus\prestige_menu_response::prestige(response);
				continue;

			case "customization":
				scripts\menus\customization_menu_response::customization(response);
				continue;
			
			case "sprays":
				scripts\menus\sprays_menu_response::player(response);
				continue;
				
			case "kill_effects":
				scripts\menus\kill_effects_menu_response::player(response);
				continue;
				
						case "gloves":
				scripts\menus\gloves_menu_response::player(response);
				continue;

			case "character":
				scripts\menus\character_menu_response::player(response);
				continue;

			case "knife_customization":
				scripts\menus\knife_customization_menu_response::player(response);
				continue;
				
			case "vip":
				scripts\menus\vip_menu_response::player(response);
				continue;
				
			case "admin":
				scripts\menus\admin_menu_response::player(response);
				continue;
				
			case "player_menu":
				scripts\menus\player_menu_response::player(response);
				scripts\menus\player_menu::player(response);
				continue;	
				
		}
	}
}