#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    level.trail_fx = [];
    for(i = 1; i <= 20; i++)
    {
        fxName = tableLookup("mp/trailTable.csv", 0, i, 3);
        if(isDefined(fxName) && fxName != "" && fxName != "none")
        {
            level.trail_fx[i] = loadFX(fxName);
        }
    }
}

spawnTrail()
{
    self endon("disconnect");
    self endon("death");
    self notify("stop_trail");
    self endon("stop_trail");

    trailId = self getStat(978);
    if(!isDefined(trailId) || trailId == 0)
        return;

    if(isDefined(level.trail_fx[trailId]))
    {
        wait 0.1;
        
        trailEnt = spawn("script_model", self.origin);
        trailEnt setModel("tag_origin");
        trailEnt linkTo(self, "tag_origin", (0,0,0), (0,0,0));
        wait 0.05;
        PlayFXOnTag(level.trail_fx[trailId], trailEnt, "tag_origin");
        
        self thread deleteOnEvents(trailEnt);
    }
}

deleteOnEvents(ent)
{
    ent endon("death");
    
    self thread _deleteOn(ent, "death");
    self thread _deleteOn(ent, "disconnect");
    self thread _deleteOn(ent, "stop_trail");
}

_deleteOn(ent, event)
{
    ent endon("death");
    self waittill(event);
    if (isDefined(ent))
        ent delete();
}
