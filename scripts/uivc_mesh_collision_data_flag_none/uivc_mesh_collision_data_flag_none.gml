/// @param UIBitfieldOption
function uivc_mesh_collision_data_flag_none(argument0) {

    var option = argument0;
    var mesh = option.root.root.mesh;
    var slice = mesh.collision_flags[# option.root.root.xx, option.root.root.yy];
    option.root.value = 0;

    slice[@ option.root.root.zz] = option.root.value;


}
