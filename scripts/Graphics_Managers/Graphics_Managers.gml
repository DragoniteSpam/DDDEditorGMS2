function dialog_create_manager_graphic_battle(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Battlers", Game.graphics.battlers,
        PREFIX_GRAPHIC_BATTLER, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    return dg;
}

function dialog_create_manager_graphic_etc(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Misc. Graphics", Game.graphics.etc,
        PREFIX_GRAPHIC_ETC, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    dg.el_frames_horizontal.interactive = false;
    dg.el_frames_vertical.interactive = false;
    dg.el_frame_speed.interactive = false;
    return dg;
}

function dialog_create_manager_graphic_overworld(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Overworld Sprites", Game.graphics.overworlds,
        PREFIX_GRAPHIC_OVERWORLD, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    return dg;
}

function dialog_create_manager_graphic_particle(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Particles", Game.graphics.particles,
        PREFIX_GRAPHIC_PARTICLE, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    return dg;
}

function dialog_create_manager_graphic_skybox(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Skyboxes", Game.graphics.skybox,
        PREFIX_GRAPHIC_SKYBOX, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    dg.el_frames_horizontal.interactive = false;
    dg.el_frames_vertical.interactive = false;
    dg.el_frame_speed.interactive = false;
    return dg;
}

function dialog_create_manager_graphic_tileset(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Tilesets and Textures", Game.graphics.tilesets,
        PREFIX_GRAPHIC_TILESET, dmu_graphic_add_tileset, dmu_graphic_add_tileset_drag,
        dmu_graphic_delete_tileset, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    dg.el_frames_horizontal.interactive = false;
    dg.el_frames_vertical.interactive = false;
    dg.el_frame_speed.interactive = false;
    return dg;
}

function dialog_create_manager_graphic_ui(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "User Interface", Game.graphics.ui,
        PREFIX_GRAPHIC_UI, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    return dg;
}

