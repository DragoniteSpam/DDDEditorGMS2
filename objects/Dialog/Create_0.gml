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
    IS_QUIT                 = 0x0001,
    IS_EXCEPTION            = 0x0002,
    NO_CLOSE_BUTTON         = 0x0004,
    IS_DUPLICATE_WARNING    = 0x0008,
}