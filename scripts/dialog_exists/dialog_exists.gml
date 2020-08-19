function dialog_exists() {
    // the 3D preview counts as a dialog (for now?)
    return !ds_list_empty(Stuff.dialogs);


}
