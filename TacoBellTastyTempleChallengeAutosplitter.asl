state("DOSBOX")
{
	int Consumables : 0x193A1A0, 0x27C73C;
	int Health :      0x193A1A0, 0x284704;
	int GoldKey :     0x193A1A0, 0x3C02E4;
	int BronzeKey :   0x193A1A0, 0x469CC4;
	int SilverKey :   0x193A1A0, 0x47BE94;
	int BossKey :     0x193A1A0, 0x450CA4;
	int Machete :     0x193A1A0, 0x429F14;
	int Crowbar :     0x193A1A0, 0x4199E4;
	int EndGame :     0x193A1A0, 0x27C64C;
	int EnemyKilled : 0x193A1A0, 0x27C69C;
}

startup {
	settings.Add("Split on Bronze Key", true);
	settings.Add("Split on Silver Key", true);
	settings.Add("Split on Gold Key", true);
	settings.Add("Split on Boss Key", true);
	settings.Add("Split on Crowbar", true);
	settings.Add("Split on Machete", true);
	settings.Add("Split on Consumables", false);
	settings.Add("Display amount of Enemies Killed", false);
}

init {
	vars.tcs = null;
	vars.enemiesKilled = 0;
	
	foreach (LiveSplit.UI.Components.IComponent component in timer.Layout.Components) {
		if (component.GetType().Name == "TextComponent") {
			vars.tc = component;
			vars.tcs = vars.tc.Settings;
			vars.tcs.Text1 = "Enemies Killed:";
			vars.tcs.Text2 = "0";
			break;
		}
	}
}

start {
	if (old.Health == 0x19000) {
		vars.tcs.Text2 = "0";
		return true;
	}
}

split {
	// Bronze Key
	if (old.BronzeKey != current.BronzeKey) {
		return settings["Split on Bronze Key"];
	}
	
	// Gold Key
	if (old.GoldKey != current.GoldKey) {
		return settings["Split on Gold Key"];
	}

	// Silver Key
	if (old.SilverKey != current.SilverKey) {
		return settings["Split on Silver Key"];
	}

	// Boss Key
	if (old.BossKey != current.BossKey) {
		return settings["Split on Boss Key"];
	}

	// Crowbar
	if (old.Crowbar != current.Crowbar) {
		return settings["Split on Crowbar"];
	}

	// Machete
	if (old.Machete != current.Machete) {
		return settings["Split on Machete"];
	}

	// Consumables
	if (old.Consumables != current.Consumables) {
		return settings["Split on Consumables"];
	}

	// Killed Enemy
	if (settings["Display amount of Enemies Killed"]
		&& old.EnemyKilled != current.EnemyKilled) {
		
		vars.enemiesKilled++;
		vars.tcs.Text2 = vars.enemiesKilled.ToString();
	}

	// End of Game
	if (old.EndGame != current.EndGame) {
		return true;
	}
}

reset {
	if (old.Health == 0x0) {
		return true;
	}
}
