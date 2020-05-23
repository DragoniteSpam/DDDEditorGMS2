/// @param UICheckbox

var checkbox = argument0;

Stuff.particle.system_auto_update = checkbox.value;
checkbox.root.manual_update.interactive = !checkbox.value;
part_system_automatic_update(Stuff.particle.system, checkbox.value);