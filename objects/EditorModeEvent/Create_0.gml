event_inherited();

x = setting_get("Event", "x", 0);
y = setting_get("Event", "y", 100);
z = setting_get("Event", "z", 100);

xto = setting_get("Event", "xto", 0);
yto = setting_get("Event", "yto", 0);
zto = setting_get("Event", "zto", 0);

xup = setting_get("Event", "xup", 0);
yup = setting_get("Event", "yup", 0);
zup = setting_get("Event", "zup", 1);

fov = setting_get("Event", "fov", 50);
pitch = setting_get("Event", "pitch", 0);
direction = setting_get("Event", "direction", 0);

render = editor_render_event;
save = editor_save_setting_event;

canvas_active_node = noone;
canvas_active_node_index = 0;
request_cancel_active_node = false;

active = event_create("DefaultEvent");
ds_list_add(Stuff.all_events, active);
node_info = noone;

map = noone;

ui = ui_init_event(id);
mode_id = ModeIDs.EVENT;