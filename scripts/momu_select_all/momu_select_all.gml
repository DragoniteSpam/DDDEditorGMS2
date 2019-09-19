/// @param MenuElement

var element = argument0;

selection_clear();

var selection = instance_create_depth(0, 0, 0, SelectionRectangle);
ds_list_add(Camera.selection, selection);
selection.x = 0;
selection.y = 0;
selection.z = 0;
selection.x2 = Stuff.active_map.xx;
selection.y2 = Stuff.active_map.yy;
selection.z2 = Stuff.active_map.zz;

Camera.last_selection = selection;