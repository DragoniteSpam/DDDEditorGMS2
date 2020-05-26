/// @param UIButton

var button = argument0;

var selection = ui_list_selection(button.root.el_list);
if (selection + 1) {
    var entrypoint = button.root.el_list.entries[| selection];
    /// @gml update chained accessors
    var data = button.root.node.custom_data[| button.root.index];
    data[| button.root.multi_index] = entrypoint.GUID;
}

dmu_dialog_commit(button);
dmu_dialog_commit(button);