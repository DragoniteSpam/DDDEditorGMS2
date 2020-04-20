/// @param DataMapContainer

var map = argument0;
var version = map.version;
var buffer = map.data_buffer;

if (Stuff.map.active_map) {
    buffer_delete(Stuff.map.active_map.data_buffer);
    Stuff.map.active_map.version = DataVersions._CURRENT - 1;
    Stuff.map.active_map.data_buffer = serialize_save_current_map();
    if (Stuff.map.active_map.contents) {
        instance_activate_object(Stuff.map.active_map.contents);
        instance_destroy(Stuff.map.active_map.contents);
        Stuff.map.active_map.contents = noone;
    }
    if (Stuff.map.active_map.preview) {
        buffer_delete(Stuff.map.active_map.preview);
        Stuff.map.active_map.preview = noone;
    }
    if (Stuff.map.active_map.wpreview) {
        buffer_delete(Stuff.map.active_map.wpreview);
        Stuff.map.active_map.wpreview = noone;
    }
    if (Stuff.map.active_map.cpreview) {
        c_world_remove_object(Stuff.map.active_map.cpreview);
        Stuff.map.active_map.cpreview = noone;
    }
    if (Stuff.map.active_map.cpreview) {
        c_object_destroy(Stuff.map.active_map.cpreview);
        Stuff.map.active_map.cpreview = noone;
    }
    if (Stuff.map.active_map.cspreview) {
        c_shape_destroy(Stuff.map.active_map.cspreview);
        Stuff.map.active_map.cspreview = noone;
    }
    Stuff.map.active_map.contents = noone;
    ui_create_notification("[c_red]There are " + string(ds_queue_size(Stuff.c_objects_to_destroy)) + " collision objects to destroy. Clearing them is unfathomably slow so the editor may lag for a bit.[]", 15);
}

Stuff.map.active_map = map;

map.contents = instance_create_depth(0, 0, 0, MapContents);
instance_deactivate_object(map.contents);

data_resize_map(map, map.xx, map.yy, map.zz);

if (buffer_md5(buffer, 0, buffer_get_size(buffer)) != EMPTY_BUFFER_MD5) {
    buffer_seek(buffer, buffer_seek_start, 0);

    buffer_read(buffer, buffer_u32);
    serialize_load_map_contents_meta(buffer, version, map);
    buffer_read(buffer, buffer_u32);
    serialize_load_map_contents_batch(buffer, version, map);
    buffer_read(buffer, buffer_u32);
    serialize_load_map_contents_dynamic(buffer, version, map);
    buffer_read(buffer, buffer_u32);
    serialize_load_map_contents_zones(buffer, version, map);
} // else the map has not been initialized yet and it just uses its default values

// this also
var list = Stuff.map.ui.t_maps.el_map_list;
for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
    if (Stuff.all_maps[| i] == Stuff.map.active_map) {
        ui_list_select(list, i);
        script_execute(list.onvaluechange, list);
        break;
    }
}

graphics_create_grids();