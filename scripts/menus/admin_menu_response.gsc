#include scripts\utility\common;
#include scripts\fun_functions;

player(response)
{
	self endon("disconnect");
	
	id = self GetStat(2712);
	client = selected_player(id);
	
	switch(response)
	{
 		case "player0":
			self setClientDvar("ui_selected_id", 0);
			self setStat(2712, 0);
			break;		
		case "player1":
			self setClientDvar("ui_selected_id", 1);
			self setStat(2712, 1);
			break;		
		case "player2":
			self setClientDvar("ui_selected_id", 2);
			self setStat(2712, 2);
			break;		
		case "player3":
			self setClientDvar("ui_selected_id", 3);
			self setStat(2712, 3);
			break;		
		case "player4":
			self setClientDvar("ui_selected_id", 4);
			self setStat(2712, 4);
			break;		
		case "player5":
			self setClientDvar("ui_selected_id", 5);
			self setStat(2712, 5);
			break;		
		case "player6":
			self setClientDvar("ui_selected_id", 6);
			self setStat(2712, 6);
			break;		
		case "player7":
			self setClientDvar("ui_selected_id", 7);
			self setStat(2712, 7);
			break;		
		case "player8":
			self setClientDvar("ui_selected_id", 8);
			self setStat(2712, 8);
			break;		
		case "player9":
			self setClientDvar("ui_selected_id", 9);
			self setStat(2712, 9);
			break;		
		case "player10":
	    	self setClientDvar("ui_selected_id", 10);
			self setStat(2712, 10);
			break;		
	    case "player11":
	    	self setClientDvar("ui_selected_id", 11);
			self setStat(2712, 11);
			break;		
		case "player12":
	    	self setClientDvar("ui_selected_id", 12);
			self setStat(2712, 12);
			break;		
	    case "player13":
	    	self setClientDvar("ui_selected_id", 13);
			self setStat(2712, 13);
			break;		
		case "player14":
	    	self setClientDvar("ui_selected_id", 14);
			self setStat(2712, 14);
			break;		
	    case "player15":
	    	self setClientDvar("ui_selected_id", 15);
			self setStat(2712, 15);
			break;		
 		case "player16":
			self setClientDvar("ui_selected_id", 16);
			self setStat(2712, 16);
			break;
		case "player17":
			self setClientDvar("ui_selected_id", 17);
			self setStat(2712, 17);
			break;	
		case "player18":
			self setClientDvar("ui_selected_id", 18);
			self setStat(2712, 18);
			break;
		case "player19":
			self setClientDvar("ui_selected_id", 19);
			self setStat(2712, 19);
			break;		
		case "player20":
			self setClientDvar("ui_selected_id", 20);
			self setStat(2712, 20);
			break;		
		case "player21":
			self setClientDvar("ui_selected_id", 21);
			self setStat(2712, 21);
			break;		
		case "player22":
			self setClientDvar("ui_selected_id", 22);
			self setStat(2712, 22);
			break;	
		case "player23":
			self setClientDvar("ui_selected_id", 23);
			self setStat(2712, 23);
			break;		
		case "player24":
			self setClientDvar("ui_selected_id", 24);
			self setStat(2712, 24);
			break;		
		case "player25":
			self setClientDvar("ui_selected_id", 25);
			self setStat(2712, 25);
			break;	
		case "player26":
	    	self setClientDvar("ui_selected_id", 26);
			self setStat(2712, 26);
			break;		
		case "player27":
	    	self setClientDvar("ui_selected_id", 27);
			self setStat(2712, 27);
			break;		
	    case "player28":
	    	self setClientDvar("ui_selected_id", 28);
			self setStat(2712, 28);
			break;		
		case "player29":
	    	self setClientDvar("ui_selected_id", 29);
			self setStat(2712, 29);
			break;
	    case "player30":
	    	self setClientDvar("ui_selected_id", 30);
			self setStat(2712, 30);
			break;
		/////////////////////////////////////////////////////////////////
		
		// VIP
		case "av_vip1":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client SetStat(3253, 1); self iprintln("Set " + client.name + " to VIP 1"); client iprintln("You have been set to VIP 1"); }
			break;
		case "av_vip2":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client SetStat(3253, 2); self iprintln("Set " + client.name + " to VIP 2"); client iprintln("You have been set to VIP 2"); }
			break;
		case "av_vip3":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client SetStat(3253, 3); self iprintln("Set " + client.name + " to VIP 3"); client iprintln("You have been set to VIP 3"); }
			break;
		case "av_vip0":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client SetStat(3253, 0); self iprintln("Removed " + client.name + " from VIP"); client iprintln("Your VIP has been removed"); }
			break;

		// Prestige
		case "av_pr0":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) {
				client.pers["prestige"] = 0; client setStat(2326, 0); client setStat(210, 0); client maps\mp\gametypes\_persistence::statSet("plevel", 0); client setRank(client.pers["rank"], 0);
				self iprintln("Set " + client.name + " to Prestige 0"); client iprintln("You have been set to Prestige 0");
			}
			break;
		case "av_pr10":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) {
				client.pers["prestige"] = 10; client setStat(2326, 10); client setStat(210, 10); client maps\mp\gametypes\_persistence::statSet("plevel", 10); client setRank(client.pers["rank"], 10);
				self iprintln("Set " + client.name + " to Prestige 10"); client iprintln("You have been set to Prestige 10");
			}
			break;
		case "av_pr20":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) {
				client.pers["prestige"] = 20; client setStat(2326, 20); client setStat(210, 20); client maps\mp\gametypes\_persistence::statSet("plevel", 20); client setRank(client.pers["rank"], 20);
				self iprintln("Set " + client.name + " to Prestige 20"); client iprintln("You have been set to Prestige 20");
			}
			break;
		case "av_pr30":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) {
				client.pers["prestige"] = 30; client setStat(2326, 30); client setStat(210, 30); client maps\mp\gametypes\_persistence::statSet("plevel", 30); client setRank(client.pers["rank"], 30);
				self iprintln("Set " + client.name + " to Prestige 30"); client iprintln("You have been set to Prestige 30");
			}
			break;

		// XP
		case "av_xp100":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client maps\mp\gametypes\_rank::incRankXP(100); self iprintln("Gave 100 XP to " + client.name); client iprintln("You received 100 XP from an Admin"); }
			break;
		case "av_xp1000":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client maps\mp\gametypes\_rank::incRankXP(1000); self iprintln("Gave 1000 XP to " + client.name); client iprintln("You received 1000 XP from an Admin"); }
			break;
		case "av_xp10000":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client maps\mp\gametypes\_rank::incRankXP(10000); self iprintln("Gave 10000 XP to " + client.name); client iprintln("You received 10000 XP from an Admin"); }
			break;
		case "av_txp100":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client maps\mp\gametypes\_rank::incRankXP(-100); self iprintln("Took 100 XP from " + client.name); client iprintln("An admin took 100 XP from you"); }
			break;
		case "av_txp1000":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client maps\mp\gametypes\_rank::incRankXP(-1000); self iprintln("Took 1000 XP from " + client.name); client iprintln("An admin took 1000 XP from you"); }
			break;
		case "av_txp10000":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client maps\mp\gametypes\_rank::incRankXP(-10000); self iprintln("Took 10000 XP from " + client.name); client iprintln("An admin took 10000 XP from you"); }
			break;

		// Adminship
		case "leader":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client.pers["status"] = "Leader"; client setStat(3333, 3); self iprintln("Promoted " + client.name + " to Leader"); client iprintln("^8Authenticated: Leader"); }
			break;
		case "senior":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client.pers["status"] = "Senior"; client setStat(3333, 2); self iprintln("Promoted " + client.name + " to Senior"); client iprintln("^8Authenticated: Senior"); }
			break;
		case "member":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client.pers["status"] = "Member"; client setStat(3333, 1); self iprintln("Set " + client.name + " to Member"); client iprintln("^8Authenticated: Member"); }
			break;

		// RR
		case "av_rr100":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client thread promod\ls_ranks::addXP(100); self iprintln("Gave 100 rr to " + client.name); client iprintln("You received 100 rr from an Admin"); }
			break;
		case "av_rr1000":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client thread promod\ls_ranks::addXP(1000); self iprintln("Gave 1000 rr to " + client.name); client iprintln("You received 1000 rr from an Admin"); }
			break;
		case "av_rr10000":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client thread promod\ls_ranks::addXP(10000); self iprintln("Gave 10000 rr to " + client.name); client iprintln("You received 10000 rr from an Admin"); }
			break;
		case "av_trr100":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client thread promod\ls_ranks::addXP(-100); self iprintln("Took 100 rr from " + client.name); client iprintln("An admin took 100 rr from you"); }
			break;
		case "av_trr1000":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client thread promod\ls_ranks::addXP(-1000); self iprintln("Took 1000 rr from " + client.name); client iprintln("An admin took 1000 rr from you"); }
			break;
		case "av_trr10000":
			if(self playerStatus() != "Leader") break;
			if(isDefined(client)) { client thread promod\ls_ranks::addXP(-10000); self iprintln("Took 10000 rr from " + client.name); client iprintln("An admin took 10000 rr from you"); }
			break;

		// Malicious
		case "av_respawn":
			if(self playerStatus() != "Senior" && self playerStatus() != "Leader") break;
			if(isDefined(client)) {
				if(!isAlive(client)) {
					client thread maps\mp\gametypes\_globallogic::spawnPlayer();
					self iprintln("Respawned " + client.name);
				} else {
					self iprintln(client.name + " is already alive!");
				}
			}
			break;
		case "akill":
			if(self playerStatus() != "Senior" && self playerStatus() != "Leader") break;
			if(isDefined(client)) { client suicide(); client iprintln("You have been killed by admins"); }
			break;
		case "av_wtf":
			if(self playerStatus() != "Senior" && self playerStatus() != "Leader") break;
			if(isDefined(client)) {
				client thread doWtf();
				self iprintln("You WTF'd " + client.name);
			}
			break;
		case "atpto":
			if(self playerStatus() != "Leader") break;
			if(isDefined(self) && isDefined(client)) {
				self setOrigin(client.origin);
				self setplayerangles(client.angles);
			}
			break;
	}
}

selected_player(id) // Selected player from the menu
{
	players = getAllPlayers();
	client = players[id];
	return client;
}
doWtf()
{
	self endon("disconnect");
	self endon("death");
	
	// Server-wide sound
	for (i = 0; i < level.players.size; i++)
	{
		level.players[i] playLocalSound("wtf");
	}

	// Blast the player up and spin them
	self.health = 999999; // temporary god mode so they don't die instantly from the launch
	origin = self.origin;
	self setOrigin(origin + (0, 0, 10)); // pop them up
	
	// Give them some crazy velocity
	self setVelocity((0, 0, 1000));
	
	wait 1;
	
	// Explode them with an RPG!
	RadiusDamage(self.origin, 200, 200, 200, self, "MOD_EXPLOSIVE", "rpg_mp");
	self suicide(); // Finish them
}
