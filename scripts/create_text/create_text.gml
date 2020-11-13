function create_text(x, y, text, width, height, alignment, wrap_width, root) {
    with (instance_create_depth(x, y, 0, UIText)) {
        self.text = text;
        self.width = width;
        self.height = height;
        self.alignment = alignment;
        self.wrap_width = wrap_width;
        self.root = root;
        return id;
    }
}