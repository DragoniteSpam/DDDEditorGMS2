/// @param Dialog

var dialog = argument0;
// no need to check that it exists because the button will be disabled if it doesn't
var selection = ui_list_selection(dialog.root.el_map_list);
var index = (selection + 1) ? selection : 0;
var map = Stuff.all_maps[| index];
var map_contents = map.contents;

var dw = 960;
var dh = 640;

var dg = dialog_create(dw, dh, "More Map Settings", undefined, undefined, dialog);
dg.map = map;

var columns = 3;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;
var spacing = 16;

var col1_x = dw * 0 / columns + spacing;
var col2_x = dw * 1 / columns + spacing;
var col3_x = dw * 2 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;
var yy_base = 64;

var el_other = create_text(col1_x, yy, "Lighting, Fog and Atmosphere", ew, eh, fa_left, ew, dg);
el_other.color = c_blue;
yy += el_other.height + spacing;

#region fog
var el_other_fog_enabled = create_checkbox(col1_x, yy, "Fog Enabled?", ew, eh, uivc_settings_map_fog_enabled, map.fog_enabled, dg);
el_other_fog_enabled.tooltip = "Whether or not vertex fog should be enabled in the map";
yy += el_other_fog_enabled.height + spacing;

var el_other_fog_start = create_input(col1_x, yy, "     Fog Start:", ew, eh, uivc_settings_map_fog_start, map.fog_start, "512?", validate_int, 1, 0xffff, 5, vx1, vy1, vx2, vy2, dg);
el_other_fog_start.tooltip = "The distance from the camera at which fog begins to become visible; this should be in game units, not tiles (I recomment assuming 32 units = 1 tile)";
dg.el_other_fog_start = el_other_fog_start;
yy += el_other_fog_start.height + spacing;

var el_other_fog_end = create_input(col1_x, yy, "     Fog End:", ew, eh, uivc_settings_map_fog_end, map.fog_end, "2048?", validate_int, 1, 0xffff, 5, vx1, vy1, vx2, vy2, dg);
el_other_fog_end.tooltip = "The distance from the camera at which fog completely obscures objects behind it; this should be in game units, not tiles (I recomment assuming 32 units = 1 tile)";
dg.el_other_fog_end = el_other_fog_end;
yy += el_other_fog_end.height + spacing;

var el_other_fog_colour = create_color_picker(col1_x, yy, "     Fog Color:", ew, eh, uivc_settings_map_fog_colour, map.fog_colour, vx1, vy1, vx2, vy2, dg);
el_other_fog_colour.tooltip = "The color of the fog; you will usually want this to be white or off-white, but sometimes it may be preferred to be some other color";
dg.el_other_fog_colour = el_other_fog_colour;
yy += el_other_fog_colour.height + spacing;
#endregion

#region lighting
var el_other_light_enabled = create_checkbox(col1_x, yy, "Lighting Enabled?", ew, eh, uivc_settings_map_light_enabled, map.light_enabled, dg);
el_other_light_enabled.tooltip = "Whether or not vertex lighting should be enabled in the map";
yy += el_other_light_enabled.height + spacing;

var el_other_light_colour = create_color_picker(col1_x, yy, "     Ambient:", ew, eh, uivc_settings_map_light_colour, map.light_ambient_colour, vx1, vy1, vx2, vy2, dg);
el_other_light_colour.tooltip = "The color of unlit regions of the map; most of the time, this should be black";
dg.el_other_light_colour = el_other_light_colour;
yy += el_other_light_colour.height + spacing;

var el_other_light_player = create_checkbox(col1_x + 16, yy, "Player Light Enabled?", ew, eh, uivc_settings_map_light_player_enabled, map.light_player_enabled, dg);
el_other_light_player.tooltip = "Whether or not there should be a point light around the player on this map";
yy += el_other_light_player.height + spacing;

var el_other_light_list = create_button(col1_x, yy, "Default Lights", ew, eh, fa_center, dialog_create_map_default_lights, dg);
el_other_light_list.tooltip = "Choose which lights will be turned on by default in this map. Up to eight lights may be active at one time.";
dg.el_other_light_list = el_other_light_list;
yy += el_other_light_list.height + spacing;
#endregion

#region atmosphere
var el_other_indoors = create_checkbox(col1_x, yy, "Is indoors?", ew, eh, uivc_settings_map_indoors, map.indoors, dg);
el_other_indoors.tooltip = "Whether or not the map is supposed to be indoors (or underground); this will have effects such as determining whether or not the atmosphere is to be drawn, or whether or not weather should be processed";
yy += el_other_indoors.height + spacing;

var el_other_water = create_checkbox(col1_x, yy, "Render water?", ew, eh, uivc_settings_map_water, map.draw_water, dg);
el_other_water.tooltip = "Whether or not water should be rendered";
yy += el_other_water.height + spacing;

