/// @param MenuElement

var catch = argument0;

Camera.mode = EditorModes.EDITOR_ANIMATION;

__view_set( e__VW.Visible, view_fullscreen, true );
__view_set( e__VW.Visible, view_3d, false );
__view_set( e__VW.Visible, view_ribbon, true );
__view_set( e__VW.Visible, view_hud, false );
__view_set( e__VW.Visible, view_3d_preview, false );

__view_set( e__VW.WView, view_fullscreen, room_width );
__view_set( e__VW.WPort, view_fullscreen, room_width );
__view_set( e__VW.XView, view_fullscreen, 0 );
__view_set( e__VW.YView, view_fullscreen, 0 );

menu_activate(noone);