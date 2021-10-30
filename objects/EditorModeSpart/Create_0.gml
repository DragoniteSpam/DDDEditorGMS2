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

/// @todo nullish bug
if (Settings.spart[$ "x"] == undefined)                   Settings.spart.x = def_x;
if (Settings.spart[$ "y"] == undefined)                   Settings.spart.y = def_y;
if (Settings.spart[$ "z"] == undefined)                   Settings.spart.z = def_z;
if (Settings.spart[$ "xto"] == undefined)                 Settings.spart.xto = def_xto;
if (Settings.spart[$ "yto"] == undefined)                 Settings.spart.yto = def_yto;
if (Settings.spart[$ "zto"] == undefined)                 Settings.spart.zto = def_zto;
if (Settings.spart[$ "xup"] == undefined)                 Settings.spart.xup = def_xup;
if (Settings.spart[$ "yup"] == undefined)                 Settings.spart.yup = def_yup;
if (Settings.spart[$ "zup"] == undefined)                 Settings.spart.zup = def_zup;
if (Settings.spart[$ "fov"] == undefined)                 Settings.spart.fov = def_fov;

x = Settings.spart.x;
y = Settings.spart.y;
z = Settings.spart.z;
xto = Settings.spart.xto;
yto = Settings.spart.yto;
zto = Settings.spart.zto;
xup = Settings.spart.xup;
yup = Settings.spart.yup;
zup = Settings.spart.zup;
fov = Settings.spart.fov;

pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
direction = point_direction(x, y, xto, yto);

render = function() {
    switch (view_current) {
        case view_3d: draw_editor_spart(); break;
        case view_ribbon: draw_editor_menu(true); break;
        case view_hud: draw_editor_hud(); break;
    }
};
save = function() {
    Settings.spart.x = self.x;
    Settings.spart.y = self.y;
    Settings.spart.z = self.z;
    Settings.spart.xto = self.xto;
    Settings.spart.yto = self.yto;
    Settings.spart.zto = self.zto;
    Settings.spart.xup = self.xup;
    Settings.spart.yup = self.yup;
    Settings.spart.zup = self.zup;
    Settings.spart.fov = self.fov;
};
ui = ui_init_spart(id);
mode_id = ModeIDs.SPART;