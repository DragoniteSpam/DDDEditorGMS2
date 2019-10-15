/// @description smf_init()
/*
Initializes Snidrs Model Format.
Needs to be used once in the beginning of the game

Script made by TheSnidr
www.TheSnidr.com
*/
////////////////////////////////////////////////////
//---------------Format settings------------------\\
globalvar SMF_format, SMF_format_bytes;
SMF_format_bytes = 0;
vertex_format_begin();
vertex_format_add_position_3d();    SMF_format_bytes += 3 * 4;		//Adds three f32
vertex_format_add_normal();         SMF_format_bytes += 3 * 4;		//Adds three f32
vertex_format_add_texcoord();		SMF_format_bytes += 2 * 4;		//Adds two f32 - Texture coordinates
vertex_format_add_color();          SMF_format_bytes += 1 * 4;		//Adds four u8 - Tangent
vertex_format_add_color();          SMF_format_bytes += 1 * 4;		//Adds four u8 - Bone indices
vertex_format_add_color();          SMF_format_bytes += 1 * 4;		//Adds four u8 - Bone weights
SMF_format = vertex_format_end();

globalvar SMF_modelList;
SMF_modelList = ds_list_create();

/////////////////////////////////////////////////////
//----------------Model enums----------------------\\
enum SMF_model{Name,Center,Size,Material,VBuff,MBuff,Visible,MaterialIndex,TextureIndex,NodeTypeMap,NodeScale,NodeList,CollisionBuffer,OctreeBuffer,QuadtreeBuffer,BindPose,BindSampleMappingList,Animation,Compiled,CollisionList,OctreeList,LightList,AmbientColor,Static,Kind,ModelParameters}

//////////////////////////////////////////////////////
//---------------Material settings------------------\\
enum SMF_mat{Name,Type,SpecReflectance,SpecDamping,CelSteps,RimPower,RimFactor,NormalMapFactor,HeightMapMinSamples,HeightMapMaxSamples,HeightMapScale,Animate,Sample,Lights,LightNum,NormalMap,HeightMap,OutlineThickness,OutlineRed,OutlineGreen,OutlineBlue,ReflectionMap,ReflectionFactor,OutlinesEnabled,ReflectionsEnabled,NormalMapEnabled,HeightMapEnabled,Shader,MatParameters}

////////////////////////////////////////////////////////
//---------------Asynchronous loading-----------------\\
globalvar SMF_asyncLoadList, SMF_asyncHandle, SMF_asyncFileName, SMF_asyncBuffer, SMF_asyncLoadText;
SMF_asyncLoadList = ds_list_create();
SMF_asyncHandle = -1;
SMF_asyncFileName = "";
SMF_asyncBuffer = buffer_create(1, buffer_grow, 1);
SMF_asyncLoadText = "";

//////////////////////////////////////////////////////
//----------------Texture settings------------------\\
globalvar SMF_textureList, SMF_textureLookup;
SMF_textureList = ds_list_create();
SMF_textureLookup = ds_list_create();

var s = surface_create(32, 32);
surface_set_target(s);
draw_clear(c_gray);
smf_texture_add(sprite_create_from_surface(s, 0, 0, 32, 32, 0, 0, 0, 0), "TexDefault", false);
draw_clear(make_color_rgb(128, 128, 255));
smf_texture_add(sprite_create_from_surface(s, 0, 0, 32, 32, 0, 0, 0, 0), "NomDefault", false);
surface_reset_target();
surface_free(s);

/////////////////////////////////////////////////////
//---------------Animation module------------------\\
#macro SMF_loop_quadratic 0
#macro SMF_play_quadratic 1
#macro SMF_loop_linear 2
#macro SMF_play_linear 3

///////////////////////////////////////////////
//---------------Delta time------------------\\
//#macro SMF_deltaTime delta_time / game_get_speed(gamespeed_microseconds)
#macro SMF_deltaTime 30 * delta_time / 1000000

/////////////////////////////////////////////////////
//---------------Collision module------------------\\
globalvar SMF_colTriBytes;
SMF_colTriBytes = 12 * 4; //Bytes per triangle
//math_set_epsilon(0.00001);

////////////////////////////////////////////////////////
//------------------Physics settings------------------\\
globalvar SMF_gravity, SMF_gravityDir;
SMF_gravityDir = [0, 0, -1];
SMF_gravity = 1;

////////////////////////////////////////////////////
//---------------Camera settings------------------\\
smf_camera_init()

////////////////////////////////////////////////////
//---------------Lighting settings-----------------\\
globalvar SMF_ambientColor, SMF_lights, SMF_shadowmapEnabled, SMF_shadowmapSmoothing;
SMF_ambientColor = [0.4, 0.4, 0.4];
SMF_lights = [0];
SMF_shadowmapEnabled = [];
SMF_shadowmapSmoothing = 1;
enum SMF_shadowmap{size,surface,intensity,FOV,near,far,pos,lookat,vmat,pmat,vpmat,texelsize,depthbias}

///////////////////////////////////////////////////
//----------------Path settings------------------\\
globalvar SMF_pathList;
SMF_pathList = ds_list_create();
globalvar SMF_pathModel;
SMF_pathModel = vertex_create_buffer();

/////////////////////////////////////////////////
//---------------Debug format------------------\\
globalvar SMF_debugformat;
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
SMF_debugformat = vertex_format_end();

/////////////////////////////////////////////////////
//----------------Matrix constants-----------------\\
#macro SMF_MATIDENTITY matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1)
#macro SMF_XTO 0
#macro SMF_YTO 1
#macro SMF_ZTO 2
#macro SMF_WTO 3
#macro SMF_XSI 4
#macro SMF_YSI 5
#macro SMF_ZSI 6
#macro SMF_WSI 7
#macro SMF_XUP 8
#macro SMF_YUP 9
#macro SMF_ZUP 10
#macro SMF_WUP 11
#macro SMF_X 12
#macro SMF_Y 13
#macro SMF_Z 14
#macro SMF_W 15

/////////////////////////////////////////////////////
//---------------Shaders-------------------\\
smf_shaders_init();