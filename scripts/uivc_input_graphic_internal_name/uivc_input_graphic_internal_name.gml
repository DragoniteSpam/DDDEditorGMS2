/// @param UIInput

var input = argument0;
var list = input.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    var already = internal_name_get(input.value);
    if (!already || already == list.entries[| selection]) {
        internal_name_remove(list.entries[| selection].internal_name);
        internal_name_set(list.entries[| selection], input.value);
        input.color = c_black;
    } else {
        input.color = c_red;
    }
}