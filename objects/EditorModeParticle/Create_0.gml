event_inherited();

Stuff.particle = id;

back_color = setting_get("Particle", "back", c_black);
system_auto_update = setting_get("Particle", "auto-update", true);
emitter_set_snap = false;
emitter_set_snap_size = 32;

emitter_setting = noone;
emitter_first_corner = true;

system = part_system_create();
types = ds_list_create();
emitters = ds_list_create();

part_system_automatic_update(system, system_auto_update);
part_system_automatic_draw(system, false);

render = editor_render_particle;
ui = ui_init_particle(id);
mode_id = ModeIDs.PARTICLE;

var default_emitter = ui_particle_emitter_add(noone);
default_emitter.name = "Default Emitter";
var default_type = ui_particle_type_add(noone);
default_type.name = "Default Type";

ui_list_select(ui.t_emitter.list, 0, false);
ui_list_select(ui.t_emitter.types, 0, false);
ui_particle_emitter_type(ui.t_emitter.types);
ui_list_deselect(ui.t_emitter.list);
ui_list_deselect(ui.t_emitter.types);

demo_fire = buffer_load("data\\particles\\fire.dddp");
demo_water = buffer_load("data\\particles\\waterfall.dddp");
demo_glow = buffer_load("data\\particles\\glow.dddp");