/// @param x
/// @param y
/// @param element-width
/// @param element-height
/// @param content-slots
/// @param moment-slots
/// @param onvaluechange
/// @param oninteract
/// @param root
function create_timeline() {

    with (instance_create_depth(argument[0], argument[1], 0, UIListTimeline)) {
        moment_width = argument[2];
        height = argument[3];
        slots = argument[4];
        moment_slots = argument[5];
        onvaluechange = argument[6];
        oninteract = argument[7];
        root = argument[8];
    
        if (slots * height < 128) {
            wtf("ListTimeline: " + text + " has a total height less than 128 (" + string(slots) + " slots of height " + string(height) + "). The scroll bar may not behave as intended.");
        }
    
        return id;
    }


}
