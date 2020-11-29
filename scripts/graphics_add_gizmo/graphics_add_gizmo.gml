/// @param mesh
/// @param matrix
/// @param use-gizmo-setting
function graphics_add_gizmo(argument0, argument1, argument2) {

    var mesh = argument0;
    var matrix = argument1;
    var use_gizmo = argument2;

    if (!use_gizmo || Stuff.settings.view.gizmos) {
        ds_queue_enqueue(Stuff.unlit_meshes, [mesh, matrix]);
    }


}
