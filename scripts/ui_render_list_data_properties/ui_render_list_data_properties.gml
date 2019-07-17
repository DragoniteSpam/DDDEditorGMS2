/// @param UIList

var otext = argument0.text;
var oentries = argument0.entries;

var datadata = argument0.root.selected_data;

if (datadata) {
    argument0.text = otext + string(ds_list_size(datadata.properties));
    // no alphabetize - it's not useful and it's slow(er) anyway
    argument0.entries = datadata.properties;
}

ui_render_list(argument0, argument1, argument2);

if (datadata) {
    argument0.text = otext;
    argument0.entries = oentries;
}