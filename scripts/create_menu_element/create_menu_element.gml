function create_menu_element(text, onmouseup, root) {
    with (instance_create_depth(0, 0, 0, MenuElement)) {
        self.text = text;
        self.onmouseup = method(self, onmouseup);
        self.root = root;
        return id;
    }
}