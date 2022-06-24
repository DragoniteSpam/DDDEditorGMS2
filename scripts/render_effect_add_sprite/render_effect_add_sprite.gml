function render_effect_add_sprite(sprite, position, offset) {
    ds_queue_enqueue(Stuff.screen_icons, [sprite, position.Add(offset)]);
}