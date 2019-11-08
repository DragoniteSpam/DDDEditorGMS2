/// @param UIThing

var thing = argument0;

var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

if (data) {
    data.flags = data.flags ^ thing.value;
}