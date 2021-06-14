event_inherited();

Stuff.particle = id;

back_color = setting_get("particle", "back", c_black);
system_auto_update = setting_get("particle", "auto_update", true);
emitter_set_snap = false;
emitter_set_snap_size = 32;

emitter_setting = noone;
emitter_first_corner = true;

system = part_system_create();
types = [new ParticleType("Default Type")];
emitters = [new ParticleEmitter("Default Emitter")];

part_system_automatic_update(system, system_auto_update);
part_system_automatic_draw(system, false);

render = function() {
    switch (view_current) {
        case view_3d: draw_editor_particle(); break;
        case view_ribbon: draw_editor_menu(); break;
        case view_hud: draw_editor_hud(); break;
    }
};
ui = ui_init_particle(id);
mode_id = ModeIDs.PARTICLE;

ui_list_select(ui.t_emitter.list, 0, false);
ui_list_select(ui.t_emitter.types, 0, false);
ui.t_emitter.types.onvaluechange(ui.t_emitter.types);
ui_list_deselect(ui.t_emitter.list);
ui_list_deselect(ui.t_emitter.types);

demo_fire = buffer_load("data\\particles\\fire.dddp");
demo_water = buffer_load("data\\particles\\waterfall.dddp");
demo_glow = buffer_load("data\\particles\\glow.dddp");