event_inherited();

system = part_system_create();
types = ds_list_create();
emitters = ds_list_create();

system_auto_update = true;

render = editor_render_particle;
ui = ui_init_particle(id);
mode_id = ModeIDs.PARTICLE;