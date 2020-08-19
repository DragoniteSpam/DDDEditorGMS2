/// @param x
/// @param y
/// @param text
/// @param width
/// @param height
/// @param onvaluechange
/// @param value
/// @param value-x1
/// @param value-y1
/// @param value-x2
/// @param value-y2
/// @param root
function create_color_picker() {

    with (instance_create_depth(argument[0], argument[1], 0, UIColorPicker)) {
        text = argument[2];
        width = argument[3];
        height = argument[4];
    
        onvaluechange = argument[5];
        value = argument[6];
    
        value_x1 = argument[7];
        value_y1 = argument[8];
        value_x2 = argument[9];
        value_y2 = argument[10];
    
        root = argument[11];
    
        return id;
    }



}
