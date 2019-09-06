/// @param x
/// @param y
/// @param node

var xx = argument0;
var yy = argument1;
var node = argument2;

draw_sprite(spr_plus_minus, 0, xx, yy);

var tolerance = 8;
if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
    draw_sprite(spr_plus_minus, 1, xx, yy);
    if (get_release_left()) {
        var list_branch_types = node.custom_data[| 0];
        var list_branch_indices = node.custom_data[| 1];
        var list_branch_comparisons = node.custom_data[| 2];
        var list_branch_values = node.custom_data[| 3];
        var list_branch_code = node.custom_data[| 4];
        
        ds_list_add(list_branch_types, ConditionBasicTypes.SWITCH);
        ds_list_add(list_branch_indices, -1);
        ds_list_add(list_branch_comparisons, Comparisons.EQUAL);
        ds_list_add(list_branch_values, 1);
        ds_list_add(list_branch_code, Stuff.default_lua_event_node_conditional);
        
        var radio = create_radio_array(16, 32, "Else if:", EVENT_NODE_CONTACT_WIDTH - 32, 24, null, ConditionBasicTypes.SWITCH, node);
        radio.adjust_view = true;
        create_radio_array_options(radio, ["Variable", "Switch", "Self Variable", "Self Switch", "Code"]);
        
        var eh = 32;
        radio.y = radio.y + (((ui_get_radio_array_height(radio) div eh) * eh) + eh + 16) * ds_list_size(node.ui_things);
        
        ds_list_add(node.ui_things, radio);
        // insert at the second to last position so that the "else" outbound node stays where it is
        ds_list_insert(node.outbound, ds_list_size(node.outbound) - 1, noone);
    }
}