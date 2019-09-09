event_inherited();

save_script = serialize_save_entity_tile;
load_script = serialize_load_entity_tile;

name = "Tile";
etype = ETypes.ENTITY_TILE;

Stuff.active_map.population[ETypes.ENTITY_TILE]++;

// serialize
tile_x = 0;
tile_y = 0;
tile_color = c_white;
tile_alpha = 1;

// if you want to be really fancy you can use different colors for
// all four vertices of the tile but I can't think of any practical
// use for that

// other properties

static = true;
Stuff.active_map.population_static++;

// editor properties

slot = MapCellContents.TILE;

batch = batch_tile;
render = render_tile;
selector = select_single;
on_select = safc_on_tile;