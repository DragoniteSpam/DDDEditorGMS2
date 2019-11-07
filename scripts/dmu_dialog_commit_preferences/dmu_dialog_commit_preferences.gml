/// @param UIButton

var button = argument0;

terrain_export_heightmap(button.root.filename, real(button.root.el_scale.value));
dialog_destroy();