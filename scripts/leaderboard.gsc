init()
{
    level.leaderboard_players = [];
    level.map_leaderboard_players = [];
    
    // Load historical stats from file on startup
    loadLeaderboard();
    loadMapLeaderboard();
    
    level thread onPlayerConnect();
    level thread updateLeaderboardLoop();
}

lb_playerKilled(data)
{
    if(isDefined(data.attacker) && isPlayer(data.attacker) && data.attacker != data.victim)
        data.attacker map_lb_addStat("kills", 1);
    
    if(isDefined(data.victim) && isPlayer(data.victim))
        data.victim map_lb_addStat("deaths", 1);
}

map_lb_addStat(statName, value)
{
    guid = self getGuid();
    if(!isDefined(guid) || guid == "")
        guid = self.name;

    for(i = 0; i < level.map_leaderboard_players.size; i++)
    {
        if(level.map_leaderboard_players[i].guid == guid)
        {
            if(statName == "kills")
                level.map_leaderboard_players[i].kills += value;
            else if(statName == "deaths")
                level.map_leaderboard_players[i].deaths += value;
            return;
        }
    }
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerConnected();
    }
}

onPlayerConnected()
{
    self endon("disconnect");

    if(!isDefined(self.lb_tab))
        self.lb_tab = 0;
    self setClientDvar("ui_lb_tab", self.lb_tab);

    guid = self getGuid();
    if(!isDefined(guid) || guid == "")
        guid = self.name; // Fallback to name if GUID is unavailable

    // 1. GLOBAL LEADERBOARD
    found = false;
    for(i = 0; i < level.leaderboard_players.size; i++)
    {
        if(level.leaderboard_players[i].guid == guid)
        {
            found = true;
            level.leaderboard_players[i].name = self.name;
            level.leaderboard_players[i].playerObj = self;
            break;
        }
    }

    if(!found)
    {
        entry = spawnStruct();
        entry.guid = guid;
        entry.name = self.name;
        entry.kills = 0;
        entry.deaths = 0;
        entry.kd = 0;
        entry.skill = 0;
        entry.rankLevel = 1;
        entry.prestige = 0;
        entry.trXp = 0;
        entry.rankName = "Private";
        entry.playerObj = self;
        level.leaderboard_players[level.leaderboard_players.size] = entry;
    }

    // 2. MAP LEADERBOARD
    found_map = false;
    for(i = 0; i < level.map_leaderboard_players.size; i++)
    {
        if(level.map_leaderboard_players[i].guid == guid)
        {
            found_map = true;
            level.map_leaderboard_players[i].name = self.name;
            level.map_leaderboard_players[i].playerObj = self;
            break;
        }
    }

    if(!found_map)
    {
        entry2 = spawnStruct();
        entry2.guid = guid;
        entry2.name = self.name;
        entry2.kills = 0;
        entry2.deaths = 0;
        entry2.kd = 0;
        entry2.skill = 0;
        entry2.rankLevel = 1;
        entry2.prestige = 0;
        entry2.trXp = 0;
        entry2.rankName = "Private";
        entry2.playerObj = self;
        level.map_leaderboard_players[level.map_leaderboard_players.size] = entry2;
    }

    self thread delayedUpdateClientDvars();
}

delayedUpdateClientDvars()
{
    self endon("disconnect");
    wait 2.0;
    self updateClientDvars();
}

