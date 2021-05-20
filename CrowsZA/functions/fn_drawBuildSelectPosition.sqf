#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: drawBuildSelectPosition.sqf
Parameters:
Return: none

handles selection of multiple points to draw lines between them

Inspired by how ZEN handles selection with teleport players

*///////////////////////////////////////////////
params [
    ["_startPosition", [], []],
    ["_function", {}, [{}]]
];

diag_log "entered drawBuildSelectPosition";

// exit if instance is already running
if (crowsZA_common_selectPositionActive) exitWith {
	// didn't succeed
    [false, []] call _function;
};

// set as active 
crowsZA_common_selectPositionActive = true;

// global vars, as we need to update between event calls
crowsZA_drawBuild_startPos = _startPosition;

// icon vars
private _angle = 45;
private _colour = [0.28, 0.78, 0.96, 1]; //xcom blue
private _icon = "\a3\ui_f\data\igui\cfg\cursors\select_target_ca.paa";
private _text = "Build to here";
private _textStart = "Start Position";

// display vars 
private _display = findDisplay IDD_RSCDISPLAYCURATOR;
private _visuals = [_text, _icon, _angle, _colour, _textStart];

// mouse eventhandler to get clicks/positions
private _mouseEH = [_display, "MouseButtonUp", {
    params ["", "_button", "", "", "_shift", "_ctrl", "_alt"];

	// if not leftclick
    if (_button != 0) exitWith {};

	// get position clicked
    private _position = [] call crowsZA_fnc_getPosFromMouse;

	// call build function 
    [crowsZA_drawBuild_startPos, _position] call crowsZA_fnc_drawBuild;
    // set start pos to new pos 
    crowsZA_drawBuild_startPos = _position;

}, []] call CBA_fnc_addBISEventHandler;

// eventhandler to register ESC/space so we can end selection
private _keyboardEH = [_display, "KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

	// exit if key is not ESC or space
    if (_key != DIK_ESCAPE && _key != DIK_SPACE) exitWith {false};

	// if ESC, we are calling _function with the positions gathered
    _thisArgs params ["_function"];

    [true, crowsZA_drawBuild_startPos] call _function;

	// and setting instance to false
    crowsZA_common_selectPositionActive = false;

    true // handled
}, [_function]] call CBA_fnc_addBISEventHandler;

// main handler
[{
    params ["_args", "_pfhID"];
    _args params ["_function", "_visuals", "_mouseEH", "_keyboardEH", "_drawEH"];

    // End selection with failure if an object is deleted, Zeus display is closed, or pause menu is opened
	if (isNull findDisplay IDD_RSCDISPLAYCURATOR || !isNull findDisplay IDD_INTERRUPT) then {
        [false, crowsZA_drawBuild_startPos] call _function;
        crowsZA_common_selectPositionActive = false;
    };

    // If no longer actice, exit and remove event handlers
    if (!crowsZA_common_selectPositionActive) exitWith {
        private _display = findDisplay IDD_RSCDISPLAYCURATOR;
		// mouse and keyboard
        _display displayRemoveEventHandler ["MouseButtonUp", _mouseEH];
        _display displayRemoveEventHandler ["KeyDown", _keyboardEH];

		// clear global vars
		crowsZA_drawBuild_startPos = []; 

		// remove myself
        [_pfhID] call CBA_fnc_removePerFrameHandler;
    };

    // only draw 3D if map is not visible
    if (visibleMap) exitWith {};

	// get current pos to draw as pointer
    private _currPos = [] call crowsZA_fnc_getPosFromMouse;
    _visuals params ["_text", "_icon", "_angle", "_color", "_textStart"];
    
	// convert to AGL for drawing
	_currPos = ASLtoAGL _currPos;
    private _startPos = ASLToAGL crowsZA_drawBuild_startPos;

	// draw start pos icon in 3D
	drawIcon3D [_icon, _color, _startPos, 1, 1, _angle, _textStart];

	// draw current icon in 3D, xcom blue
    drawIcon3D [_icon, _color, _currPos, 1.5, 1.5, _angle, _text];

    // draw line between the positions 
    drawLine3D [_startPos, _currPos, _color];	

}, 0, [_function, _visuals, _mouseEH, _keyboardEH]] call CBA_fnc_addPerFrameHandler;
