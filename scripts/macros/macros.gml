#macro EDITOR_BASE_MODE ModeIDs.MAP
#macro Terrain:EDITOR_BASE_MODE ModeIDs.TERRAIN
#macro scribble:EDITOR_BASE_MODE ModeIDs.SCRIBBLE
#macro spart:EDITOR_BASE_MODE ModeIDs.SPART
// the dedicated Scribble / spart preview tools will not have the rest of the
// program available
#macro EDITOR_FORCE_SINGLE_MODE false
#macro scribble:EDITOR_FORCE_SINGLE_MODE true
#macro spart:EDITOR_FORCE_SINGLE_MODE true

#macro MENU_EDITOR_ENABLED true
#macro scribble:MENU_EDITOR_ENABLED false
#macro spart:MENU_EDITOR_ENABLED false
#macro GLOBAL_CONTORLS_ENABLED true
#macro scribble:GLOBAL_CONTORLS_ENABLED false
#macro spart:GLOBAL_CONTORLS_ENABLED false
#macro PROJECT_MENU_ENABLED true
#macro scribble:PROJECT_MENU_ENABLED false
#macro spart:PROJECT_MENU_ENABLED false

// game maker buffer_compress uses medium-level compression; the first two bytes you'll see are
// "78" and "9c" but buffer_read is little endian so they'll be in reverse order
#macro MAGIC_ZLIB_HEADER 0x9c78
// instance IDs begin here
#macro MAGIC_INSTANCE_ID 100000

#macro ALARM_SETTINGS_SAVE 0
#macro AUTOTILE_AVAILABLE_MAX 100
#macro AUTOTILE_COUNT 48
#macro AUTOTILE_MAX 32
#macro BATCH_CACHE_SIZE 160
#macro buffer_datatype buffer_u32
#macro CAMERA_SAVE_FREQUENCY 5
#macro CAMERA_ZNEAR 32
#macro CAMERA_ZFAR 0x4000
// these aren't meant to be used for view coordinates but window coordinates, otherwise i'd make them relative
#macro CH 900
#macro CW 1080
#macro DEBUG true
#macro EVENT_NODE_CONTACT_HEIGHT 48
#macro EVENT_NODE_CONTACT_WIDTH 320
#macro EXPORT_EXTENSION_DATA ".dddd"
#macro EXPORT_EXTENSION_MAP ".dddm"
#macro EXPORT_EXTENSION_ASSETS ".ddda"
#macro FLAG_COUNT 32
#macro HH 900
#macro HW 520
#macro IMPORT_GRID_SIZE 32          // for setting the bounds of imported meshes, and possibly other things
#macro INTERNAL_NAME_LENGTH 20
#macro VISIBLE_NAME_LENGTH 32
#macro LIMIT_TILESET 255
#macro MAP_AXIS_LIMIT 2048
#macro MAP_VOLUME_LIMIT 0x100000
#macro MAX_SELECTION_COUNT 32
#macro MAX_VISIBLE_MOVE_ROUTES 4
#macro MAX_LIGHTS 8
#macro mouse_x_view (Stuff.MOUSE_X - view_get_xport(view_current))
#macro mouse_y_view (Stuff.MOUSE_Y - view_get_yport(view_current))
#macro PATH_AUTOTILE ".\\autotile\\"
#macro PATH_GRAPHICS ".\\data\\graphics\\"  // local storage - no leading punctuation - used for opening files
#macro PATH_LUA ".\\data\\lua\\"
#macro PATH_PROJECTS ".\\projects\\"
#macro PATH_TEMP_CODE "temp\\"              // local storage - no leading punctuation - used for opening files
#macro PATH_AUDIO "audio\\"                 // local storage - no leading punctuation - used for opening files
#macro SERIALIZE_ASSETS 2
#macro SERIALIZE_DATA 1
#macro SERIALIZE_DATA_AND_MAP 3
#macro SERIALIZE_MAP 0
#macro TEXTURE_SIZE 4096
#macro TILE_DEPTH Stuff.tile_depth
#macro TILE_HEIGHT Stuff.tile_height
#macro TILE_MAX_PRIORITY 256
#macro TILE_PASSABLE 0xff
#macro TILE_WIDTH Stuff.tile_width
#macro TILESET_MAX_SIZE 2048
#macro TILESET_TEXTURE_HEIGHT 0.5
#macro TILESET_TEXTURE_WIDTH 0.5

#macro FILE_ERRORS "errors.log"
#macro FILE_SETTINGS "settings.json"

#macro PREFIX_GRAPHIC_BATTLER "GBat"
#macro PREFIX_GRAPHIC_OVERWORLD "GOv"
#macro PREFIX_GRAPHIC_PARTICLE "GPart"
#macro PREFIX_GRAPHIC_UI "GUI"
#macro PREFIX_GRAPHIC_ETC "GEtc"
#macro PREFIX_GRAPHIC_AUTOTILE "GAt"
#macro PREFIX_GRAPHIC_TILESET "GTs"
#macro PREFIX_AUDIO_SE "Se"
#macro PREFIX_AUDIO_BGM "Bgm"
#macro PREFIX_MESH "Ms"

#macro CONTORL_3D_LOOK (Controller.mouse_middle)

#macro DEFAULT_TERRAIN_HEIGHT 256
#macro DEFAULT_TERRAIN_HEIGHTMAP_SCALE 256
#macro DEFAULT_TERRAIN_WIDTH 256
#macro MAX_TERRAIN_HEIGHT 512
#macro MAX_TERRAIN_WIDTH 512
#macro MIN_TERRAIN_HEIGHT 32
#macro MIN_TERRAIN_WIDTH 32

#macro view_fullscreen 0
#macro view_3d 1
#macro view_ribbon 2
#macro view_hud 3
#macro view_3d_preview 4
#macro view_5 5
#macro view_6 6
#macro view_overlay 7

#macro view_hud_width_3d 520
#macro view_hud_width_event 320

#macro c_ev_basic 0x99ff00
#macro c_ev_comment 0xd8bfd8
#macro c_ev_custom 0x99ccff
#macro c_ev_ghost 0x0099cc
#macro c_ev_ghost_external 0x4dd2ff
#macro c_ev_init 0xffcc99
#macro c_magenta 0xff00ff
#macro c_progress_bar 0xff9900
#macro c_tooltip 0xccffff
#macro c_ui_active_bitfield c_ltgray
#macro c_ui_select 0xffb8ac
#macro c_ui 0xebebeb

#macro c_array_zone_selected [1, 1, 1, 1]

#macro BILLION 1000000000
#macro EMPTY_BUFFER_MD5 "93b885adfe0da089cdf634904fd59f71"
#macro MILLION 1000000

#macro BASE_GAME_VARIABLES 100      // this also counts for switches
#macro BASE_SELF_VARIABLES 4        // this also counts for switches