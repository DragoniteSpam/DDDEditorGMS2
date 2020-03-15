/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2

var surface = argument0;
var x1 = argument1;
var y1 = argument2;
var x2 = argument3;
var y2 = argument4;
var mesh = surface.root.mesh;

var str_translation_rate = surface.root.el_settings_trans_rate.value;
var str_rotation_rate = surface.root.el_settings_rot_rate.value;
var str_scale_rate = surface.root.el_settings_scale_rate.value;

var translation_rate = (validate_double(str_translation_rate) ? real(str_translation_rate) : 2) * Stuff.dt;
var rotation_rate = (validate_double(str_rotation_rate) ? real(str_rotation_rate) : 360) * Stuff.dt;
var scale_rate = (validate_double(str_scale_rate) ? real(str_scale_rate) : 1) * Stuff.dt;

if (mouse_within_rectangle_view(x1, y1, x2, y2)) {
    // this is the same set of controls as in control_3d_preview
    if (keyboard_check(vk_shift)) {
        if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
            Stuff.mesh_z = Stuff.mesh_z - translation_rate * TILE_DEPTH;
            ui_input_set_value(surface.root.el_control_z, string(Stuff.mesh_z));
        }
        if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
            Stuff.mesh_z = Stuff.mesh_z + translation_rate * TILE_DEPTH;
            ui_input_set_value(surface.root.el_control_z, string(Stuff.mesh_z));
        }
        if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
            Stuff.mesh_zrot = (Stuff.mesh_zrot - rotation_rate + 360) % 360
            ui_input_set_value(surface.root.el_control_rot_z, string(Stuff.mesh_zrot));
        }
        if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
            Stuff.mesh_zrot = (Stuff.mesh_zrot + rotation_rate) % 360;
            ui_input_set_value(surface.root.el_control_rot_z, string(Stuff.mesh_zrot));
        }
    } else if (keyboard_check(vk_control)) {
        if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
            Stuff.mesh_yrot = (Stuff.mesh_yrot - rotation_rate + 360) % 360;
            ui_input_set_value(surface.root.el_control_rot_y, string(Stuff.mesh_yrot));
        }
        if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
            Stuff.mesh_yrot = (Stuff.mesh_yrot + rotation_rate) % 360;
            ui_input_set_value(surface.root.el_control_rot_y, string(Stuff.mesh_yrot));
        }
        if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
            Stuff.mesh_xrot = (Stuff.mesh_xrot - rotation_rate + 360) % 360;
            ui_input_set_value(surface.root.el_control_rot_x, string(Stuff.mesh_xrot));
        }
        if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
            Stuff.mesh_xrot = (Stuff.mesh_xrot + rotation_rate) % 360;
            ui_input_set_value(surface.root.el_control_rot_x, string(Stuff.mesh_xrot));
        }
    } else if (keyboard_check(vk_alt)) {
        if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
            Stuff.mesh_scale = min(Stuff.mesh_scale + scale_rate, 10);
            ui_input_set_value(surface.root.el_control_scale, string(Stuff.mesh_scale));
        }
        if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
            Stuff.mesh_scale = max(Stuff.mesh_scale - scale_rate, 0.1);
            ui_input_set_value(surface.root.el_control_scale, string(Stuff.mesh_scale));
        }
    } else {
        if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
            Stuff.mesh_y = Stuff.mesh_y - translation_rate * TILE_HEIGHT;
            ui_input_set_value(surface.root.el_control_y, string(Stuff.mesh_y));
        }
        if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
            Stuff.mesh_y = Stuff.mesh_y + translation_rate * TILE_HEIGHT;
            ui_input_set_value(surface.root.el_control_y, string(Stuff.mesh_y));
        }
        if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
            Stuff.mesh_x = Stuff.mesh_x - translation_rate * TILE_WIDTH;
            ui_input_set_value(surface.root.el_control_x, string(Stuff.mesh_x));
        }
        if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
            Stuff.mesh_x = Stuff.mesh_x + translation_rate * TILE_WIDTH;
            ui_input_set_value(surface.root.el_control_x, string(Stuff.mesh_x));
        }
    }
    
    if (keyboard_check(vk_backspace) || keyboard_check(vk_delete)) {
        script_execute(surface.root.el_controls_reset.onmouseup, surface.root.el_controls_reset);
    }
    
    if (keyboard_check_pressed(vk_tab)) {
        var length = ds_list_size(mesh.submeshes);
        if (keyboard_check(vk_shift)) {
            mesh.preview_index = (--mesh.preview_index + length) % length;
            ui_input_set_value(surface.root.el_controls_index, string(mesh.preview_index));
            var bsize = buffer_get_size(mesh.submeshes[| mesh.preview_index].buffer);
            surface.root.el_stats_kb.text = "    Size: " + string_comma(bsize) + " bytes";
            surface.root.el_stats_vertices.text = "    Vertices: " + string(bsize / Stuff.graphics.format_size);
            surface.root.el_stats_triangles.text = "    Triangles: " + string(bsize / Stuff.graphics.format_size / 3);
        } else {
            mesh.preview_index = ++mesh.preview_index % length;
            ui_input_set_value(surface.root.el_controls_index, string(mesh.preview_index));
            var bsize = buffer_get_size(mesh.submeshes[| mesh.preview_index].buffer);
            surface.root.el_stats_kb.text = "    Size: " + string_comma(bsize) + " bytes";
            surface.root.el_stats_vertices.text = "    Vertices: " + string(bsize / Stuff.graphics.format_size);
            surface.root.el_stats_triangles.text = "    Triangles: " + string(bsize / Stuff.graphics.format_size / 3);
        }
    }
}