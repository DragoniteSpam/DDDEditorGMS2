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

if (Stuff.settings.map[$ "x"] == undefined)                   Stuff.settings.map.x = def_x;
if (Stuff.settings.map[$ "y"] == undefined)                   Stuff.settings.map.y = def_y;
if (Stuff.settings.map[$ "z"] == undefined)                   Stuff.settings.map.z = def_z;
if (Stuff.settings.map[$ "xto"] == undefined)                 Stuff.settings.map.xto = def_xto;
if (Stuff.settings.map[$ "yto"] == undefined)                 Stuff.settings.map.yto = def_yto;
if (Stuff.settings.map[$ "zto"] == undefined)                 Stuff.settings.map.zto = def_zto;
if (Stuff.settings.map[$ "xup"] == undefined)                 Stuff.settings.map.xup = def_xup;
if (Stuff.settings.map[$ "yup"] == undefined)                 Stuff.settings.map.yup = def_yup;
if (Stuff.settings.map[$ "zup"] == undefined)                 Stuff.settings.map.zup = def_zup;
if (Stuff.settings.map[$ "fov"] == undefined)                 Stuff.settings.map.fov = def_fov;

x = Stuff.settings.map.x;
y = Stuff.settings.map.y;
z = Stuff.settings.map.z;
xto = Stuff.settings.map.xto;
yto = Stuff.settings.map.yto;
zto = Stuff.settings.map.zto;
xup = Stuff.settings.map.xup;
yup = Stuff.settings.map.yup;
zup = Stuff.settings.map.zup;
fov = Stuff.settings.map.fov;

pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

update = editor_update_map;
render = function() {
    switch (view_current) {
        case view_3d: draw_clear(Stuff.settings.config.color_world); draw_editor_3d(); break;
        case view_ribbon: draw_editor_menu(true); break;
        case view_hud: draw_editor_hud(); break;
    }
};
cleanup = editor_cleanup_map;
save = function() {
    Stuff.settings.map.x = self.x;
    Stuff.settings.map.y = self.y;
    Stuff.settings.map.z = self.z;
    Stuff.settings.map.xto = self.xto;
    Stuff.settings.map.yto = self.yto;
    Stuff.settings.map.zto = self.zto;
    Stuff.settings.map.xup = self.xup;
    Stuff.settings.map.yup = self.yup;
    Stuff.settings.map.zup = self.zup;
    Stuff.settings.map.fov = self.fov;
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

fill_types = [
    safc_fill_tile, safc_fill_tile_animated,
    safc_fill_mesh, safc_fill_pawn,
    safc_fill_effect, safc_fill_terrain
];

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
ds_grid_resize(active_map.contents.map_grid, active_map.xx, active_map.yy);
ds_grid_resize(active_map.contents.map_grid_frozen_tags, active_map.xx, active_map.yy);
map_fill_grid(active_map.contents.map_grid, active_map.zz);
map_fill_tag_grid(active_map.contents.map_grid_frozen_tags, active_map.zz);

ui = ui_init_main(id);
mode_id = ModeIDs.MAP;
mouse_over_ui = false;