/// @param Dialog
function dialog_is_active(argument0) {
    // this assumes that if there are no active dialog windows, any
    // active ui elements live in a Free Parking part of the  window.

    var dialog = argument0;

    if (ds_list_empty(Stuff.dialogs)) {
        return true;
    }

    return (ds_list_top(Stuff.dialogs) == dialog);


}
