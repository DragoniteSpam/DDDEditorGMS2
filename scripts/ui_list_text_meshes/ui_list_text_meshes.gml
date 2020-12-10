/// @param UIList
/// @param index
function ui_list_text_meshes(argument0, argument1) {

    var list = argument0;
    var index = argument1;
    var mesh = list.entries[| index];

    var prefix = "";

    if (mesh.flags & MeshFlags.PARTICLE) {
        prefix = "(p)" + prefix;
    }

    return prefix + mesh.name;


}
