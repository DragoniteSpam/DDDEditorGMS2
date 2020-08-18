/// @param UIButton
function ui_particle_demo_fire_execute(argument0) {

	var button = argument0;

	var version = buffer_peek(Stuff.particle.demo_fire, 0, buffer_u32);
	serialize_load_particles(Stuff.particle.demo_fire, version);
	buffer_seek(Stuff.particle.demo_fire, buffer_seek_start, 0);

	ui_list_select(Stuff.particle.ui.t_emitter.list, 0);
	ui_list_select(Stuff.particle.ui.t_type.list, 0);
	script_execute(Stuff.particle.ui.t_emitter.list.onvaluechange, Stuff.particle.ui.t_emitter.list);
	script_execute(Stuff.particle.ui.t_type.list.onvaluechange, Stuff.particle.ui.t_type.list);

	dialog_destroy();


}
