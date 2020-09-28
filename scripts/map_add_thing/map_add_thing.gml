/// @param Entity
/// @param [xx]
/// @param [yy]
/// @param [zz]
/// @param [map]
/// @param [is-temp?]
/// @param [add-to-lists?]
function map_add_thing() {
    // Does not check to see if the specified coordinates are in bounds.
    // You are responsible for that.

    var entity = argument[0];
    var xx = (argument_count < 4) ? entity.xx : argument[1];
    var yy = (argument_count < 4) ? entity.yy : argument[2];
    var zz = (argument_count < 4) ? entity.zz : argument[3];
    var map_container = (argument_count > 4 && argument[4] != undefined) ? argument[4] : Stuff.map.active_map;
    var is_temp = (argument_count > 5 && argument[5] != undefined) ? argument[5] : false;
    var add_to_lists = (argument_count > 6 && argument[6] != undefined) ? argument[6] : true;
    var map = map_container.contents;

    var cell = map_get_grid_cell(xx, yy, zz, map_container);

    // only add thing if the space is not already occupied
    if (!cell[@ entity.slot]) {
        cell[@ entity.slot] = entity;
    
        entity.xx = xx;
        entity.yy = yy;
        entity.zz = zz;
    
        map_transform_thing(entity);
    
        if (add_to_lists) {
            ds_list_add(map.all_entities, entity);
        }
    
        // set that argument to false to avoid adding the instance to a list - this might
        // be because it's a temporary instance, or perhaps it's already in the map and you're
        // just trying to move it
        if (!is_temp && add_to_lists) {
            var list = entity.batchable ? map.batch_in_the_future : map.dynamic;
            // smf meshes simply aren't allowed to be batched, or static, so exert your authority over them
            if (instanceof_classic(entity, EntityMesh) && guid_get(entity.mesh) && guid_get(entity.mesh).type == MeshTypes.SMF) {
                list = map.dynamic;
            }
        
            ds_list_add(list, entity);
            entity.listed = true;
            ds_list_add(Stuff.map.changes, entity);
        }
    } else {
        safa_delete(entity);
    }


}
