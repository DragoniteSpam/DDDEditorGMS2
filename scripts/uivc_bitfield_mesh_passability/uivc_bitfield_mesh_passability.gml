/// @param UIThing

var thing = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];

if (data) {
    data.passage = data.passage ^ thing.value;
}