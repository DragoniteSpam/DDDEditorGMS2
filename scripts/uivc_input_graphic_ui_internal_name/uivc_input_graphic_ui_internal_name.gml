/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.el_list);

if (selection) {
    var already = internal_name_get(input.value);
    if (!already || already == Stuff.all_graphic_ui[| selection]) {
        internal_name_remove(Stuff.all_graphic_ui[| selection].internal_name);
        internal_name_set(Stuff.all_graphic_ui[| selection], input.value);
        input.color = c_black;
    } else {
        input.color = c_red;
    }
}