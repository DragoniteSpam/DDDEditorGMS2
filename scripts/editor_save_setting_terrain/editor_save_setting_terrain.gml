/// @param EditorModeTerrain
function editor_save_setting_terrain(argument0) {

    var terrain = argument0;

    setting_set("Terrain", "x", terrain.x);
    setting_set("Terrain", "y", terrain.y);
    setting_set("Terrain", "z", terrain.z);
    setting_set("Terrain", "xto", terrain.xto);
    setting_set("Terrain", "yto", terrain.yto);
    setting_set("Terrain", "zto", terrain.zto);
    setting_set("Terrain", "fov", terrain.fov);


}
