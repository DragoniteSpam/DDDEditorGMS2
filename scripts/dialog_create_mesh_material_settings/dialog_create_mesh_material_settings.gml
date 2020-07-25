/// @param Dialog
/// @param selected-meshes

var root = argument0;
var selection = argument1;
var mode = Stuff.mesh_ed;

var dw = 1200;
var dh = 840;

var dg = dialog_create(dw, dh, "Materials", dialog_default, dc_close_no_questions_asked, root);
dg.selection = selection;

var columns = 3;
var ew = dw / columns - 64;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var c1x = 0 * dw / columns + 32;
var c2x = 1 * dw / columns + 32;
var c3x = 2 * dw / columns + 32;
var spacing = 16;

var yy = 64;
var yy_base = 64;

var el_base = create_list(c1x, yy, "Base Texture", "no textures", ew, eh, 8, null, false, dg, Stuff.all_graphic_tilesets);
el_base.entries_are = ListEntries.INSTANCES;
yy += ui_get_list_height(el_base) + spacing;

var el_ambient = create_list(c1x, yy, "Ambient Map", "no textures", ew, eh, 8, null, false, dg, Stuff.all_graphic_tilesets);
el_ambient.interactive = false;
el_ambient.entries_are = ListEntries.INSTANCES;
yy += ui_get_list_height(el_ambient) + spacing;

var el_specular_color = create_list(c1x, yy, "Specular Color Map", "no textures", ew, eh, 8, null, false, dg, Stuff.all_graphic_tilesets);
el_specular_color.interactive = false;
el_specular_color.entries_are = ListEntries.INSTANCES;
yy += ui_get_list_height(el_specular_color) + spacing;

yy = yy_base;

var el_specular_highlight = create_list(c2x, yy, "Specular Highlight Map", "no textures", ew, eh, 8, null, false, dg, Stuff.all_graphic_tilesets);
el_specular_highlight.interactive = false;
el_specular_highlight.entries_are = ListEntries.INSTANCES;
yy += ui_get_list_height(el_specular_highlight) + spacing;

var el_alpha = create_list(c2x, yy, "Alpha Map", "no textures", ew, eh, 8, null, false, dg, Stuff.all_graphic_tilesets);
el_alpha.interactive = false;
el_alpha.entries_are = ListEntries.INSTANCES;
yy += ui_get_list_height(el_alpha) + spacing;

var el_bump = create_list(c2x, yy, "Bump Map", "no textures", ew, eh, 8, null, false, dg, Stuff.all_graphic_tilesets);
el_bump.interactive = false;
el_bump.entries_are = ListEntries.INSTANCES;
yy += ui_get_list_height(el_bump) + spacing;

yy = yy_base;

var el_displacement = create_list(c3x, yy, "Displacement Map", "no textures", ew, eh, 8, null, false, dg, Stuff.all_graphic_tilesets);
el_displacement.interactive = false;
el_displacement.entries_are = ListEntries.INSTANCES;
yy += ui_get_list_height(el_displacement) + spacing;

var el_stencil = create_list(c3x, yy, "Stencil Map", "no textures", ew, eh, 8, null, false, dg, Stuff.all_graphic_tilesets);
el_stencil.interactive = false;
el_stencil.entries_are = ListEntries.INSTANCES;
yy += ui_get_list_height(el_stencil) + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_base, el_ambient, el_specular_color, el_specular_highlight,
    el_alpha, el_bump, el_displacement, el_stencil,
    el_confirm
);

return dg;