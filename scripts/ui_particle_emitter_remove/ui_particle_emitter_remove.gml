/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    instance_activate_object(emitter);
    instance_destroy(emitter);
    ds_list_delete(Stuff.particle.emitters, selection);
    ui_list_deselect(button.root.list);
}