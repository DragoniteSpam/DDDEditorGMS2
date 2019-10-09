/// @param UIRadioOption

var option = argument0;

Camera.mouse_drag_behavior = option.root.value;
setting_save_real("mouse", "drag-behavior", Camera.mouse_drag_behavior);