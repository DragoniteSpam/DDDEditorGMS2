/// @param x
/// @param y
/// @param node
function draw_event_node_condition_add(argument0, argument1, argument2) {

    var xx = argument0;
    var yy = argument1;
    var node = argument2;

    draw_sprite(spr_plus_minus, 0, xx, yy);

    var tolerance = 8;
    if (mouse_within_rectangle(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
        draw_sprite(spr_plus_minus, 1, xx, yy);
        draw_tooltip(xx, yy + 16, "Add Data");
        if (Controller.release_left) {
            var list_branch_types = node.custom_data[0];
            var list_branch_indices = node.custom_data[1];
            var list_branch_comparisons = node.custom_data[2];
            var list_branch_values = node.custom_data[3];
            var list_branch_code = node.custom_data[4];
        
            array_push(list_branch_types, ConditionBasicTypes.SWITCH);
            array_push(list_branch_indices, -1);
            array_push(list_branch_comparisons, Comparisons.EQUAL);
            array_push(list_branch_values, 1);
            array_push(list_branch_code, "");
        
            var radio = create_radio_array(16, 32, "Else if:", EVENT_NODE_CONTACT_WIDTH - 32, 24, null, ConditionBasicTypes.SWITCH, node);
            radio.adjust_view = true;
            create_radio_array_options(radio, ["Variable", "Switch", "Self Variable", "Self Switch", "Code"]);
        
            var eh = 32;
            radio.y = radio.y + (((radio.GetHeight() div eh) * eh) + eh + 16) * array_length(node.ui_things);
        
            array_push(node.ui_things, radio);
            // insert at the second to last position so that the "else" outbound node stays where it is
            array_insert(node.outbound, array_length(node.outbound) - 1, noone);
        }
    }


}
