player(response)
{
	self endon("disconnect");
	if(response != "emblem_1" && response != "emblem_2"  && response != "emblem_3")
	{
		if( int(response) < 6)
		{
			spray = int(response);
			requiredVip = 3;
			if(spray == 1 || spray == 2)
				requiredVip = 1;
			else if(spray == 3 || spray == 4)
				requiredVip = 2;
			else if(spray == 5)
				requiredVip = 3;

			if(self GetStat(3253) < requiredVip)
			{
				self iprintlnBold("^1Error: ^7Requires VIP " + requiredVip + " status!");
				return;
			}
			spray = (spray + 29);
			self setStat(979, spray);
			self setClientDvar("drui_spray", spray);
		}
		else if(int(response) > 5 && int(response) < 9)
		{
			spray = int(response) - 5;
			if(self maps\mp\gametypes\_rank::isDSprayUnlocked(spray))
			{
				spray = (spray + 34);
				self setStat(979, spray);
				self setClientDvar("drui_spray", spray);
			}
		}		
		else if(int(response) > 9 && int(response) < 13)
		{
			character = int(response) - 9;
			if(self maps\mp\gametypes\_rank::isDCharacterUnlocked(character))
			{
				self setStat(980, (character+19));
				self setClientDvar("drui_character", character);
			}
		}
		else if(int(response) > 12 && int(response) <= 15)
		{
			character = int(response) - 10;
			requiredVip = 3;
			if(character == 3)
				requiredVip = 1;
			else if(character == 4)
				requiredVip = 2;
			else if(character == 5)
				requiredVip = 3;

			if(self GetStat(3253) < requiredVip)
			{
				self iprintlnBold("^1Error: ^7Requires VIP " + requiredVip + " status!");
				return;
			}
			self setStat(980, (character+20));
			self setClientDvar("drui_character", character);
		}
		else if(int(response) >= 16 && int(response) <= 18)
		{
			glove = int(response) - 16;
			requiredVip = glove + 1;
			if(self GetStat(3253) < requiredVip)
			{
				self iprintlnBold("^1Error: ^7Requires VIP " + requiredVip + " status!");
				return;
			}
			self setStat(980, 26 + glove);
			self iprintlnBold("^3VIP Glove equipped!");
		}
	}
	else
	{
		if(response == "emblem_1" && self GetStat(3253) >= 1)
		{
			self duffman\killcard::setDesign("VIP1");
			self setClientDvar("ui_killcard", self.pers["design"]);
		}
		else if(response == "emblem_2" && self GetStat(3253) >= 2)
		{
			self duffman\killcard::setDesign("VIP2");
			self setClientDvar("ui_killcard", self.pers["design"]);
		}
		else if(response == "emblem_3" && self GetStat(3253) >= 3)
		{
			self duffman\killcard::setDesign("VIP3");
			self setClientDvar("ui_killcard", self.pers["design"]);
		}
	}
}