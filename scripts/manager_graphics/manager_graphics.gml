function dialog_create_manager_graphics() {
    var dialog = new EmuDialog(1408, 760, "Graphics");
    dialog.graphics_prefix = PREFIX_GRAPHIC_TILESET;
    dialog.graphics_list = Game.graphics.tilesets;
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 384;
    var col3 = 736;
    
    if (!IS_MESH_MODE) {
        dialog.AddContent([
            (new EmuRadioArray(col1, EMU_AUTO, element_width, element_height, "Type:", 0, function() {
                switch (self.value) {
                    case 0: self.root.graphics_list = Game.graphics.tilesets; self.root.graphics_prefix = PREFIX_GRAPHIC_TILESET; break;
                    case 1: self.root.graphics_list = Game.graphics.overworlds; self.root.graphics_prefix = PREFIX_GRAPHIC_OVERWORLD; break;
                    case 2: self.root.graphics_list = Game.graphics.battlers; self.root.graphics_prefix = PREFIX_GRAPHIC_BATTLER; break;
                    case 3: self.root.graphics_list = Game.graphics.ui; self.root.graphics_prefix = PREFIX_GRAPHIC_UI; break;
                    case 4: self.root.graphics_list = Game.graphics.skybox; self.root.graphics_prefix = PREFIX_GRAPHIC_SKYBOX; break;
                    case 5: self.root.graphics_list = Game.graphics.particles; self.root.graphics_prefix = PREFIX_GRAPHIC_PARTICLE; break;
                    case 6: self.root.graphics_list = Game.graphics.etc; self.root.graphics_prefix = PREFIX_GRAPHIC_ETC; break;
                }
                self.GetSibling("LIST").Deselect().SetList(self.root.graphics_list);
                self.root.Refresh({ list: self.root.graphics_list, index: -1 });
            }))
                .AddOptions(["Tilesets", "Overworlds", "Battlers", "UI", "Skyboxes", "Particles", "Misc"])
                .SetColumns(4, 160)
                .SetTooltip("Choose from the various categories of imges")
                .SetID("TYPE")
        ]);
    }
    
    dialog.AddContent([
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Images:", element_height, !IS_MESH_MODE ? 14 : 20, function() {
            if (self.root) {
                self.root.Refresh({ list: self.entries, index: self.GetSelection() });
            }
        }))
            .SetListColors(function(index) {
                return self.root.graphics_list[index].texture_exclude ? c_gray : EMU_COLOR_TEXT;
            })
            .SetNumbered(true)
            .SetList(Game.graphics.tilesets)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetTooltip("All of the images of the selected type")
            .SetID("LIST"),
        (new EmuButton(col2, EMU_BASE, element_width, element_height, "Add Image", function() {
            var fn = get_open_filename_image();
            if (file_exists(fn)) {
                if (self.root.graphics_list == Game.graphics.tilesets) {
                    tileset_create(fn);
                } else {
                    graphics_add_generic(fn, self.root.graphics_prefix, self.root.graphics_list, undefined, false);
                }
                self.GetSibling("LIST").Deselect().Select(array_length(self.root.graphics_list) - 1);
                self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
            }
        }))
            .SetTooltip("Add an image")
            .SetID("ADD"),
        (new EmuButton(col2, EMU_AUTO, element_width / 2, element_height, "Delete Image", function() {
            var image = self.GetSibling("LIST").GetSelectedItem();
            self.GetSibling("LIST").Deselect();
            array_delete(self.root.graphics_list, array_get_index(self.root.graphics_list, image), 1);
            image.Destroy();
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Delete the image; any references to it elsewhere will become null and you'll probably see a lot of magenta")
            .SetID("DELETE"),
        (new EmuButton(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Export Image", function() {
            try {
                var image = self.GetSibling("LIST").GetSelectedItem();
                var fn = get_save_filename_image(image.name + ".png");
                sprite_save(image.picture, 0, fn);
            } catch (e) {
                wtf("Could not save the image: " + e.message);
            }
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Save the image to a file")
            .SetID("EXPORT"),
        (new EmuButton(col2, EMU_AUTO, element_width / 2, element_height, "Reload Image", function() {
            self.GetSibling("LIST").GetSelectedItem().Reload();
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Automatically reload the image from its source file (if it exists on the disk)")
            .SetID("RELOAD"),
        (new EmuButton(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Change Image", function() {
            var image = self.GetSibling("LIST").GetSelectedItem();
            var fn = get_open_filename_image();
            if (file_exists(fn)) {
                image.source_filename = fn;
                sprite_delete(image.picture);
                image.picture = sprite_add(fn, 0, false, false, 0, 0);
                image.width = sprite_get_width(image.picture);
                image.height = sprite_get_height(image.picture);
                data_image_force_power_two(image);
                data_image_npc_frames(image);
            }
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Replace the image")
            .SetID("CHANGE"),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Remove Background Color...", function() {
            var image = self.GetSibling("LIST").GetSelectedItem();
            image.picture = sprite_remove_transparent_color(image.picture);
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Remove the transparent background color from the image, that being defined as the color of the pixel in the bottom-right corner")
            .SetID("BACKGROUND"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Resize:", "1.0", "proportionally", 4, E_InputTypes.REAL, function() {
            var scale = real(self.value);
            var image = self.GetSibling("LIST").GetSelectedItem();
            image.Resize(image.width * scale, image.height * scale);
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetRealNumberBounds(0.125, 8)
            .SetRequireConfirm(true)
            .SetID("RESIZE"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Name:", "", "image name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            self.GetSibling("LIST").GetSelectedItem().name = self.value;
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].name);
            })
            .SetInteractive(false)
            .SetTooltip("The name of the asset visible in the editor (and/or player)")
            .SetID("NAME")
    ]);
    
    if (IS_DEFAULT_MODE) {
        dialog.AddContent([
            (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Internal name:", "", "image internal name", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITS, function() {
                var image = self.GetSibling("LIST").GetSelectedItem();
                var already = internal_name_get(self.value);
                if (!already || already == image) {
                    internal_name_remove(image.internal_name);
                    internal_name_set(image, self.value);
                }
            }))
                .SetRefresh(function(data) {
                    self.SetInteractive(data.index != -1);
                    if (data.index == -1) return;
                    self.SetValue(data.list[data.index].internal_name);
                })
                .SetTooltip("The unique internal name that the game can use to identify this asset")
                .SetID("INTERNAL NAME"),
        ]);
    }

    dialog.AddContent([
        new EmuText(col2, EMU_AUTO, element_width, 24, "Source file:"),
        (new EmuText(col2, EMU_AUTO, element_width, 24, "[c_orange]<no path saved>"))
            .SetRefresh(function(data) {
                if (data.index == -1) return;
                var abb = filename_abbreviated(data.list[data.index].source_filename, self.width - self.offset);
                if (abb == "") abb = "<no path saved>";
                if (!file_exists(data.list[data.index].source_filename)) abb = "[c_orange]" + abb;
                self.SetValue(abb);
            })
            .SetTextUpdate(undefined)
            .SetID("SOURCE FILE"),
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
            var image = self.GetSibling("LIST").GetSelectedItem();
            // @todo impelment a cutoff value
            var dim = sprite_get_cropped_dimensions(image.picture, 0, 127);
            // @todo implement a value to round to?
            var round_to = 16;
            image.width = round_ext(dim.x, round_to);
            image.height = round_ext(dim.y, round_to);
            image.picture = sprite_crop(image.picture, 0, 0, image.width, image.height);
            data_image_npc_frames(image);
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
            })
            .SetTooltip("Crop the whitespace around the border of this image")
            .SetInteractive(false)
            .SetID("CROP"),
        (new EmuButton(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Uncrop", function() {
            var image = self.GetSibling("LIST").GetSelectedItem();
            image.width = sprite_get_width(image.picture);
            image.height = sprite_get_height(image.picture);
            data_image_npc_frames(image);
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
            })
            .SetTooltip("Restore the image to its uncropped size")
            .SetInteractive(false)
            .SetID("UNCROP"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "X Frames:", "1", "horizontal frames", 3, E_InputTypes.INT, function() {
            var image = self.GetSibling("LIST").GetSelectedItem();
            image.hframes = real(self.value);
            data_image_npc_frames(image);
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
            var image = self.GetSibling("LIST").GetSelectedItem();
            image.vframes = real(self.value);
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
            self.GetSibling("LIST").GetSelectedItem().aspeed = real(self.value);
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
            self.GetSibling("LIST").GetSelectedItem().texture_exclude = self.value;
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
            draw_clear(EMU_COLOR_BACK);
            var image = self.GetSibling("LIST").GetSelectedItem();
            if (image) {
                self.drawCheckerbox();
                draw_sprite(image.picture, 0, 0, 0);
                var hspacing = image.width / image.hframes;
                var vspacing = image.height / image.vframes;
                for (var i = 0; i < image.hframes; i++) {
                    draw_line_colour(hspacing * i, 0, hspacing * i, image.height - 1, c_red, c_red);
                }
                for (var i = 0; i < image.vframes; i++) {
                    draw_line_colour(0, vspacing * i, image.width - 1, vspacing * i, c_red, c_red);
                }
                draw_rectangle_colour(1, 1, image.width - 1, image.height - 1, c_blue, c_blue, c_blue, c_blue, true);
            }
        }, function(mx, my) {
                
        }, function() {
        }))
            .SetID("PREVIEW"),
        new EmuFileDropperListener(function(files) {
            files = self.Filter(files, [".png", ".jpeg", ".jpg", ".jpe", ".bmp"]);
            if (self.root.graphics_list == Game.graphics.tilesets) {
                for (var i = 0, n = array_length(files); i < n; i++) {
                    tileset_create(files[i]);
                }
            } else {
                for (var i = 0, n = array_length(files); i < n; i++) {
                    graphics_add_generic(files[i], self.root.graphics_prefix, self.root.graphics_list, undefined, false);
                }
            }
            self.GetSibling("LIST").Deselect().Select(array_length(self.root.graphics_list) - 1);
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }),
    ])
        .AddDefaultCloseButton();
    
    return dialog;
}
