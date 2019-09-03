/// @param UIThing

var thing = argument0;

var fn = get_save_filename("drago's old file format (*.vrax)|*.vrax", "");

// @todo try catch
if (string_length(fn) > 0) {
    export_vrax(fn);
}