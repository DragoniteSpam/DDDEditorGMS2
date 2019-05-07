event_inherited();

render=menu_render_main;
root=noone;
active_element=noone;

element_height=16;
element_width=96;

/*
 * top-level stuff
 */

var menu_file=create_menu("File", element_width, element_height, id);
var menu_edit=create_menu("Edit", element_width, element_height, id);
var menu_data=create_menu("Data", element_width, element_height, id);
var menu_help=create_menu("Help", element_width, element_height, id);
contents=ds_list_create();
ds_list_add(contents, menu_file, menu_edit, menu_data, menu_help);

/*
 * File menu
 */

var m_separator=create_menu_element("----------", null, id);

var mf_new=create_menu_element("New (Ctrl+N)", momu_new, menu_file);
var mf_save=create_menu_element("Save Map (Ctrl+S)", momu_save_map, menu_file);
var mf_save_as=create_menu_element("Save Data (Ctrl+Shift+S)", momu_save_data, menu_file);
var mf_open=create_menu_element("Open (Ctrl+O)", momu_open, menu_file);
var mf_backup=create_menu_element("View Backups", momu_backup, menu_file);
var mf_settings_map=create_menu_element("Settings - Map", momu_settings_map, menu_file);
var mf_settings_data=create_menu_element("Settings - Data", momu_settings_data, menu_file);
var mf_preferences=create_menu_element("Preferences", momu_preferences, menu_file);
var mf_exit=create_menu_element("Exit (Alt+F4)", momu_exit, menu_file);
ds_list_add(menu_file.contents, mf_new, mf_save, mf_save_as, mf_open, mf_backup,
    m_separator,
    mf_settings_map, mf_settings_data, mf_preferences,
    mf_exit);

/*
 * Edit menu
 */

var me_undo=create_menu_element("Undo (Ctrl+Z)", momu_undo, menu_edit);
var me_redo=create_menu_element("Redo (Ctrl+Y)", momu_redo, menu_edit);
var me_copy=create_menu_element("Copy (Ctrl+C)", momu_copy, menu_edit);
var me_cut=create_menu_element("Cut (Ctrl+X)", momu_cut, menu_edit);
var me_paste=create_menu_element("Paste (Ctrl+V)", momu_paste, menu_edit);
var me_select_all=create_menu_element("Select All (Ctrl+A)", momu_select_all, menu_edit);
var me_deselect=create_menu_element("Deselect (Ctrl+D)", momu_deselect, menu_edit);
ds_list_add(menu_edit.contents, me_undo, me_redo,
    m_separator,
    me_copy, me_cut, me_paste,
    m_separator,
    me_select_all, me_deselect);

/*
 * Data stuff
 */

var md_mesh=create_menu_element("Meshes (vrax)", momu_mesh, menu_data);
var md_ts=create_menu_element("Tileset", momu_tileset, menu_data);
var md_data_types=create_menu_element("Define Data Types", momu_data_types, menu_data);
var md_conflicts=create_menu_element("View Mesh Conflicts", momu_conflicts, menu_data);
var md_missing=create_menu_element("View Missing Data", momu_missing, menu_data);
var md_3d=create_menu_element("3D Editor (F6)", momu_editor_3d, menu_data);
var md_events=create_menu_element("Event Editor (F7)", momu_editor_event, menu_data);
var md_data=create_menu_element("Game Data (F8)", momu_editor_data, menu_data);
ds_list_add(menu_data.contents, md_mesh, md_ts, md_data_types,
    m_separator,
    md_conflicts, md_missing,
    m_separator,
    md_3d, md_events, md_data);

/*
 * Help stuff
 */

var mh_help=create_menu_element("Contents", momu_help, menu_help);
var mh_about=create_menu_element("Credits", momu_about, menu_help);
ds_list_add(menu_help.contents, mh_help, mh_about);

enum MenuTabs {
    FILE,
    EDIT
}

/* */
/*  */
