/// @description void map_fill_grid(grid, zz);
/// @param grid
/// @param zz

for (var i=0; i<ds_grid_width(argument0); i++) {
    for (var j=0; j<ds_grid_height(argument0); j++) {
        // if something already exists, use its data
        if (is_array(argument0[# i, j])) {
            var existing_array=argument0[# i, j];
            var le=array_length_1d(existing_array);
            var contents=array_create(argument1);
            for (var k=0; k<argument1; k++) {
                if (k<le) {
                    contents[k]=existing_array[k];
                } else {
                    contents[k]=[noone, noone, noone, noone];
                }
            }
        } else {
            var contents=array_create(argument1);
            for (var k=0; k<argument1; k++) {
                contents[k]=[noone, noone, noone, noone];
            }
        }
        argument0[# i, j]=contents;
    }
}

enum MapCellContents {
    TILE,
    MESHMOB,
    EFFECT,
    EVENT
}
