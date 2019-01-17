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
	settings.Add("Display amount of Items Collected", false);
	settings.Add("Display amount of Enemies Killed", false);
}

init {
	vars.tcsItem = null;
	vars.tcsEnemy = null;
	
	vars.enemiesKilled = 0;
	vars.itemCount = 0;
	vars.allItems = false;
	
	if (settings["Display amount of Items Collected"]
		|| settings["Display amount of Enemies Killed"]) {
		
		bool secondText = false;
		foreach (LiveSplit.UI.Components.IComponent component in timer.Layout.Components) {
			if (component.GetType().Name == "TextComponent") {
				// This is a bit of a mess but it should let you enable the options independently
				if (secondText) {
					vars.tcEnemy = component;
					vars.tcsEnemy = vars.tcEnemy.Settings;
					vars.tcsEnemy.Text1 = "Enemies Killed:";
					vars.tcsEnemy.Text2 = "0";
					break;
				} else {
					if (settings["Display amount of Items Collected"]) {
						vars.tcItem = component;
						vars.tcsItem = vars.tcItem.Settings;
						vars.tcsItem.Text1 = "Items Collected:";
						vars.tcsItem.Text2 = "0";
						
						if (settings["Display amount of Items Collected"]) {
							secondText = true;
						} else {
							break;
						}
					} else {
						vars.tcEnemy = component;
						vars.tcsEnemy = vars.tcEnemy.Settings;
						vars.tcsEnemy.Text1 = "Enemies Killed:";
						vars.tcsEnemy.Text2 = "0";
					}
				}
			}
		}
	}
}

start {
	if (old.Health == 0x19000) {
		vars.enemiesKilled = 0;
		vars.itemCount = 0;
        vars.allItems = false;
		return true;
	}
}

split {
	// Bronze Key
	if (old.BronzeKey != current.BronzeKey) {
		vars.itemCount++;
		return settings["Split on Bronze Key"];
	}
	
	// Gold Key
	if (old.GoldKey != current.GoldKey) {
		vars.itemCount++;
		return settings["Split on Gold Key"];
	}

	// Silver Key
	if (old.SilverKey != current.SilverKey) {
		vars.itemCount++;
		return settings["Split on Silver Key"];
	}

	// Boss Key
	if (old.BossKey != current.BossKey) {
		vars.itemCount++;
		return settings["Split on Boss Key"];
	}

	// Crowbar
	if (old.Crowbar != current.Crowbar) {
		vars.itemCount++;
		return settings["Split on Crowbar"];
	}

	// Machete
	if (old.Machete != current.Machete) {
		vars.itemCount++;
		return settings["Split on Machete"];
	}

	// Consumables
	if (old.Consumables != current.Consumables) {
		vars.itemCount++;
	}

	// Killed Enemy
	if (old.EnemyKilled != current.EnemyKilled) {
		vars.enemiesKilled++;
	}

	// Any% Ending
	if (old.EndGame != current.EndGame) {
		return true;
	}
	// 100% Ending
	if (vars.itemCount >= 55 && vars.enemiesKilled >= 60 && !vars.allItems) {
		vars.allItems = true;
		return true;
	}
	
	// Update Text Components
	if (settings["Display amount of Items Collected"]) {
		vars.tcsItem.Text2 = vars.itemCount.ToString();
	}
	if (settings["Display amount of Enemies Killed"]) {
		vars.tcsEnemy.Text2 = vars.enemiesKilled.ToString();
	}
}

reset {
	if (old.Health == 0x0) {
		return true;
	}
}
