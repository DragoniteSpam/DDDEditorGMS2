/// @param DataMesh
function data_mesh_recalculate_bounds(argument0) {
    var mesh = argument0;

    var new_grid = ds_grid_create(mesh.xmax - mesh.xmin, mesh.ymax - mesh.ymin);
    for (var i = 0; i < mesh.xmax - mesh.xmin; i++) {
        for (var j = 0; j < mesh.ymax - mesh.ymin; j++) {
            var new_array = array_create(mesh.zmax - mesh.zmin);
            new_grid[# i, j] = new_array;
            if (i < ds_grid_width(mesh.collision_flags) && j < ds_grid_height(mesh.collision_flags)) {
                for (var k = 0; k < mesh.zmax - mesh.zmin; k++) {
                    var old_array = mesh.collision_flags[# i, j];
                    if (k < array_length(old_array)) {
                        new_array[@ k] = old_array[@ k];
                    } else {
                        new_array[@ k] = 0xffffffff;
                    }
                }
            }
        }
    }

    ds_grid_destroy(mesh.collision_flags);
    mesh.collision_flags = new_grid;


}
