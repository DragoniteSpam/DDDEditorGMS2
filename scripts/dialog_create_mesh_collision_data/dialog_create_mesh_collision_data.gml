function dialog_create_mesh_collision_data(mesh) {
    var valid = true;
    var ww = mesh.xmax - mesh.xmin;
    var hh = mesh.ymax - mesh.ymin;
    var dd = mesh.zmax - mesh.zmin;
    
    if (ww * hh * dd == 0) {
        emu_dialog_notice("The bounding box of " + mesh.name + " has a volume of zero; if you want to assign it collision data, please make sure it has a non-zero volume.");
        return undefined;
    }
    
    var dw = 1440;
    var dh = 800;
    
    var dg = dialog_create(dw, dh, "Mesh flag data: " + mesh.name, dialog_default, dialog_destroy, undefined);
    dg.mesh = mesh;
    dg.xx = 0;
    dg.yy = 0;
    dg.zz = 0;
    dg.stored_value = undefined;
    
    var columns = 6;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var c1 = dw * 0 / columns + spacing;
    var c2 = dw * 1 / columns + spacing;
    var c3 = dw * 2 / columns + spacing;
    var c4 = dw * 3 / columns + spacing;
    var c5 = dw * 4 / columns + spacing;
    
    var b_width = 128;
    var b_height = 32;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = yy;
    
    var color_active = c_ui_select;
    var color_inactive = c_white;
    
    #region numerical inputs and sliders
    var el_x_input = create_input(c1, yy, "X:", ew, eh, uivc_mesh_collision_cell_x, 0, "", validate_int, 0, max(mesh.xmax - mesh.xmin - 1, 0), 3, vx1, vy1, vx2, vy2, dg);
    el_x_input.value_default = string(el_x_input.value_upper);
    dg.el_x_input = el_x_input;
    
    yy += el_x_input.height + spacing;
    
    var el_x = create_progress_bar(c1, yy, ew, eh, uivc_mesh_collision_cell_x_slider, 4, 0, dg);
    dg.el_x = el_x;
    
    yy = yy_base;
    
    var el_y_input = create_input(c2, yy, "Y:", ew, eh, uivc_mesh_collision_cell_y, 0, "", validate_int, 0, max(mesh.ymax - mesh.ymin - 1, 0), 3, vx1, vy1, vx2, vy2, dg);
    el_y_input.value_default = string(el_y_input.value_upper);
    dg.el_y_input = el_y_input;
    
    yy += el_y_input.height + spacing;
    
    var el_y = create_progress_bar(c2, yy, ew, eh, uivc_mesh_collision_cell_y_slider, 4, 0, dg);
    dg.el_y = el_y;
    
    yy = yy_base;
    
    var el_z_input = create_input(c3, yy, "Z:", ew, eh, uivc_mesh_collision_cell_z, 0, "", validate_int, 0, max(mesh.zmax - mesh.zmin - 1, 0), 3, vx1, vy1, vx2, vy2, dg);
    el_z_input.value_default = string(el_z_input.value_upper);
    dg.el_z_input = el_z_input;
    
    yy += el_z_input.height + spacing;
    
    var el_z = create_progress_bar(c3, yy, ew, eh, uivc_mesh_collision_cell_z_slider, 4, 0, dg);
    dg.el_z = el_z;
    
    yy += el_z.height + spacing;
    
    var yy_base_c1 = yy;
    
    var el_alpha_text = create_text(c3, yy, "Preview Alpha", ew, eh, fa_left, ew, dg);
    
    yy += el_z_input.height + spacing;
    
    var el_alpha = create_progress_bar(c3, yy, ew, eh, null, 4, 0, dg);
    el_alpha.value = 0.5;
    dg.el_alpha = el_alpha;
    
    yy += el_z.height + spacing;
    
    var yy_base_c3 = yy;
    #endregion
    
    yy = yy_base;
    
    #region collision and asset flags
    var default_value = mesh.asset_flags[dg.xx][dg.yy][dg.zz];
    var el_collision_triggers = create_bitfield(c4, yy, "Asset and Collision Flags", ew, eh, default_value, dg);
    dg.el_collision_triggers = el_collision_triggers;
    
    var rows = 24;
    for (var i = 0; i < FLAG_COUNT; i++) {
        var label = (Game.vars.flags[i] == "") ? "<" + string(i) + ">" : Game.vars.flags[i];
        create_bitfield_options_vertical(el_collision_triggers, [create_bitfield_option_data(i, function(option, x, y) {
            option.state = option.root.value & (1 << option.value);
            ui_render_bitfield_option_text(option, x, y);
        }, function(option) {
            option.root.value ^= (1 << option.value);
            option.root.root.mesh.asset_flags[@ option.root.root.xx][@ option.root.root.yy][@ option.root.root.zz] = option.root.value;
        }, label, -1, 0, ew / 2, spacing / 2, 0, 0, color_active, color_inactive)]);
        var option = el_collision_triggers.contents[| ds_list_size(el_collision_triggers.contents) - 1];
        option.x = ew * (i div rows);
        option.y = eh * (i % rows);
    }
    
    create_bitfield_options_vertical(el_collision_triggers, [
        create_bitfield_option_data(i, function(option, x, y) {
            option.state = (option.root.value == FLAG_MAX_VALUE);
            ui_render_bitfield_option_text(option, x, y);
        }, function(option) {
            option.root.root.mesh.asset_flags[@ option.root.root.xx][@ option.root.root.yy][@ option.root.root.zz] = FLAG_MAX_VALUE;
            option.root.value = FLAG_MAX_VALUE;
        }, "All", -1, 0, ew / 2, spacing / 2, ew * (i div rows), 0, color_active, color_inactive),
        create_bitfield_option_data(i, function(option, x, y) {
            option.state = !option.root.value;
            ui_render_bitfield_option_text(option, x, y);
        }, function(option) {
            option.root.root.mesh.asset_flags[@ option.root.root.xx][@ option.root.root.yy][@ option.root.root.zz] = 0;
            option.root.value = 0;
        }, "None", -1, 0, ew / 2, spacing / 2, ew * (i div rows), 0, color_active, color_inactive),
        create_bitfield_option_data(i, function(option, x, y) {
            option.state = (option.root.value == 0xffffffff);
            ui_render_bitfield_option_text(option, x, y);
        }, function(option) {
            option.root.root.mesh.asset_flags[@ option.root.root.xx][@ option.root.root.yy][@ option.root.root.zz] = 0xffffffff;
            option.root.value = 0xffffffff;
        }, "First Half", -1, 0, ew / 2, spacing / 2, ew * (i div rows), 0, color_active, color_inactive),
        create_bitfield_option_data(i, function(option, x, y) {
            option.state = (option.root.value == 0x7fffffff00000000);
            ui_render_bitfield_option_text(option, x, y);
        }, function(option) {
            option.root.root.mesh.asset_flags[@ option.root.root.xx][@ option.root.root.yy][@ option.root.root.zz] = 0x7fffffff00000000;
            option.root.value = 0x7fffffff00000000;
        }, "Latter Half", -1, 0, ew / 2, spacing / 2, ew * (i div rows), 0, color_active, color_inactive),
    ]);
    
    el_collision_triggers.tooltip = "Each cell occupied by a mesh can have each flag data toggled on or off.\n\nShaded cells are solid, while unshaded cells are passable.";
    
    var xx = c5 + ew / 2 - 2.5 * b_width - spacing / 2;
    yy += (rows + 1) * eh + spacing;
    var el_button_apply_layer = create_button(xx, yy, "Apply to Layer", b_width, b_height, fa_center, function(button) {
        var flag_grid = button.root.mesh.asset_flags;
        for (var i = 0; i < array_length(flag_grid); i++) {
            for (var j = 0; j < array_length(flag_grid[0]); j++) {
                flag_grid[@ i][@ j][@ button.root.zz] = button.root.el_collision_triggers.value;
            }
        }
    }, dg);
    xx += b_width;
    var el_button_apply_all = create_button(xx, yy, "Apply to All", b_width, b_height, fa_center, function(button) {
        var flag_grid = button.root.mesh.asset_flags;
        for (var i = 0; i < array_length(flag_grid); i++) {
            for (var j = 0; j < array_length(flag_grid[0]); j++) {
                for (var k = 0; k < array_length(flag_grid[0][0]); k++) {
                    flag_grid[@ i][@ j][@ k] = button.root.el_collision_triggers.value;
                }
            }
        }
    }, dg);
    xx += b_width;
    var el_button_clear = create_button(xx, yy, "Clear", b_width, b_height, fa_center, function(button) {
        button.root.mesh.asset_flags[@ button.root.xx][@ button.root.yy][@ button.root.zz] = 0;
        button.root.el_collision_triggers.value = 0;
    }, dg);
    xx += b_width;
    var el_button_copy = create_button(xx, yy, "Copy", b_width, b_height, fa_center, function(button) {
        button.root.stored_value = button.root.el_collision_triggers.value;
    }, dg);
    xx += b_width;
    var el_button_paste = create_button(xx, yy, "Paste", b_width, b_height, fa_center, function(button) {
        if (button.root.stored_value != undefined) {
            button.root.mesh.asset_flags[@ button.root.xx][@ button.root.yy][@ button.root.zz] = button.root.stored_value;
            button.root.el_collision_triggers.value = button.root.stored_value;
        }
    }, dg);
    #endregion
    
    #region preview(s)
    yy = yy_base_c1;
    
    var el_render = create_render_surface(c1, yy, ew * 2 + spacing, ew * 1.5, ui_render_surface_render_mesh_collision, ui_render_surface_control_mesh_collision, c_black, dg);
    
    yy = yy_base_c3;
    
    var el_render_grid = create_render_surface(c3, yy, ew, ew, ui_render_surface_render_mesh_collision_grid, ui_render_surface_control_mesh_collision_grid, c_black, dg);
    
    yy += el_render_grid.height + spacing;
    #endregion
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_x_input,
        el_x,
        el_y_input,
        el_y,
        el_z_input,
        el_z,
        el_render,
        el_render_grid,
        el_alpha_text,
        el_alpha,
        el_collision_triggers,
        el_button_apply_layer,
        el_button_apply_all,
        el_button_clear,
        el_button_copy,
        el_button_paste,
        el_confirm
    );
    
    return dg;
}