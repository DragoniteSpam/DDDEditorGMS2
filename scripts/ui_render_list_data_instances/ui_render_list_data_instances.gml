/// @param UIList

var list = argument0;
var xx = argument1;
var yy = argument2;

var otext = list.text;
var otextvacant = list.text_vacant;

var data = guid_get(list.root.active_type_guid);

if (data) {
    if (data.is_enum) {
        list.text_vacant = "<Enums can't be instantiated>"
		list.entries = Stuff.empty_list;
    } else {
        list.entries = data.instances;
    }
} else {
	list.entries = Stuff.empty_list;
}

ui_render_list(list, xx, yy);

list.text = otext;
list.text_vacant = otextvacant;