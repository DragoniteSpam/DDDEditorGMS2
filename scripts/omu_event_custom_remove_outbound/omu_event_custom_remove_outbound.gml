/// @param UIThing
function omu_event_custom_remove_outbound(argument0) {

    var thing = argument0;
    var event = thing.root.event;
    var list = thing.root.el_outbound;

    var index = ui_list_selection(list);

    array_delete(event.outbound, index, 1);
    if (index >= array_length(event.outbound)) {
        ui_list_deselect(list);
        ds_map_add(list.selected_entries, --index, true);
    }
    ui_input_set_value(thing.root.el_outbound_name, event.outbound[index]);

    thing.root.el_outbound_add.interactive = true;
    thing.root.el_outbound_remove.interactive = array_length(event.outbound) > 1;


}
