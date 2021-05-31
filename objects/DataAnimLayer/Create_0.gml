name = "Layer 0";
is_actor = false;

// list of Keyframes - the game would prefer this to be a priority queue
// but we need to randomly access them so they're not
keyframes = ds_list_create();

// base values

xx = 0;
yy = 0;
zz = 0;
xrot = 0;
yrot = 0;
zrot = 0;
xscale = 1;
yscale = 1;
zscale = 1;

color = c_white;
alpha = 1;

graphic_type = GraphicTypes.NO_CHANGE;
// becuase i'm a dumbass
graphic_sprite = noone;
graphic_mesh = noone;
graphic_frame = 1;

CreateJSONAnimLayer = function() {
    var json = { };
    json.is_actor = self.is_actor;
    json.xx = self.xx;
    json.yy = self.yy;
    json.zz = self.zz;
    json.xrot = self.xrot;
    json.yrot = self.yrot;
    json.zrot = self.zrot;
    json.xscale = self.xscale;
    json.yscale = self.yscale;
    json.zscale = self.zscale;
    json.color = self.color;
    json.alpha = self.alpha;
    json.graphic_type = self.graphic_type;
    json.graphic_sprite = self.graphic_sprite;
    json.graphic_mesh = self.graphic_mesh;
    json.graphic_frame = self.graphic_frame;
    json.keyframes = array_create(ds_list_size(self.keyframes), undefined);
    for (var i = 0, n = ds_list_size(self.keyframes); i < n; i++) {
        if (self.keyframes[| i]) {
            json.keyframes[i] = self.keyframes[| i].CreateJSON();
        }
    }
    return json;
};

CreateJSON = function() {
    return self.CreateJSONAnimLayer();
};

enum GraphicTypes {
    NONE,
    NO_CHANGE,
    SPRITE,
    MESH
}