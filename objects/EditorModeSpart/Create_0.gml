event_inherited();

var camera = view_get_camera(view_3d);

def_x = 0;
def_y = 512;
def_z = 128;
def_xto = 0;
def_yto = 0;
def_zto = 0;
def_xup = 0;
def_yup = 0;
def_zup = 1;
def_fov = 60;

x = setting_get("Spart", "x", def_x);
y = setting_get("Spart", "y", def_y);
z = setting_get("Spart", "z", def_z);

xto = setting_get("Spart", "xto", def_xto);
yto = setting_get("Spart", "yto", def_yto);
zto = setting_get("Spart", "zto", def_zto);

xup = def_xup;
yup = def_yup;
zup = def_zup;

fov = setting_get("Spart", "fov", def_fov);
pitch = arctan2(z, point_distance(0, 0, x, y));
direction = point_direction(x, y, 0, 0);

render = editor_render_spart;
ui = ui_init_spart(id);
mode_id = ModeIDs.SPART;