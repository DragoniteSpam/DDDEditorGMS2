function spriteops_set_alpha(sprite, subimage, alpha) {
    var buffer = sprite_to_buffer(sprite, subimage);
    __spriteops_set_alpha(buffer_get_address(buffer), buffer_get_size(buffer), alpha);
    var changed_sprite = sprite_from_buffer(buffer, sprite_get_width(sprite), sprite_get_height(sprite));
    buffer_delete(buffer);
    return changed_sprite;
}

show_debug_message("SpriteOps version: " + spriteops_version());