function get_active_tileset() {
    var ts = guid_get(Stuff.map.active_map.tileset);
    if (ts) return ts;
    return Game.graphics.tilesets[0];
}