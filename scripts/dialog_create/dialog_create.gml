/// @param width
/// @param height
/// @param text
/// @param render
/// @param commit
/// @param root
/// @param [close]

var base_x = 64;
var base_y = 64;
var offset = 48;
var n = ds_list_size(Camera.dialogs);

var dg = instance_create_depth(base_x + n * offset, base_y + n * offset, 0, Dialog);
dg.width = argument[0];
dg.height = argument[1];
dg.text = argument[2];
dg.render = (argument[3] != undefined) ? argument[3] : dialog_default;
dg.commit = (argument[4] != undefined) ? argument[4] : dc_default;
dg.root = argument[5];

dg.close = (argument_count > 6) ? argument[6] : dg.close;

ds_list_add(Camera.dialogs, dg);
instance_deactivate_object(dg);

return dg;