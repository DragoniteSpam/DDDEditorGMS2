event_inherited();

def_x = 0;
def_y = 100;

if (Settings.event[$ "x"] == undefined)                 Settings.event.x = def_x;
if (Settings.event[$ "y"] == undefined)                 Settings.event.y = def_y;

x = Settings.event.x;
y = Settings.event.y;

render = function() {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_fullscreen: draw_editor_event(); break;
        case view_ribbon: draw_editor_menu(); break;
        case view_hud: draw_editor_hud(); break;
    }
};
save = function() {
    Settings.event.x = self.x;
    Settings.event.y = self.y;
};

canvas_active_node = noone;
canvas_active_node_index = 0;
request_cancel_active_node = false;

active = new DataEvent("DefaultEvent");
array_push(Game.events.events, active);
node_info = noone;

map = noone;

ui = ui_init_event(id);
mode_id = ModeIDs.EVENT;