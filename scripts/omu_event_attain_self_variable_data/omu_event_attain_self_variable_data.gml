/// @param UIThing
/// @param EventNode
/// @param data-index
function omu_event_attain_self_variable_data(argument0, argument1, argument2) {

    var thing = argument0;
    var event_node = argument1;
    var data_index = argument2;

    // going to just put all of the available properties in here, i think, because that
    // should make some things a bit easier

    var dw = 320;
    var dh = 320;

    var dg = dialog_create(dw, dh, "Modify Self Variable", dialog_default, dialog_destroy, thing);
    dg.node = event_node;
    dg.index = data_index;

    var custom_data_entity = event_node.custom_data[0];
    var custom_data_variable = event_node.custom_data[1];
    var custom_data_value = event_node.custom_data[2];
    var custom_data_relative = event_node.custom_data[3];

    var ew = dw - 64;
    var eh = 24;

    var vx1 = dw / 4 + 16;
    var vy1 = 0;
    var vx2 = vx1 + (ew - vx1);
    var vy2 = eh;

    var yy = 64;
    var spacing = 16;

    var el_choices = create_radio_array(16, yy, "Variables", ew, eh, function(radio) {
        radio.root.root.node.custom_data[@ 1][@ 0] = radio.value;
    }, custom_data_variable[0], dg);
    create_radio_array_options(el_choices, ["A", "B", "C", "D"]);
    dg.el_choices = el_choices;

    yy += el_choices.GetHeight() + spacing;

    var el_value = create_input(16, yy, "Value", ew, eh, function(input) {
        input.root.node.custom_data[@ 1][@ 0] = real(input.value);
    }, custom_data_value[0], "float", validate_double, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
    dg.el_value = el_value;

    yy += el_value.height + spacing;

    var el_relative = create_checkbox(16, yy, "Relative?", ew, eh, function(checkbox) {
        checkbox.root.node.custom_data[@ 2][@ 0] = checkbox.value;
    }, custom_data_relative[0], dg);
    dg.el_relative = el_relative;

    var b_width = 128;
    var b_height = 32;
    var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents, el_choices, el_value, el_relative, el_close);

    return dg;


}
