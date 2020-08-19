/// @param UIBitFieldOption
/// @param x
/// @param y
function uivc_mesh_collision_render_data_flag_none(argument0, argument1, argument2) {

    var option = argument0;
    var xx = argument1;
    var yy = argument2;

    option.state = !option.root.value;

    ui_render_bitfield_option_text(option, xx, yy);


}
