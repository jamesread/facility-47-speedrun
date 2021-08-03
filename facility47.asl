state("Facility47") 
{
	// currScene:sz:COutsideCell
	string50 scene : "Facility47.exe", 0x0051887c, 0x8, 0xc, 0x4, 0x38, 0x0, 0x8, 0xA
}


startup 
{
	print("!!!! Startup");

	settings.Add("debug", true, "Debug");

	Action<string> AddSceneSplit = (name) => {
		settings.Add("scene_" + name, false, name);
	};

	AddSceneSplit("OutsideCell");
	AddSceneSplit("BasementExit");
	AddSceneSplit("FumeHoodLab");
	AddSceneSplit("OutsideBuilding1");
	AddSceneSplit("UndergroundStorage");
	AddSceneSplit("FrozenLab");
	AddSceneSplit("BadEnding");

	vars.visited = new HashSet<string>();
	vars.actualScene = "?";
}

start
{
	if (current.scene != null) {
		print("!!!! Start");
		vars.visited = new HashSet<string>();
		vars.actualScene = "?";

		return true;
	}
}

reset
{
	if (current.scene == null) {	
		return true;
	}
}

split 
{
	if (current.scene == null) {
		return false;
	}

	vars.actualScene = current.scene.Substring(4, current.scene.IndexOf('_', 4) - 4);

	if (settings["debug"]) {
		print("Scene:" + vars.actualScene);
		print("Visited:" + vars.visited.Count);
	}

	if (!vars.visited.Contains(vars.actualScene)) {
		vars.visited.Add(vars.actualScene);

		if (settings.ContainsKey("scene_" + vars.actualScene)) {
			if (settings["scene_" + vars.actualScene]) {
				return true;
			}
		} else {
			print("Scene not found in settings:" + vars.actualScene);
		}
	}
}

