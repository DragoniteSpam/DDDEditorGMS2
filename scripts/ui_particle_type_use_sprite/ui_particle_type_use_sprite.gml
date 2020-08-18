/// @param UICheckbox
function ui_particle_type_use_sprite(argument0) {

	var checkbox = argument0;
	var selection = ui_list_selection(checkbox.root.list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    type.sprite_custom = checkbox.value;
	    editor_particle_type_set_sprite(type);
	}


}
