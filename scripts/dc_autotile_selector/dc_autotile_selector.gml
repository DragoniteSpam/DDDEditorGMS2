/// @description  void dc_autotile_selector(Dialog);
/// @param Dialog

var map=argument0.data;

// I really, really really don't feel like doing the commit changes thing here too

dialog_destroy();

// however, you do need to rebuild the master texture when you do this because
// i definitely do not want to do that every time you select something new

// later though because in the middle of the step while the 3D camera is on things
// tend to get flipped upside-down sometimes

Camera.schedule_rebuild_master_texture=true;

/*
var index=noone;

if (ds_map_exists(map, "list")){
    // this is a single-select list so there should only be one value in the map.
    // also don't delete it yet, delete it when the dialog is destroyed otherwise
    // you have a memory leak
    index=ds_map_find_first(map[? "list"])-1;
}

if (index==noone){
    var missing=ds_list_create();
    for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++){
        var thing=ActiveMap.all_entities[| i];
        if (instanceof(thing, EntityAutoTile)){
            if (thing.autotile_id!=index){
                ds_list_add(missing, thing);
            }
        }
    }
    
    if (!ds_list_empty(missing)){
        var dg=dialog_create_yes_or_no(argument0, "So it looks like you want to reset this autotile. There are still some autotile Entities in the map that point to it, so if you proceed, they will just be deleted. Is this all right with you?",
            dmu_dialog_commit, "Hey!", "sure", dmu_dialog_cancel, "no stop");
        dg.commit=dc_vrax;
/*        ds_map_add(dg.data, "vra_path", vra_path);
        ds_map_add(dg.data, "fn", fn);
    }
    
    ds_list_destroy(missing);
    /*
    if (name_missing){
        var dg=dialog_create_yes_or_no(argument0, "If you change the model file now, there are some Entities whose models will no longer point to anything. If you proceed, these Entities will just be deleted. Is this all right with you?",
            dmu_dialog_commit, "Hey!", "sure", dmu_dialog_cancel, "no stop");
        dg.commit=dc_vrax;
        ds_map_add(dg.data, "vra_path", vra_path);
        ds_map_add(dg.data, "fn", fn);
    } else {
        data_load_vra_on_the_fly(argument0, vra_path, fn);
    }
}

// -----------------------------
/*
var xx=ActiveMap.xx;
var yy=ActiveMap.yy;
var zz=ActiveMap.zz;
if (ds_map_exists(map, "x")){
    xx=map[? "x"];
}
if (ds_map_exists(map, "y")){
    yy=map[? "y"];
}
if (ds_map_exists(map, "z")){
    zz=map[? "z"];
}

var oob=ds_list_create();
for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++){
    var thing=ActiveMap.all_entities[| i];
    if (thing.xx>=xx||thing.yy>=yy||thing.zz>=zz){
        ds_list_add(oob, thing);
    }
}

selection_clear();

if (!ds_list_empty(oob)){
    dialog_create_settings_confirm_world_resize(argument0);
} else {
    // normally when you do this kind of thing you'd want to destroy the
    // oob list (or other dynamic resources) first, but this doesn't
    // actually destroy the dialog, just informs the program that it needs
    // to be destroyed after everything has been rendered
    dialog_destroy();
    dc_settings_execute(argument0);
}

ds_list_destroy(oob);
*/
