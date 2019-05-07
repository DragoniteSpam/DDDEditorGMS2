event_inherited();

text_vacant="<empty list>";

value=0;
width=128;
height=24;

index=0;            // where the list starts
last_index=-1;
slots=4;

click_x=-1;
click_y=-1;

onvaluechange=null;
render=ui_render_list;

allow_multi_select=false;
selected_entries=ds_map_create();

// could probably use contents for this but those are for
// instances which get destroyed when the ui element is
// destroyed, and i dont know what will happen if you try
// to destroy a string and i dont want to find out
entries=ds_list_create();
entry_colors=ds_list_create();
colorize=true;
entries_are=ListEntries.STRINGS;
numbered=false;

enum ListEntries {
    STRINGS,
    INSTANCES,
    GUIDS
}

