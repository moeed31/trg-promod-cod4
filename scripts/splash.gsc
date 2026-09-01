#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\utility\_utility;
#include scripts\utility\splash_utility;

init()
{
	level.splashNum = int(tableLookup("mp/splashTable.csv", 0, "splashnum", 1));
	for(ID = 1; ID <= level.SplashNum; ID++)
	{
		precacheString(tableLookupIString( "mp/splashTable.csv", 0, ID, 2));
		precacheString(tableLookupIString( "mp/splashTable.csv", 0, ID, 3));
	}
	precacheShader("gradient_top");
	precacheShader("gradient_bottom");
	precacheShader("flare");
	precacheShader("semtex_logo");
	
	// Precache custom medals
	precacheShader("sles_hud_medals_assists");
	precacheShader("sles_hud_medals_deaths");
	precacheShader("sles_hud_medals_defuses");
	precacheShader("sles_hud_medals_headshots");
	precacheShader("sles_hud_medals_kills");
	precacheShader("sles_hud_medals_knife_killer");
	precacheShader("sles_hud_medals_nade_killer");
	precacheShader("sles_hud_medals_plants");
	precacheShader("sles_hud_medals_score");
	precacheShader("sles_hud_medals_suicides");

	level.numKills = 0;
	level thread onPlayerConnect();	
	
	// Register playerKilled callback
	scripts\_missions::registerMissionCallback("playerKilled", ::onPlayerKilled);
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
		player.lastKilledBy = undefined;
		player.pers["cur_kill_streak"] = 0;
		player.pers["cur_death_streak"] = 0;
		player.recentKillCount = 0;
		player.lastKillTime = 0;
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned");
		self.firstTimeDamaged = [];
		self.damaged = undefined;
	}
}

onPlayerKilled(data)
{
	if(isDefined(data.victim) && isPlayer(data.victim))
	{
		if(!isDefined(data.victim.pers["cur_death_streak"]))
			data.victim.pers["cur_death_streak"] = 0;
		data.victim.pers["cur_death_streak"]++;

		if(data.victim.pers["cur_death_streak"] == 5)
			data.victim playLocalSound("whyami");

		if(isDefined(data.attacker) && isPlayer(data.attacker) && data.attacker != data.victim)
		{
			data.attacker.pers["cur_death_streak"] = 0;
			data.attacker thread killedPlayer(data.victim, data.sWeapon, data.sMeansOfDeath);
		}
		else
		{
			// Suicide or World Death
			if(isDefined(data.sMeansOfDeath) && data.sMeansOfDeath == "MOD_SUICIDE")
				data.victim thread showMedal("sles_hud_medals_suicides");
			else
				data.victim thread showMedal("sles_hud_medals_deaths");
		}
	}
}

