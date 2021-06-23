function momu_copy() {
    emu_dialog_notice("copy: we haven't implemented this yet. please stand by!");
}

function momu_cut() {
    emu_dialog_notice("cut: we haven't implemented this yet. please stand by!");
}

function momu_deselect() {
    selection_clear();
}

function momu_paste() {
    emu_dialog_notice("paste: we haven't implemented this yet. please stand by!");
}

function momu_redo() {
    emu_dialog_notice("redo: we haven't implemented this yet. please stand by!");
}

function momu_select_all() {
    selection_clear();
    Stuff.map.last_selection = new SelectionRectangle(0, 0, 0, Stuff.map.active_map.xx, Stuff.map.active_map.yy, Stuff.map.active_map.zz);
}

function momu_undo() {
    emu_dialog_notice("undo: we haven't implemented this yet. please stand by!");
}