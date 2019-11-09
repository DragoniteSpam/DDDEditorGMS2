/// @param EditorMode

var mode = argument0;

gpu_set_cullmode(cull_noculling);
script_execute(mode.ui.render, mode.ui);