/// @param filename
/// @param project-name

var fn = argument[0];
var proj_name = argument[1];
var outcome = true;

var fn_asset = filename_change_ext(fn, EXPORT_EXTENSION_ASSETS);
var fn_data = filename_change_ext(fn, EXPORT_EXTENSION_DATA);

var original_asset = -1;
var original_data = -1;
var decompressed_asset = -1;
var decompressed_data = -1;

if (!file_exists(fn_asset)) {
    dialog_create_notice(noone, "Could not find an asset file (it should be named \"" + filename_name(fn_asset) +"\" and be in the same folder as the data file). Please do not separate the asset and data files.");
    outcome = false;
}
if (!file_exists(fn_data)) {
    dialog_create_notice(noone, "Could not find a data file (it should be named \"" + filename_name(fn_data) +"\" and be in the same folder as the asset file). Please do not separate the asset and data files.");
    outcome = false;
}

// this is a bit ugly, but there are various points where the loading can fail, so after
// each point it needs to be wrapped in another check because trying to proceed would make
// the whole thing explode
if (outcome) {
    var original_asset = buffer_load(fn_asset);
    var original_data = buffer_load(fn_data);
    
    var header_zlib_asset = buffer_peek(original_asset, 0, buffer_u16);
    var header_zlib_data = buffer_peek(original_data, 0, buffer_u16);
    
    if (header_zlib_asset == MAGIC_ZLIB_HEADER) {
        var decompressed_asset = buffer_decompress(original_asset);
        var buffer_asset = decompressed_asset;
    } else {
        var buffer_asset = original_asset;
    }
    
    if (header_zlib_data == MAGIC_ZLIB_HEADER) {
        var decompressed_data = buffer_decompress(original_data);
        var buffer_data = decompressed_data;
    } else {
        var buffer_data = original_data;
    }
    
    // header
    var header_asset = chr(buffer_read(buffer_asset, buffer_u8)) + chr(buffer_read(buffer_asset, buffer_u8)) + chr(buffer_read(buffer_asset, buffer_u8));
    var header_data = chr(buffer_read(buffer_data, buffer_u8)) + chr(buffer_read(buffer_data, buffer_u8)) + chr(buffer_read(buffer_data, buffer_u8));
    
    if (header_asset != "DDD") {
        dialog_create_notice(noone, "The asset file isn't any good (" + fn_asset + "). Please load a valid asset file.");
        outcome = false;
    }
    if (header_data != "DDD") {
        dialog_create_notice(noone, "The data file isn't any good (" + fn_data + "). Please load a valid data file.");
        outcome = false;
    }
    
    if (outcome) {
        var last_safe_version = DataVersions.MAP_TILED_ID;
        var last_safe_release = "2019.4.1.19";
        var version_asset = buffer_read(buffer_asset, buffer_u32);
        var version_data = buffer_read(buffer_data, buffer_u32);
        
        if (version_asset < last_safe_version) {
            dialog_create_notice(noone, "We stopped supporting versions of the data file before " + string(last_safe_version) +
                ". This file's version is " + string(version_asset) + ". Please find a version of " + filename_name(fn_asset) +
                " made with a more up-to-date version of the editor - the last version which nuked compatibility was " +
                last_safe_version + ".", true
            );
            outcome = false;
        }
        
        if (version_data < last_safe_version) {
            dialog_create_notice(noone, "We stopped supporting versions of the data file before " + string(last_safe_version) +
                ". This file's version is " + string(version_data) + ". Please find a version of " + filename_name(fn_data) +
                " made with a more up-to-date version of the editor - the last version which nuked compatibility was " +
                last_safe_version + ".", true
            );
            outcome = false;
        }
        
        if (outcome) {
            serialize_load_old(buffer_asset);
            serialize_load_old(buffer_data);
            setting_project_add(proj_name);
            //setting_project_create_local(proj_name, original_asset, original_data);
            game_auto_title();
    
            Stuff.save_name = proj_name;
        }
    }
}

buffer_delete(original_asset);
buffer_delete(original_data);
if (buffer_exists(decompressed_asset)) {
    buffer_delete(decompressed_asset);
}
if (buffer_exists(decompressed_data)) {
    buffer_delete(decompressed_data);
}

return outcome;