event_inherited();

data = ds_map_create();
commit = null;
close = dialog_destroy;
changed = false;

contents_interactive = false;

// for dragging the dialog around with the mouse
cmx = -1;
cmy = -1;

flags = 0;
active_shade = true;

Dispose = function() {
    dialog_destroy();
};

enum DialogFlags {
    IS_QUIT                 = 0x0001,
    IS_EXCEPTION            = 0x0002,
    NO_CLOSE_BUTTON         = 0x0004,
    IS_DUPLICATE_WARNING    = 0x0008,
    IS_GENERIC_WARNING      = 0x0010,
}