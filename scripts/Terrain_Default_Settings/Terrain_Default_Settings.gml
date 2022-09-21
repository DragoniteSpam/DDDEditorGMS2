#macro DEFAULT_TERRAIN_HEIGHT               256
#macro DEFAULT_TERRAIN_WIDTH                256
#macro MAX_TERRAIN_HEIGHT                   5400                                // there's a hard limit on 16384 for these since the texture painting surface cant
#macro MAX_TERRAIN_WIDTH                    5400                                // be larger than that, but in reality you'll run into problems long before that
#macro MIN_TERRAIN_HEIGHT                   16                                  // (a 16384*16384 terrain would consume 19 GB of RAM... for the base vertex buffer alone)
#macro MIN_TERRAIN_WIDTH                    16                                  // anyway gamemaker has a hard limit of 2^31 bytes in a data buffer for now anyway

#macro TERRAIN_DEF_COLOR_SCALE                      8

#macro TERRAIN_DEF_GEN_NOISE_SCALE                  0.5
#macro TERRAIN_DEF_GEN_NOISE_SMOOTHNESS             0.5
#macro TERRAIN_DEF_HEIGHTMAP_SCALE                  0.5
#macro TERRAIN_DEF_EXPORT_SCALE                     1
#macro TERRAIN_DEF_EXPORT_ALL                       true
#macro TERRAIN_DEF_EXPORT_SWAP_UVS                  false
#macro TERRAIN_DEF_EXPORT_SWAP_ZUP                  false
#macro TERRAIN_DEF_EXPORT_CENTERED                  false
#macro TERRAIN_DEF_EXPORT_CHUNK_SIZE                64
#macro TERRAIN_DEF_EXPORT_SMOOTH                    false
#macro TERRAIN_DEF_EXPORT_SMOOTH_THRESHOLD          60
#macro TERRAIN_DEF_EXPORT_LOD_LEVELS                2
#macro TERRAIN_DEF_EXPORT_LOD_REDUCTION             4
#macro TERRAIN_DEF_EXPORT_VERTEX_FORMAT             VertexFormatData.STANDARD

#macro TERRAIN_DEF_VIEW_WATER                       true
#macro TERRAIN_DEF_WATER_MIN_ALPHA                  0.5
#macro TERRAIN_DEF_WATER_MAX_ALPHA                  0.9
#macro TERRAIN_DEF_WATER_LEVEL                      -0.2
#macro TERRAIN_DEF_VIEW_DISTANCE                    1200
#macro TERRAIN_DEF_WIREFRAME_ALPHA                  0.5
#macro TERRAIN_DEF_CURSOR_ALPHA                     0.5
#macro TERRAIN_DEF_VIEW_SKYBOX                      true
#macro TERRAIN_DEF_VIEW_AXES                        true
#macro TERRAIN_DEF_VIEW_DATA                        TerrainViewData.DIFFUSE
#macro TERRAIN_DEF_ORTHOGRAPHIC                     false
#macro TERRAIN_DEF_LIGHT_ENABLED                    true
#macro TERRAIN_DEF_FOG_ENABLED                      true
#macro TERRAIN_DEF_FOG_COLOR                        c_white
#macro TERRAIN_DEF_FOG_START                        1000
#macro TERRAIN_DEF_FOG_END                          8000
#macro TERRAIN_DEF_GRADIENT                         0

#macro TERRAIN_DEF_VIEW_DISTANCE_ORTHO_MIN          1.5
#macro TERRAIN_DEF_VIEW_DISTANCE_ORTHO_MAX          2.5
#macro TERRAIN_DEF_VIEW_DISTANCE_PERSPECTIVE_MIN    640
#macro TERRAIN_DEF_VIEW_DISTANCE_PERSPECTIVE_MAX    2800

#macro TERRAIN_DEF_HIGHLIGHT_UPWARDS_SURFACES       false
#macro TERRAIN_DEF_HIGHLIGHT_UPWARDS_ANGLE          15

#macro TERRAIN_DEF_LIGHT_AMBIENT_COLOUR             0x5a5a5a
#macro TERRAIN_DEF_LIGHT_PRIMARY_ANGLE              255
#macro TERRAIN_DEF_LIGHT_PRIMARY_STRENGTH           0.6
#macro TERRAIN_DEF_LIGHT_SECONDARY_ANGLE            345
#macro TERRAIN_DEF_LIGHT_SECONDARY_STRENGTH         0.2
#macro TERRAIN_DEF_LIGHT_SHADOWS                    false
#macro TERRAIN_DEF_LIGHT_SHADOWS_QUALITY            2048
#macro TERRAIN_DEF_LIGHT_DIRECTION                  (new Vector3(0.5, 0, -0.5))

#macro TERRAIN_DEF_MODE                             TerrainModes.Z

#macro TERRAIN_DEF_HEIGHT_BRUSH_MIN                 1.5
#macro TERRAIN_DEF_HEIGHT_BRUSH_MAX                 160
#macro TERRAIN_DEF_HEIGHT_RATE_MIN                  0.05
#macro TERRAIN_DEF_HEIGHT_RATE_MAX                  2.5
#macro TERRAIN_DEF_HEIGHT_RATE                      0.5
#macro TERRAIN_DEF_HEIGHT_BRUSH_INDEX               1
#macro TERRAIN_DEF_HEIGHT_RADIUS                    12
#macro TERRAIN_DEF_HEIGHT_SUBMODE                   TerrainSubmodes.MOUND
#macro TERRAIN_DEF_HEIGHT_GLOBAL_SCALE              1

#macro TERRAIN_DEF_TEX_BRUSH_MIN                    1.5
#macro TERRAIN_DEF_TEX_BRUSH_MAX                    250
#macro TERRAIN_DEF_TEX_BRUSH_SIZE_MIN               4
#macro TERRAIN_DEF_TEX_BRUSH_SIZE_MAX               256
#macro TERRAIN_DEF_TEX_BRUSH_RADIUS                 4
#macro TERRAIN_DEF_TEX_BRUSH_INDEX                  1
#macro TERRAIN_DEF_TEX_BRUSH_X                      0
#macro TERRAIN_DEF_TEX_BRUSH_Y                      0
#macro TERRAIN_DEF_TEX_BRUSH_SIZE                   32

#macro TERRAIN_DEF_PAINT_BRUSH_MIN                  1.5
#macro TERRAIN_DEF_PAINT_BRUSH_MAX                  250
#macro TERRAIN_DEF_PAINT_STRENGTH_MIN               0.025
#macro TERRAIN_DEF_PAINT_STRENGTH_MAX               0.15
#macro TERRAIN_DEF_PAINT_BRUSH_RADIUS               4
#macro TERRAIN_DEF_PAINT_BRUSH_INDEX                7
#macro TERRAIN_DEF_PAINT_COLOR                      0xffffffff
#macro TERRAIN_DEF_PAINT_STREINGTH                  0.05