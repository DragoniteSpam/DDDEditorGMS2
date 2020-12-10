event_inherited();

type = MeshTypes.RAW;

animations = ds_map_create();           // this should map an animation name onto an index
marker = 0;                             // this is basically a flag but for metadata

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

ds_list_add(Stuff.all_meshes, id);

preview_index = 0;

enum MeshTypes {
    RAW,
    SMF
}

enum MeshMarkers {
    PARTICLE            = 0x0001,
}