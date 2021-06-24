event_inherited();

save_script = serialize_save_entity_tile;

name = "Tile";
etype = ETypes.ENTITY_TILE;
etype_flags = ETypeFlags.ENTITY_TILE;

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

vbuffer = entity_tile_create_vbuffer(id);
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

is_static = true;
Stuff.map.active_map.contents.population_static++;

// editor properties

slot = MapCellContents.TILE;

batch = batch_tile;
batch_collision = batch_collision_tile;
render = render_tile;
on_select_ui = safc_on_tile_ui;

LoadJSONTile = function(source) {
    self.LoadJSONBase(source);
    self.tile_x = source.tile.x;
    self.tile_y = source.tile.y;
    self.tile_color = source.tile.color;
    self.tile_alpha = source.tile.alpha;
};

LoadJSON = function(source) {
    self.LoadJSONTile(source);
};

CreateJSONTile = function() {
    var json = self.CreateJSONBase();
    json.tile = {
        x: self.tile_x,
        y: self.tile_y,
        color: self.tile_color,
        alpha: self.tile_alpha,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONTile();
};