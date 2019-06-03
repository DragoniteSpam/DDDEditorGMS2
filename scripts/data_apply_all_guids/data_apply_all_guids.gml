/// @description void data_apply_all_guids(list of DataData);
/// @param list of DataData

// if you want to refresh everything
for (var i=0; i<ds_list_size(argument0); i++) {
    var data=argument0[| i];
    guid_set(data);
    for (var j=0; j<ds_list_size(data.properties); j++) {
        guid_set(data.properties[| j]);
    }
}
