/// @description  DataEventNode event_create_node(Event, EventNodeType, [x, y], [custom guid]);
/// @param Event
/// @param  EventNodeType
/// @param  [x
/// @param  y]
/// @param  [custom guid]

// XVIEW and YVIEW won't work because this script may
// be called from a script other than view_fullscreen and
// that will make bad things happen
var xx=__view_get( e__VW.XView, view_fullscreen )+room_width/2;
var yy=__view_get( e__VW.YView, view_fullscreen )+room_height/2;
var custom_guid=0;

switch (argument_count){
    case 5:
        custom_guid=argument[4];
        if (!is_undefined(argument[2])){
            xx=argument[2];
        }
        if (!is_undefined(argument[3])){
            yy=argument[3];
        }
        break;
    case 4:
        xx=argument[2];
        yy=argument[3];
        break;
}

var node=instance_create_depth(xx, yy, 0, DataEventNode);
node.event=argument[0];
node.type=argument[1];

switch (argument[1]){
    case EventNodeTypes.ENTRYPOINT:
        node.is_root=true;
        node.name="+Entrypoint";
        node.data[| 0]="";
        break;
    case EventNodeTypes.TEXT:
        node.name="Text";
        break;
    case EventNodeTypes.CUSTOM:
        var custom=guid_get(custom_guid);
        if (custom!=noone){
            node.custom_guid=custom_guid;
            node.name=custom.name;
            
            // pre-allocate space for the properties of the event
            for (var i=0; i<ds_list_size(custom.types); i++){
                var new_list=ds_list_create();
                var type=custom.types[| i];
                ds_list_add(node.custom_data, new_list);
                
                // initial value(s)
                switch (type[1]){
                    case DataTypes.INT:
                    case DataTypes.FLOAT:
                        var value=0;
                        break;
                    case DataTypes.BOOL:
                        var value=false;
                        break;
                    case DataTypes.STRING:
                        var value="The quick brown fox jumped over the lazy game dev";
                        break;
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                        var value=0;
                        break;
                }
                
                ds_list_add(new_list, value);
                
                // if all values are required, populate them with defaults
                // (adding and deleting will be disabled)
                if (type[4]){
                    repeat(type[3]-1){
                        ds_list_add(new_list, value);
                    }
                }
            }
        }
        break;
}

// this used to be a # but that was screwing with game maker's newline
// thing because this version of game maker still used the stupid
// version of newlines
node.name=node.name+"$"+string(ds_list_size(argument[0].nodes));

instance_deactivate_object(node);

ds_list_add(argument[0].nodes, node);
ds_map_add(argument[0].name_map, node.name, node);

return node;
