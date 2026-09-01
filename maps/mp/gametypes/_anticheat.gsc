#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\utility\common;

init()
{
	addConnectThread(::monitorRapidFire);
	addSpawnThread(::monitorAimbot);
	addSpawnThread(::monitorSpeedHack);
}

monitorAimbot()
{
	if((isDefined(self.pers["isBot"]) && self.pers["isBot"]) || (isDefined(self.isbot) && self.isbot))
		return;
		
	self endon("disconnect");
	self endon("death");
	
	self.suspiciousSnaps = 0;
	self.spinCount = 0;
	lastAngles = self getPlayerAngles();
	
	while(1)
	{
		wait 0.05; // Wait 1 server frame
		
		if(!isPlayer(self) || self.sessionstate != "playing")
			continue;
			
		if(isDefined(self.isZoomSpawning) && self.isZoomSpawning)
			continue;
			
		currentAngles = self getPlayerAngles();
		
		// Detect Spinbot / Impossible Angles
		pitchVal = currentAngles[0];
		if(pitchVal > 88 || pitchVal < -88)
		{
			iPrintln("^1Anti-Cheat:^7 " + self.name + " flagged for Impossible View Pitch!");
			logPrint("ANTICHEAT: Player " + self.name + " (" + self getGuid() + ") flagged for Pitch Limit. Pitch: " + pitchVal + "\n");
			self thread warnOrKick("Impossible View Pitch");
			wait 1.0; // Prevent warning flood
		}
		
		if(self attackButtonPressed())
		{
			yawDiff = getAngleDiff(currentAngles[1], lastAngles[1]);
			pitchDiff = getAngleDiff(currentAngles[0], lastAngles[0]);
			
			// Detect Spinbot rotation
			if(yawDiff > 150)
			{
				self.spinCount++;
				if(self.spinCount >= 3)
				{
					iPrintln("^1Anti-Cheat:^7 " + self.name + " flagged for Spinbot / Impossible Rotation!");
					logPrint("ANTICHEAT: Player " + self.name + " (" + self getGuid() + ") flagged for Spinbot. Spin Count: " + self.spinCount + "\n");
					self thread warnOrKick("Spinbot Hack");
					self.spinCount = 0;
				}
			}
			else
			{
				if(self.spinCount > 0)
					self.spinCount--;
			}
			
			// A snap of > 25 degrees yaw or > 15 degrees pitch in 1 frame (50ms)
			if(yawDiff > 25 || pitchDiff > 15)
			{
				self.suspiciousSnaps++;
				if(self.suspiciousSnaps >= 3)
				{
					iPrintln("^1Anti-Cheat:^7 " + self.name + " flagged for suspicious aim snaps!");
					logPrint("ANTICHEAT: Player " + self.name + " (" + self getGuid() + ") flagged for Aim Snap. YawDiff: " + yawDiff + ", PitchDiff: " + pitchDiff + "\n");
					
					// Trigger screenshot
					exec("getss " + self getEntityNumber());
					
					self thread warnOrKick("Aimbot Snap");
					self.suspiciousSnaps = 0;
				}
			}
		}
		else
		{
			if(self.suspiciousSnaps > 0)
				self.suspiciousSnaps -= 0.05;
		}
		
		lastAngles = currentAngles;
	}
}

monitorSpeedHack()
{
	if((isDefined(self.pers["isBot"]) && self.pers["isBot"]) || (isDefined(self.isbot) && self.isbot))
		return;
		
	self endon("disconnect");
	self endon("death");
	
	wait 2.0; // Grace period after spawn
	
	while(1)
	{
		lastPos = self.origin;
		wait 0.5;
		
		if(!isPlayer(self) || self.sessionstate != "playing")
			continue;
			
		if(isDefined(self.isZoomSpawning) && self.isZoomSpawning)
			continue;
			
		if(isDefined(self.isjetpack) && self.isjetpack)
			continue;
			
		if(isDefined(self.isBouncing) && self.isBouncing)
			continue;
			
		dist_2d = distance2d(self.origin, lastPos);
		
		// 450 units in 0.5s is 900 units/second (~3.6x max sprint speed)
		if(dist_2d > 450)
		{
			iPrintln("^1Anti-Cheat:^7 " + self.name + " flagged for Speedhack / Teleport!");
			logPrint("ANTICHEAT: Player " + self.name + " (" + self getGuid() + ") flagged for Speedhack. Distance 2D: " + dist_2d + "\n");
			self thread warnOrKick("Speedhack / Teleport");
		}
	}
}

monitorRapidFire()
{
	if((isDefined(self.pers["isBot"]) && self.pers["isBot"]) || (isDefined(self.isbot) && self.isbot))
		return;
		
	self endon("disconnect");
	
	lastFireTime = 0;
	fireCount = 0;
	
	while(1)
	{
		self waittill("weapon_fired");
		
		if(!isPlayer(self) || self.sessionstate != "playing")
			continue;
			
		currentWeapon = self getCurrentWeapon();
		
		if(isSemiAuto(currentWeapon))
		{
			currentTime = getTime();
			timeDiff = currentTime - lastFireTime;
			
			// Detect consistent firing at the maximum engine cap (100ms per shot)
			// A human cannot click at the exact maximum fire cooldown limit 5 times consecutively.
			if(timeDiff <= 115)
			{
				fireCount++;
				if(fireCount >= 5)
				{
					iPrintln("^1Anti-Cheat:^7 " + self.name + " flagged for Rapid Fire / Macro / Scroll Bind!");
					logPrint("ANTICHEAT: Player " + self.name + " (" + self getGuid() + ") flagged for Rapid Fire. TimeDiff: " + timeDiff + "ms\n");
					
					self thread warnOrKick("Rapid Fire / Macro");
					fireCount = 0;
				}
			}
			else
			{
				if(fireCount > 0)
					fireCount--;
			}
			lastFireTime = currentTime;
		}
	}
}

isSemiAuto(weapon)
{
	switch(weapon)
	{
		case "beretta_mp":
		case "usp_mp":
		case "colt45_mp":
		case "deserteagle_mp":
		case "deserteaglegold_mp":
		case "g3_mp":
		case "m14_mp":
			return true;
	}
	return false;
}

getAngleDiff(angle1, angle2)
{
	diff = abs(angle1 - angle2);
	if(diff > 180)
		diff = 360 - diff;
	return diff;
}

warnOrKick(reason)
{
	self endon("disconnect");
	
	if(!isDefined(self.anticheatWarnings))
		self.anticheatWarnings = 0;
		
	self.anticheatWarnings++;
	
	if(self.anticheatWarnings >= 3)
	{
		iPrintlnBold("^1" + self.name + " has been auto-kicked for: " + reason);
		wait 0.5;
		self scripts\utility\common::dropPlayer("kick", reason);
	}
	else
	{
		self iPrintlnBold("^1Anti-Cheat Warning (" + self.anticheatWarnings + "/3): ^7" + reason);
		self iprintln("^1Anti-Cheat:^7 Suspicious behavior detected: " + reason);
	}
}
