/// @param EntityAutotile

var autotile = argument0;

for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
    var thing = Stuff.map.active_map.contents.all_entities[| i];
    if (thing.modification == Modifications.NONE) {
        if (instanceof(thing, EntityAutoTile)) {
            var dx = thing.xx - autotile.xx;
            var dy = thing.yy - autotile.yy;
            // i will be SHOCKED if this works
            if ((abs(dx) | abs(dy)) == 1) {
                // figure out the positions
                var index = (dy + 1) * 3 + dx + 1;
                if (index > 4) {
                    index--;
                }
                var index_alt = (1 - dy) * 3 + 1 - dx;
                if (index_alt > 4) {
                    index_alt--;
                }
                
                // set thing as autotile's neighbor
                var old = autotile.neighbors[index];
                if (instance_exists(old)) {
                    old.neighbors[index_alt] = noone;
                }
                autotile.neighbors[index] = thing;
                // set autotile as thing's neighbor
                var old = thing.neighbors[index_alt];
                if (instance_exists(old)) {
                    old.neighbors[index] = noone;
                }
                thing.neighbors[index_alt] = autotile;
                
                editor_map_mark_changed(thing);
            }
        }
    }
}