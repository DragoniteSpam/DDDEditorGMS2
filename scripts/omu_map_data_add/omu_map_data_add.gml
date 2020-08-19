/// @param UIButton
function omu_map_data_add(argument0) {

    var button = argument0;
    var map = Stuff.map.active_map;

    if (ds_list_size(map.generic_data) < 0x100) {
        var data = instance_create_depth(0, 0, 0, DataAnonymous);
        data.name = "GenericData" + string(ds_list_size(map.generic_data));
        ds_list_add(map.generic_data, data);
        instance_deactivate_object(data);
    } else {
        dialog_create_notice(button.root, "Please don't try to create more than " + string(0xff) + " data types. If you need a lot of generic data grouped together you may want to create a type to represent instantiated enemies instead.", "Hey!");
    }


}
