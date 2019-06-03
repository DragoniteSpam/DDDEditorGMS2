/// @description void omu_data_property_remove(UIThing);
/// @param UIThing

if (argument0.root.selected_property!=noone) {
    argument0.root.selected_property.deleted=true;
    dialog_create_notice(argument0.root, argument0.root.selected_property.name+" has been marked for deletion, but due to the technical headache that is identifying and handling uses of it elsewhere in the data it's not actually going to be deleted. In the future when I have time I might address ways around this but for now just dummy it out, perhaps adding a few Zs to its name so it sinks to the bottom of the list; you can set the game to ignore it anyway.", undefined, undefined, 480, 400);
}
