/// @param mesh
/// @param matrix
/// @param use-gizmo-setting

var mesh = argument0;
var matrix = argument1;
var use_gizmo = argument2;

if (!use_gizmo || Stuff.setting_view_gizmos) {
    ds_queue_enqueue(Stuff.unlit_meshes, [mesh, matrix]);
}