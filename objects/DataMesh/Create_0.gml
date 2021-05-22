event_inherited();

type = MeshTypes.RAW;

animations = ds_map_create();           // this should map an animation name onto an index

submeshes = ds_list_create();
// there will only be one collision shape, defined as the first mesh
// you import; this is a good reason to make all meshes in a series
// the same shape, or almost the same shape
cshape = noone;

proto_guids = { };
proto_guid_current = 0;
first_proto_guid = NULL;

/* s */ xmin = 0;
/* s */ ymin = 0;
/* s */ zmin = 0;
/* s */ xmax = 1;
/* s */ ymax = 1;
/* s */ zmax = 1;

/* s */ asset_flags = [[[0]]];

/* s */ flags = 0;          // overrides Data.flags

tex_base = NULL;                    // map_Kd
tex_ambient = NULL;                 // map_Ka
tex_specular_color = NULL;          // map_Ls
tex_specular_highlight = NULL;      // map_Ns
tex_alpha = NULL;                   // map_d
tex_bump = NULL;                    // map_bump
tex_displacement = NULL;            // disp
tex_stencil = NULL;                 // decal

texture_scale = 1;

ds_list_add(Stuff.all_meshes, id);

enum MeshTypes {
    RAW,
    SMF
}

enum MeshFlags {
    PARTICLE            = 0x0001,
    SILHOUETTE          = 0x0002,
}

AddSubmesh = function(submesh, proto_guid) {
    var mesh = self.id;
    submesh.proto_guid = proto_guid_set(mesh, ds_list_size(mesh.submeshes), proto_guid);
    submesh.owner = mesh;
    ds_list_add(mesh.submeshes, submesh);
    return submesh;
};

AutoCalculateBounds = function() {
    xmin = infinity;
    ymin = infinity;
    zmin = infinity;
    xmax = -infinity;
    ymax = -infinity;
    zmax = -infinity;
    
    for (var i = 0; i < ds_list_size(submeshes); i++) {
        var sub = submeshes[| i];
        buffer_seek(sub.buffer, buffer_seek_start, 0);
        
        while (buffer_tell(sub.buffer) < buffer_get_size(sub.buffer)) {
            var xx = round(buffer_read(sub.buffer, buffer_f32) / TILE_WIDTH);
            var yy = round(buffer_read(sub.buffer, buffer_f32) / TILE_HEIGHT);
            var zz = round(buffer_read(sub.buffer, buffer_f32) / TILE_DEPTH);
            buffer_seek(sub.buffer, buffer_seek_relative, VERTEX_SIZE - 12);
            xmin = min(xmin, xx);
            ymin = min(ymin, yy);
            zmin = min(zmin, zz);
            xmax = max(xmax, xx);
            ymax = max(ymax, yy);
            zmax = max(zmax, zz);
        }
        
        buffer_seek(sub.buffer, buffer_seek_start, 0);
    }
    
    data_mesh_recalculate_bounds(id);
};

GenerateReflections = function() {
    for (var i = 0; i < ds_list_size(submeshes); i++) {
        submeshes[| i].GenerateReflections();
    }
};

SetNormalsZero = function() {
    for (var i = 0; i < ds_list_size(submeshes); i++) {
        submeshes[| i].SetNormalsZero();
    }
};

SetNormalsFlat = function() {
    for (var i = 0; i < ds_list_size(submeshes); i++) {
        submeshes[| i].SetNormalsFlat();
    }
};

SetNormalsSmooth = function(threshold) {
    for (var i = 0; i < ds_list_size(submeshes); i++) {
        submeshes[| i].SetNormalsSmooth(threshold);
    }
};

SwapReflections = function() {
    for (var i = 0; i < ds_list_size(submeshes); i++) {
        submeshes[| i].SwapReflections();
    }
};

Reload = function() {
    for (var i = 0; i < ds_list_size(submeshes); i++) {
        submeshes[| i].Reload();
    }
};

RemoveSubmesh = function(index) {
    proto_guid_remove(self, submeshes[| index].proto_guid);
    submeshes[| index]._destructor();
    ds_list_delete(submeshes, index);
};