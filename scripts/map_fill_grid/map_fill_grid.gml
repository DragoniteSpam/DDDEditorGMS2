/// @param grid
/// @param zz
function map_fill_grid(argument0, argument1) {

	var grid = argument0;
	var zz = argument1;

	for (var i = 0; i < ds_grid_width(grid); i++) {
	    for (var j = 0; j < ds_grid_height(grid); j++) {
	        // if something already exists, use its data
	        if (is_array(grid[# i, j])) {
	            var existing_array = grid[# i, j];
	            var le = array_length(existing_array);
	            var contents = array_create(zz);
	            for (var k = 0; k < zz; k++) {
	                contents[k] = (k < le) ? existing_array[k] : [noone, noone, noone, noone];
	            }
	        } else {
	            var contents = array_create(zz);
	            for (var k = 0; k < zz; k++) {
	                contents[k] = [noone, noone, noone, noone];
	            }
	        }
	        grid[# i, j] = contents;
	    }
	}

	// @gml update LWO - these may need to be destroyed manually in the data_resize_map script




}
