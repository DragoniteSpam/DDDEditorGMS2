/// @description  void draw_event_node_title(DataEventNode, color);
/// @param DataEventNode
/// @param  color

var x1=argument0.x;
var y1=argument0.y;
var x2=argument0.x+EVENT_NODE_CONTACT_WIDTH;
var y2=argument0.y+EVENT_NODE_CONTACT_HEIGHT;
var tolerance=4;

if (!dialog_exists()&&event_canvas_active_node==noone){
    if (mouse_within_rectangle_view(x1, y1, x2, y2)){
        draw_rectangle_colour(x1+tolerance, y1+tolerance, x2-tolerance, y2-tolerance, argument1, argument1, argument1, argument1, false);
        
        // i don't like this either but it also works
        if (get_release_left()){
            var new_name=get_string("New name for this node?", argument0.name);
            if (new_name!=argument0.name){
                if (string_length(new_name)==0){
                    // don't
                } else if (ds_map_exists(argument0.event.name_map, new_name)){
                    show_message(new_name+" is already in use!");
                } else {
                    ds_map_delete(argument0.event.name_map, argument0.name);
                    ds_map_add(argument0.event.name_map, new_name, argument0);
                    argument0.name=new_name;
                }
            }
        }
    }
}
    
draw_text(x1+16, mean(y1, y2), string_hash_to_newline(argument0.name));