updateLeaderboardLoop()
{
    for(;;)
    {
        wait 30.0;

        // 1. Update stats for all connected players (GLOBAL)
        for(i = 0; i < level.leaderboard_players.size; i++)
        {
            entry = level.leaderboard_players[i];
            if(isDefined(entry.playerObj))
            {
                kills = entry.playerObj getStat(2303);
                if(isDefined(kills)) entry.kills = kills;
                deaths = entry.playerObj getStat(2305);
                if(isDefined(deaths)) entry.deaths = deaths;
                if(isDefined(entry.playerObj.pers["rank"])) entry.rankLevel = entry.playerObj.pers["rank"] + 1;
                if(isDefined(entry.playerObj.pers["prestige"])) entry.prestige = entry.playerObj.pers["prestige"];
                if(isDefined(entry.playerObj.pers["xp"])) entry.trXp = entry.playerObj.pers["xp"];

                rankId = 0;
                if(isDefined(entry.playerObj.pers["rank"])) rankId = entry.playerObj.pers["rank"];
                entry.rankName = tableLookup("mp/ranktable.csv", 0, rankId, 1);
            }

            if(entry.deaths == 0) entry.kd = entry.kills;
            else entry.kd = entry.kills / entry.deaths;
            entry.kd = int(entry.kd * 100) / 100;
            entry.skill = int(entry.kd * 1000);
        }

        // 2. Update stats for all connected players (MAP)
        for(i = 0; i < level.map_leaderboard_players.size; i++)
        {
            entry = level.map_leaderboard_players[i];
            if(isDefined(entry.playerObj))
            {
                // We don't update kills/deaths from getStat, we use our local counter!
                if(isDefined(entry.playerObj.pers["rank"])) entry.rankLevel = entry.playerObj.pers["rank"] + 1;
                if(isDefined(entry.playerObj.pers["prestige"])) entry.prestige = entry.playerObj.pers["prestige"];
                if(isDefined(entry.playerObj.pers["xp"])) entry.trXp = entry.playerObj.pers["xp"];

                rankId = 0;
                if(isDefined(entry.playerObj.pers["rank"])) rankId = entry.playerObj.pers["rank"];
                entry.rankName = tableLookup("mp/ranktable.csv", 0, rankId, 1);
            }

            if(entry.deaths == 0) entry.kd = entry.kills;
            else entry.kd = entry.kills / entry.deaths;
            entry.kd = int(entry.kd * 100) / 100;
            // Map skill level logic: prioritize kills if KD is same
            entry.skill = int(entry.kd * 1000) + entry.kills;
        }

        // 3. Sort leaderboard arrays (Bubble Sort)
        for(i = 0; i < level.leaderboard_players.size; i++)
        {
            for(j = i + 1; j < level.leaderboard_players.size; j++)
            {
                if(level.leaderboard_players[j].trXp > level.leaderboard_players[i].trXp)
                {
                    temp = level.leaderboard_players[i];
                    level.leaderboard_players[i] = level.leaderboard_players[j];
                    level.leaderboard_players[j] = temp;
                }
            }
        }
        for(i = 0; i < level.map_leaderboard_players.size; i++)
        {
            for(j = i + 1; j < level.map_leaderboard_players.size; j++)
            {
                // Sort Map Leaderboard by Kills primarily, then KD (represented by skill)
                if(level.map_leaderboard_players[j].skill > level.map_leaderboard_players[i].skill)
                {
                    temp = level.map_leaderboard_players[i];
                    level.map_leaderboard_players[i] = level.map_leaderboard_players[j];
                    level.map_leaderboard_players[j] = temp;
                }
            }
        }

        // 4. Save to files
        saveLeaderboard();
        saveMapLeaderboard();

        // 5. Update dvars for all players
        players = getEntArray("player", "classname");
        for(p = 0; p < players.size; p++)
        {
            if(isDefined(players[p]))
            {
                players[p] thread updateClientDvars();
                wait 0.15;
            }
        }
    }
}

