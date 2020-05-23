/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.list);

if (selection + 1) {
    var emitter = Stuff.particle.emitters[| selection];
    part_emitter_destroy(Stuff.particle.system, emitter);
    ds_list_delete(Stuff.particle.emitters, selection);
    ui_list_deselect(button.root.list);
}