event_inherited();

def_x = 256;
def_y = 256;
def_z = 128;
def_xto = 0;
def_yto = 0;
def_zto = 0;
def_xup = 0;
def_yup = 0;
def_zup = 1;
def_fov = 60;

if (Settings.map[$ "x"] == undefined)                   Settings.map.x = def_x;
if (Settings.map[$ "y"] == undefined)                   Settings.map.y = def_y;
if (Settings.map[$ "z"] == undefined)                   Settings.map.z = def_z;
if (Settings.map[$ "xto"] == undefined)                 Settings.map.xto = def_xto;
if (Settings.map[$ "yto"] == undefined)                 Settings.map.yto = def_yto;
if (Settings.map[$ "zto"] == undefined)                 Settings.map.zto = def_zto;
if (Settings.map[$ "xup"] == undefined)                 Settings.map.xup = def_xup;
if (Settings.map[$ "yup"] == undefined)                 Settings.map.yup = def_yup;
if (Settings.map[$ "zup"] == undefined)                 Settings.map.zup = def_zup;
if (Settings.map[$ "fov"] == undefined)                 Settings.map.fov = def_fov;

x = Settings.map.x;
y = Settings.map.y;
z = Settings.map.z;
xto = Settings.map.xto;
yto = Settings.map.yto;
zto = Settings.map.zto;
xup = Settings.map.xup;
yup = Settings.map.yup;
zup = Settings.map.zup;
fov = Settings.map.fov;

pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

update = editor_update_map;
render = function() {
    switch (view_current) {
        case view_3d: draw_clear(Settings.config.color_world); draw_editor_3d(); break;
        case view_ribbon: draw_editor_menu(true); break;
        case view_hud: draw_editor_hud(); break;
    }
};
cleanup = editor_cleanup_map;
save = function() {
    Settings.map.x = self.x;
    Settings.map.y = self.y;
    Settings.map.z = self.z;
    Settings.map.xto = self.xto;
    Settings.map.yto = self.yto;
    Settings.map.zto = self.zto;
    Settings.map.xup = self.xup;
    Settings.map.yup = self.yup;
    Settings.map.zup = self.zup;
    Settings.map.fov = self.fov;
};
changes = ds_list_create();

under_cursor = noone;

selection = ds_list_create();
selected_entities = ds_list_create();
last_selection = noone;
selected_zone = noone;

selection_fill_mesh = -1;       // list index
selection_fill_tile_x = 4;
selection_fill_tile_y = 0;

selected_zone = noone;
edit_z = 0;

enum SelectionModes {
    SINGLE,
    RECTANGLE,
    CIRCLE
}

enum FillTypes {
    TILE,
    TILE_ANIMATED,
    MESH,
    PAWN,
    EFFECT,
    TERRAIN,
    ZONE,
}

active_map = instance_create_depth(0, 0, 0, DataMapContainer);
active_map.contents = instance_create_depth(0, 0, 0, MapContents);
active_map.contents.map_grid = array_create_4d(active_map.xx, active_map.yy, active_map.zz, MapCellContents._COUNT);
active_map.contents.map_grid_tags = array_create_3d(active_map.xx, active_map.yy, active_map.zz);

ui = ui_init_main(id);
mode_id = ModeIDs.MAP;
mouse_over_ui = false;