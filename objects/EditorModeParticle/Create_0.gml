event_inherited();

back_color = setting_get("Particle", "back", c_black);
system_auto_update = setting_get("Particle", "auto-update", true);

emitter_setting = noone;
emitter_first_corner = true;
emitter_set_snap = false;
emitter_set_snap_size = 32;

system = part_system_create();
types = ds_list_create();
emitters = ds_list_create();

part_system_automatic_update(system, system_auto_update);
part_system_automatic_draw(system, false);

render = editor_render_particle;
ui = ui_init_particle(id);
mode_id = ModeIDs.PARTICLE;