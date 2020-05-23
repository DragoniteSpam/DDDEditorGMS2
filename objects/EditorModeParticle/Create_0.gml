event_inherited();

system_auto_update = true;

system = part_system_create();
types = ds_list_create();
emitters = ds_list_create();

part_system_automatic_update(system, system_auto_update);

render = editor_render_particle;
ui = ui_init_particle(id);
mode_id = ModeIDs.PARTICLE;