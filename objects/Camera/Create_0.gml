/*
 * other stuff
 */

ui_event = ui_init_event();
ui_game_data = noone;
ui_animation = ui_init_animation();
ui_terrain = ui_init_terrain();
menu = instance_create_depth(0, 0, 0, MenuMain);
dialogs = ds_list_create();

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
vertex_begin(mesh_preview_grid, vertex_format);

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
schedule_view_particle_texture = false;
schedule_view_ui_texture = false;
schedule_save = false;
schedule_open = false;

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
    TERRAIN,
}

fill_types = [safc_fill_tile, safc_fill_autotile, safc_fill_mesh, safc_fill_pawn, safc_fill_effect, safc_fill_terrain];

/*
 * the autotile shader
 */

shd_uniform_at_tex_offset = shader_get_uniform(shd_default_autotile, "texoffset");
shd_value_at_tex_offset = array_create(MAX_AUTOTILE_SHADER_POSITIONS);

/*
 * Event editor
 */

event_canvas_active_node = noone;
event_canvas_active_node_index = 0;

event_x = ini_read_real("Camera", "ex", 0);
event_y = ini_read_real("Camera", "ey", 100);
event_z = ini_read_real("Camera", "ez", 100);

event_xto = ini_read_real("Camera", "exto", 0);
event_yto = ini_read_real("Camera", "eyto", 0);
event_zto = ini_read_real("Camera", "ezto", 0);

event_xup = ini_read_real("Camera", "exup", 0);
event_yup = ini_read_real("Camera", "eyup", 0);
event_zup = ini_read_real("Camera", "ezup", 1);

event_fov = ini_read_real("Camera", "efov", 50);
event_pitch = ini_read_real("Camera", "epitch", 0);
event_direction = ini_read_real("Camera", "edirection", 0);

event_map = noone;

ini_close();