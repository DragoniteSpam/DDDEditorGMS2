event_inherited();

x = setting_get("Event", "x", 0);
y = setting_get("Event", "y", 100);
z = setting_get("Event", "z", 100);

xto = setting_get("Event", "xto", 0);
yto = setting_get("Event", "yto", 0);
zto = setting_get("Event", "zto", 0);

xup = 0;
yup = 0;
zup = 1;

fov = setting_get("Event", "fov", 50);
pitch = setting_get("Event", "pitch", 0);
direction = setting_get("Event", "direction", 0);

render = function() {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_fullscreen: draw_editor_event(); break;
        case view_ribbon: draw_editor_menu(); break;
        case view_hud: draw_editor_hud(); break;
    }
};
save = function() {
    setting_set("Event", "x", x);
    setting_set("Event", "y", y);
    setting_set("Event", "z", z);
    setting_set("Event", "xto", xto);
    setting_set("Event", "yto", yto);
    setting_set("Event", "zto", zto);
    setting_set("Event", "fov", fov);
    setting_set("Event", "pitch", pitch);
    setting_set("Event", "direction", direction);
};

canvas_active_node = noone;
canvas_active_node_index = 0;
request_cancel_active_node = false;

active = event_create("DefaultEvent");
ds_list_add(Stuff.all_events, active);
node_info = noone;

map = noone;

ui = ui_init_event(id);
mode_id = ModeIDs.EVENT;