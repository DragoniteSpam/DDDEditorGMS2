/// @param Dialog
function dialog_create_event_custom(argument0) {

    var dialog = argument0;

    var dw = 960;
    var dh = 560;

    var dg = dialog_create(dw, dh, "Custom Event Node Properties", dialog_note_changes, dialog_destroy, dialog);
    dg.x = dg.x - 32;

    // later on this will be a clone; elements on the dialog should check this instead of the permenant one,
    // and it should be deleted when the dialog is closed
    dg.event = Game.events.custom[ui_list_selection(dialog.root.el_list_custom)];

    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var col1_x = spacing;
    var col2_x = dw / columns + spacing;
    var col3_x = dw * 2 / columns + spacing;

    var vx1 = ew / 2 - 16;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var b_width = 128;
    var b_height = 32;

    var n_slots = 10;

    var yy = 64;

    var el_name = create_input(col1_x, yy, "Name:", ew, eh, uivc_input_custom_event_name, dg.event.name, "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    yy += el_name.height + spacing;

    var yy_base = yy;

    var el_list = create_list(col1_x, yy, "Properties Types: ", "<no properties>", ew, eh, n_slots, uivc_list_event_custom_property, false, dg);
    el_list.render = ui_render_list_event_custom_properties;
    el_list.colorize = false;
    el_list.numbered = true;
    dg.el_list = el_list;

    yy += ui_get_list_height(el_list) + spacing;

    var el_add = create_button(col1_x, yy, "Add Property", ew, eh, fa_center, omu_event_custom_add_property, dg);
    yy += el_add.height + spacing;

    var el_remove = create_button(col1_x, yy, "Delete Property", ew, eh, fa_center, omu_event_custom_remove_property, dg);

    // COLUMN 2
    yy = yy_base;

    var el_property_name = create_input(col2_x, yy, "Name:", ew, eh, uivc_input_custom_data_property_name, "", "Value name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_property_name.interactive = false;
    dg.el_property_name = el_property_name;

    yy += el_property_name.height + spacing;

    var el_property_type = create_radio_array(col2_x, yy, "Type:", ew, eh, uivc_custom_data_property_type, 0, dg);
    create_radio_array_options(el_property_type, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code"]);
    el_property_type.interactive = false;
    dg.el_property_type = el_property_type;

    yy += ui_get_radio_array_height(el_property_type) + spacing;

    var el_property_ext_type = create_button(col2_x, yy, "Other Data Types", ew, eh, fa_middle, omu_event_custom_data_select_type, dg);
    el_property_ext_type.interactive = false;
    dg.el_property_ext_type = el_property_ext_type;

    yy += el_property_ext_type.height + spacing;

    // selector is set when the radio button is messed with
    var el_property_type_guid = create_button(col2_x, yy, "Select Data Type", ew, eh, fa_center, null, dg);
    el_property_type_guid.interactive = false;
    dg.el_property_type_guid = el_property_type_guid;

    yy += el_property_type_guid.height + spacing;

    // COLUMN 3
    yy = yy_base;

    var el_outbound = create_list(col3_x, yy, "Outbound Nodes (max 10):", "what?", ew, eh, 10, uivc_list_event_custom_outbound, false, dg, dg.event.outbound);
    ui_list_select(el_outbound, 0);
    el_outbound.render = ui_render_list_event_custom_outbound;
    dg.el_outbound = el_outbound;
    yy += ui_get_list_height(el_outbound) + spacing;
    var el_outbound_name = create_input(col3_x, yy, "Name:", ew, eh, uivc_input_event_custom_outbound_name, "", "Name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_outbound_name = el_outbound_name;
    yy += el_outbound_name.height + spacing;
    var el_outbound_add = create_button(col3_x, yy, "Add", ew, eh, fa_center, omu_event_custom_add_outbound, dg);
    dg.el_outbound_add = el_outbound_add;
    yy += el_outbound_add.height + spacing;
    var el_outbound_remove = create_button(col3_x, yy, "Delete", ew, eh, fa_center, omu_event_custom_remove_outbound, dg);
    el_outbound_remove.interactive = array_length(dg.event.outbound) > 1;
    dg.el_outbound_remove = el_outbound_remove;
    yy += el_outbound_remove.height + spacing;

    var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg, fa_center);

    ds_list_add(dg.contents,
        el_name, el_list, el_add, el_remove,
        el_property_name, el_property_type, el_property_ext_type, el_property_type_guid,
        el_outbound, el_outbound_name, el_outbound_add, el_outbound_remove,
        el_confirm
    );

    return dg;


}
