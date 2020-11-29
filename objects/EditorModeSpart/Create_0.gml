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

if (Stuff.settings.spart[$ "x"] == undefined)                   Stuff.settings.spart.x = def_x;
if (Stuff.settings.spart[$ "y"] == undefined)                   Stuff.settings.spart.y = def_y;
if (Stuff.settings.spart[$ "z"] == undefined)                   Stuff.settings.spart.z = def_z;
if (Stuff.settings.spart[$ "xto"] == undefined)                 Stuff.settings.spart.xto = def_xto;
if (Stuff.settings.spart[$ "yto"] == undefined)                 Stuff.settings.spart.yto = def_yto;
if (Stuff.settings.spart[$ "zto"] == undefined)                 Stuff.settings.spart.zto = def_zto;
if (Stuff.settings.spart[$ "xup"] == undefined)                 Stuff.settings.spart.xup = def_xup;
if (Stuff.settings.spart[$ "yup"] == undefined)                 Stuff.settings.spart.yup = def_yup;
if (Stuff.settings.spart[$ "zup"] == undefined)                 Stuff.settings.spart.zup = def_zup;
if (Stuff.settings.spart[$ "fov"] == undefined)                 Stuff.settings.spart.fov = def_fov;

x = Stuff.settings.spart.x;
y = Stuff.settings.spart.y;
z = Stuff.settings.spart.z;
xto = Stuff.settings.spart.xto;
yto = Stuff.settings.spart.yto;
zto = Stuff.settings.spart.zto;
xup = Stuff.settings.spart.xup;
yup = Stuff.settings.spart.yup;
zup = Stuff.settings.spart.zup;
fov = Stuff.settings.spart.fov;

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
    Stuff.settings.spart.x = self.x;
    Stuff.settings.spart.y = self.y;
    Stuff.settings.spart.z = self.z;
    Stuff.settings.spart.xto = self.xto;
    Stuff.settings.spart.yto = self.yto;
    Stuff.settings.spart.zto = self.zto;
    Stuff.settings.spart.xup = self.xup;
    Stuff.settings.spart.yup = self.yup;
    Stuff.settings.spart.zup = self.zup;
    Stuff.settings.spart.fov = self.fov;
};
ui = ui_init_spart(id);
mode_id = ModeIDs.SPART;