event_inherited();

save_script = serialize_save_entity_tile;
load_script = serialize_load_entity_tile;

name = "Tile";
etype = ETypes.ENTITY_TILE;
etype_flags = ETypeFlags.ENTITY_TILE;
collision_flags = 0;

Stuff.map.active_map.contents.population[ETypes.ENTITY_TILE]++;

// serialize
tile_x = 0;
tile_y = 0;
tile_color = c_white;
tile_alpha = 1;

// if you want to be really fancy you can use different colors for all four vertices
// of the tile but I can't think of any practical use for that

// rendering
var tw = TILE_WIDTH;
var th = TILE_HEIGHT;
var texw = TILE_WIDTH / TEXTURE_SIZE;
var texh = TILE_HEIGHT / TEXTURE_SIZE;

vbuffer = vertex_create_buffer();
vertex_begin(vbuffer, Stuff.graphics.vertex_format);
vertex_point_complete(vbuffer, 0, 0, 0, 0, 0, 1, 0, 0, tile_color, tile_alpha);
vertex_point_complete(vbuffer, tw, 0, 0, 0, 0, 1, texw, 0, tile_color, tile_alpha);
vertex_point_complete(vbuffer, tw, th, 0, 0, 0, 1, texw, texh, tile_color, tile_alpha);
vertex_point_complete(vbuffer, tw, th, 0, 0, 0, 1, texw, texh, tile_color, tile_alpha);
vertex_point_complete(vbuffer, 0, th, 0, 0, 0, 1, 0, texh, tile_color, tile_alpha);
vertex_point_complete(vbuffer, 0, 0, 0, 0, 0, 1, 0, 0, tile_color, tile_alpha);
vertex_end(vbuffer);
wbuffer = vertex_create_buffer();
vertex_begin(wbuffer, Stuff.graphics.vertex_format);
vertex_point_line(wbuffer, 0, 0, 0, c_white, 1);
vertex_point_line(wbuffer, tw, 0, 0, c_white, 1);
vertex_point_line(wbuffer, tw, th, 0, c_white, 1);
vertex_point_line(wbuffer, tw, th, 0, c_white, 1);
vertex_point_line(wbuffer, 0, th, 0, c_white, 1);
vertex_point_line(wbuffer, 0, 0, 0, c_white, 1);
vertex_end(wbuffer);

// other properties

static = true;
Stuff.map.active_map.contents.population_static++;

// editor properties

slot = MapCellContents.TILE;

batch = batch_tile;
batch_collision = batch_collision_tile;
render = render_tile;
selector = select_single;
on_select_ui = safc_on_tile_ui;