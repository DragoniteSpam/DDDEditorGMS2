#macro EDITOR_BASE_MODE EditorModes.EDITOR_HEIGHTMAP

#macro ALARM_CAMERA_SAVE 0
#macro AUTOTILE_AVAILABLE_MAX 100
#macro AUTOTILE_MAX 16
#macro BATCH_CACHE_SIZE 160
#macro buffer_datatype buffer_u32
#macro CAMERA_SAVE_FREQUENCY 5
#macro CAMERA_ZNEAR 1
#macro CAMERA_ZFAR 32000
// these aren't meant to be used for view coordinates but window coordinates, otherwise i'd make them relative
#macro CH 900
#macro CW 1080
#macro DATA_INI "data.ini"
#macro DEBUG true
#macro EVENT_NODE_CONTACT_HEIGHT 48
#macro EVENT_NODE_CONTACT_WIDTH 320
#macro EXPORT_EXTENSION_DATA ".dddd"
#macro EXPORT_EXTENSION_MAP ".dddm"
#macro EXPORT_EXTENSION_ASSETS ".ddda"
#macro HH 900
#macro HW 520
#macro IMPORT_GRID_SIZE 32          // for setting the bounds of imported meshes, and possibly other things
#macro INTERNAL_NAME_LENGTH 20
#macro VISIBLE_NAME_LENGTH 32
#macro LIMIT_TILESET 255
#macro MAP_AXIS_LIMIT 2048
#macro MAP_VOLUME_LIMIT 0x100000
#macro MAX_AUTOTILE_SHADER_POSITIONS 12 * 16 * 8 * 2
#macro MAX_SELECTION_COUNT 32
#macro MAX_VISIBLE_MOVE_ROUTES 4
#macro mouse_x_view (Camera.MOUSE_X - view_get_xport(view_current))
#macro mouse_y_view (Camera.MOUSE_Y - view_get_yport(view_current))
#macro PATH_AUTOTILE ".\\autotile\\"
#macro PATH_BACKUP_DATA ".\\backups\\data\\"
#macro PATH_BACKUP_MAP ".\\backups\\maps\\"
#macro PATH_BACKUP_ASSET ".\\backups\\assets\\"
#macro PATH_GRAPHICS ".\\data\\graphics\\"
#macro PATH_LUA ".\\data\\lua\\"
#macro PATH_PROJECTS ".\\projects\\"
#macro PATH_TEMP_CODE "temp\\"              // local storage - no leading punctuation - used for opening files
#macro PATH_AUDIO "audio\\"                 // local storage - no leading punctuation - used for opening files
#macro SELECTION_MASK_ALL ~0
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
#macro TILED_MAP_LAYERS_PER_BASE_LAYER 4
#macro TILESET_TEXTURE_HEIGHT 0.5
#macro TILESET_TEXTURE_WIDTH 0.5
#macro VERTEX_FORMAT_SIZE 40 /* bytes */

#macro PREFIX_GRAPHIC_BATTLER "GBat"
#macro PREFIX_GRAPHIC_OVERWORLD "GOv"
#macro PREFIX_GRAPHIC_PARTICLE "GPart"
#macro PREFIX_GRAPHIC_UI "GUI"
#macro PREFIX_GRAPHIC_ETC "GEtc"
#macro PREFIX_GRAPHIC_AUTOTILE "GAt"
#macro PREFIX_GRAPHIC_TILESET "GTs"
#macro PREFIX_AUDIO_SE "Se"
#macro PREFIX_AUDIO_BGM "Bgm"
#macro PREFIX_MESH "Msh"

#macro CONTORL_3D_LOOK Controller.mouse_middle

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

#macro c_ev_basic $99ffcc
#macro c_ev_comment $d8bfd8
#macro c_ev_custom $99ccff
#macro c_ev_ghost $0099cc
#macro c_ev_init $ffcc99
#macro c_ui_select $ffb8ac
#macro c_ui $ebebeb

#macro AUDIO_BASE_FREQUENCY 48000
#macro BILLION 1000000000
#macro EMPTY_BUFFER_MD5 "93b885adfe0da089cdf634904fd59f71"
#macro MILLION 1000000

#macro BASE_GAME_VARIABLES 100      // this also counts for switches
#macro BASE_SELF_VARIABLES 4        // this also counts for switches

enum CollisionMasks {
	NONE				= 0x0000,
	MAIN				= 0x0001,
	SURFACE				= 0x0002,
}