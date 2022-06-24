/// @param UIText
/// @param x
/// @param y
function ui_render_text(argument0, argument1, argument2) {

    var text = argument0;
    var xx = argument1;
    var yy = argument2;

    var x1 = text.x + xx;
    var y1 = text.y + yy;
    var x2 = x1 + text.width;
    var y2 = y1 + text.height;

    var tx = text.GetTextX(x1, x2);
    var ty = text.GetTextX(y1, y2);

    scribble(text.text)
        .align(text.alignment, text.valignment)
        .wrap(text.width, text.height)
        .draw(tx, ty);

    if (mouse_within_rectangle(x1, y1, x2, y2)) {
        Stuff.element_tooltip = text;
    }

    ui_handle_dropped_files(text);


}
