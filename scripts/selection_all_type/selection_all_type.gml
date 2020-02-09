// returns the object index; would use an enum but i like to keep things as
// simple as possible on occasion, believe it or not
// this is O(n). will not scale as well as i'd like. Use with caution.

var latest_common_ancestor = noone;

var all_tile = true;
var all_tile_auto = true;
var all_mesh = true;
var all_mesh_autotile = true;
var all_pawn = true;
var all_effect = true;

for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
    var thing = Stuff.map.active_map.contents.all_entities[| i];
    var object_type = thing.object_index;
    if (selected(thing)) {
        // if latest common ancestor is undefined, define it
        if (!latest_common_ancestor) {
            latest_common_ancestor = object_type;
        } else {
            // if Thing IS AN instance of the latest common ancestor, you're good
            if (!instanceof(thing, latest_common_ancestor)) {
                // check each ancestor of Thing, and see if it is a common ancestor for
                // the current latest common ancestor
                while (object_type) {
                    if (instanceof_object(latest_common_ancestor, object_type)) {
                        latest_common_ancestor = object_type;
                        break;
                    }
                    object_type = object_get_parent(object_type);
                }
            }
        }
    }
}

return latest_common_ancestor;