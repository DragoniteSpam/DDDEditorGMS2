/// @param x
/// @param y
/// @param text
/// @param vacant-text
/// @param width
/// @param element-height
/// @param content-slots
/// @param onvaluechange
/// @param allow-multi-select?
/// @param root

with (instance_create_depth(argument[0], argument[1], 0, UIList)) {
    text = argument[2];
    text_vacant = argument[3];
    width = argument[4];
    height = argument[5];
    
    slots = argument[6];
    onvaluechange = argument[7];
    allow_multi_select = argument[8];
    
    root = argument[9];
    
    if (slots * height < 128) {
        debug("List: " + text + " has a total height less than 128 (" + string(slots) + " slots of height " + string(height) + "). The scroll bar may not behave as intended.");
    }
    
    return id;
}