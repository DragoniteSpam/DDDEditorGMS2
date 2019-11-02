/// @param UIButton

var button = argument0;
var terrain = Stuff.terrain;

var fn = get_open_filename_image();

if (fn != "") {
    var sprite = terrain_create_texture_sprite(fn);
    if (sprite) {
        sprite_delete(terrain.texture);
        terrain.texture = sprite;
        button.root.element_tile_selector.tileset = sprite;
        terrain.texture_name = filename_name(fn);
        terrain.texture_width = sprite_get_width(sprite);
        terrain.texture_height = sprite_get_height(sprite);
        button.root.element_texture_name.text = terrain.texture_name + " (" + string(terrain.texture_width) + " x " + string(terrain.texture_height) + ")";
    }
}