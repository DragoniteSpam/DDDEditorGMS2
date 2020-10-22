function create_radio_array(x, y, text, width, height, onvaluechange, def, root) {
    with (instance_create_depth(x, y, 0, UIRadioArray)) {
        self.text = text;
        self.width = width;
        self.height = height;
        self.onvaluechange = onvaluechange;
        self.value = def;
        self.root = root;
        return id;
    }
}