var el_other_water_reflect = create_checkbox(col1_x + string_width("     "), yy, "Reflections enabled?", ew, eh, uivc_settings_map_reflections, map.reflections_enabled, dg);
el_other_water_reflect.tooltip = "Whether or not reflections will be shown; most of the time this should be turned off if you have the water level turned off, and it should probably be turned off if the map is marked as indoors, but you may choose otherwise";
yy += el_other_water_reflect.height + spacing;

var el_other_water_level = create_input(col1_x, yy, "     Water level:", ew, eh, uivc_settings_map_water_level, map.water_level, "float", validate_double, 0, map.zz - 1, 4, vx1, vy1, vx2, vy2, dg);
el_other_water_level.tooltip = "The level of the water, in tile units";
yy += el_other_water_level.height + spacing;
#endregion

yy = yy_base;

#region more atmosphere
var el_skybox_image = create_list(col2_x, yy, "Skybox", "<no skyboxes>", ew, eh, 8, uivc_settings_map_skybox, false, dg, Stuff.all_graphic_skybox);
ui_list_select(el_skybox_image, ds_list_find_index(Stuff.all_graphic_skybox, map.skybox), true);
el_skybox_image.tooltip = "The skybox to be used by the map. Deselect to clear.";
el_skybox_image.entries_are = ListEntries.INSTANCES;
yy += el_skybox_image.height + spacing;
#endregion

yy = yy_base;

#region update
var el_code_heading = create_text(col3_x, yy, "Update Ticker", ew, eh, fa_left, ew, dg);
el_code_heading.color = c_blue;
yy += el_code_heading.height + spacing;

var el_code = create_input_code(col3_x, yy, "Code:", ew, eh, vx1, vy1, vx2, vy2, map.code, uivc_map_code, dg);
el_code.tooltip = "Code which runs in each update step for the map";
yy += el_code.height + spacing;

var el_encounter_heading = create_text(col3_x, yy, "Encounter Stuff", ew, eh, fa_left, ew, dg);
el_encounter_heading.color = c_blue;
yy += el_encounter_heading.height + spacing;

var el_encounter_base = create_input(col3_x, yy, "Base Rate", ew, eh, uivc_settings_map_encounter_base, map.base_encounter_rate, "0 for off", validate_int, 0, 1000000, 7, vx1, vy1, vx2, vy2, dg);
el_encounter_base.tooltip = "The base number of steps between random encounters; if movement is set to be off-grid, this can be approximated in tiles";
yy += el_encounter_base.height + spacing;

var el_encounter_deviation = create_input(col3_x, yy, "Deviation", ew, eh, uivc_settings_map_encounter_deviation, map.base_encounter_deviation, "Probably steps", validate_int, 0, 1000000, 7, vx1, vy1, vx2, vy2, dg);
el_encounter_deviation.tooltip = "The deviation in steps between random encounters; if movement is set to be off-grid, this can be approximated in tiles";
yy += el_encounter_deviation.height + spacing;
#endregion

#region navigation
var el_nav_heading = create_text(col3_x, yy, "Navigation Settings", ew, eh, fa_left, ew, dg);
el_nav_heading.color = c_blue;
yy += el_nav_heading.height + spacing;

var el_other_fast_travel_to = create_checkbox(col3_x, yy, "Can fast travel to?", ew, eh, uivc_settings_map_fast_travel_to, map.fast_travel_to, dg);
el_other_fast_travel_to.tooltip = "Should you be able to teleport into this map?";
yy += el_other_fast_travel_to.height + spacing;

var el_other_fast_travel_from = create_checkbox(col3_x, yy, "Can fast travel from?", ew, eh, uivc_settings_map_fast_travel_from, map.fast_travel_from, dg);
el_other_fast_travel_from.tooltip = "Should you be able to teleport away from this map?";
yy += el_other_fast_travel_from.height + spacing;

var el_other_grid = create_checkbox(col3_x, yy, "Grid aligned?", ew, eh, null, map.on_grid, dg);
el_other_grid.tooltip = "This setting is currently unavailable; in the future I may enable off-grid editing";
el_other_grid.interactive = false;
yy += el_other_grid.height + spacing;
#endregion

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_other,
    el_other_grid,
    el_other_fog_enabled,
    el_other_fog_start,
    el_other_fog_end,
    el_other_fog_colour,
    el_other_light_enabled,
    el_other_light_colour,
    el_other_light_player,
    el_other_light_list,
    el_other_indoors,
    el_other_water,
    el_other_water_reflect,
    el_other_water_level,
    el_skybox_image,
    el_code_heading,
    el_code,
    el_encounter_heading,
    el_encounter_base,
    el_encounter_deviation,
    el_nav_heading,
    el_other_fast_travel_to,
    el_other_fast_travel_from,
    el_confirm
);

return dg;