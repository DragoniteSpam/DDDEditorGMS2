/// @description  double ds_stuff_help_auto(UIThing);
/// @param UIThing

/*
 * automatically opens the help file to the page attached to the argument;
 * would be nicer to use this through with() but ui elements are deactivated
 * so you can't really do that
 */

return ds_stuff_help(Stuff.help_pages[argument0.help]);
