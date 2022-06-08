// the mode that the editor starts in
#macro EDITOR_BASE_MODE                     ModeIDs.MAP
#macro Terrain:EDITOR_BASE_MODE             ModeIDs.TERRAIN
#macro spart:EDITOR_BASE_MODE               ModeIDs.SPART
#macro mesh:EDITOR_BASE_MODE                ModeIDs.MESH
// standalone tools will not have the rest of the program enabled
#macro EDITOR_FORCE_SINGLE_MODE             false
#macro spart:EDITOR_FORCE_SINGLE_MODE       true
#macro mesh:EDITOR_FORCE_SINGLE_MODE        true
#macro Terrain:EDITOR_FORCE_SINGLE_MODE     true
//
#macro MENU_EDITOR_ENABLED                  true
#macro spart:MENU_EDITOR_ENABLED            false
#macro mesh:MENU_EDITOR_ENABLED             false
//
#macro MENU_EDITOR_PARTICLE_OVERRIDE        false
#macro spart:MENU_EDITOR_PARTICLE_OVERRIDE  true
//
#macro GLOBAL_CONTORLS_ENABLED              true
#macro spart:GLOBAL_CONTORLS_ENABLED        false
#macro mesh:GLOBAL_CONTORLS_ENABLED         false
#macro Terrain:GLOBAL_CONTORLS_ENABLED      false
//
#macro PROJECT_MENU_ENABLED                 true
#macro spart:PROJECT_MENU_ENABLED           false
#macro mesh:PROJECT_MENU_ENABLED            false
#macro Terrain:PROJECT_MENU_ENABLED         false
//
#macro RIBBON_MENU                          menu_init_main
#macro mesh:RIBBON_MENU                     menu_init_mesh
#macro Terrain:RIBBON_MENU                  menu_init_terrain
//
#macro TERRAIN_MODE                         false
#macro Terrain:TERRAIN_MODE                 true
//
#macro DEFAULT_TILESET                      "b_tileset_overworld_0.png"
#macro mesh:DEFAULT_TILESET                 "b_magenta.png"

// game maker
#macro wtf                                  show_debug_message
#macro mouse_x                              (window_mouse_get_x() * _base_window_width / window_get_width())
#macro mouse_y                              (window_mouse_get_y() * _base_window_height / window_get_height())
#macro _base_window_width                   1600
#macro _base_window_height                  900

// game maker buffer_compress uses medium-level compression; the first two bytes you'll see are
// "78" and "9c" but buffer_read is little endian so they'll be in reverse order
#macro MAGIC_ZLIB_HEADER 0x9c78
#macro LAST_SAFE_RELEASE                    "2019.4.1.19";
#macro DEFAULT_FROZEN_BUFFER_SIZE           1

#macro AUTOTILE_COUNT                       48
#macro BATCH_CACHE_SIZE                     160
#macro buffer_datatype                      buffer_string
#macro buffer_flag                          buffer_u64
#macro buffer_field                         buffer_u64
#macro buffer_eof                           0xffffffff
#macro CAMERA_ZNEAR                         0x0004
#macro CAMERA_ZFAR                          0x2000
#macro CH                                   900                                 // these aren't meant to be used for view coordinates but window coordinates, otherwise i'd make them relative
#macro CW                                   1080
#macro DEBUG                                true
#macro EVENT_NODE_CONTACT_HEIGHT            48
#macro EVENT_NODE_CONTACT_WIDTH             320
#macro EXPORT_EXTENSION_DATA                ".dddd"
#macro EXPORT_EXTENSION_ASSETS              ".ddda"
#macro EXPORT_EXTENSION_MAP                 ".dddm"                             // yeah we're bringing this back
#macro EXPORT_EXTENSION_PARTICLES           ".dddp"
#macro EXPORT_EXTENSION_PROJECT             ".dragon"
#macro FLAG_COUNT                           63
#macro FLAG_MAX_VALUE                       0x7fffffffffffffff
#macro INTERNAL_NAME_LENGTH                 32
#macro VISIBLE_NAME_LENGTH                  32
#macro MAP_AXIS_LIMIT                       0x800
#macro MAP_VOLUME_LIMIT                     0x40000
#macro MAX_SELECTION_COUNT                  32
#macro MAX_LIGHTS                           7                                   // one is reserved for the point / spot light around the player
#macro NULL                                 ""
#macro PATH_AUTOTILE                        "autotile/"
#macro PATH_GRAPHICS                        "data/graphics/"                    // local storage - no leading punctuation - used for opening files
#macro PATH_PROJECTS                        "projects/"
#macro PATH_TEMP                            "temp/"                             // local storage - no leading punctuation - used for opening files
#macro PATH_AUDIO                           "audio/"                            // local storage - no leading punctuation - used for opening files
#macro PATH_TERRAIN                         "terrain/"
#macro MAP_ACTIVE_TILESET                   (guid_get(Stuff.map.active_map.tileset) ?? Game.graphics.tilesets[0])
#macro TEXTURE_WIDTH                        sprite_get_width(MAP_ACTIVE_TILESET.picture)
#macro TEXTURE_HEIGHT                       sprite_get_height(MAP_ACTIVE_TILESET.picture)
#macro TILE_DEPTH                           Stuff.tile_depth
#macro TILE_HEIGHT                          Stuff.tile_height
#macro TILE_WIDTH                           Stuff.tile_width
#macro VERTEX_SIZE                          Stuff.graphics.format_size
#macro VERTEX_SIZE_TERRAIN                  12

