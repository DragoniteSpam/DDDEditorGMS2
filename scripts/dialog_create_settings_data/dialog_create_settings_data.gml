function dialog_create_settings_data() {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 720, "Global Game Settinsg");
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        #region Project DNA
        (new EmuInput(col1, EMU_BASE, dialog.width - 64, element_height * 3, "Summary:", Game.meta.project.summary, "Write a short description here", 500, E_InputTypes.STRING, function() {
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
        #region General
        new EmuText(col1, EMU_AUTO, element_width, element_height, "[c_aqua]General Gameplay Settings"),
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Snap player to grid", Game.meta.grid.snap, function() {
            Game.meta.grid.snap = self.value;
        }))
            .SetTooltip("Whether the player's position will be restricted to the grid, or whether they will be allowed to move freely between cells"),
        (new EmuButton(col2, EMU_INLINE, element_width, element_height, "Player Start", function() {
            dialog_create_settings_data_player_start(); /* update this */
        }))
            .SetTooltip("Set the player's starting position on the map. By default it will be in the bottom-upper-left corner of the default map, but you probably want it to be somewhere with meaning."),
        (new EmuCheckbox(col3, EMU_INLINE, element_width, element_height, "Export mesh collision shapes", Game.meta.export.flags & GameExportFlags.COLLISION_SHAPES, function() {
            Game.meta.export.flags &= ~GameExportFlags.COLLISION_SHAPES;
            if (self.value) {
                Game.meta.export.flags |= GameExportFlags.COLLISION_SHAPES;
            }
        }))
            .SetTooltip("Whether the player's position will be restricted to the grid, or whether they will be allowed to move freely between cells"),
        #endregion
        #region Graphical stuff
        new EmuText(col1, EMU_AUTO, element_width, element_height, "[c_aqua]Graphical Settings"),
        (new EmuColorPicker(col1, EMU_AUTO, element_width, element_height, "Default ambient:", Game.meta.lighting.ambient, function() {
            Game.meta.lighting.ambient = self.value;
        }))
            .SetTooltip("The default ambient lighting color. New maps will use this value. Existing maps will not be updated."),
        (new EmuInput(col2, EMU_INLINE, element_width, element_height, "Chunk size:", Game.meta.grid.chunk_size, "cells", 5, E_InputTypes.INT, function() {
            Game.meta.grid.chunk_size = self.value;
        }))
            .SetRealNumberBounds(8, MAP_AXIS_LIMIT)
            .SetTooltip("The size of map chunks, in tiles"),
        (new EmuButton(col3, EMU_INLINE, element_width, element_height, "Exported vertex format", function() {
            emu_dialog_vertex_format(Game.meta.export.vertex_format, function(value) { Game.meta.export.vertex_format = value; });
        }))
            .SetTooltip("The vertex format that exported meshes (mesh data, frozen map data, etc) uses."),
        (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Screen width:", Game.meta.screen.width, "pixels", 4, E_InputTypes.INT, function() {
            Game.meta.screen.width = self.value;
        }))
            .SetInteractive(false)
            .SetTooltip("How you want the game to be scaled. If you are making a game that is primarily pixel art, you may want to use a base resolution such as 640x360 or 320x180. Set these to -1 if you do not want scaling."),
        (new EmuInput(col2, EMU_INLINE, element_width, element_height, "Screen height:", Game.meta.screen.height, "pixels", 4, E_InputTypes.INT, function() {
            Game.meta.screen.height = self.value;
        }))
            .SetInteractive(false),
        #endregion
        #region Variables and stuff
        new EmuText(col1, EMU_AUTO, element_width, element_height, "[c_aqua]Variables and stuff"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Global Variables", function() {
            dialog_create_settings_data_variables(); /* update this */
        }))
            .SetTooltip("A list of built-in variables which you may wish to modify during the game. You may set their default values here."),
        (new EmuButton(col2, EMU_INLINE, element_width, element_height, "Global Switches", function() {
            dialog_create_settings_data_switches(); /* update this */
        }))
            .SetTooltip("A list of built-in variables which you may wish to modify during the game. You may set their default values here."),
        (new EmuButton(col3, EMU_INLINE, element_width, element_height, "Global Constants", function() {
            dialog_create_settings_data_game_constants(); /* update this */
        }))
            .SetTooltip("A list of properties whose value will not change during the game. Examples might include things such as \"walk speed\" or \"experience multiplier.\""),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Event Triggers", function() {
            dialog_create_settings_data_event_triggers(); /* update this */
        }))
            .SetTooltip("In addition to the default event triggers (action button, player touch, etc) you may define your own, such as \"on contact with a magic spell\" or something."),
        (new EmuButton(col2, EMU_INLINE, element_width, element_height, "Asset Collision Flags", function() {
            dialog_create_settings_data_asset_flags(); /* update this */
        }))
            .SetTooltip("Some extra flags you can assign to various game assets. This now includes collision triggers."),
        (new EmuButton(col3, EMU_INLINE, element_width, element_height, "Effect Markers", function() {
            dialog_create_settings_data_effect_marker(); /* update this */
        }))
            .SetTooltip("Effects can be used to denote misc ambient entities, such as fish in water or that kind of thing."),
        #endregion
        new EmuText(col1, EMU_AUTO, element_width, element_height, "[c_aqua]Other things"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Data and Asset Files", function() {
            dialog_create_settings_data_asset_files(); /* update this */
        }))
            .SetTooltip("You may wish to separate different kinds of game assets into different data files. In fact, if you have a lot of them, you'll definitely want to do that, especially if you're on source control."),
    ]).AddDefaultCloseButton();
}