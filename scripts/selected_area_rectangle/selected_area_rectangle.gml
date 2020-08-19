/// @param SelectionRectangle
function selected_area_rectangle(argument0) {
    // volume can be zero if it's just a flat plane, but area can't

    var selection = argument0;

    return (selection.x - selection.x2) * (selection.y - selection.y2);


}
