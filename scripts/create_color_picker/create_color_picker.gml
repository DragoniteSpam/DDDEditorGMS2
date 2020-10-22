function create_color_picker(x, y, text, width, height, onvaluechange, value, value_x1, value_y1, value_x2, value_y2, root) {
    with (instance_create_depth(x, y, 0, UIColorPicker)) {
        self.text = text;
        self.width = width;
        self.height = height;
        self.onvaluechange = onvaluechange;
        self.value = value;
        self.value_x1 = value_x1;
        self.value_y1 = value_y1;
        self.value_x2 = value_x2;
        self.value_y2 = value_y2;
        self.root = root;
        return id;
    }
}