updateClientDvars()
{
    self endon("disconnect");
    self notify("stop_lb_update");
    self endon("stop_lb_update");

    target_array = level.leaderboard_players;
    if(isDefined(self.lb_tab) && self.lb_tab == 1)
        target_array = level.map_leaderboard_players;

    for(r = 0; r < 10; r++)
    {
        if(r < target_array.size)
        {
            trXpVal = target_array[r].trXp;
            if(!isDefined(trXpVal)) trXpVal = 0;

            trRankIcon = promod\ls_ranks::getRankIcon(trXpVal);
            trRankName = promod\ls_ranks::getRankName(trXpVal);

            skillVal = target_array[r].skill;
            if(!isDefined(skillVal))
                skillVal = int(target_array[r].kd * 1000);

            self setClientDvars(
                "ui_lb_rank_" + r, (r + 1),
                "ui_lb_name_" + r, target_array[r].name,
                "ui_lb_kills_" + r, target_array[r].kills,
                "ui_lb_deaths_" + r, target_array[r].deaths,
                "ui_lb_kd_" + r, target_array[r].kd,
                "ui_lb_tr_icon_" + r, trRankIcon,
                "ui_lb_tr_name_" + r, trRankName,
                "ui_lb_tr_xp_" + r, trXpVal,
                "ui_lb_skill_" + r, skillVal
            );
        }
        else
        {
            self setClientDvars(
                "ui_lb_rank_" + r, "",
                "ui_lb_name_" + r, "",
                "ui_lb_kills_" + r, "",
                "ui_lb_deaths_" + r, "",
                "ui_lb_kd_" + r, "",
                "ui_lb_tr_icon_" + r, "",
                "ui_lb_tr_name_" + r, "",
                "ui_lb_tr_xp_" + r, "",
                "ui_lb_skill_" + r, ""
            );
        }
        wait 0.05;
    }

    // --- 11th Row (Index 10) Local Player Stats ---
    guid = self getGuid();
    if(!isDefined(guid) || guid == "") guid = self.name;
    
    localRank = "-";
    for(i = 0; i < target_array.size; i++)
    {
        if(target_array[i].guid == guid)
        {
            localRank = "#" + (i + 1);
            break;
        }
    }

    trXpVal = self.pers["xp"];
    if(!isDefined(trXpVal)) trXpVal = 0;
    trRankIcon = promod\ls_ranks::getRankIcon(trXpVal);
    trRankName = promod\ls_ranks::getRankName(trXpVal);
    
    if(isDefined(self.lb_tab) && self.lb_tab == 1)
    {
        // Map stats
        kills = 0; deaths = 0; skill = 0; kd = 0;
        for(i = 0; i < level.map_leaderboard_players.size; i++)
        {
            if(level.map_leaderboard_players[i].guid == guid)
            {
                kills = level.map_leaderboard_players[i].kills;
                deaths = level.map_leaderboard_players[i].deaths;
                kd = level.map_leaderboard_players[i].kd;
                skill = level.map_leaderboard_players[i].skill;
                break;
            }
        }
    }
    else
    {
        // Global stats
        kills = self getStat(2303); if(!isDefined(kills)) kills = 0;
        deaths = self getStat(2305); if(!isDefined(deaths)) deaths = 0;
        kd = kills; if(deaths > 0) kd = kills / deaths;
        kd = int(kd * 100) / 100;
        skill = int(kd * 1000);
    }

    self setClientDvars(
        "ui_lb_rank_10", localRank,
        "ui_lb_name_10", "^3" + self.name,
        "ui_lb_kills_10", kills,
        "ui_lb_deaths_10", deaths,
        "ui_lb_kd_10", kd,
        "ui_lb_tr_icon_10", trRankIcon,
        "ui_lb_tr_name_10", trRankName,
        "ui_lb_tr_xp_10", trXpVal,
        "ui_lb_skill_10", skill
    );
}

loadLeaderboard()
{
    path = "leaderboard.txt";
    if(!FS_TestFile(path)) return;
    file = FS_FOpen(path, "read");
    if(file < 0) return;
    for(;;)
    {
        line = FS_ReadLine(file);
        if(!isDefined(line) || line == "") break;
        tokens = strTok(line, "\\");
        if(tokens.size >= 4)
        {
            entry = spawnStruct();
            entry.guid = tokens[0]; entry.name = tokens[1];
            entry.kills = int(tokens[2]); entry.deaths = int(tokens[3]);
            if(entry.deaths == 0) entry.kd = entry.kills;
            else entry.kd = entry.kills / entry.deaths;
            entry.kd = int(entry.kd * 100) / 100;
            entry.skill = int(entry.kd * 1000);
            if(tokens.size >= 7) { entry.rankLevel = int(tokens[4]); entry.prestige = int(tokens[5]); entry.rankName = tokens[6]; }
            else { entry.rankLevel = 1; entry.prestige = 0; entry.rankName = "Private"; }
            if(tokens.size >= 8) entry.trXp = int(tokens[7]); else entry.trXp = 0;
            entry.playerObj = undefined;
            level.leaderboard_players[level.leaderboard_players.size] = entry;
        }
    }
    FS_FClose(file);
}

