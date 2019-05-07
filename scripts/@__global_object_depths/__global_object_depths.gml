// Initialise the global array that allows the lookup of the depth of a given object
// GM2.0 does not have a depth on objects so on import from 1.x a global array is created
// NOTE: MacroExpansion is used to insert the array initialisation at import time
gml_pragma( "global", "__global_object_depths()");

// insert the generated arrays here
global.__objectDepths[0] = 0; // ObjectError
global.__objectDepths[1] = 0; // Camera
global.__objectDepths[2] = 0; // Stuff
global.__objectDepths[3] = 0; // Entity
global.__objectDepths[4] = 0; // EntityTile
global.__objectDepths[5] = 0; // EntityAutoTile
global.__objectDepths[6] = 0; // EntityMesh
global.__objectDepths[7] = 0; // EntityPawn
global.__objectDepths[8] = 0; // EntityEffect
global.__objectDepths[9] = 0; // EntityEvent
global.__objectDepths[10] = 0; // ActiveMap
global.__objectDepths[11] = 0; // Data
global.__objectDepths[12] = 0; // DataEvent
global.__objectDepths[13] = 0; // DataEventNode
global.__objectDepths[14] = 0; // DataEventNodeCustom
global.__objectDepths[15] = 0; // DataInstantiatedEvent
global.__objectDepths[16] = 0; // DataObject
global.__objectDepths[17] = 0; // DataTileset
global.__objectDepths[18] = 0; // DataData
global.__objectDepths[19] = 0; // DataEnum
global.__objectDepths[20] = 0; // DataGeneric
global.__objectDepths[21] = 0; // DataProperty
global.__objectDepths[22] = 0; // DataInstantiated
global.__objectDepths[23] = 0; // DataMoveRoute
global.__objectDepths[24] = 0; // SelectionRectangle
global.__objectDepths[25] = 0; // SelectionCircle
global.__objectDepths[26] = 0; // SelectionSingle
global.__objectDepths[27] = 0; // Selection
global.__objectDepths[28] = 0; // Dialog
global.__objectDepths[29] = 0; // MenuMenu
global.__objectDepths[30] = 0; // MenuElement
global.__objectDepths[31] = 0; // MenuMain
global.__objectDepths[32] = 0; // UIBitField
global.__objectDepths[33] = 0; // UIBitFieldOption
global.__objectDepths[34] = 0; // UIButton
global.__objectDepths[35] = 0; // UIImageButton
global.__objectDepths[36] = 0; // UICheckbox
global.__objectDepths[37] = 0; // UIInput
global.__objectDepths[38] = 0; // UIList
global.__objectDepths[39] = 0; // UIMain
global.__objectDepths[40] = 0; // UINotification
global.__objectDepths[41] = 0; // UIRadioArray
global.__objectDepths[42] = 0; // UITab
global.__objectDepths[43] = 0; // UIText
global.__objectDepths[44] = 0; // UITextRadio
global.__objectDepths[45] = 0; // UIThing
global.__objectDepths[46] = 0; // UITileSelector
global.__objectDepths[47] = 0; // Controller


global.__objectNames[0] = "ObjectError";
global.__objectNames[1] = "Camera";
global.__objectNames[2] = "Stuff";
global.__objectNames[3] = "Entity";
global.__objectNames[4] = "EntityTile";
global.__objectNames[5] = "EntityAutoTile";
global.__objectNames[6] = "EntityMesh";
global.__objectNames[7] = "EntityPawn";
global.__objectNames[8] = "EntityEffect";
global.__objectNames[9] = "EntityEvent";
global.__objectNames[10] = "ActiveMap";
global.__objectNames[11] = "Data";
global.__objectNames[12] = "DataEvent";
global.__objectNames[13] = "DataEventNode";
global.__objectNames[14] = "DataEventNodeCustom";
global.__objectNames[15] = "DataInstantiatedEvent";
global.__objectNames[16] = "DataObject";
global.__objectNames[17] = "DataTileset";
global.__objectNames[18] = "DataData";
global.__objectNames[19] = "DataEnum";
global.__objectNames[20] = "DataGeneric";
global.__objectNames[21] = "DataProperty";
global.__objectNames[22] = "DataInstantiated";
global.__objectNames[23] = "DataMoveRoute";
global.__objectNames[24] = "SelectionRectangle";
global.__objectNames[25] = "SelectionCircle";
global.__objectNames[26] = "SelectionSingle";
global.__objectNames[27] = "Selection";
global.__objectNames[28] = "Dialog";
global.__objectNames[29] = "MenuMenu";
global.__objectNames[30] = "MenuElement";
global.__objectNames[31] = "MenuMain";
global.__objectNames[32] = "UIBitField";
global.__objectNames[33] = "UIBitFieldOption";
global.__objectNames[34] = "UIButton";
global.__objectNames[35] = "UIImageButton";
global.__objectNames[36] = "UICheckbox";
global.__objectNames[37] = "UIInput";
global.__objectNames[38] = "UIList";
global.__objectNames[39] = "UIMain";
global.__objectNames[40] = "UINotification";
global.__objectNames[41] = "UIRadioArray";
global.__objectNames[42] = "UITab";
global.__objectNames[43] = "UIText";
global.__objectNames[44] = "UITextRadio";
global.__objectNames[45] = "UIThing";
global.__objectNames[46] = "UITileSelector";
global.__objectNames[47] = "Controller";


// create another array that has the correct entries
var len = array_length_1d(global.__objectDepths);
global.__objectID2Depth = [];
for( var i=0; i<len; ++i ) {
	var objID = asset_get_index( global.__objectNames[i] );
	if (objID >= 0) {
		global.__objectID2Depth[ objID ] = global.__objectDepths[i];
	} // end if
} // end for