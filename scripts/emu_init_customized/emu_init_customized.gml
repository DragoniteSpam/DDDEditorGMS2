// Emu (c) 2020 @dragonitespam
// See the Github wiki for documentation: https://github.com/DragoniteSpam/Emu/wiki

#region some macros which you may want to set
// !
#macro EMU_COLOR_BACK                                                           Settings.colors.back
// !
#macro EMU_COLOR_DEFAULT                                                        Settings.colors.def
// !
#macro EMU_COLOR_TEXT                                                           Settings.colors.text
// !
#macro EMU_COLOR_DISABLED                                                       Settings.colors.disabled
// !
#macro EMU_COLOR_HELP_TEXT                                                      Settings.colors.help_text
// !
#macro EMU_COLOR_HOVER                                                          Settings.colors.hover
// !
#macro EMU_COLOR_INPUT_REJECT                                                   Settings.colors.input_reject
// !
#macro EMU_COLOR_INPUT_WARN                                                     Settings.colors.input_warn
// !
#macro EMU_COLOR_LIST_TEXT                                                      Settings.colors.list_text
// !
#macro EMU_COLOR_PROGRESS_BAR                                                   Settings.colors.progress_bar
// !
#macro EMU_COLOR_RADIO_ACTIVE                                                   Settings.colors.radio_active
// !
#macro EMU_COLOR_SELECTED                                                       Settings.colors.sel
// !
#macro EMU_COLOR_WINDOWSKIN                                                     Settings.colors.primary

// !
#macro EMU_DIALOG_SHADE_ALPHA                                                   Settings.config.focus_alpha
#macro EMU_DIALOG_SHADE_COLOR                                                   0x000000

#macro EMU_FONT_DEFAULT                                                         FDefault

#macro EMU_TIME_DOUBLE_CLICK_THRESHOLD                                          250
#macro EMU_TIME_HOLD_THRESHOLD                                                  500

#macro EMU_INPUT_BLINKING_SPEED                                                 800
#macro EMU_KEY_REPEAT_DELAY                                                     60
#macro EMU_KEY_REPEAT_RATE                                                      2

#macro EMU_DEFAULT_CLOSE_BUTTON_WIDTH                                           160
#macro EMU_DEFAULT_CLOSE_BUTTON_HEIGHT                                          32
#endregion

#region macros which it is not very useful to touch
#macro EMU_AUTO                                                                 ptr(0)
#macro EMU_INLINE                                                               ptr(1)
#macro EMU_BASE                                                                 ptr(2)
#macro EMU_AUTO_NO_SPACING                                                      ptr(3)

#macro EmuOverlay                                                               (_emu_get_overlay())

function _emu_get_overlay() {
    static _overlay = new EmuCore(0, 0, window_get_width(), window_get_height());
    return _overlay;
}

#macro EmuActiveElement (_emu_active_element())

function _emu_active_element() { 
    static _active = undefined;
    if (argument_count > 0) {
        _active = argument[0];
    }
    return _active;
}
#endregion