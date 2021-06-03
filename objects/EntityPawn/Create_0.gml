event_inherited();

save_script = serialize_save_entity_pawn;
load_script = serialize_load_entity_pawn;

overworld_sprite = ds_list_empty(Stuff.all_graphic_overworlds) ? 0 : Stuff.all_graphic_overworlds[| 0].GUID;
map_direction = 0;

// not serialized but

frame = 0;
is_animating = false;

Stuff.map.active_map.contents.population[ETypes.ENTITY_PAWN]++;

// other properties - inherited

name = "Pawn";
etype = ETypes.ENTITY_PAWN;
etype_flags = ETypeFlags.ENTITY_PAWN;

direction_fix = false;              // because it would be weird to have this off by default
preserve_on_save = true;
reflect = true;

// editor properties

slot = MapCellContents.PAWN;
batchable = false;

// there will be other things here probably
batch = null;                     // you don't batch pawns
render = render_pawn;
selector = select_single;
on_select_ui = safc_on_pawn_ui;

CreateJSONPawn = function() {
    var json = self.CreateJSONBase();
    json.pawn = {
        direction: self.map_direction,
        sprite: self.overworld_sprite,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONPawn();
};