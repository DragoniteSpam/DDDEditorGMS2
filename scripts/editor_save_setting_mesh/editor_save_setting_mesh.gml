/// @param EditorModeMesh

var mesh = argument0;

setting_set("Mesh", "x", mesh.x);
setting_set("Mesh", "y", mesh.y);
setting_set("Mesh", "z", mesh.z);
setting_set("Mesh", "xto", mesh.xto);
setting_set("Mesh", "yto", mesh.yto);
setting_set("Mesh", "zto", mesh.zto);
setting_set("Mesh", "fov", mesh.fov);

setting_set("Mesh", "export-type", mesh.export_type);
setting_set("Mesh", "vertex-formats", json_encode(mesh.format_json));