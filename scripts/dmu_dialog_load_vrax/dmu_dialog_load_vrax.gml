/// @description  void dmu_dialog_load_vrax(UIThing);
/// @param UIThing

var fn=get_open_filename("virgo mesh collections (*.vrax)|*.vrax", "");

if (file_exists(fn)){
    var new_names=data_load_vra_names_only(fn);
    var name_missing=false;
    for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++){
        var thing=ActiveMap.all_entities[| i];
        if (instanceof(thing, EntityMesh)){
            if (!ds_map_exists(new_names, thing.mesh_id)){
                name_missing=true;
                break;
            }
        }
    }
    
    ds_map_destroy(new_names);
    
    if (name_missing){
        var dg=dialog_create_yes_or_no(argument0, "If you change the model file now, there are some Entities whose models will no longer point to anything. If you proceed, these Entities will just be deleted. Is this all right with you?",
            dmu_dialog_commit, "Hey!", "sure", dmu_dialog_cancel, "no stop");
        dg.commit=dc_vrax;
        ds_map_add(dg.data, "vra_path", PATH_VRA);
        ds_map_add(dg.data, "fn", fn);
    } else {
        data_load_vra_on_the_fly(argument0, PATH_VRA, fn);
    }
}