#macro MAP_BATCH_MESH_ENABLED               false

#macro FILE_SETTINGS                        "settings.json"
#macro FILE_TERRAIN_TEXTURE                 PATH_TERRAIN + "tex.png"

#macro PREFIX_GRAPHIC_BATTLER               "GBat"
#macro PREFIX_GRAPHIC_OVERWORLD             "GOv"
#macro PREFIX_GRAPHIC_PARTICLE              "GPart"
#macro PREFIX_GRAPHIC_UI                    "GUI"
#macro PREFIX_GRAPHIC_SKYBOX                "GSky"
#macro PREFIX_GRAPHIC_ETC                   "GEtc"
#macro PREFIX_GRAPHIC_AUTOTILE              "GAt"
#macro PREFIX_GRAPHIC_TILESET               "GTs"
#macro PREFIX_AUDIO_SE                      "Se"
#macro PREFIX_AUDIO_BGM                     "Bgm"
#macro PREFIX_MESH                          "Ms"

#macro CONTROL_3D_LOOK                      Controller.mouse_middle
#macro CONTROL_3D_LOOK_DOWN                 Controller.press_middle
#macro CONTROL_3D_LOOK_UP                   Controller.release_middle

#macro c_ev_basic                           0x99ff00
#macro c_ev_comment                         0xd8bfd8
#macro c_ev_custom                          0x99ccff
#macro c_ev_ghost                           0x0099cc
#macro c_ev_ghost_external                  0x4dd2ff
#macro c_ev_init                            0xffcc99
#macro c_progress_bar                       0xff9900
#macro c_tooltip                            0xccffff
#macro c_ui_active_bitfield                 0xc0c0c0
#macro c_ui_select                          0xffb8ac
#macro c_ui                                 0xebebeb

#macro c_wireframe_mesh_col_sphere          0x8080ff
#macro c_wireframe_mesh_col_box             0x80ff80
#macro c_wireframe_mesh_col_capsule         0xff8080
#macro c_wireframe_mesh_col_trimesh         0x80ffff

#macro c_array_zone_selected                c_white

#macro BILLION                              1000000000
#macro MILLION                              1000000

#macro BASE_GAME_VARIABLES                  10                                  // this also counts for switches
#macro BASE_SELF_VARIABLES                  4                                   // this also counts for switches

#macro PROJECT_PATH_ROOT                    (environment_get_variable("localappdata") + "/" + game_project_name + "/")     // in case an extension needs to see the exact path of something in local storage
#macro PROJECT_PATH_AUDIO                   "audio"
#macro PROJECT_PATH_IMAGE                   "image"
#macro PROJECT_PATH_MAP                     "map"
#macro PROJECT_PATH_MESH                    "mesh"
#macro PROJECT_PATH_MESH_AUTOTILE           "autotile"
#macro PROJECT_PATH_TERRAIN                 "terrain"

// RefID prefixes
#macro REFID_PLAYER                                                             "$"
#macro REFID_SELF                                                               "@"