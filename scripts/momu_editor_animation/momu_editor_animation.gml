/// @param MenuElement

var catch = argument0;

Camera.mode = EditorModes.EDITOR_ANIMATION;

__view_set( e__VW.Visible, view_fullscreen, true );
__view_set( e__VW.Visible, view_3d, true );
__view_set( e__VW.Visible, view_ribbon, true );
__view_set( e__VW.Visible, view_hud, false );
__view_set( e__VW.Visible, view_3d_preview, false );

__view_set( e__VW.WView, view_fullscreen, room_width );
__view_set( e__VW.WPort, view_fullscreen, room_width );
__view_set( e__VW.XView, view_fullscreen, 0 );
__view_set( e__VW.YView, view_fullscreen, 0 );

__view_set( e__VW.XView, view_3d, 0 );
__view_set( e__VW.YView, view_3d, 0 );
// hard-coding this will SEVERELY screw up the whole deal with allowing the window to be
// resized, but i'll deal with that when i have to
__view_set( e__VW.XPort, view_3d, 576);
__view_set( e__VW.YPort, view_3d, 336);
__view_set( e__VW.WPort, view_3d, room_width - 32 - 576 );
__view_set( e__VW.HPort, view_3d, room_height - 32 - 336 );

menu_activate(noone);