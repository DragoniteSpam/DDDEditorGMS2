
function momu_copy() {
    dialog_create_notice(noone, "copy: we haven't implemented this yet. pleaes stand by!");
}

function momu_cut() {
    dialog_create_notice(noone, "cut: we haven't implemented this yet. pleaes stand by!");
}

function momu_deselect() {
    selection_clear();
}

function momu_paste() {
    dialog_create_notice(noone, "paste: we haven't implemented this yet. pleaes stand by!");
}

function momu_redo() {
    dialog_create_notice(noone, "redo: we haven't implemented this yet. pleaes stand by!");
}

function momu_select_all() {
    selection_clear();
    var selection = instance_create_depth(0, 0, 0, SelectionRectangle);
    ds_list_add(Stuff.map.selection, selection);
    selection.x = 0;
    selection.y = 0;
    selection.z = 0;
    selection.x2 = Stuff.map.active_map.xx;
    selection.y2 = Stuff.map.active_map.yy;
    selection.z2 = Stuff.map.active_map.zz;
    Stuff.map.last_selection = selection;
}

function momu_undo() {
    dialog_create_notice(noone, "undo: we haven't implemented this yet. pleaes stand by!");
}