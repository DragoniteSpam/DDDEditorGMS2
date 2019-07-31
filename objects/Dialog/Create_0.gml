event_inherited();

data = ds_map_create();
commit = null;
close = dc_default;
changed = false;

// for dragging the dialog around with the mouse
cmx = -1;
cmy = -1;

dialog_flags = 0;

enum DialogFlags {
    IS_QUIT,                    /*  1 */
}