global.dae_image_library = ds_map_create();

//Used to express what vertex format a vertex buffer requires
//Format codes are made from bitflags
#macro DOTDAE_FORMAT_P   (1 << 0)   //Position
#macro DOTDAE_FORMAT_N   (1 << 1)   //Normal
#macro DOTDAE_FORMAT_C   (1 << 2)   //Colour
#macro DOTDAE_FORMAT_T   (1 << 3)   //Texcoord
#macro DOTDAE_FORMAT_J   (1 << 4)   //Joint Index   N.B. Not implemented (2020-06-14)
#macro DOTDAE_FORMAT_W   (1 << 5)   //Joint Weight  N.B. Not implemented (2020-06-14)

//Define the position-normal-colour-texcoord vertex format
vertex_format_begin();
vertex_format_add_position_3d();                 //              12
vertex_format_add_normal();                      //            + 12
vertex_format_add_colour();                      //            +  4
vertex_format_add_texcoord();                    //            +  8
global.__dae_vformat_pnct = vertex_format_end(); //vertex size = 36

//Define the position-normal-colour-texcoord-joint-weight vertex format
vertex_format_begin();
vertex_format_add_position_3d();                   //              12
vertex_format_add_normal();                        //            + 12
vertex_format_add_colour();                        //            +  4
vertex_format_add_texcoord();                      //            +  8
vertex_format_add_colour();                        //            +  4
vertex_format_add_colour();                        //            +  4
global.__dae_vformat_pnctjw = vertex_format_end(); //vertex size = 44

#region Internal Object Enums

enum eDotDae
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    ObjectMap,
    EffectList,
    MaterialList,
    ImageList,
    GeometryList,
    VertexBufferList,
    __Size
}

enum eDotDaeImage
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    RelativePath,
    Sprite,
    Texture,
    External,
    __Size
}

enum eDotDaeSource
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    FloatArray,
    __Size
}

enum eDotDaeEffect
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    
    Parameters,
    Technique,
    
    Emission,
    EmissionImageName,
    EmissionTexture,
    
    Ambient,
    AmbientImageName,
    AmbientTexture,
    
    Diffuse,
    DiffuseImageName,
    DiffuseTexture,
    
    Specular,
    SpecularImageName,
    SpecularTexture,
    
    Shininess,
    ShininessImageName,
    ShininessTexture,
    
    Refraction,
    
    __Size
}

enum eDotDaeParameter
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    ParameterType,
    Value,
    __Size
}

enum eDotDaeMaterial
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    DisplayName,
    InstanceOf,
    __Size
}

enum eDotDaeGeometry
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    MeshArray,
    __Size
}

enum eDotDaeMesh
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    SourceArray,
    VertexBufferArray,
    __Size
}

enum eDotDaeFloatArray
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    List,
    __Size
}

enum eDotDaeInput
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    Semantic,
    Source,
    Offset,
    __Size
}

enum eDotDaeVertices
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    InputArray,
    __Size
}

enum eDotDaePolyList
{
    Name, //Must be the same as __DOTDAE_NAME_INDEX
    Type, //Must be the same as __DOTDAE_TYPE_INDEX
    Material,
    Effect,
    InputArray,
    VertexBuffer,
    PString,
    FormatCode,
    __Size
}

#endregion

#region Internal macros

//Always date your work!
#macro __DOTDAE_VERSION   "1.0.0"
#macro __DOTDAE_DATE      "2020/06/14"

#macro __DOTDAE_NAME_INDEX   0 //Common position of an object's name
#macro __DOTDAE_TYPE_INDEX   1 //Common position of an object's type

#endregion