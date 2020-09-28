/// @description void dmu_dialog_cancel_destroy_data(UIThing);
/// @param UIThing
function dmu_dialog_cancel_destroy_data(argument0) {

    var map=argument0.data;

    if (ds_map_exists(map, "data_list")) {
        ds_list_destroy(map[? "data_list"]);
    }

    if (ds_map_exists(map, "data_map")) {
        ds_map_destroy(map[? "data_map"]);
    }

    // anything else is probably going to be really rare

    if (ds_map_exists(map, "data_queue")) {
        ds_queue_destroy(map[? "data_queue"]);
    }

    if (ds_map_exists(map, "data_priority")) {
        ds_priority_destroy(map[? "data_priority"]);
    }

    if (ds_map_exists(map, "data_stack")) {
        ds_stack_destroy(map[? "data_stack"]);
    }

    if (ds_map_exists(map, "data_grid")) {
        ds_grid_destroy(map[? "data_grid"]);
    }

    dialog_destroy();



}
