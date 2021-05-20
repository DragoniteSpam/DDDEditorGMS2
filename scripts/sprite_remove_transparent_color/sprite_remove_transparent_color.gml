function sprite_remove_transparent_color(sprite, color) {
    if (color == undefined) color = 0xff00ff;
    
    var buffer = sprite_to_buffer(sprite, 0);
    var changed = false;
    for (var i = 0, len = buffer_get_size(buffer); i < len; i += 4) {
        if (buffer_peek(buffer, i, buffer_u32) & 0xffffff == color) {
            buffer_poke(buffer, i, buffer_u32, 0);
            changed = true;
        }
    }
    
    if (changed) {
        sprite_delete(sprite);
        sprite = sprite_from_buffer(buffer);
    }
    
    buffer_delete(buffer);
    
    return sprite;
}