#include maps\mp\gametypes\_hud_util;

init()
{
	precacheShader("damage_feedback");
	precacheShader("hit_icon_1");
	precacheShader("hit_icon_2");
	precacheShader("hit_icon_3");
	precacheShader("hit_icon_4");
	precacheShader("hit_icon_5");

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		
		player.hud_damagefeedback = newClientHudElem(player);
		player.hud_damagefeedback.horzAlign = "center";
		player.hud_damagefeedback.vertAlign = "middle";
		player.hud_damagefeedback.x = -12;
		player.hud_damagefeedback.y = -12;
		player.hud_damagefeedback.alpha = 0;
		player.hud_damagefeedback.archived = true;
		player.hud_damagefeedback.color = (1,1,1);
		player.hud_damagefeedback setShader("damage_feedback", 24, 48);
	}
}

updateDamageFeedback(isHeadshot)
{
	if ( !isPlayer( self ) )
		return;
	
	hitShader = "damage_feedback";
	if ( isDefined( self.pers["hit_icon"] ) )
	{
		if ( self.pers["hit_icon"] == 1 )
			hitShader = "hit_icon_1";
		else if ( self.pers["hit_icon"] == 2 )
			hitShader = "hit_icon_2";
		else if ( self.pers["hit_icon"] == 3 )
			hitShader = "hit_icon_3";
		else if ( self.pers["hit_icon"] == 4 )
			hitShader = "hit_icon_4";
		else if ( self.pers["hit_icon"] == 5 )
			hitShader = "hit_icon_5";
	}
	
	self.hud_damagefeedback setShader( hitShader, 24, 48 );

	self playlocalsound("MP_hit_alert");
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime( 1.0 );
	self.hud_damagefeedback.alpha = 0;
}
