/// @description  void draw_active_event();

if (Stuff.active_event!=noone){
    draw_set_font(FDefault12);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    
    Stuff.event_node_info=noone;
    
    for (var i=0; i<ds_list_size(Stuff.active_event.nodes); i++){
        draw_event_node(Stuff.active_event.nodes[| i]);
    }
    
    // if you're hovering over an event to show info for, draw it at
    // the end otherwise another event might get drawn on top of it
    if (Stuff.event_node_info!=noone){
        var base=guid_get(Stuff.event_node_info.custom_guid);
        var n=ds_list_size(base.types);
        var x1=Stuff.event_node_info.x;
        var y1=Stuff.event_node_info.y-64-16*max(n, 1);
        var x2=x1+EVENT_NODE_CONTACT_WIDTH;
        var y2=Stuff.event_node_info.y-32;
        var vertical_padding=8;
        
        draw_roundrect_colour(x1, y1-vertical_padding, x2, y2+vertical_padding, c_white, c_white, false);
        draw_roundrect(x1, y1-vertical_padding, x2, y2+vertical_padding, true);
        
        draw_text(x1+16, y1+8, string_hash_to_newline(base.name));
        draw_line(x1+16, y1+24, x2-16, y1+24);
        if (n==0){
            draw_text_colour(x1+16, y1+40, string_hash_to_newline("No data properties"), c_gray, c_gray, c_gray, c_gray, 1);
        } else {
            for (var i=0; i<n; i++){
                var type=base.types[| i];
                switch (type[1]){
                    case DataTypes.INT:
                        var type_name="int";
                        break;
                    case DataTypes.FLOAT:
                        var type_name="float";
                        break;
                    case DataTypes.STRING:
                        var type_name="string";
                        break;
                    case DataTypes.BOOL:
                        var type_name="boolean";
                        break;
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                        var datadata=guid_get(type[EventNodeCustomData.TYPE_GUID]);
                        if (datadata==noone){
                            var type_name="<no type set>";
                        } else {
                            var type_name=datadata.name;
                        }
                        break;
                }
                draw_text(x1+16, y1+40+i*16, string_hash_to_newline(string(i+1)+". "+type[EventNodeCustomData.NAME]+" ("+type_name+")"));
            }
        }
    }
}
