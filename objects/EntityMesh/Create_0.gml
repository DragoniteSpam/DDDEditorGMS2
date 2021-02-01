event_inherited();

save_script = serialize_save_entity_mesh;
load_script = serialize_load_entity_mesh;

name = "Mesh";
etype = ETypes.ENTITY_MESH;
etype_flags = ETypeFlags.ENTITY_MESH;

Stuff.map.active_map.contents.population[ETypes.ENTITY_MESH]++;

is_static = true;

mesh = NULL;
mesh_submesh = NULL;                   // proto-GUID
animated = false;
animation_index = 0;
animation_type = SMF_loop_linear;
animation_speed = 0;
animation_end_action = AnimationEndActions.LOOP;

// editor properties

slot = MapCellContents.MESH;
rotateable = true;
offsettable = true;
scalable = true;

batch = batch_mesh;
batch_collision = batch_collision_mesh;
render = render_mesh;
selector = select_single;
on_select_ui = safc_on_mesh_ui;
get_bounding_box = entity_bounds_mesh;

SetStatic = function(state) {
    // Meshes with no mesh are not allowed to be marked as static
    if (!guid_get(mesh)) return false;
    // SMF meshes are simply not allowed to be marked as static
    if (guid_get(mesh).type == MeshTypes.SMF) return false;
    
    if (state != is_static) {
        is_static = state;
        Stuff.map.active_map.contents.population_static = Stuff.map.active_map.contents.population_static + (is_static ? 1 : -1);
    }
};
/*
___________________________________________
############################################################################################
ERROR in
action number 1
of Draw Event
for object Stuff:

ds_list_find_value argument 2 incorrect type (undefined) expecting a Number (YYGI32)
 at gml_Script_anon_gml_Object_EntityMesh_Create_0_1289_gml_Object_EntityMesh_Create_0 (line 52) -     return mesh_data ? mesh_data.submeshes[| proto_guid_get(mesh_data, mesh_submesh)].buffer : undefined;
############################################################################################
gml_Script_anon_gml_Object_EntityMesh_Create_0_1289_gml_Object_EntityMesh_Create_0 (line 52)
gml_Script_batch_mesh (line 13) -     var raw = mesh.GetBuffer();
gml_Script_batch_cache (line 21) -         thing.batch(batch.vertex, batch.wire, batch.reflect_vertex, batch.reflect_wire, thing);
gml_Script_editor_cleanup_map (line 130) -         batch_cache();
gml_Object_Stuff_Draw_75 (line 7) - mode.cleanup(mode);
*/
GetBuffer = function() {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh_data = guid_get(mesh);
    if (!mesh_data) return undefined;
    if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
    return mesh_data ? mesh_data.submeshes[| proto_guid_get(mesh_data, mesh_submesh)].buffer : undefined;
};

GetVertexBuffer = function() {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh_data = guid_get(mesh);
    if (!mesh_data) return undefined;
    if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
    return mesh_data ? mesh_data.submeshes[| proto_guid_get(mesh_data, mesh_submesh)].vbuffer : undefined;
};

GetWireBuffer = function() {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh_data = guid_get(mesh);
    if (!mesh_data) return undefined;
    if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
    return mesh_data ? mesh_data.submeshes[| proto_guid_get(mesh_data, mesh_submesh)].wbuffer : undefined;
};

GetReflectBuffer = function() {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh_data = guid_get(mesh);
    if (!mesh_data) return undefined;
    if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
    return mesh_data ? mesh_data.submeshes[| proto_guid_get(mesh_data, mesh_submesh)].reflect_buffer : undefined;
};

GetReflectVertexBuffer = function() {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh_data = guid_get(mesh);
    if (!mesh_data) return undefined;
    if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
    return mesh_data ? mesh_data.submeshes[| proto_guid_get(mesh_data, mesh_submesh)].reflect_vbuffer : undefined;
};

GetReflectWireBuffer = function() {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh_data = guid_get(mesh);
    if (!mesh_data) return undefined;
    if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
    return mesh_data ? mesh_data.submeshes[| proto_guid_get(mesh_data, mesh_submesh)].reflect_wbuffer : undefined;
};

GetTexture = function() {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh_data = guid_get(mesh);
    var def_texture = Settings.view.texture ? sprite_get_texture(get_active_tileset().picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
    return (mesh_data && guid_get(mesh_data.tex_base)) ? sprite_get_texture(guid_get(mesh_data.tex_base).picture, 0) : def_texture;
};