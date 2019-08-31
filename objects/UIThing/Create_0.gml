render = ui_render;
contents = ds_list_create();
root = noone;
enabled = true;
check_view = true;

interactive = true;
outline = true;             // not used in all element types

key = "key";

text = "thing";
height = 24;
width = 128;

color = c_black;
alignment = fa_left;
valignment = fa_middle;

help = HelpPages.OVERVIEW;

// if you have a list of ui things in a list, and want to iterate over the list, but
// want to ignore this one
is_aux = false;