loadMapLeaderboard()
{
    mapname = getDvar("mapname");
    path = "Map_Leaderboard/" + mapname + "_leaderboard.txt";
    if(!FS_TestFile(path)) return;
    file = FS_FOpen(path, "read");
    if(file < 0) return;
    for(;;)
    {
        line = FS_ReadLine(file);
        if(!isDefined(line) || line == "") break;
        tokens = strTok(line, "\\");
        if(tokens.size >= 4)
        {
            entry = spawnStruct();
            entry.guid = tokens[0]; entry.name = tokens[1];
            entry.kills = int(tokens[2]); entry.deaths = int(tokens[3]);
            if(entry.deaths == 0) entry.kd = entry.kills;
            else entry.kd = entry.kills / entry.deaths;
            entry.kd = int(entry.kd * 100) / 100;
            entry.skill = int(entry.kd * 1000) + entry.kills;
            if(tokens.size >= 7) { entry.rankLevel = int(tokens[4]); entry.prestige = int(tokens[5]); entry.rankName = tokens[6]; }
            else { entry.rankLevel = 1; entry.prestige = 0; entry.rankName = "Private"; }
            if(tokens.size >= 8) entry.trXp = int(tokens[7]); else entry.trXp = 0;
            entry.playerObj = undefined;
            level.map_leaderboard_players[level.map_leaderboard_players.size] = entry;
        }
    }
    FS_FClose(file);
}

saveLeaderboard()
{
    path = "leaderboard.txt";
    file = FS_FOpen(path, "write");
    if(file < 0) return;
    limit = 30; if(level.leaderboard_players.size < 30) limit = level.leaderboard_players.size;
    for(i = 0; i < limit; i++)
    {
        entry = level.leaderboard_players[i];
        levelVal = entry.rankLevel; if(!isDefined(levelVal)) levelVal = 1;
        prestigeVal = entry.prestige; if(!isDefined(prestigeVal)) prestigeVal = 0;
        rankNameVal = entry.rankName; if(!isDefined(rankNameVal) || rankNameVal == "") rankNameVal = "Private";
        trXpVal = entry.trXp; if(!isDefined(trXpVal)) trXpVal = 0;
        line = entry.guid + "\\" + entry.name + "\\" + entry.kills + "\\" + entry.deaths + "\\" + levelVal + "\\" + prestigeVal + "\\" + rankNameVal + "\\" + trXpVal;
        FS_WriteLine(file, line);
    }
    FS_FClose(file);
}

saveMapLeaderboard()
{
    mapname = getDvar("mapname");
    path = "Map_Leaderboard/" + mapname + "_leaderboard.txt";
    file = FS_FOpen(path, "write");
    if(file < 0) return;
    limit = 30; if(level.map_leaderboard_players.size < 30) limit = level.map_leaderboard_players.size;
    for(i = 0; i < limit; i++)
    {
        entry = level.map_leaderboard_players[i];
        levelVal = entry.rankLevel; if(!isDefined(levelVal)) levelVal = 1;
        prestigeVal = entry.prestige; if(!isDefined(prestigeVal)) prestigeVal = 0;
        rankNameVal = entry.rankName; if(!isDefined(rankNameVal) || rankNameVal == "") rankNameVal = "Private";
        trXpVal = entry.trXp; if(!isDefined(trXpVal)) trXpVal = 0;
        line = entry.guid + "\\" + entry.name + "\\" + entry.kills + "\\" + entry.deaths + "\\" + levelVal + "\\" + prestigeVal + "\\" + rankNameVal + "\\" + trXpVal;
        FS_WriteLine(file, line);
    }
    FS_FClose(file);
}
