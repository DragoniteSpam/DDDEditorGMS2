/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    part_type_destroy(type);
    ds_list_delete(Stuff.particle.types, selection);
    ui_list_deselect(button.root.list);
}