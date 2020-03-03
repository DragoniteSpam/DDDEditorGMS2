/// @param Dialog

var dialog = argument0;

var dw = 400;
var dh = 320;

var dg = dialog_create(dw, dh, "New Terrain", dialog_default, dc_default, dialog);

var columns = 1;
var ew = (dw - 64) / columns;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;
var spacing = 16;

var col1_x = 32;

var el_width = create_input(
    col1_x, yy, "Width:", ew, eh, null, string(DEFAULT_TERRAIN_WIDTH), string(MIN_TERRAIN_WIDTH) + "..." + string(MAX_TERRAIN_WIDTH),
    validate_int, MIN_TERRAIN_WIDTH, MAX_TERRAIN_WIDTH, log10(MAX_TERRAIN_WIDTH) + 1, vx1, vy1, vx2, vy2, dg
);
el_width.tooltip = "Height of the terrain";
dg.el_width = el_width;

yy += el_width.height + spacing;

var el_height = create_input(
    col1_x, yy, "Height:", ew, eh, null,  string(DEFAULT_TERRAIN_HEIGHT), string(MIN_TERRAIN_HEIGHT) + "..." + string(MAX_TERRAIN_HEIGHT),
    validate_int, MIN_TERRAIN_HEIGHT, MAX_TERRAIN_HEIGHT, log10(MAX_TERRAIN_HEIGHT) + 1, vx1, vy1, vx2, vy2, dg
);
el_height.tooltip = "Height of the terrain";
dg.el_height = el_height;

yy += el_height.height + spacing;

var el_dual_layer = create_checkbox(col1_x, yy, "Dual layer?", ew, eh, null, false, dg);
el_dual_layer.tooltip = "Enable the secondary texture layer for the terrain";
el_dual_layer.enabled = false;
dg.el_dual_layer = el_dual_layer;

yy += el_dual_layer.height + spacing;

var el_scale = create_input(col1_x, yy, "Heightmap Scale:", ew, eh, null, "10", "1...255", validate_int, 1, 255, 3, vx1, vy1, vx2, vy2, dg);
el_scale.tooltip = "The brightest point on the heightmap will correspond to this value (in most cases a value of 10 or 16 will be sufficient). This is only useful when importing a heightmap.";
dg.el_scale = el_scale;

yy += el_height.height + spacing;

var el_import_heightmap = create_button(dw / 2 - ew / 2, dh - 32 - b_height - eh / 2 - spacing, "Import Heightmap", ew, b_height, fa_center, dmu_terrain_import_heightmap, dg);
el_import_heightmap.tooltip = "Import a grayscale image to use to create terrain. Darker values will be lower, and lighter values will be higher.";

var el_confirm = create_button(dw * 2 / 7 - b_width / 2, dh - 32 - b_height / 2, "Create", b_width, b_height, fa_center, dmu_dialog_commit_terrain_create, dg);
var el_never_mind = create_button(dw * 5 / 7 - b_width / 2, dh - 32 - b_height / 2, "Cancel", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_width, el_height, el_dual_layer, el_scale,
    el_import_heightmap, el_confirm, el_never_mind
);

return dg;