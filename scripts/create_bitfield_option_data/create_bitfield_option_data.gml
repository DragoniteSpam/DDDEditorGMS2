function create_bitfield_option_data(value, render, onvaluechange, text, sprite, index, width, height, x, y, color_active, color_inactive) {
    if (x == undefined) x = 0;
    if (y == undefined) y = 0;
    if (color_active == undefined) color_active = c_ui_active_bitfield;
    if (color_inactive == undefined) color_inactive = c_white;
    
    // @gml update lightweight objects
    return [value, render, onvaluechange, text, sprite, index, width, height, x, y, color_active, color_inactive];
}