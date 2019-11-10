/// @param filename

var filename = argument0;

var original = buffer_load(filename);
var erroneous = false;

var buffer = buffer_decompress(original);

// if the file won't decompress, it's probably not compressed
if (buffer < 0) {
    buffer = original;
}

buffer_seek(buffer, buffer_seek_start, 0);
    
/*
* Header
*/

var header = chr(buffer_read(buffer, buffer_u8)) + chr(buffer_read(buffer, buffer_u8)) + chr(buffer_read(buffer, buffer_u8));

if (header == "DDD") {
    var version = buffer_read(buffer, buffer_u32);
    var last_safe_version = DataVersions.STARTING_POSITION;
	
    if (version < last_safe_version) {
        show_error("We stopped supporting versions of the data file before " + string(last_safe_version) +
            ". This current version is " + string(version) + ". Please find a version of " + filename_name(filename) +
            " made with a more up-to-date version of the editor.", true
        );
	}
    
    buffer_read(buffer, buffer_u8);
    buffer_read(buffer, buffer_u32);
	
    var datatype = buffer_read(buffer, buffer_datatype);
    
    if (datatype == SerializeThings.TERRAIN_HEIGHTMAP) {
        serialize_load_terrain(buffer, version);
    } else {
        erroneous = true;
    }
    
    error_show();
} else {
    erroneous = true;
}

if (erroneous) {
    dialog_create_notice(noone, "this is a dddt file but the contents are no good?");
}

/*
 * that's it!
 */

buffer_delete(buffer);
if (buffer != original) {
    buffer_delete(original);
}