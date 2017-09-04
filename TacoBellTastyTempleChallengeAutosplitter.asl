state("DOSBOX")
{
	int Consumables : 0x193A1A0, 0x27C73C;
	int Health : 0x193A1A0, 0x284704;
	int GoldKey : 0x193A1A0, 0x3C02E4;
	int BronzeKey : 0x193A1A0, 0x469CC4;
	int SilverKey : 0x193A1A0, 0x47BE94;
	int BossKey : 0x193A1A0, 0x450CA4;
	int Machete : 0x193A1A0, 0x429F14;
	int Crowbar : 0x193A1A0, 0x4199E4;
	int EndGame : 0x193A1A0, 0x27C64C;
}

start
{
	if(old.Health == 0x19000)
	{
		return true;
	}
}

startup 
{
	settings.Add("Split on Bronze Key", true);
	settings.Add("Split on Silver Key", true);
	settings.Add("Split on Gold Key", true);
	settings.Add("Split on Boss Key", true);
	settings.Add("Split on Crowbar", true);
	settings.Add("Split on Machete", true);
	settings.Add("Split on Consumables", false);
}

split
{
	//Bronze Key
	if(old.BronzeKey != current.BronzeKey)
		{
		return settings["Split on Bronze Key"];
		}
	
	//Gold Key
	if(old.GoldKey != current.GoldKey)
		{
		return settings["Split on Gold Key"];
		}

	//Silver Key
	if(old.SilverKey != current.SilverKey)
		{
		return settings["Split on Silver Key"];
		}

	//Boss Key
	if(old.BossKey != current.BossKey)
		{
		return settings["Split on Boss Key"];
		}

	//Crowbar
	if(old.Crowbar != current.Crowbar)
		{
		return settings["Split on Crowbar"];
		}

	//Machete
	if(old.Machete != current.Machete)
		{
		return settings["Split on Machete"];
		}

	//Consumables
	if(old.Consumables != current.Consumables)
		{
		return settings["Split on Consumables"];
		}

	//End of Game
	if(old.EndGame != current.EndGame)
		{
		return true;
		}

}




//Consumables: 27C73C
//Health: 284704
//Gold Key: 3C02E4
//Bronze Key: 469CC4
//Crowbar: 4199E4
//Machete: 429F14
//Silver Key: 47BE94
//Boss Key: 450CA4
//End Game: 27C64C