function dialog_create_manager_graphics() {
    var dialog = new EmuDialog(1408, 760, "Graphics");
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 384;
    var col3 = 736;
    
    return dialog.AddContent([
        (new EmuRadioArray(col1, EMU_AUTO, element_width, element_height, "Type:", 0, function() {
            var list = self.GetSibling("LIST");
            list.Deselect();
            switch (self.value) {
                case 0: list.SetList(Game.graphics.tilesets); self.root.Refresh({ list: Game.graphics.tilesets, index: -1 }); break;
                case 1: list.SetList(Game.graphics.overworlds); self.root.Refresh({ list: Game.graphics.overworlds, index: -1 }); break;
                case 2: list.SetList(Game.graphics.battlers); self.root.Refresh({ list: Game.graphics.battlers, index: -1 }); break;
                case 3: list.SetList(Game.graphics.ui); self.root.Refresh({ list: Game.graphics.ui, index: -1 }); break;
                case 4: list.SetList(Game.graphics.skybox); self.root.Refresh({ list: Game.graphics.skybox, index: -1 }); break;
                case 5: list.SetList(Game.graphics.particles); self.root.Refresh({ list: Game.graphics.particles, index: -1 }); break;
                case 6: list.SetList(Game.graphics.etc); self.root.Refresh({ list: Game.graphics.etc, index: -1 }); break;
            }
        }))
            .AddOptions(["Tilesets", "Overworlds", "Battlers", "UI", "Skyboxes", "Particles", "Misc"])
            .SetColumns(4, 160)
            .SetTooltip("Choose from the various categories of imges")
            .SetID("TYPE"),
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Images:", element_height, 14, function() {
            if (self.root) {
                self.root.Refresh({ list: self._entries, index: self.GetSelection() });
            }
        }))
            .SetListColors(function(index) {
                return self._entries[index].texture_exclude ? c_gray : EMU_COLOR_TEXT;
            })
            .SetNumbered(true)
            .SetList(Game.graphics.tilesets)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetTooltip("All of the images of the selected type")
            .SetID("LIST"),
        (new EmuButton(col2, EMU_BASE, element_width, element_height, "Add Image", function() {
        }))
            .SetTooltip("Add an image")
            .SetID("ADD"),
        (new EmuButton(col2, EMU_AUTO, element_width / 2, element_height, "Delete Image", function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Delete the image; any references to it elsewhere will become null and you'll probably see a lot of magenta")
            .SetID("DELETE"),
        (new EmuButton(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Export Image", function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Save the image to a file")
            .SetID("EXPORT"),
        (new EmuButton(col2, EMU_AUTO, element_width / 2, element_height, "Reload Image", function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Automatically reload the image from its source file (if it exists on the disk)")
            .SetID("RELOAD"),
        (new EmuButton(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Change Image", function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Replace the image")
            .SetID("CHANGE"),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Remove Background Color...", function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Remove the transparent background color from the image, that being defined as the color of the pixel in the bottom-right corner")
            .SetID("BACKGROUND"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Name:", "", "image name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].name);
            })
            .SetInteractive(false)
            .SetTooltip("The name of the asset visible in the editor (and/or player)")
            .SetID("NAME"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Internal name:", "", "image internal name", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITS, function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].internal_name);
            })
            .SetTooltip("The unique internal name that the game can use to identify this asset")
            .SetID("INTERNAL NAME"),
        (new EmuText(col2, EMU_AUTO, element_width, element_height, "Dimensions: N/A"))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) {
                    self.text = "Dimensions: N/A";
                } else {
                    var image = data.list[data.index];
                    self.text = "Dimensions: " + string(image.width) + " x " + string(image.height);
                    if (image.width != sprite_get_width(image.picture) || image.height != sprite_get_height(image.picture)) {
                        self.text += " (" + string(sprite_get_width(image.picture)) + " x " + string(sprite_get_height(image.picture)) + ")";
                    }
                }
            }),
        (new EmuButton(col2, EMU_AUTO, element_width / 2, element_height, "Crop", function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
            })
            .SetTooltip("Crop the whitespace around the border of this image")
            .SetInteractive(false)
            .SetID("CROP"),
        (new EmuButton(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Uncrop", function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
            })
            .SetTooltip("Restore the image to its uncropped size")
            .SetInteractive(false)
            .SetID("UNCROP"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "X Frames:", "1", "horizontal frames", 3, E_InputTypes.INT, function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].hframes);
            })
            .SetInteractive(false)
            .SetTooltip("The number of horizontal frames stored in this image")
            .SetID("X FRAMES"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Y Frames:", "1", "vertical frames", 3, E_InputTypes.INT, function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].vframes);
            })
            .SetInteractive(false)
            .SetTooltip("Most of the time this is going to be either 1 or 4.")
            .SetID("Y FRAMES"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Speed:", "1", "animation speed", 3, E_InputTypes.REAL, function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].aspeed);
            })
            .SetInteractive(false)
            .SetTooltip("This should be frames per second, although like everything else this depends largely on how you plan on using it.")
            .SetID("SPEED"),
        (new EmuCheckbox(col2, EMU_AUTO, element_width, element_height, "Exclude from texture page?", false, function() {
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].texture_exclude);
            })
            .SetInteractive(false)
            .SetTooltip("For optimization purposes the game may attempt to pack related sprites onto a single texture. In some cases you may wish for that to not happen.")
            .SetID("EXCLUDE"),
        (new EmuRenderSurface(col3, EMU_BASE, 640, 640, function() {
            self.drawCheckerbox();
            var data = self.GetSibling("LIST").GetSelectedItem();
            if (data) {
                draw_sprite(data.picture, 0, 0, 0);
            }
        }, function(mx, my) {
                
        }, function() {
        }))
            .SetID("PREVIEW")
    ])
        .AddDefaultCloseButton();
}
