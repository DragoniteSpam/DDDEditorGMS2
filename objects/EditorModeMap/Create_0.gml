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

x = setting_get("Map", "x", def_x);
y = setting_get("Map", "y", def_y);
z = setting_get("Map", "z", def_z);

xto = setting_get("Map", "xto", def_xto);
yto = setting_get("Map", "yto", def_yto);
zto = setting_get("Map", "zto", def_zto);

// don't put the up vector in the settings file
xup = def_xup;
yup = def_yup;
zup = def_zup;

fov = setting_get("Map", "fov", def_fov);
pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

update = editor_update_map;
render = function() {
    switch (view_current) {
        case view_3d: draw_clear(Stuff.setting_color_world); draw_editor_3d(); break;
        case view_ribbon: draw_editor_menu(true); break;
        case view_hud: draw_editor_hud(); break;
    }
};
cleanup = editor_cleanup_map;
save = function() {
    setting_set("Map", "x", x);
    setting_set("Map", "y", y);
    setting_set("Map", "z", z);
    setting_set("Map", "xto", xto);
    setting_set("Map", "yto", yto);
    setting_set("Map", "zto", zto);
    setting_set("Map", "fov", fov);
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