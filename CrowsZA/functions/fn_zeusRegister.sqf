/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_zeusRegister.sqf
Parameters: none
Return: none

Using the same setup method as JShock in JSHK contamination mod. 

*///////////////////////////////////////////////

private _hasZen = isClass (configFile >> "CfgPatches" >> "zen_custom_modules");
if !(_hasZen) exitWith
{
	private _msg = "******CBA and/or ZEN not detected. They are required for Crows Zeus Additions.";
	diag_log _msg;
};

if (!hasInterface) exitWith {};

private _wait = [player] spawn
{
	params ["_unit"];
	private _timeout = 0;
	waitUntil 
	{
		if (_timeout >= 10) exitWith 
		{
			diag_log "CrowZA:fn_zeusRegister: Timed out!!!";
			true;
		};
		sleep 1;
		_timeout = _timeout + 1;
		if (count allCurators == 0 || {!isNull (getAssignedCuratorLogic _unit)}) exitWith {true};
		false;
	};
	
	private _moduleList = 
	[
		["ACE Add Damage to Unit",{_this call crowsZA_fnc_aceDamageToUnit}, "\CrowsZA\data\icon.paa"],
		["Remove Trees",{_this call crowsZA_fnc_removeTreesZeus}, "\CrowsZA\data\icon.paa"],
		["Follow Unit With Animal",{_this call crowsZA_fnc_animalFollowZeus}, "\CrowsZA\data\icon.paa"],
		["Scatter Teleport",{_this call crowsZA_fnc_scatterTeleportZeus}, "\CrowsZA\data\icon.paa"]
	];

	//registering ZEN custom modules
	{
		private _reg = 
		[
			"Crows Zeus Modules", 
			(_x select 0), 
			(_x select 1),
			(_x select 2)
		] call zen_custom_modules_fnc_register;
	} forEach _moduleList;
};
//waitUntil {scriptDone _wait};
diag_log format ["CrowZA:fn_zeusRegister: Zeus initialization complete. Zeus Enhanced Detected: %2",_hasZen];