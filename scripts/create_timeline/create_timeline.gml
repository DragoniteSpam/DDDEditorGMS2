/// @param x
/// @param y
/// @param element-width
/// @param element-height
/// @param content-slots
/// @param moment-slots
/// @param onvaluechange
/// @param root
/// @param [help]

with (instance_create_depth(argument[0], argument[1], 0, UIListTimeline)) {
    moment_width = argument[2];
    height = argument[3];
    slots = argument[4];
    moment_slots = argument[5];
    onvaluechange = argument[6];
    root = argument[7];
    
    help = (argument_count > 8) ? argument[8] : help;
    
    if (slots * height < 128) {
        debug("ListTimeline: " + text + " has a total height less than 128 (" + string(slots) + " slots of height " + string(height) + "). The scroll bar may not behave as intended.");
    }
    
    return id;
}