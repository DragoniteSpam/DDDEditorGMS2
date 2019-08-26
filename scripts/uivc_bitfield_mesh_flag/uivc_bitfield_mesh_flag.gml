/// @param UIThing

if (data_vra_exists()) {
    var data = Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
    data[@ MeshArrayData.FLAGS] = data[@ MeshArrayData.FLAGS] ^ argument0.value;
}