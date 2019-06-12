#macro PATH_RESOURCES ".\\data\\resources\\"
#macro PATH_GRAPHICS ".\\data\\graphics\\"
#macro PATH_TEMP_CODE ".\\data\\temp\\"
#macro ALARM_CAMERA_SAVE 0
#macro AUTOTILE_AVAILABLE_MAX 100
#macro AUTOTILE_MAX 16
#macro BATCH_CACHE_SIZE 160
#macro buffer_datatype buffer_u32
#macro c_ev_basic $99ffcc
#macro c_ev_custom $99ccff
#macro c_ev_ghost $0099cc
#macro c_ev_init $ffcc99
#macro c_ui_select $ffb8ac
#macro c_ui $ebebeb
#macro CAMERA_SAVE_FREQUENCY 5
#macro CH 900
#macro CW 1080 /*these aren't meant to be used for view coordinates but window coordinates, otherwise i'd make them relative*/
#macro DATA_INI "data.ini"
#macro DEBUG true
#macro EVENT_NODE_CONTACT_HEIGHT 32
#macro EVENT_NODE_CONTACT_WIDTH 320
#macro EXPORT_EXTENSION_DATA ".dddd"
#macro EXPORT_EXTENSION_MAP ".dddm"
#macro HH 900
#macro HVIEW __view_get( e__VW.HView, view_current )
#macro HW 520
#macro LIMIT_TILESET 255
#macro MAP_X_LIMIT 1024
#macro MAP_Y_LIMIT 1024
#macro MAP_Z_LIMIT 512
#macro MAX_AUTOTILE_SHADER_POSITIONS 12*16*8*2
#macro MAX_VISIBLE_MOVE_ROUTES 4
#macro MILLION 1000000
#macro mouse_x_view mouse_x+__view_get( e__VW.XView, view_current )
#macro mouse_y_view mouse_y+__view_get( e__VW.YView, view_current )
#macro N chr($0d)+chr($0a)
#macro PATH_AUTOTILE ".\\autotile\\"
#macro PATH_BACKUP_DATA ".\\backups\\data\\"
#macro PATH_BACKUP_MAP ".\\backups\\maps\\"
#macro PATH_DUMMY ".\\data\\graphics\\dummy\\"
#macro PATH_PERMANENT ".\\data\\graphics\\permanent\\"
#macro PATH_VRA ".\\data\\vra\\"
#macro SELECTION_MASK_ALL ETypeFlags.ENTITY_TILE|ETypeFlags.ENTITY_TILE_AUTO|ETypeFlags.ENTITY_EVENT|ETypeFlags.ENTITY_PAWN|ETypeFlags.ENTITY_MESH|ETypeFlags.ENTITY_EFFECT
#macro SERIALIZE_DATA 1
#macro SERIALIZE_MAP 0
#macro T buffer_f32
#macro TEXTURE_SIZE 4096
#macro TILE_DEPTH Stuff.tile_depth
#macro TILE_HEIGHT Stuff.tile_height
#macro TILE_MAX_PRIORITY 256
#macro TILE_PASSABLE TilePassability.UP|TilePassability.DOWN|TilePassability.LEFT|TilePassability.RIGHT
#macro TILE_WIDTH Stuff.tile_width
#macro TILESET_TEXTURE_HEIGHT 0.5
#macro TILESET_TEXTURE_WIDTH 0.5
#macro view_3d_preview 4
#macro view_3d 1
#macro view_fullscreen 0
#macro view_hud_width_3d 520
#macro view_hud_width_event 320
#macro view_hud 3
#macro view_invisible 7
#macro view_ribbon 2
#macro WVIEW __view_get( e__VW.WView, view_current )
#macro XVIEW __view_get( e__VW.XView, view_current )
#macro YVIEW __view_get( e__VW.YView, view_current )
