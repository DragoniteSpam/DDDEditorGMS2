/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var what = Stuff.all_graphic_battlers[| selection];
    
    list.root.el_name.value = what.name;
    list.root.el_name_internal.value = what.internal_name;
    list.root.el_frames_horizontal.value = string(what.hframes);
    list.root.el_frames_vertical.value = string(what.vframes);
    list.root.el_image.image = what.picture;
    list.root.el_dimensions.text = "Dimensions: " + string(sprite_get_width(what.picture)) + " x " + string(sprite_get_height(what.picture));
}