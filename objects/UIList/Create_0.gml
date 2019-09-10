event_inherited();

text_vacant = "<empty list>";

value = 0;
width = 128;
height = 24;

index = 0;            // where the list starts
last_index = -1;
slots = 4;

click_x = -1;
click_y = -1;

onvaluechange = null;
ondoubleclick = null;
render = ui_render_list;

allow_multi_select = false;
allow_deselect = true;
selected_entries = ds_map_create();

// you may own your own entry list, in which case it'll be destroyed when the UIList is
// destroyed, or it may use someone else's list instead, in which case it won't be

Next:
 - all ui_render_list_* scripts that only exist to slot in an existing list can be
	removed entirely and replaced with the "list" parameter in create_list
 - Get rid of pretty much everything to do with "alphabetize" and instead add an option
	to manually alphabetize lists which can reasonably be expected to be alphabetized
	without causing problems

own_entries = true;
entries = ds_list_create();
entry_colors = ds_list_create();
colorize = true;
entries_are = ListEntries.STRINGS;
numbered = false;

enum ListEntries {
    STRINGS,
    INSTANCES,
    GUIDS
}