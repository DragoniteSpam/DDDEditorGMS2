/// @param Dialog
function dialog_create_add_prefab_node(argument0) {

    var root = argument0;

    var dw = 320;
    var dh = 640;

    // todo cache the custom event and only commit the changes when you're done
    var dg = dialog_create(dw, dh, "Prefab Nodes", dialog_default, dialog_destroy, root);

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var b_width = 128;
    var b_height = 32;

    var n_slots = 20;

    var yy = 64;
    
    var f_add = function(element) {
        var selection = ui_list_selection(element.root.el_list_main);
        
        if (selection + 1) {
            var event = Stuff.event.active;
            var prefab = Game.events.prefabs[selection];
            
            var instantiated = event_create_node(event, prefab.type, undefined, undefined, prefab.custom_guid);
            // when the node is named normally the $number is appended before the event is added to the
            // list; in this case it's already in the list and you're renaming it, so the number you want
            // is length minus one
            instantiated.Rename(prefab.name + "$" + string(array_length(Stuff.event.active.nodes) - 1));
            instantiated.prefab_guid = prefab.GUID;
            instantiated.data = array_clone(prefab.data);
            
            instantiated.custom_data = [];
            
            for (var i = 0; i < array_length(prefab.custom_data); i++) {
                array_push(instantiated.custom_data, array_clone(prefab.custom_data[i]));
            }
        }
    
        dialog_destroy();
    };

    var el_list = create_list(16, yy, "Prefab Nodes:", "<no prefab nodes>", ew, eh, n_slots, null, false, dg, Game.events.prefabs);
    el_list.ondoubleclick = method(el_list, f_add);
    el_list.entries_are = ListEntries.INSTANCES;

    dg.el_list_main = el_list;

    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, f_add, dg);
    dg.el_confirm = el_confirm;

    ds_list_add(dg.contents,
        el_list,
        el_confirm,
    );

    return dg;


}
