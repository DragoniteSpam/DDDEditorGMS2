/// @description  ui_init_game_data_refresh();
/*
 * 1. check to see if there are any lists of the selected type already created; if there are,
 *      refresh them
 * 2. assign values to the property field things
 */

var data=guid_get(Camera.ui_game_data.active_type_guid);
var selection=ui_list_selection(Camera.ui_game_data.el_instances);

if (selection<0){
    var instance=noone;
} else {
    var instance=guid_get(data.instances[| selection].GUID);
}

if (instance!=noone){
    Camera.ui_game_data.el_inst_name.value=instance.name;
} else {
    Camera.ui_game_data.el_inst_name.value="";
}

// if you got to this point, you already know data has a value
// container
var dynamic=Camera.ui_game_data.el_dynamic;
var n=0;
for (var i=0; i<ds_list_size(dynamic.contents); i++){
    // another container
    var column=dynamic.contents[| i];
    
    // slot 0 in column 0 is taken up by "name" which doesn't count
    if (i==0){
        var start=1;
    } else {
        var start=0;
    }
    for (var j=start; j<ds_list_size(column.contents); j++){
        // it'd be nice if i could just add the elements to a list and go over the
        // list without having to "physically" go down each column and row, but then
        // the list would be orphaned/memory leak unless i do some other things that
        // i don't feel like doing
        var property=data.properties[| n];
        var thingy=column.contents[| j];
        
        // only check data, not enums
        if (property.type==DataTypes.DATA){
            ui_list_deselect(thingy);
            if (property.type_guid==data.GUID){
                // element
                ui_list_clear(thingy);
                for (var k=0; k<ds_list_size(data.instances); k++){
                    create_list_entries(thingy, data.instances[| k], c_black);
                }
            }
        }
        
        if (instance!=noone){
            if (property.type==DataTypes.BOOL){
                thingy.value=instance.values[| n];
            } else {
                thingy.value=string(instance.values[| n]);
            }
            // if you re-select a data that already has one of these fields set, it should
            // be re-selected when you re-select the instance - there should be some indication
            // that the value is set
            if (property.type==DataTypes.DATA){
                ui_list_deselect(thingy);
                var datatype=guid_get(property.type_guid);
                for (var k=0; k<ds_list_size(datatype.instances); k++){
                    if (datatype.instances[| k].GUID==instance.values[| n]){
                        ds_map_add(thingy.selected_entries, k, true);
                        thingy.index=max(0, k-thingy.slots+1);
                        break;
                    }
                }
            } else if (property.type==DataTypes.ENUM){
                ui_list_deselect(thingy);
                var datatype=guid_get(property.type_guid);
                for (var k=0; k<ds_list_size(datatype.properties); k++){
                    if (datatype.properties[| k].GUID==instance.values[| n]/*==k*/){
                        ds_map_add(thingy.selected_entries, k, true);
                        thingy.index=max(0, k-thingy.slots+1);
                        break;
                    }
                }
            }
        } else {
            switch (property.type){
                case DataTypes.INT:
                case DataTypes.FLOAT:
                case DataTypes.ENUM:
                case DataTypes.DATA:
                    thingy.value=string(0);
                    break;
                case DataTypes.STRING:
                    thingy.value="";
                    break;
                case DataTypes.BOOL:
                    thingy.value=string(false);
                    break;
            }
        }
        
        n++;
    }
}
