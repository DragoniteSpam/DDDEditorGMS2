/// @param UIButton

var button = argument0;
var terrain = Stuff.terrain;

var fn = get_save_filename_image(terrain.texture_name);

if (fn != "") {
    sprite_save(terrain.texture, 0, fn);
}