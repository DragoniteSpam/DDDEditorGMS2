/// @description void game_auto_title();

var displayname="";

if (string_length(Stuff.save_name_data)>0) {
    displayname=Stuff.save_name_data+" [data]";
}

if (string_length(Stuff.save_name_data)>0&&string_length(Stuff.save_name_map)>0) {
    displayname=": "+displayname+" / ";
}

if (string_length(Stuff.save_name_map)>0) {
    if (ActiveMap.is_3d) {
        var is3d="3D";
    } else {
        var is3d="2D";
    }
    displayname=displayname+Stuff.save_name_map+" [map: "+is3d+"]";
}

window_set_caption("DDD Editor - "+displayname);
