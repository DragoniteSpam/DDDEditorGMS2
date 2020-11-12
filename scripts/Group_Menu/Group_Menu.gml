// dont methodize this, as you pass it a null value to close menus
function menu_activate(menu) {
    Stuff.menu.active_element = menu;
    if (!menu) Stuff.menu.extra_element = undefined;
}

function momu_expand() {
    // you need to set this as the "onmouseup" script if you want a menu to
    // be able to expand out
    menu_activate(self);
}

function menu_activate_extra(menu) {
    menu_activate(menu);
    Stuff.menu.extra_element = menu;
}

function menu_is_active(menu) {
    return menu_is_ancestor(Stuff.menu.active_element, menu);
}

function menu_is_ancestor(test, root) {
    if (!test || !root) return false;
    if (test == root) return true;
    return menu_is_ancestor(test.root, root);
}