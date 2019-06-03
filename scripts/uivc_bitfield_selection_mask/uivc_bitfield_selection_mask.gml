/// @description uivc_bitfield_selection_mask(UIThing);
/// @param UIThing

Camera.selection_mask=Camera.selection_mask^argument0.value;
setting_save_real("selection", "mask", Camera.selection_mask);
