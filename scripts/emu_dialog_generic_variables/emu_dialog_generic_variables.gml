function emu_dialog_generic_variables(list) {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 672, "Data Settings: Game Constants");
    dialog.list = list;
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Constants", element_height, 14, function() {
            if (self.root) self.root.Refresh(self.GetSelection());
        }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(list)
            .SetCallbackMiddle(function() {
                var selection = self.GetSelectedItem();
                array_sort_name(self.root.list);
                if (!selection) return;
                self.Select(array_search(self.root.list, selection), true);
            })
            .SetID("LIST"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Constant", function() {
            if (array_length(self.root.list) < 0xffff) {
                array_push(self.root.list, new DataValue("Constant" + string(array_length(self.root.list))));
            }
            self.root.Refresh();
        }))
            .SetInteractive(false)
            .SetRefresh(function(data) {
                self.SetInteractive(array_length(self.root.list) < 0xffff);
            }),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Delete Constant", function() {
            array_delete(self.root.list, self.GetSibling("LIST").GetSelection(), 1);
            self.root.Refresh();
        }))
            .SetInteractive(false)
            .SetRefresh(function(data) {
                self.SetInteractive(data != -1 && array_length(self.root.list) > 0);
            }),
        (new EmuInput(col2, EMU_BASE, element_width, element_height, "Name:", "", "constant name", VISIBLE_NAME_LENGTH, E_InputTypes.LETTERSDIGITSANDUNDERSCORES, function() {
            self.root.list[self.GetSibling("LIST").GetSelection()].name = self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function(data) {
                self.SetInteractive(data != -1);
                if (data == -1) return;
                self.SetValue(self.root.list[data].name);
            }),
        (new EmuList(col2, EMU_AUTO, element_width, element_height, "Type:", element_height, 10, function() {
            if (!self.root) return;
            var selection = self.GetSelection();
            if (selection == -1) return;
            var data = self.root.list[self.GetSibling("LIST").GetSelection()];
            var original = data.type;
            data.type = self.GetSelection();
            if (original != data.type) {
                data.value = Stuff.data_type_meta[selection].default_value;
                data.type_guid = NULL;
                self.root.Refresh(self.GetSibling("LIST").GetSelection());
            }
        }))
            .SetInteractive(false)
            .SetRefresh(function(data) {
                self.SetInteractive(data != -1);
                if (data == -1) return;
                self.Deselect();
                self.Select(self.root.list[data].type, true);
            })
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetAllowDeselect(false)
            .SetList(Stuff.data_type_meta)
            .SetID("TYPE"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Value:", "", "value", 100, E_InputTypes.STRING, function() {
            var data = self.root.list[self.GetSibling("LIST").GetSelection()];
            data.value = (data.type == DataTypes.INT || data.type == DataTypes.FLOAT) ? real(self.value) : self.value;
        }))
            .SetInteractive(false)
            .SetRealNumberBounds(-0x80000000, 0x7fffffff)
            .SetRefresh(function(data) {
                self.SetInteractive(false);
                if (data == -1) return;
                
                var what = self.root.list[data];
                
                switch (what.type) {
                    case DataTypes.INT:
                        self.SetInteractive(true);
                        self.SetValueType(E_InputTypes.INT);
                        self.SetCharacterLimit(10);
                        self.SetValue(what.value);
                        break;
                    case DataTypes.FLOAT:
                        self.SetInteractive(true);
                        self.SetValueType(E_InputTypes.REAL);
                        self.SetCharacterLimit(10);
                        self.SetValue(what.value);
                        break;
                    case DataTypes.STRING:
                        self.SetInteractive(true);
                        self.SetValueType(E_InputTypes.STRING);
                        self.SetCharacterLimit(100);
                        self.SetValue(what.value);
                        break;
                }
            }),
        (new EmuCheckbox(col2, EMU_AUTO, element_width, element_height, "Value:", false, function() {
            self.root.list[self.GetSibling("LIST").GetSelection()].value = self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function(data) {
                self.SetInteractive(false);
                if (data == -1) return;
                
                if (self.root.list[data].type == DataTypes.BOOL) {
                    self.SetInteractive(true);
                    self.SetValue(self.root.list[data].value);
                }
            }),
        (new EmuColorPicker(col2, EMU_AUTO, element_width, element_height, "Color:", 0xff000000, function() {
            self.root.list[self.GetSibling("LIST").GetSelection()].value = self.value;
        }))
            .SetInteractive(false)
            .SetAlphaUsed(true)
            .SetRefresh(function(data) {
                self.SetInteractive(false);
                if (data == -1) return;
                if (self.root.list[data].type == DataTypes.COLOR) {
                    self.SetInteractive(true);
                    self.SetValue(self.root.list[data].value);
                }
            }),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Event...", function() {
            var what = self.root.list[self.GetSibling("LIST").GetSelection()];
            emu_dialog_get_event(guid_get(what.value), function() {
                var selection = self.GetSibling("ENTRYPOINTS").GetSelectedItem();
                self.root.data.value = selection ? selection.GUID : NULL;
            }, what);
        }))
            .SetUpdate(function() {
                var what = self.GetSibling("LIST").GetSelectedItem();
                self.text = "Event...";
                if (!what) return;
                if (what.type == DataTypes.EVENT) {
                    var event = guid_get(what.value);
                    if (event) self.text = event.GetShortName();
                }
            })
            .SetInteractive(false)
            .SetRefresh(function(data) {
                self.SetInteractive(false);
                self.text = "Event...";
                if (data == -1) return;
                self.SetInteractive(self.root.list[data].type == DataTypes.EVENT);
            }),
        (new EmuList(col3, EMU_BASE, element_width, element_height, "", element_height, 16, function() {
            var selection = self.GetSelection();
            if (selection == -1) return;
            self.root.list[self.GetSibling("LIST").GetSelection()].value = self.GetSelectedItem().GUID;
        }))
            .SetInteractive(false)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetRefresh(function(data) {
                self.SetInteractive(false);
                self.Deselect();
                self.enabled = false;
                if (data == -1) return;
                var what = self.root.list[data];
                var value = guid_get(what.value);
                self.text = Stuff.data_type_meta[what.type].name + ":";
                
                switch (what.type) {
                    case DataTypes.MESH:
                        self.SetList(Game.meshes);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.meshes, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.MESH_AUTOTILE:
                        self.SetList(Game.mesh_autotiles);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.mesh_autotiles, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.IMG_TEXTURE:
                        self.SetList(Game.graphics.tilesets);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.graphics.tilesets, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.IMG_TILE_ANIMATION:
                        self.SetList(Game.graphics.tile_animations);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.graphics.tile_animations, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.IMG_BATTLER:
                        self.SetList(Game.graphics.battlers);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.graphics.battlers, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.IMG_OVERWORLD:
                        self.SetList(Game.graphics.overworlds);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.graphics.overworlds, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.IMG_PARTICLE:
                        self.SetList(Game.graphics.particles);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.graphics.particles, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.IMG_UI:
                        self.SetList(Game.graphics.ui);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.graphics.ui, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.IMG_ETC:
                        self.SetList(Game.graphics.etc);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.graphics.etc, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.IMG_SKYBOX:
                        self.SetList(Game.graphics.skybox);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.graphics.skybox, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.AUDIO_BGM:
                        self.SetList(Game.audio.bgm);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.audio.bgm, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.AUDIO_SE:
                        self.SetList(Game.audio.se);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.audio.se, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.ANIMATION:
                        self.SetList(Game.animations);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.animations, value), true);
                        self.enabled = true;
                        break;
                    case DataTypes.MAP:
                        self.SetList(Game.maps);
                        self.SetInteractive(true);
                        self.Select(array_search(Game.maps, value), true);
                        self.enabled = true;
                        break;
                }
            })
            .SetID("GENERIC"),
        (new EmuList(col3, EMU_INLINE, element_width, element_height, "Value type:", element_height, 8, function() {
            var selection = self.GetSelection();
            if (selection == -1) return;
            var data_index = self.GetSibling("LIST").GetSelection();
            var data = self.root.list[data_index];
            var type = Game.data[selection];
            var previous_type = data.type_guid;
            data.type_guid = type.GUID;
            if (type.GUID != previous_type) {
                data.value = NULL;
                self.GetSibling("DATA GUID").Refresh(data_index);
            }
            // if you select an enum but the type is data or vice versa,
            // update the constant's type instead of trying to restrict it
            if (type.type != data.type) {
                data.type = type.type;
                self.GetSibling("TYPE").Refresh(data_index);
            }
        }))
            .SetEnabled(false)
            .SetInteractive(false)
            .SetList(Game.data)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetRefresh(function(data) {
                self.SetInteractive(false);
                self.Deselect();
                self.enabled = false;
                if (data == -1) return;
                var what = self.root.list[data];
                
                if (what.type == DataTypes.DATA || what.type == DataTypes.ENUM) {
                    self.SetInteractive(true);
                    self.Select(array_search(Game.data, guid_get(what.type_guid)), true);
                    self.text = "Value type:";
                    self.enabled = true;
                }
            })
            .SetID("TYPE GUID"),
        (new EmuList(col3, EMU_AUTO, element_width, element_height, "Instance:", element_height, 8, function() {
            if (self.GetSelection() == -1) return;
            var data = self.root.list[self.GetSibling("LIST").GetSelection()];
            data.value = self.GetSelectedItem().GUID;
        }))
            .SetEnabled(false)
            .SetInteractive(false)
            .SetRefresh(function(data) {
                self.SetInteractive(false);
                self.Deselect();
                self.SetEnabled(false);
                if (data == -1) return;
                
                var what = self.root.list[data];
                
                switch (what.type) {
                    case DataTypes.DATA:
                        var type_selection = self.GetSibling("TYPE GUID").GetSelection();
                        if (type_selection == -1) {
                            self.SetList([]);
                            return;
                        }
                        var type = Game.data[type_selection];
                        self.SetList(type.instances);
                        self.Select(array_search(type.instances, guid_get(what.value)), true);
                        self.SetInteractive(true);
                        self.SetEnabled(true);
                        break;
                    case DataTypes.ENUM:
                        var type_selection = self.GetSibling("TYPE GUID").GetSelection();
                        if (type_selection == -1) {
                            self.SetList([]);
                            return;
                        }
                        var type = Game.data[type_selection];
                        self.SetList(type.properties);
                        self.Select(array_search(type.properties, guid_get(what.value)), true);
                        self.SetInteractive(true);
                        self.SetEnabled(true);
                        break;
                }
            })
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetID("DATA GUID")
    ]).AddDefaultCloseButton();
}