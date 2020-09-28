/// @param Entity
function map_remove_thing(argument0) {

    var entity = argument0;
    var map = Stuff.map.active_map.contents;

    var cell = map_get_grid_cell(entity.xx, entity.yy, entity.zz);

    if (cell[@ entity.slot] == entity) {
        cell[@ entity.slot] = noone;
    }


}
