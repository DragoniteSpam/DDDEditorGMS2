function tileset_create(filename, name = undefined) {
    // these are expensive, so if you've already got the same image loaded into
    // the editor, just return a reference to that instead
    var file_hash = "";
    if (file_exists(filename)) {
        file_hash = md5_file(filename);
        for (var i = 0; i < array_length(Game.graphics.tilesets); i++) {
            var ts = Game.graphics.tilesets[i];
            if (ts.hash == file_hash) {
                return ts;
            }
        }
    }
    
    // don't instantiate these outside of this script (or the project loading script)
    var ts = new DataImageTileset();
    ts.Import(filename);
    if (name != undefined) ts.name = name;
    array_push(Game.graphics.tilesets, ts);
    return ts;
}