/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2
function ui_render_surface_control_mesh_collision(argument0, argument1, argument2, argument3, argument4) {

    var surface = argument0;
    var x1 = argument1;
    var y1 = argument2;
    var x2 = argument3;
    var y2 = argument4;

    var rotation_rate = 2;
    var translation_rate = 1;
    var scale_rate = 1.01;

    if (mouse_within_rectangle(x1, y1, x2, y2)) {
        // this is the same set of controls as in control_3d_preview
        if (keyboard_check(vk_shift)) {
            if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
                Stuff.mesh_z = Stuff.mesh_z - translation_rate;
            }
            if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
                Stuff.mesh_z = Stuff.mesh_z + translation_rate;
            }
            if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
                Stuff.mesh_zrot = Stuff.mesh_zrot - rotation_rate;
            }
            if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
                Stuff.mesh_zrot = Stuff.mesh_zrot + rotation_rate;
            }
        } else if (keyboard_check(vk_control)) {
            if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
                Stuff.mesh_yrot = Stuff.mesh_yrot - translation_rate;
            }
            if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
                Stuff.mesh_yrot = Stuff.mesh_yrot + translation_rate;
            }
            if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
                Stuff.mesh_xrot = Stuff.mesh_xrot - rotation_rate;
            }
            if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
                Stuff.mesh_xrot = Stuff.mesh_xrot + rotation_rate;
            }
        } else if (keyboard_check(vk_alt)) {
            if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
                Stuff.mesh_scale = min(Stuff.mesh_scale * scale_rate, 10);
            }
            if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
                Stuff.mesh_scale = max(Stuff.mesh_scale / scale_rate, 0.1);
            }
        } else {
            if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
                Stuff.mesh_y = Stuff.mesh_y - translation_rate;
            }
            if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
                Stuff.mesh_y = Stuff.mesh_y + translation_rate;
            }
            if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
                Stuff.mesh_x = Stuff.mesh_x - translation_rate;
            }
            if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
                Stuff.mesh_x = Stuff.mesh_x + translation_rate;
            }
        }
    
        if (keyboard_check(vk_backspace) || keyboard_check(vk_delete)) {
            Stuff.mesh_x = 0;
            Stuff.mesh_y = 0;
            Stuff.mesh_z = 0;
            Stuff.mesh_xrot = 0;
            Stuff.mesh_yrot = 0;
            Stuff.mesh_zrot = 0;
            Stuff.mesh_scale = 1;
        }
    }


}
