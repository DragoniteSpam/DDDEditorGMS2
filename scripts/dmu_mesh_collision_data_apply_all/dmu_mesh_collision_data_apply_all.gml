/// @param UIButton
function dmu_mesh_collision_data_apply_all(argument0) {

    var button = argument0;
    var grid = button.root.mesh.collision_flags;

    for (var i = 0; i < ds_grid_width(grid); i++) {
        for (var j = 0; j < ds_grid_height(grid); j++) {
            var slice = grid[# i, j];
            for (var k = 0; k < array_length(slice); k++) {
                slice[@ k] = button.root.el_collision_triggers.value;
            }
        }
    }


}