killedPlayer(victim, weapon, meansOfDeath)
{
	level endon("_game_ended");
	self endon("disconnect");
	victim endon("disconnect");
	
	if(!isDefined(level.numKills))
		level.numKills = 0;	
	level.numKills++;
	if(!isDefined(self) || !isDefined(victim) || (victim.team == self.team && level.teambased) || weapon == "none")
		return;
		
	// Play streak announcer sounds
	streak = self.cur_kill_streak;
	if(isDefined(streak))
	{
		if(streak == 5)
			self playLocalSound("killingspree");
		else if(streak == 10)
			self playLocalSound("dominating");
		else if(streak == 13)
			self playLocalSound("unreal");
		else if(streak == 15)
			self playLocalSound("rampage");
		else if(streak == 17)
			self playLocalSound("unstoppable");
		else if(streak == 20)
			self playLocalSound("godlike");
		else if(streak == 25)
			self playLocalSound("holyshit");
	}
		
	curTime = getTime();
	self thread updateRecentKills();
	self.lastKillTime = getTime();
	self.lastKilledPlayer = victim;

	if(isDefined(victim.damaged) && victim.damaged == getTime())
	{
		weaponClass = getWeaponClass( weapon );
		if(meansOfDeath != "MOD_MELEE" && (weaponClass == "weapon_sniper"))
			self thread splashNotifyDelayed("one_shot_kill");
	}
	if(level.numKills == 1)
		self firstBlood();
	if(self.pers["cur_death_streak"] > 3)
		self comeBack();
	if(meansOfDeath == "MOD_HEAD_SHOT")
		self headShot();
	if(!isAlive(self) && self.deathtime + 800 < getTime())
		self postDeathKill();
	if(level.teamBased && curTime - victim.lastKillTime < 500)
	{
		if(victim.lastkilledplayer != self)
			self avengedPlayer();
	}
	if(isDefined(victim.attackerPosition))
		attackerPosition = victim.attackerPosition;
	else
		attackerPosition = self.origin;

	if(isAlive(self) && (meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_HEAD_SHOT") && distance(attackerPosition, victim.origin ) > 1536 && !isDefined(self.assistedSuicide))
		self longshot();

	if(isDefined( victim.pers["cur_kill_streak"] ) && victim.pers["cur_kill_streak"] >= max(3, int(level.aliveCount[level.otherTeam[victim.team]] / 2)))
		self buzzKill();

	if(isDefined( self.lastKilledBy ) && self.lastKilledBy == victim)
	{
		self.lastKilledBy = undefined;
		self revenge();
	}
	victim.lastKilledBy = self;	

	// Add medal popups for specific kill types
	if(meansOfDeath == "MOD_MELEE")
		self thread showMedal("sles_hud_medals_knife_killer");
	else if(meansOfDeath == "MOD_GRENADE" || meansOfDeath == "MOD_GRENADE_SPLASH")
		self thread showMedal("sles_hud_medals_nade_killer");
	else if(meansOfDeath == "MOD_HEAD_SHOT")
		self thread showMedal("sles_hud_medals_headshots");
	else
		self thread showMedal("sles_hud_medals_kills");
		
	// Show death medal for the victim
	victim thread showMedal("sles_hud_medals_deaths");
}

wallbang()
{
	self thread splashNotifyDelayed("wallbang");
	self thread maps\mp\gametypes\_rank::giveRankXP("wallbang");
	self thread showMedal("sles_hud_medals_score");
}

longshot()
{
	self thread splashNotifyDelayed("longshot");
	self thread maps\mp\gametypes\_rank::giveRankXP("longshot");
	self thread showMedal("sles_hud_medals_score");
}

execution()
{
	self thread splashNotifyDelayed("execution");
	self thread maps\mp\gametypes\_rank::giveRankXP("execution");
	self thread showMedal("sles_hud_medals_score");
}

headShot()
{
	self thread splashNotifyDelayed("headshot_splash");
	self thread maps\mp\gametypes\_rank::giveRankXP("headshot_splash");
}

avengedPlayer()
{
	self thread splashNotifyDelayed("avenger");
	self thread maps\mp\gametypes\_rank::giveRankXP("avenger");
	self thread showMedal("sles_hud_medals_score");
}

assistedSuicide()
{
	self thread splashNotifyDelayed("assistedsuicide");
	self thread maps\mp\gametypes\_rank::giveRankXP("assistedsuicide");
	self thread showMedal("sles_hud_medals_assists");
}

defendedPlayer()
{
	self thread splashNotifyDelayed("defender");
	self thread maps\mp\gametypes\_rank::giveRankXP("defender");
	self thread showMedal("sles_hud_medals_score");
}

postDeathKill()
{
	self thread splashNotifyDelayed("posthumous");
	self thread maps\mp\gametypes\_rank::giveRankXP("posthumous");
	self thread showMedal("sles_hud_medals_score");
}

revenge()
{
	self thread splashNotifyDelayed("revenge");
	self thread maps\mp\gametypes\_rank::giveRankXP("revenge");
	self thread showMedal("sles_hud_medals_score");
}

multiKill(killCount)
{
	assert(killCount > 1);
	
	if(killCount == 2)
	{
		self playLocalSound("doublekill");
		self thread splashNotifyDelayed("doublekill");
	}
	else if(killCount == 3)
	{
		self playLocalSound("triplekill");
		self thread splashNotifyDelayed("triplekill");
		thread teamPlayerCardSplash("callout_3xkill", self);
	}
	else if(killCount == 4)
	{
		self playLocalSound("ultrakill");
		self thread splashNotifyDelayed("multikill");
		thread teamPlayerCardSplash("callout_3xpluskill", self);
	}
	else
	{
		self playLocalSound("monsterkill");
		self thread splashNotifyDelayed("multikill");
		thread teamPlayerCardSplash("callout_3xpluskill", self);
	}	
	self thread showMedal("sles_hud_medals_score");
}

firstBlood()
{
	self playLocalSound("firstblood");
	self thread splashNotifyDelayed("firstblood");
	self thread maps\mp\gametypes\_rank::giveRankXP("firstblood");
	thread teamPlayerCardSplash("callout_firstblood", self);
	self thread showMedal("sles_hud_medals_score");
}

buzzKill()
{
	self thread splashNotifyDelayed("buzzkill");
	self thread maps\mp\gametypes\_rank::giveRankXP("buzzkill");
	self thread showMedal("sles_hud_medals_score");
}

comeBack()
{
	self thread splashNotifyDelayed("comeback");
	self thread maps\mp\gametypes\_rank::giveRankXP("comeback");
	self thread showMedal("sles_hud_medals_score");
}

updateRecentKills()
{
	self endon("disconnect");
	level endon("game_ended");
	self notify("updateRecentKills");
	self endon("updateRecentKills");
	self.recentKillCount++;
	wait 2.0;
	if(self.recentKillCount > 1)
		self multiKill(self.recentKillCount);
	self.recentKillCount = 0;
}

isWallBang(attacker, victim)
{
	return bulletTracePassed(attacker getEye(), victim getEye(), false, attacker);
}

showMedal(shaderName)
{
	self endon("disconnect");

	if(!isDefined(self.medalQueue))
		self.medalQueue = [];

	// Add to queue
	self.medalQueue[self.medalQueue.size] = shaderName;

	// If there is already a medal showing, wait in queue
	if(isDefined(self.showingMedal) && self.showingMedal)
		return;

	self.showingMedal = true;
	while(self.medalQueue.size > 0)
	{
		currentShader = self.medalQueue[0];
		
		// Shift array
		newQueue = [];
		for(i=1; i<self.medalQueue.size; i++)
			newQueue[newQueue.size] = self.medalQueue[i];
		self.medalQueue = newQueue;

		self thread doMedalAnim(currentShader);
		wait 2.6; // Wait for animation to finish
	}
	self.showingMedal = false;
}

doMedalAnim(shaderName)
{
	self endon("disconnect");

	hud = newClientHudElem(self);
	hud.horzAlign = "center";
	hud.vertAlign = "top";
	hud.alignX = "center";
	hud.alignY = "middle";
	hud.x = 0;
	hud.y = 30; // Starts slightly higher
	hud.alpha = 0;
	hud.sort = 100;
	hud.hideWhenInMenu = true;
	hud.archived = false;
	hud setShader(shaderName, 56, 56);

	// Slide down and fade in
	hud fadeOverTime(0.2);
	hud moveOverTime(0.2);
	hud.y = 80; // Slides down to Y=80
	hud.alpha = 1;
	
	// Play objective sound as reward feedback
	self playLocalSound("splash");

	wait 2.0;

	// Slide up and fade out
	hud fadeOverTime(0.2);
	hud moveOverTime(0.2);
	hud.y = 60;
	hud.alpha = 0;

	wait 0.2;
	hud destroy();
}