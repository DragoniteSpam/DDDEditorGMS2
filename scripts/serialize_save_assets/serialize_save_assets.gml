/// @param filename

var fn = argument0;

if (string_length(fn) > 0) {
    Stuff.save_name = string_replace(filename_name(fn), EXPORT_EXTENSION_ASSETS, "");
    serialize_backup(PATH_BACKUP, Stuff.save_name, EXPORT_EXTENSION_ASSETS, fn);
    game_auto_title();
    
    var buffer = buffer_create(65536, buffer_grow, 1);
    
    #region header and index
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
    buffer_write(buffer, buffer_u8, SERIALIZE_ASSETS);
    buffer_write(buffer, buffer_u32, 0);
    
    // lol
    var index_addr_content = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var index_addr_autotiles = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_tilesets = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_battlers = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_overworlds = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_particles = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_ui = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_etc = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_bgm = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_se = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_meshes = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    #endregion
    
    buffer_poke(buffer, index_addr_content, buffer_u64, buffer_tell(buffer));
    
    #region data
    var addr_autotiles =            serialize_save_image_autotiles(buffer);
    var addr_tilesets =             serialize_save_image_tilesets(buffer);
    var addr_battlers =             serialize_save_image_battlers(buffer);
    var addr_overworlds =           serialize_save_image_overworlds(buffer);
    var addr_particles =            serialize_save_image_particles(buffer);
    var addr_ui =                   serialize_save_image_ui(buffer);
    var addr_etc =                  serialize_save_image_etc(buffer);
    var addr_bgm =                  serialize_save_bgm(buffer);
    var addr_se =                   serialize_save_se(buffer);
    var addr_meshes =               serialize_save_meshes(buffer);
    #endregion
    
    #region addresses
    buffer_poke(buffer, index_addr_autotiles, buffer_u64, addr_autotiles);
    buffer_poke(buffer, index_addr_tilesets, buffer_u64, addr_tilesets);
    buffer_poke(buffer, index_addr_battlers, buffer_u64, addr_battlers);
    buffer_poke(buffer, index_addr_overworlds, buffer_u64, addr_overworlds);
    buffer_poke(buffer, index_addr_particles, buffer_u64, addr_particles);
    buffer_poke(buffer, index_addr_ui, buffer_u64, addr_ui);
    buffer_poke(buffer, index_addr_etc, buffer_u64, addr_etc);
    buffer_poke(buffer, index_addr_bgm, buffer_u64, addr_bgm);
    buffer_poke(buffer, index_addr_se, buffer_u64, addr_se);
    buffer_poke(buffer, index_addr_meshes, buffer_u64, addr_meshes);
    #endregion
    
    buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);
    
    var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
    buffer_save(compressed, fn);
    //buffer_save(buffer, fn);
    var proj_name = filename_change_ext(filename_name(fn), "");
	setting_project_add(proj_name);
    setting_project_create_local(proj_name, compressed, undefined);
    
    buffer_delete(compressed);
    buffer_delete(buffer);
}