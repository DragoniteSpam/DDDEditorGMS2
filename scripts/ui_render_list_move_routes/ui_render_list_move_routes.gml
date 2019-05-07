/// @description  void ui_render_list_move_routes(UIList, x, y);
/// @param UIList
/// @param  x
/// @param  y

var oldentries=argument0.entries;
var visible_things=argument0.root.entity.visible_routes;
argument0.colorize=true;

argument0.entries=argument0.root.entity.movement_routes;
ds_list_clear(argument0.entry_colors);

for (var i=0; i<ds_list_size(argument0.entries); i++){
    var is_drawn=false;
    for (var j=0; j<array_length_1d(visible_things); j++){
        if (visible_things[j]==argument0.entries[| i].GUID){
            is_drawn=true;
            break;
        }
    }
    
    if (argument0.entries[| i].GUID==argument0.root.entity.autonomous_movement_route){
        // drawn and autonomous
        if (is_drawn){
            ds_list_add(argument0.entry_colors, c_purple);
        // not drawn and autonomous
        } else {
            ds_list_add(argument0.entry_colors, c_blue);
        }
    // drawn and not autonomous
    } else if (is_drawn){
        ds_list_add(argument0.entry_colors, c_red);
    // not drawn and not autonomous
    } else {
        ds_list_add(argument0.entry_colors, c_black);
    }
}

ui_render_list(argument0, argument1, argument2);

// no memory leak, although the list isn't used
argument0.entries=oldentries;
