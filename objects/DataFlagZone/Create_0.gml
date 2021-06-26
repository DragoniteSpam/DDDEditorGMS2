event_inherited();

var map = Stuff.map.active_map;
var map_contents = map.contents;

Export = function(buffer) {
    self.ExportBase(buffer);
    buffer_write(buffer, buffer_u32, self.zone_flags);
};

zone_edit_script = function(root) {
    var zone = Stuff.map.selected_zone;
    var map = Stuff.map.active_map;
    
    var dw = 960;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, "Flag Zone Settings: " + zone.name, dialog_default, dialog_destroy, root);
    
    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = dw * 0 / columns + spacing;
    var col2_x = dw * 1 / columns + spacing;
    var col3_x = dw * 2 / columns + spacing;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    
    var el_name = create_input(col1_x, yy, "Name", ew, eh, uivc_input_map_zone_name, zone.name, "name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name.tooltip = "A name; this is for identification (and possibly debugging) purposes and has no influence on gameplay";
    yy += el_name.height + spacing;
    
    var yy_base = yy;
    
    var el_bounds_text = create_text(col1_x, yy, "Bounds", ew, eh, fa_left, ew, dg);
    el_bounds_text.color = c_blue;
    
    yy += el_bounds_text.height + spacing;
    
    var bounds_x_help = "0..." + string(map.xx);
    var bounds_y_help = "0..." + string(map.yy);
    var bounds_z_help = "0..." + string(map.zz);
    
    var el_bounds_x1 = create_input(col1_x, yy, "X1:", ew, eh, uivc_input_map_zone_x1, zone.x1, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_x1.tooltip = "The starting X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_x1.height + spacing;
    
    var el_bounds_y1 = create_input(col1_x, yy, "Y1:", ew, eh, uivc_input_map_zone_y1, zone.y1, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_y1.tooltip = "The starting Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_y1.height + spacing;
    
    var el_bounds_z1 = create_input(col1_x, yy, "Z1:", ew, eh, uivc_input_map_zone_z1, zone.z1, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_z1.tooltip = "The starting Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_z1.height + spacing;
    
    var el_bounds_x2 = create_input(col1_x, yy, "X2:", ew, eh, uivc_input_map_zone_x2, zone.x2, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_x2.tooltip = "The ending X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_x2.height + spacing;
    
    var el_bounds_y2 = create_input(col1_x, yy, "Y2:", ew, eh, uivc_input_map_zone_y2, zone.y2, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_y2.tooltip = "The ending Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_y2.height + spacing;
    
    var el_bounds_z2 = create_input(col1_x, yy, "Z2:", ew, eh, uivc_input_map_zone_z2, zone.z2, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_z2.tooltip = "The ending Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_z2.height + spacing;
    
    var el_priority = create_input(col1_x, yy, "Priority:", ew, eh, uivc_input_map_zone_priority, zone.zone_priority, "int", validate_int, 0, 1000, 3, vx1, vy1, vx2, vy2, dg);
    el_priority.tooltip = "If multiple camera zones overlap, the one with the highest priority will be the one that is acted upon";
    yy += el_priority.height + spacing;
    
    yy = yy_base;
    
    var color_active = c_ui_select;
    var color_inactive = c_white;
    
    var el_asset_flags = create_bitfield(col2_x, yy, "Asset Flags", ew, eh, 0, dg);
    el_asset_flags.onvaluechange = function(bitfield) {
        Stuff.map.selected_zone.zone_flags = bitfield.value;
    };
    el_asset_flags.value = zone.zone_flags;
    
    // todo all flags, not just the first 32 bits
    for (var i = 0; i < 32; i++) {
        var field_xx = (i >= 16) ? ew : 0;
        // Each element will be positioned based on the one directly above it, so you
        // only need to move them up once otherwise they'll keep moving up the screen
        var field_yy = (i == 16) ? -(eh * 16) : 0;
        var label = (i >= array_length(Game.vars.flags)) ? "<" + string(i) + ">" : Game.vars.flags[i];
        create_bitfield_options_vertical(el_asset_flags, [create_bitfield_option_data(i, function(bitfield, x, y) {
            bitfield.state = bitfield.root.value & (1 << bitfield.value);
            ui_render_bitfield_option_text(bitfield, xx, yy);
        }, function(bitfield) {
            var base = bitfield.root;
            base.value = base.value ^ (1 << bitfield.value);
            base.onvaluechange(base);
        }, label, -1, 0, ew / 2, spacing / 2, field_xx, field_yy, color_active, color_inactive)]);
    }
    
    create_bitfield_options_vertical(el_asset_flags, [
        create_bitfield_option_data(32, function(bitfield, x, y) {
            bitfield.state = (base.value == 0xffffffff);
            ui_render_bitfield_option_text(bitfield.root, x, y);
        }, function(bitfield) {
            var base = bitfield.root;
            base.value = 0xffffffff;
            base.onvaluechange(base);
        }, "All", -1, 0, ew / 2, spacing / 2, 0, 0, color_active, color_inactive),
        create_bitfield_option_data(33, function(bitfield, x, y) {
            bitfield.state = (bitfield.root.value == 0);
            ui_render_bitfield_option_text(bitfield, x, y);
        }, function(bitfield) {
            var base = bitfield.root;
            base.value = 0;
            base.onvaluechange(base);
        }, "None", -1, 0, ew / 2, spacing / 2, ew, -eh, color_active, color_inactive),
    ]);
    
    el_asset_flags.tooltip = "Misc. flags which you may enable or disable. You can define asset flags in Global Game Settings.";
    
    var b_width = 128;
    var b_height = 32;
    var el_commit = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_name,
        el_bounds_text,
        el_bounds_x1,
        el_bounds_y1,
        el_bounds_z1,
        el_bounds_x2,
        el_bounds_y2,
        el_bounds_z2,
        el_priority,
        el_asset_flags,
        el_commit
    );
    
    return dg;
};
editor_color = c_green;

/* s */ name = "FlagZone " + name;
/* s */ ztype = MapZoneTypes.FLAG;

zone_flags = 0;

LoadJSONZoneFlags = function(source) {
    self.LoadJSONZone(source);
};

LoadJSON = function(source) {
    self.LoadJSONZoneFlags(source);
};

CreateJSONZoneFlags = function() {
    var json = self.CreateJSONZone();
    json.flags = {
        flag: self.zone_flags,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONZoneFlags();
};