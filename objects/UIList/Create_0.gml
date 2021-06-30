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
onmiddleclick = null;
render = ui_render_list;
render_colors = ui_list_colors;
evaluate_text = null;

auto_multi_select = false;              // this will supercede the allow_multi_select option
allow_multi_select = false;
allow_deselect = true;
select_toggle = false;                    // clicking on an entry will toggle its selected-ness
selected_entries = ds_map_create();

// you may own your own entry list, in which case it'll be destroyed when the UIList is
// destroyed, or it may use someone else's list instead, in which case it won't be
own_entries = true;
entries = ds_list_create();
entry_colors = ds_list_create();
colorize = true;
entries_are = ListEntries.STRINGS;
numbered = false;
surface = noone;

enum ListEntries {
    STRINGS,
    INSTANCES,
    // behaves the same as instances, but also draws the ref ID as an extra way to differentiate
    INSTANCES_REFID,
    GUIDS,
    REFIDS,
    SCRIPT,
}

GetHeight = function() {
    return self.height * (1 + self.slots);
};