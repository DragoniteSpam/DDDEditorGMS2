/// @description array data_load_vra_skip(buffer, grid_size);
/// @param buffer
/// @param grid_size

var n=buffer_read(argument0, T);

if (argument1>0) {
    var bounds=6;
} else {
    var bounds=0;
}

repeat(10*n+bounds) {
    buffer_read(argument0, T);
}
