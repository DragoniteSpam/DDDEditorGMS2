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

x = setting_get("Animation", "x", def_x);
y = setting_get("Animation", "y", def_y);
z = setting_get("Animation", "z", def_z);

xto = setting_get("Animation", "xto", def_x);
yto = setting_get("Animation", "yto", def_y);
zto = setting_get("Animation", "zto", def_z);

xup = def_xup;
yup = def_yup;
zup = def_zup;

fov = setting_get("Animation", "fov", def_fov);
pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

update = editor_update_animation;
render = editor_render_animation;
save = function() {
    setting_set("Animation", "x", x);
    setting_set("Animation", "y", y);
    setting_set("Animation", "z", z);
    setting_set("Animation", "xto", xto);
    setting_set("Animation", "yto", yto);
    setting_set("Animation", "zto", zto);
    setting_set("Animation", "fov", fov);
};

ui = ui_init_animation(id);
mode_id = ModeIDs.ANIMATION;