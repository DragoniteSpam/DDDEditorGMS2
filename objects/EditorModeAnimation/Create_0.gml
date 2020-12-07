event_inherited();

def_x = 0;
def_y = 128;
def_z = 128;
def_xto = 0;
def_yto = 0;
def_zto = 0;
def_xup = 0;
def_yup = 0;
def_zup = 1;
def_fov = 60;

x = setting_get("animation", "x", def_x);
y = setting_get("animation", "y", def_y);
z = setting_get("animation", "z", def_z);

xto = setting_get("animation", "xto", def_x);
yto = setting_get("animation", "yto", def_y);
zto = setting_get("animation", "zto", def_z);

xup = def_xup;
yup = def_yup;
zup = def_zup;

fov = setting_get("animation", "fov", def_fov);
pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

update = editor_update_animation;
render = function() {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_fullscreen: draw_editor_animation(); break;
        case view_3d: draw_animator(); draw_animator_overlay(); break;
        case view_ribbon: draw_editor_menu(); break;
    }
};
save = function() {
    Settings.animation.x = x;
    Settings.animation.y = y;
    Settings.animation.z = z;
    Settings.animation.xto = xto;
    Settings.animation.yto = yto;
    Settings.animation.zto = zto;
    Settings.animation.fov = fov;
};

ui = ui_init_animation(id);
mode_id = ModeIDs.ANIMATION;