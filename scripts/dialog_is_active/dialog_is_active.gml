/// @param Dialog
// this assumes that if there are no active dialog windows, any
// active ui elements live in a Free Parking part of the  window.

var dialog = argument0;

// because the 3D preview counts as a dialog???
if (view_get_visible(view_3d_preview)) {
    return false;
}

if (ds_list_empty(Stuff.dialogs)) {
    return true;
}

return (ds_list_top(Stuff.dialogs) == dialog);