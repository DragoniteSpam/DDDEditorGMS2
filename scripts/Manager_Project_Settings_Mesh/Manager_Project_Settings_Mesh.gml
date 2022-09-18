function dialog_create_settings_data_mesh() {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 320, "Global Game Settings");
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        #region Project DNA
        (new EmuInput(col1, EMU_BASE, dialog.width - 64, element_height * 4, "Summary:", Game.meta.project.summary, "Write a short description here", 500, E_InputTypes.STRING, function() {
            Game.meta.project.summary = self.value;
        }))
            .SetInputBoxPosition(element_width / 2)
            .SetMultiLine(true)
            .SetTooltip("A quick summary of the game that the data files are to be used for; will be shown in the project list when you open the editor. Has no impact on gameplay (unless you code it to)."),
        (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Author:", Game.meta.project.author, "Who is responsible for this?", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            Game.meta.project.author = self.value;
        }))
            .SetTooltip("The name of the person who made this; will be shown in the project list when you open the editor. Has no impact on gameplay (unless you code it to) and is not a substitute for full game credits."),
        #endregion
    ]).AddDefaultCloseButton();
}