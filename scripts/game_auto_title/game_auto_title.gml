var displayname = "";

if (string_length(Stuff.save_name_data) > 0) {
    displayname = Stuff.save_name_data + " [data]";
}

// @todo fill this in once the new system is in place
var map_name = "";
if (string_length(Stuff.save_name_data) > 0 && string_length(map_name) > 0) {
    displayname = ": " + displayname + " / ";
}

if (string_length(map_name) > 0) {
    displayname = displayname + map_name + " [map: " + ActiveMap.is_3d ? "3D" : "2D" + "]";
}

window_set_caption("DDD Editor - " + displayname);