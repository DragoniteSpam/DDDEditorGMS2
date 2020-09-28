/// @param terrain
/// @param x
/// @param y
function terrain_get_color_index() {

    var terrain = argument[0];
    var xx = argument[1];
    var yy = argument[2];

    return (xx * terrain.height + yy) * 4;


}
