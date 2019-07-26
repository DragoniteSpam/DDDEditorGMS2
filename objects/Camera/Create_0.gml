/*
 * Projection variables
 */

ini_open(DATA_INI);
x = ini_read_real("Camera", "x", 0);
y = ini_read_real("Camera", "y", 0);
z = ini_read_real("Camera", "z", 100);

xto = ini_read_real("Camera", "xto", 512);
yto = ini_read_real("Camera", "yto", 512);
zto = ini_read_real("Camera", "zto", 0);

xup = ini_read_real("Camera", "xup", 0);
yup = ini_read_real("Camera", "yup", 0);
zup = ini_read_real("Camera", "zup", 1);

fov = ini_read_real("Camera", "fov", 50);
pitch = ini_read_real("Camera", "pitch", 0);
direction = ini_read_real("Camera", "direction", 0);
ini_close();

alarm[ALARM_CAMERA_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;

/*
 * Editor modes
 */

mode = EditorModes.EDITOR_3D;

enum EditorModes {
    EDITOR_3D,
    EDITOR_EVENT,
    EDITOR_DATA,
}

/*
 * Raycasting stuff
 */

MOUSE_X = window_mouse_get_x();
MOUSE_Y = window_mouse_get_y();
mouse_3d_lock = false;

mouse_vector = [1, 1, 1];

/*
 * Vertex formats
 */

gpu_set_alphatestenable(true);
gpu_set_alphatestref(20);

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_colour();     // second color information is for extra data
vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_colour();
vertex_format_line = vertex_format_end();

grid = noone;
graphics_create_grid();

/*
 * selection stuff
 */

under_cursor = noone;

selection = ds_list_create();
selected_entities = ds_list_create();
last_selection = noone;

ini_open(DATA_INI);
selection_mode = ini_read_real("selection", "mode", SelectionModes.RECTANGLE);
selection_addition = ini_read_real("selection", "addition", false);
selection_fill_type = ini_read_real("selection", "fill-type", FillTypes.TILE);
selection_mask = ini_read_real("selection", "mask", SELECTION_MASK_ALL);

selection_fill_mesh = 0;
selection_fill_tile_x = 4;
selection_fill_tile_y = 0;
selection_fill_autotile = 0;

view_wireframe = ini_read_real("view", "wireframe", false);
view_grid = ini_read_real("view", "grid", true);
view_backface = ini_read_real("view", "backface", false);
view_texture = ini_read_real("view", "texture", true);
view_entities = ini_read_real("view", "entities", true); /* this sounds dumb */
ini_close();

tile_data_view = TileSelectorDisplayMode.PASSAGE;
tile_on_click = TileSelectorOnClick.SELECT;

enum TileSelectorDisplayMode {
    PASSAGE,
    PRIORITY,
    FLAGS,
    TAGS,
}

enum TileSelectorOnClick {
    SELECT,
    MODIFY,
}

/*
 * inputs; maybe these can be rebound though a menu, but that's not important now
 */

input_selection_add = vk_control;

/*
 * other stuff
 */

changes = ds_list_create();
ui = ui_init_main();
ui_event = ui_init_event();
ui_game_data = noone;
menu = instantiate(MenuMain);
dialogs = ds_list_create();

stuff_to_destroy = ds_queue_create();

instance_deactivate_object(UIThing);

gpu_set_tex_repeat(true);

/*
 * preview stuff
 */

mesh_preview = noone;
mesh_x = 0;
mesh_y = 0;
mesh_z = 0;
mesh_xrot = 0;
mesh_yrot = 0;
mesh_zrot = 0;
mesh_scale = 1;

mesh_preview_grid = vertex_create_buffer();
vertex_begin(mesh_preview_grid, vertex_format_line);

var x1 = -6 * TILE_WIDTH;
var y1 = -6 * TILE_HEIGHT;
var x2 = -x1;
var y2 = -y1;
for (var i = 0; i <= 12; i++) {
    vertex_point_line(mesh_preview_grid, x1 + i * TILE_WIDTH, y1, 0, c_white, 1);
    vertex_point_line(mesh_preview_grid, x1 + i * TILE_WIDTH, y2, 0, c_white, 1);
    
    vertex_point_line(mesh_preview_grid, x1, y1 + i * TILE_HEIGHT, 0, c_white, 1);
    vertex_point_line(mesh_preview_grid, x2, y1 + i * TILE_HEIGHT, 0, c_white, 1);
}

vertex_end(mesh_preview_grid);
vertex_freeze(mesh_preview_grid);

/*
 * end of step actions
 */

schedule_rebuild_master_texture = false;
schedule_view_master_texture = false;
schedule_save_data = false;
schedule_save_map = false;
schedule_save_assets = false;
schedule_open = false;
schedule_list_kill = ds_list_create();            // list of arrays of [list index, current index]

/*
 * enumerated constants that i need
 */

enum SelectionModes {
    SINGLE,
    RECTANGLE,
    CIRCLE
}

enum FillTypes {
    TILE,
    AUTOTILE,
    MESH,
    PAWN,
    EFFECT,
    EVENT,
    TERRAIN,
}

fill_types = [safc_fill_tile, safc_fill_autotile, safc_fill_mesh, safc_fill_pawn, safc_fill_effect, safc_fill_event, safc_fill_terrain];

/*
 * the autotile shader
 */

shd_uniform_at_tex_offset = shader_get_uniform(shd_default_autotile, "texoffset");
shd_value_at_tex_offset = array_create(MAX_AUTOTILE_SHADER_POSITIONS);
//array_clear(shd_value_at_tex_offset, 2/(Stuff.tile_size/TEXTURE_SIZE))

/*
 * Event editor
 */

event_canvas_active_node = noone;
event_canvas_active_node_index = 0;
