function create_bitfield(x, y, text, width, height, def, root) {
    with (instance_create_depth(x, y, 0, UIBitField)) {
        self.text = text;
        self.width = width;
        self.height = height;
        self.value = def;
        self.root = root;
        return id;
    }
}