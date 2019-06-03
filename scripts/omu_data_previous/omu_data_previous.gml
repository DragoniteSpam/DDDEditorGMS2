/// @param UIThing

var dynamic = argument0.root.el_dynamic;

dynamic.page--;
argument0.root.el_pages.text = "Page " + string(dynamic.page + 1) + " / " + string(ds_list_size(dynamic.contents) - 2);

var columns = 5;
var cw =(room_width - columns * 32) / columns;
var spacing = 16;

for (var i = 0; i < ds_list_size(dynamic.contents); i++) {
    var thing = dynamic.contents[| i];
    thing.enabled = (i >= dynamic.page && i <= dynamic.page + 2);
    thing.x = (i - dynamic.page) * cw + spacing;
}

argument0.root.el_previous.interactive = (dynamic.page > 0);
argument0.root.el_next.interactive = (dynamic.page < ds_list_size(dynamic.contents) - 3);