function menu_activate(new_menu) {
    if (new_menu && !is_struct(new_menu)) new_menu = new_menu.id;
    Stuff.menu.active_element = new_menu;
    Stuff.menu.extra_element = new_menu ? Stuff.menu.extra_element : undefined;
}

function menu_close_all() {
    menu_activate(undefined);
}

function momu_expand() {
    menu_activate(self);
}

function menu_activate_extra(new_menu) {
    menu_activate(new_menu);
    Stuff.menu.extra_element = new_menu;
}

function menu_is_active(new_menu) {
    return menu_is_ancestor(Stuff.menu.active_element, new_menu);
}

function menu_is_ancestor(test, root) {
    if (!test || !root) return false;
    if (test == root) return true;
    return menu_is_ancestor(test.root, root);
}