/// @param UIInput

var input = argument0;

var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

if (data) {
    data.name = input.value;
    internal_name_set(data, input.value);
}