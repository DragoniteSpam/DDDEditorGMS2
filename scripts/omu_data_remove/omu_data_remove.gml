/// @description void omu_data_remove(UIThing);
/// @param UIThing

var catch=argument0;

if (argument0.root.selected_data!=noone) {
    argument0.root.selected_data.deleted=true;
    dialog_create_notice(argument0.root, argument0.root.selected_data.name+" has been marked for deletion, but due to the technical headache that is identifying and handling uses of it elsewhere in the data it's not actually going to be deleted. In the future when I have time I might address ways around this but for now just dummy it out, perhaps adding a few Zs to its name so it sinks to the bottom of the list; you can set the game to ignore it anyway.", undefined, undefined, 480, 400);
}
