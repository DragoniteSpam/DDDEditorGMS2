/// @param UIRadio
function uivc_animation_keyframe_graphic_type(argument0) {

	var radio = argument0;
	var keyframe = radio.root.root.root.root.root.el_timeline.selected_keyframe;
	var base_dialog = radio.root.root;

	keyframe.graphic_type = radio.value;

	base_dialog.el_graphic_none.enabled = (keyframe.graphic_type == GraphicTypes.NONE);
	base_dialog.el_graphic_no_change.enabled = (keyframe.graphic_type == GraphicTypes.NO_CHANGE);
	base_dialog.el_graphic_overworld_sprite_list.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);
	base_dialog.el_graphic_battler_sprite_list.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);
	base_dialog.el_graphic_mesh_list.enabled = (keyframe.graphic_type == GraphicTypes.MESH);
	base_dialog.el_graphic_battler_sprite_render.enabled = (keyframe.graphic_type == GraphicTypes.SPRITE);


}
