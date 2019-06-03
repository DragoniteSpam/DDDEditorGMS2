/// @description void momu_editor_event(MenuElement);
/// @param MenuElement

var catch=argument0;

Camera.mode=EditorModes.EDITOR_EVENT;

__view_set( e__VW.Visible, view_fullscreen, true );
__view_set( e__VW.Visible, view_3d, false );
__view_set( e__VW.Visible, view_ribbon, true );
__view_set( e__VW.Visible, view_hud, true );
__view_set( e__VW.Visible, view_3d_preview, false );

__view_set( e__VW.XView, view_hud, room_width-view_hud_width_event );
__view_set( e__VW.WView, view_hud, view_hud_width_event );
__view_set( e__VW.XPort, view_hud, room_width-view_hud_width_event );
__view_set( e__VW.WPort, view_hud, view_hud_width_event );

__view_set( e__VW.WView, view_fullscreen, room_width-view_hud_width_event );
__view_set( e__VW.WPort, view_fullscreen, room_width-view_hud_width_event );
__view_set( e__VW.XView, view_fullscreen, 0 );
__view_set( e__VW.YView, view_fullscreen, 0 );

menu_activate(noone);
