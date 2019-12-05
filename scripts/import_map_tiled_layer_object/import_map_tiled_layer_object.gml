/// @param json
/// @param tileset-columns
/// @param z
/// @param alpha
/// @param x
/// @param y
/// @param object-cache

var json = argument[0];
var columns = argument[1];
var z = argument[2];
var alpha = (argument_count > 3) ? argument[3] : 1;
var xx = (argument_count > 4) ? argument[4] : 0;
var yy = (argument_count > 5) ? argument[5] : 0;
var object_cache = (argument_count > 6) ? argument[6] : noone;
var zz = z div TILED_MAP_LAYERS_PER_BASE_LAYER;

var layer_objects = json[? "objects"];
var layer_name = json[? "name"];
var layer_alpha = json[? "opacity"];
var layer_visible = json[? "visible"];
var layer_data_x = json[? "x"];
var layer_data_y = json[? "y"];
var layer_base_z = get_2D_base_layer(z);

for (var i = 0; i < ds_list_size(layer_objects); i++) {
    var object = layer_objects[| i];
    var obj_id = object[? "id"];
    var obj_x = object[? "x"];
    var obj_y = object[? "y"];
    
    var obj_name = object[? "name"];
    var obj_template = object[? "template"];
    var obj_properties = object[? "properties"];
    var obj_type = object[? "type"];
    var obj_visible = object[? "visible"];
    var obj_width = object[? "width"];
    var obj_height = object[? "height"];
    
    var data_template = (obj_template == undefined) ? noone : import_map_tiled_get_cached_object(object_cache, obj_template);
    if (!data_template) {
        if (obj_name == undefined) continue;
        if (obj_type == undefined) continue;
        if (obj_visible == undefined) continue;
        if (obj_width == undefined) continue;
        if (obj_height == undefined) continue;
        
        var data_name = obj_name;
        var data_type = obj_type;
        var data_visible = obj_visible;
        var data_width = obj_width;
        var data_height = obj_height;
    } else {
        var data_name = (obj_name == undefined) ? data_template[? "name"] : obj_name;
        var data_type = (obj_type == undefined) ? data_template[? "type"] : obj_type;
        var data_visible = (obj_visible == undefined) ? data_template[? "visible"] : obj_visible;
        var data_width = (obj_width == undefined) ? data_template[? "width"] : obj_width;
        var data_height = (obj_height == undefined) ? data_template[? "height"] : obj_height;
    }
    
    // merging the property maps does not sound like my idea of a fun time, but not doing it would be even worse
    var data_properties = ds_map_create();
    
    // the properties given to the instantiated object go first
    if (obj_properties != undefined) {
        for (var j = 0; j < ds_list_size(obj_properties); j++) {
            var given = obj_properties[| j];
            var property = ds_map_create();
            property[? "name"] = given[? "name"];
            // skip type - only needed by Tiled
            property[? "value"] = given[? "value"];
            ds_map_add_map(data_properties, given[? "name"], property);
        }
    }
    // the properties of the template go last - if any can be found
    if (data_template && data_template[? "properties"] != undefined) {
        var template_properties = data_template[? "properties"];
        if (template_properties != undefined) {
            for (var j = 0; j < ds_list_size(template_properties); j++) {
                var given = template_properties[| j];
                if (!ds_map_exists(data_properties, given[? "name"])) {
                    var property = ds_map_create();
                    property[? "name"] = given[? "name"];
                    // skip type - only needed by Tiled
                    property[? "value"] = given[? "value"];
                    ds_map_add_map(data_properties, given[? "name"], property);
                }
            }
        }
    }
    
    switch (string_lower(data_type)) {
        case "pawn":
            var pr_cutscene_entrypoint = data_properties[? "CutsceneEntrypoint"];
            var pr_sprite_internal_name = data_properties[? "SpriteInternalName"];
            var pr_static = data_properties[? "Static?"];
            
            if (pr_cutscene_entrypoint == undefined) break;
            if (pr_sprite_internal_name == undefined) break;
            if (pr_static == undefined) break;
            
            pr_cutscene_entrypoint = pr_cutscene_entrypoint[? "value"];
            pr_sprite_internal_name = pr_sprite_internal_name[? "value"];
            pr_static = pr_static[? "value"];
            break;
        case "mesh":
            var pr_cutscene_entrypoint = data_properties[? "CutsceneEntrypoint"];
            var pr_mesh_internal_name = data_properties[? "MeshInternalName"];
            var pr_static = data_properties[? "Static?"];
            
            if (pr_cutscene_entrypoint == undefined) break;
            if (pr_mesh_internal_name == undefined) break;
            if (pr_static == undefined) break;
            
            pr_cutscene_entrypoint = pr_cutscene_entrypoint[? "value"];
            pr_mesh_internal_name = pr_mesh_internal_name[? "value"];
            pr_static = pr_static[? "value"];
            
            var pr_mesh_data = internal_name_get(pr_mesh_internal_name);
            if (pr_mesh_data) {
                map_add_thing(instance_create_mesh(pr_mesh_data), (xx + obj_x) div TILE_WIDTH, (yy + obj_y - data_height) div TILE_HEIGHT, zz);
            } else {
                show_error("Log an error somewhere", false);
            }
            break;
        case "effect":
            not_yet_implemented_polite();
            break;
    }
    
    ds_map_destroy(data_properties);
}

return z;