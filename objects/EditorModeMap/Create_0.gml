event_inherited();

x = setting_get("Map", "x", 0);
y = setting_get("Map", "y", 0);
z = setting_get("Map", "z", 100);

xto = setting_get("Map", "xto", 512);
yto = setting_get("Map", "yto", 512);
zto = setting_get("Map", "zto", 0);

xup = setting_get("Map", "xup", 0);
yup = setting_get("Map", "yup", 0);
zup = setting_get("Map", "zup", 1);

fov = setting_get("Map", "fov", 50);
pitch = setting_get("Map", "pitch", 0);
direction = setting_get("Map", "direction", 0);

smf_light_add_direction(smf_vector_normalize([-1, -1, -1]), c_white, 1);

render = editor_render_map;
cleanup = editor_cleanup_map;
changes = ds_list_create();

under_cursor = noone;

selection = ds_list_create();
selected_entities = ds_list_create();
last_selection = noone;

selection_fill_mesh = -1;       // list index
selection_fill_tile_x = 4;
selection_fill_tile_y = 0;
selection_fill_autotile = 0;

tile_data_view = TileSelectorDisplayMode.PASSAGE;
tile_on_click = TileSelectorOnClick.SELECT;