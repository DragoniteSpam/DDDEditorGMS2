/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2
function ui_render_surface_render_animation_frame(argument0, argument1, argument2, argument3, argument4) {

    var surface = argument0;
    var x1 = argument1;
    var y1 = argument2;
    var x2 = argument3;
    var y2 = argument4;
    var base_dialog = surface.root;

    var ww = x2 - x1;
    var hh = y2 - y1;

    draw_clear(c_black);

    draw_line_colour(0, hh / 2, ww, hh / 2, c_white, c_white);
    draw_line_colour(ww / 2, 0, ww / 2, hh, c_white, c_white);

    var sprite = noone;
    var batt_list = base_dialog.el_graphic_battler_sprite_list;
    var ow_list = base_dialog.el_graphic_overworld_sprite_list;
    if (ui_list_selection(batt_list)) {
        sprite = Stuff.all_graphic_battlers[| ui_list_selection(batt_list)];
    } else if (ui_list_selection(ow_list)) {
        sprite = Stuff.all_graphic_overworlds[| ui_list_selection(ow_list)];
    }

    if (sprite) {
        var frame = min(base_dialog.keyframe.graphic_frame, sprite.hframes);
        var dir = min(base_dialog.keyframe.graphic_direction, sprite.vframes);
        var fw = sprite.width / sprite.hframes;
        var fh = sprite.height / sprite.vframes;
        var scale = clamp(min(floor(ww / fw), floor(hh / fh)), 1, 4);
        var xx = (ww - scale * fw) / 2;
        var yy = (hh - scale * fh) / 2;
        draw_sprite_part_ext(sprite.picture, 0, fw * frame, fh * dir, fw, fh, xx, yy, scale, scale, c_white, 1);
    }


}
