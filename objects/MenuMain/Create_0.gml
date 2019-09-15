event_inherited();

render = menu_render_main;
root = noone;
active_element = noone;
extra_element = noone;

element_height = 16;
element_width = 96;

/*
 * top-level stuff
 */

var menu_file = create_menu("File", element_width, element_height, id);
var menu_edit = create_menu("Edit", element_width, element_height, id);
var menu_data = create_menu("Data", element_width, element_height, id);
var menu_help = create_menu("Help", element_width, element_height, id);
contents = ds_list_create();
ds_list_add(contents, menu_file, menu_edit, menu_data, menu_help);

/*
 * File menu
 */

var m_separator = create_menu_element("----------", null, id);

var mf_new = create_menu_element("New (Ctrl+N)", momu_new, menu_file);
var mf_save_data = create_menu_element("Save Data (Ctrl+S)", momu_save_data, menu_file);
var mf_save_assets = create_menu_element("Save Assets (Ctrl+Shift+S)", momu_save_assets, menu_file);
var mf_open = create_menu_element("Open (Ctrl+O)", momu_open, menu_file);
var mf_backup = create_menu_element("View Backups", momu_backup, menu_file);
var mf_settings_map = create_menu_element("Settings - Map", momu_settings_map, menu_file);
var mf_settings_data = create_menu_element("Settings - Data", momu_settings_data, menu_file);
var mf_preferences = create_menu_element("Preferences", momu_preferences, menu_file);
var mf_exit = create_menu_element("Exit (Alt+F4)", momu_exit, menu_file);
ds_list_add(menu_file.contents, mf_new, mf_save_data, mf_save_assets, mf_open, mf_backup,
    m_separator,
    mf_settings_map, mf_settings_data, mf_preferences,
    mf_exit);

/*
 * Edit menu
 */

var me_undo = create_menu_element("Undo (Ctrl+Z)", momu_undo, menu_edit);
var me_redo = create_menu_element("Redo (Ctrl+Y)", momu_redo, menu_edit);
var me_cut = create_menu_element("Cut (Ctrl+X)", momu_cut, menu_edit);
var me_copy = create_menu_element("Copy (Ctrl+C)", momu_copy, menu_edit);
var me_paste = create_menu_element("Paste (Ctrl+V)", momu_paste, menu_edit);
var me_select_all =create_menu_element("Select All (Ctrl+A)", momu_select_all, menu_edit);
var me_deselect = create_menu_element("Deselect (Ctrl+D)", momu_deselect, menu_edit);
ds_list_add(menu_edit.contents, me_undo, me_redo,
    m_separator,
    me_cut, me_copy, me_paste,
    m_separator,
    me_select_all, me_deselect);

/*
 * Data stuff
 */

var md_mesh_autotiles = create_menu_element("Autotile Meshes", momu_mesh_autotile, menu_data);
var md_ts = create_menu_element("Tileset", momu_tileset, menu_data);
var md_audio = create_menu_element("Audio", momu_expand, menu_data);
	var md_aud_bgm = create_menu_element("Background Music (BGM)", momu_bgm, md_audio);
	var md_aud_se = create_menu_element("Sound Effects (SE)", momu_se, md_audio);
	ds_list_add(md_audio.contents, md_aud_bgm, md_aud_se);
var md_data_types = create_menu_element("Define Data Types", momu_data_types, menu_data);
var md_conflicts = create_menu_element("View Mesh Conflicts", momu_conflicts, menu_data);
var md_missing = create_menu_element("View Missing Data", momu_missing, menu_data);
var md_3d = create_menu_element("3D Editor (F6)", momu_editor_3d, menu_data);
var md_events = create_menu_element("Event Editor (F7)", momu_editor_event, menu_data);
var md_data = create_menu_element("Game Data (F8)", momu_editor_data, menu_data);
var md_animation = create_menu_element("Animations (F9)", momu_editor_animation, menu_data);
ds_list_add(menu_data.contents, md_mesh_autotiles, md_ts, md_audio, md_data_types,
    m_separator,
    md_conflicts, md_missing,
    m_separator,
    md_3d, md_events, md_data, md_animation);

/*
 * Help stuff
 */

var mh_help = create_menu_element("Contents", momu_help, menu_help);
var mh_about = create_menu_element("Credits", momu_about, menu_help);
ds_list_add(menu_help.contents, mh_help, mh_about);

/*
 *
 */

menu_right_click = create_menu("right-click", element_width, element_height, id, true);
var mrc_player = create_menu_element("Set Player Start", momu_set_starting_position, menu_right_click);
var mrc_fill = create_menu_element("Fill", momu_expand, menu_right_click);
	var mrc_fill_tile = create_menu_element("Tile", null, mrc_fill);
	var mrc_fill_autotile = create_menu_element("Autotile", null, mrc_fill);
	var mrc_fill_mesh = create_menu_element("Mesh", null, mrc_fill);
	var mrc_fill_pawn = create_menu_element("Pawn", null, mrc_fill);
	var mrc_fill_effect = create_menu_element("Effect", null, mrc_fill);
	var mrc_fill_terrain = create_menu_element("Terrain", null, mrc_fill);
	ds_list_add(mrc_fill.contents, mrc_fill_tile, mrc_fill_autotile, mrc_fill_mesh, mrc_fill_pawn,
		mrc_fill_effect, mrc_fill_terrain);
var mrc_delete = create_menu_element("Delete", null, menu_right_click);
var mrc_cut = create_menu_element("Cut", momu_cut, menu_right_click);
var mrc_copy = create_menu_element("Copy", momu_copy, menu_right_click);
var mrc_paste = create_menu_element("Paste", momu_paste, menu_right_click);
var mrc_prefab = create_menu_element("Save as Prefrab", null, menu_right_click);
ds_list_add(menu_right_click.contents, mrc_player,
	m_separator,
	mrc_fill, mrc_delete,
	m_separator,
	mrc_cut, mrc_copy, mrc_paste,
	m_separator,
	mrc_prefab);