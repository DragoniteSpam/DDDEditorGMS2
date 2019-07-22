/// @param Event
/// @param EventNodeType
/// @param [x]
/// @param [y]
/// @param [custom-guid]

// XVIEW and YVIEW won't work because this script may
// be called from a script other than view_fullscreen and
// that will make bad things happen

var xx = __view_get( e__VW.XView, view_fullscreen ) + room_width / 2;
var yy = __view_get( e__VW.YView, view_fullscreen ) + room_height / 2;

var event = argument[0];
var type = argument[1];
var xx = (argument_count > 2 && argument[2] != undefined) ? argument[2] : xx;
var yy = (argument_count > 3 && argument[3] != undefined) ? argument[3] : yy;
var custom_guid = (argument_count > 4) ? argument[4] : 0;

var node = instance_create_depth(xx, yy, 0, DataEventNode);
node.event = event;
node.type = type;

switch (type) {
    case EventNodeTypes.ENTRYPOINT:
        node.is_root = true;
        node.name = "+Entrypoint";
        node.data[| 0] = "";
        break;
    case EventNodeTypes.TEXT:
        node.name = "Text";
        break;
    case EventNodeTypes.COMMENT:
        node.name = "Comment";
        node.data[| 0] = "This is a comment";
        node.valid_destination = false;
        break;
    case EventNodeTypes.CONDITIONAL:
        node.name = "Branch";
        ds_list_add(node.outbound, noone);                      // there are always one more outbound nodes than the number of branches - the last one is for the final "else"
        var list_branch_types = ds_list_create();
        var list_branch_indices = ds_list_create();
        var list_branch_code = ds_list_create();
        ds_list_add(list_branch_types, ConditionBasicTypes.SWITCH);
        ds_list_add(list_branch_indices, -1);
        ds_list_add(list_branch_code, Stuff.default_lua_event_node_conditional);
        ds_list_add(node.custom_data, list_branch_types);
        ds_list_add(node.custom_data, list_branch_indices);
        ds_list_add(node.custom_data, list_branch_code);
        
        var radio = create_radio_array(16, 32, "Condition type:", EVENT_NODE_CONTACT_WIDTH - 32, 24, null, ConditionBasicTypes.SWITCH, node);
        radio.check_view = true;
        create_radio_array_options(radio, "Variable", "Switch", "Self Variable", "Self Switch", "Code");
        
        ds_list_add(node.ui_things, radio);
        break;
    case EventNodeTypes.CUSTOM:
    default:
        if (type != EventNodeTypes.CUSTOM) {
            custom_guid = Stuff.event_prefab[type].GUID;
        }
        
        var custom = guid_get(custom_guid);
        if (custom) {
            node.custom_guid = custom_guid;
            node.name = custom.name;
            
            // pre-allocate space for the properties of the event
            for (var i = 0; i < ds_list_size(custom.types); i++) {
                var new_list = ds_list_create();
                var type = custom.types[| i];
                ds_list_add(node.custom_data, new_list);
                
                // initial value(s)
                switch (type[1]) {
                    //case DataTypes.INT:
                    //case DataTypes.FLOAT:
                    default:
                        var value = type[5];
                        break;
                }
                
                ds_list_add(new_list, value);
                
                // if all values are required, populate them with defaults
                // (adding and deleting will be disabled)
                if (type[4]) {
                    repeat(type[3] - 1) {
                        ds_list_add(new_list, value);
                    }
                }
            }
        }
        break;
}

// this used to be a # but that was screwing with game maker's newline thing because
// old game maker still used the stupid version of newlines and now that i'm on the
// new version i don't feel like changing it
node.name = node.name + "$" + string(ds_list_size(event.nodes));

instance_deactivate_object(node);

ds_list_add(event.nodes, node);
ds_map_add(event.name_map, node.name, node);

return node;