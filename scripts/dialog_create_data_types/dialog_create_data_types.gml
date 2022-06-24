function dialog_create_data_types() {
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32 + 320 + 32, 760, "Data Types");
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    var col3 = 32 + 320 + 32 + 320 + 32;
    
    return dialog.AddContent([
        #region column 1
        (new EmuList(col1, EMU_BASE, element_width, element_height, "Data types: " + string(array_length(Game.data)), element_height, 13, function() {
            if (!self.root) return;
            self.root.Refresh();
        }))
            .SetCallbackMiddle(function() {
                var selection = self.GetSelectedItem();
                
                // alphabetize the data types with enums at the top
                var list_data = [];
                var list_enums = [];
                for (var i = 0; i < array_length(Game.data); i++) {
                    var data = Game.data[i];
                    if (data.type == DataTypes.ENUM) {
                        array_push(list_enums, data);
                    } else {
                        array_push(list_data, data);
                    }
                }
                
                // Normally you'd just use the list sort funciton on the source lists since they
                // don't modify them, but in this case we want the enums to always go at the top
                var list_enums_sorted = array_sort_name(list_enums);
                var list_data_sorted = array_sort_name(list_data);
                
                for (var i = 0, n = array_length(list_enums_sorted); i < n; i++) {
                    Game.data[i] = list_enums_sorted[i];
                }
                var enums_count = array_length(list_enums_sorted);
                for (var i = 0, n = array_length(list_data_sorted); i < n; i++) {
                    Game.data[i + enums_count] = list_data_sorted[i];
                }
                
                self.Deselect();
                self.Select(array_search(Game.data, selection), true);
            })
            .SetListColors(function(index) {
                return (self.At(index).type == DataTypes.ENUM) ? c_aqua : c_white;
            })
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(Game.data)
            .SetID("LIST"),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Data", function() {
            array_push(Game.data, new DataClass("DataType" + string(array_length(Game.data))));
            var list = self.GetSibling("LIST");
            list.text = "Data types: " + string(array_length(Game.data));
            list.Deselect();
            list.Select(array_length(Game.data) - 1, true);
        })),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Add Enum", function() {
            var type = new DataClass("Enum" + string(array_length(Game.data)));
            type.type = DataTypes.ENUM;
            array_push(Game.data, type);
            var list = self.GetSibling("LIST");
            list.text = "Data types: " + string(array_length(Game.data));
            list.Deselect();
            list.Select(array_length(Game.data) - 1, true);
        })),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Move Up", function() {
            var list = self.GetSibling("LIST");
            var selection = list.GetSelection();
            var t = Game.data[selection];
            Game.data[selection] = Game.data[selection - 1];
            Game.data[selection - 1] = t;
            list.Deselect();
            list.Select(selection - 1, true);
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelection();
                self.SetInteractive(selection >= 1);
            }),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Move Down", function() {
            var list = self.GetSibling("LIST");
            var selection = list.GetSelection();
            var t = Game.data[selection];
            Game.data[selection] = Game.data[selection + 1];
            Game.data[selection + 1] = t;
            list.Deselect();
            list.Select(selection + 1, true);
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelection();
                self.SetInteractive(selection != -1 && selection < array_length(Game.data) - 1);
            }),
        (new EmuButton(col1, EMU_AUTO, element_width, element_height, "Delete", function() {
            var list = self.GetSibling("LIST");
            var selection = list.GetSelectedItem();
            if (selection) {
                selection.Destroy();
                self.root.Refresh();
            }
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
            }),
        #endregion
        #region column 2
        (new EmuInput(col2, EMU_BASE, element_width, element_height, "Name:", "", "data name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            self.GetSibling("LIST").GetSelectedItem().name = self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetValue(selection.name);
                }
            }),
        (new EmuCheckbox(col2, EMU_AUTO, element_width, element_height, "Don't Localize", false, function() {
            var item = self.GetSibling("LIST").GetSelectedItem();
            item.flags &= ~DataDataFlags.NO_LOCALIZE;
            item.flags |= DataDataFlags.NO_LOCALIZE * self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetValue((selection.flags & DataDataFlags.NO_LOCALIZE) > 0);
                }
            })
            .SetTooltip("This data type will not have any of its properties localized (this overrides individual options)"),
        (new EmuCheckbox(col2, EMU_AUTO, element_width / 2, element_height, "Exclude Name?", false, function() {
            var item = self.GetSibling("LIST").GetSelectedItem();
            item.flags &= ~DataDataFlags.NO_LOCALIZE_NAME;
            item.flags |= DataDataFlags.NO_LOCALIZE_NAME * self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetValue((selection.flags & DataDataFlags.NO_LOCALIZE_NAME) > 0);
                }
            })
            .SetTooltip("This data's name will not be localized (regardless of the above setting)"),
        (new EmuCheckbox(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Summary?", false, function() {
            var item = self.GetSibling("LIST").GetSelectedItem();
            item.flags &= ~DataDataFlags.NO_LOCALIZE_SUMMARY;
            item.flags |= DataDataFlags.NO_LOCALIZE_SUMMARY * self.value;
        }))
            .SetInteractive(false)
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetValue((selection.flags & DataDataFlags.NO_LOCALIZE_SUMMARY) > 0);
                }
            })
            .SetTooltip("This data's name will not be localized (regardless of the above setting)"),
        (new EmuList(col2, EMU_AUTO, element_width, element_height, "Properties:", element_height, 9, function() {
            if (!self.root) return;
            self.GetSibling("PROPERTY SETTINGS").Refresh();
            self.GetSibling("PROPERTY CONTROLS").Refresh();
        }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetVacantText("<name is implicit>")
            .SetRefresh(function() {
                var selection = self.GetSibling("LIST").GetSelectedItem();
                self.SetInteractive(!!selection);
                if (!!selection) {
                    self.SetList(selection.properties);
                }
            })
            .SetID("PROPERTIES"),
        (new EmuCore(col2, EMU_AUTO, dialog.width, dialog.height)).AddContent([
            (new EmuButton(0, 0, element_width, element_height, "Add Property", function() {
                var selection = self.root.GetSibling("LIST").GetSelectedItem();
                selection.AddProperty(new DataProperty("Property" + string(array_length(selection.properties)), selection));
                self.root.Refresh();
            }))
                .SetRefresh(function() {
                    self.SetInteractive(!!self.root.GetSibling("LIST").GetSelectedItem());
                }),
            (new EmuButton(0, EMU_AUTO, element_width, element_height, "Move Up", function() {
                var property_list = self.root.GetSibling("PROPERTIES");
                self.root.GetSibling("LIST").GetSelectedItem().MovePropertyUp(property_list.GetSelectedItem());
                var selection = property_list.GetSelection();
                property_list.Deselect();
                property_list.Select(selection - 1, true);
            }))
                .SetRefresh(function() {
                    var datatype = self.root.GetSibling("LIST").GetSelectedItem();
                    var selection = self.root.GetSibling("PROPERTIES").GetSelection();
                    self.SetInteractive(!!datatype && selection >= 1);
                }),
            (new EmuButton(0, EMU_AUTO, element_width, element_height, "Move Down", function() {
                var property_list = self.root.GetSibling("PROPERTIES");
                self.root.GetSibling("LIST").GetSelectedItem().MovePropertyDown(property_list.GetSelectedItem());
                var selection = property_list.GetSelection();
                property_list.Deselect();
                property_list.Select(selection + 1, true);
            }))
                .SetRefresh(function() {
                    var datatype = self.root.GetSibling("LIST").GetSelectedItem();
                    var property = self.root.GetSibling("PROPERTIES").GetSelection();
                    self.SetInteractive(!!datatype && property != -1 && property != array_length(datatype.properties) - 1);
                }),
            (new EmuButton(0, EMU_AUTO, element_width, element_height, "Delete Property", function() {
                var property_list = self.root.GetSibling("PROPERTIES");
                var datatype = self.root.GetSibling("LIST").GetSelectedItem();
                datatype.RemoveProperty(property_list.GetSelectedItem());
                var index = property_list.GetSelection();
                property_list.Deselect();
                if (array_length(datatype.properties) > 0) {
                    property_list.Select(min(index, array_length(datatype.properties) - 1), true);
                }
            }))
                .SetRefresh(function() {
                    self.SetInteractive(!!self.root.GetSibling("LIST").GetSelectedItem());
                }),
        ])
            .SetContentsInteractive(true)
            .SetOverrideRootCheck(true)
            .SetID("PROPERTY CONTROLS"),
        #endregion
        #region column 3
        (new EmuCore(col3, EMU_BASE, element_width, dialog.height)).AddContent([
            (new EmuInput(0, 0, element_width, element_height, "Name:", "", "property name", VISIBLE_NAME_LENGTH, E_InputTypes.LETTERSDIGITSANDUNDERSCORES, function() {
                self.root.GetSibling("PROPERTIES").GetSelectedItem().name = self.value;
            }))
                .SetInteractive(false)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetInteractive(!!property);
                    if (property) {
                        self.SetValue(property.name);
                    }
                }),
            (new EmuRadioArray(0, EMU_AUTO, element_width, element_height, "Type:", -1, function() {
                self.root.GetSibling("PROPERTIES").GetSelectedItem().type = self.value;
                self.root.Refresh();
            }))
                .SetInteractive(false)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetInteractive(!!property);
                    if (property) {
                        self.SetValue(property.type);
                    }
                })
                .AddOptions(["Int", "Enum", "Float", "String", "Boolean", "Data"]),
            (new EmuButton(0, EMU_AUTO, element_width, element_height, "Other types...", function() {
                dialog_create_select_data_types_ext(self/*button*/.root/*dialog*/, self.root.GetSibling("PROPERTIES").GetSelectedItem().type, function() {
                    self.root.root.GetSibling("PROPERTIES").GetSelectedItem().type = self.value;
                    self.root.root.Refresh();
                });
            }))
                .SetInteractive(false)
                .SetRefresh(function() {
                    self.SetInteractive(!!self.root.GetSibling("PROPERTIES").GetSelectedItem());
                }),
            (new EmuInput(0, EMU_AUTO, element_width, element_height, "Capacity:", "", "1 for a single value, more than that for an array of values", 3, E_InputTypes.INT, function() {
                self.root.GetSibling("PROPERTIES").GetSelectedItem().max_size = real(self.value);
            }))
                .SetInteractive(false)
                .SetRealNumberBounds(1, 255)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetInteractive(!!property);
                    if (property) {
                        self.SetValue(property.max_size);
                    }
                }),
            (new EmuCheckbox(0, EMU_AUTO, element_width, element_height, "Capacity can be zero?", false, function() {
                self.root.GetSibling("PROPERTIES").GetSelectedItem().size_can_be_zero = self.value;
            }))
                .SetTooltip("List values are optionally allowed to have their capacity be zero.")
                .SetInteractive(false)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetInteractive(!!property && property.max_size > 1);
                    if (property) {
                        self.SetValue(property.size_can_be_zero);
                    }
                }),
            (new EmuCore(0, EMU_AUTO, element_width, element_height)).AddContent([
                (new EmuButton(0, 0, element_width, element_height, "Code...", function() {
                    emu_dialog_notice("create some new code editor sometime maybe");
                }))
            ])
                .SetContentsInteractive(true)
                .SetOverrideRootCheck(true)
                .SetEnabled(false)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetEnabled(!!property && property.type == DataTypes.CODE);
                })
                .SetID("CODE DEFAULTS"),
            (new EmuCore(0, EMU_INLINE, element_width, element_height)).AddContent([
                (new EmuButton(0, 0, element_width, element_height, "Type:", function() {
                    var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                    if (property.type == DataTypes.ENUM) {
                        dialog_create_data_enum_select(self.root.root, function() {
                            if (!self.root) return;
                            var selection = self.GetSibling("LIST").GetSelectedItem();
                            self.root.root.GetSibling("PROPERTIES").GetSelectedItem().type_guid = selection ? selection.GUID : NULL;
                            self.root.root.Refresh();
                        });
                    } else {
                        dialog_create_data_data_select(self.root.root, function() {
                            if (!self.root) return;
                            var selection = self.GetSibling("LIST").GetSelectedItem();
                            self.root.root.GetSibling("PROPERTIES").GetSelectedItem().type_guid = selection ? selection.GUID : NULL;
                            self.root.root.Refresh();
                        });
                    }
                }))
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!property) return;
                        var type = guid_get(property.type_guid);
                        self.text = type ? ("Type: " + type.name) : "Type: (Select)";
                    })
            ])
                .SetContentsInteractive(true)
                .SetOverrideRootCheck(true)
                .SetEnabled(false)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetEnabled(!!property && ((property.type == DataTypes.DATA) || (property.type == DataTypes.ENUM)));
                })
                .SetID("DATA DEFAULTS"),
            (new EmuCore(0, EMU_INLINE, element_width, element_height)).AddContent([
                (new EmuInput(0, 0, element_width, element_height, "Default:", "", "default string", 250, E_InputTypes.STRING, function() {
                    self.root.root.GetSibling("PROPERTIES").GetSelectedItem().default_string = self.value;
                }))
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!!property && property.type == DataTypes.STRING) {
                            self.SetValue(property.default_string);
                        }
                    }),
                (new EmuInput(0, EMU_AUTO, element_width, element_height, "Character limit:", "", "how much text", 3, E_InputTypes.INT, function() {
                    self.root.root.GetSibling("PROPERTIES").GetSelectedItem().char_limit = real(self.value);
                }))
                    .SetRealNumberBounds(1, 1000)
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!!property && property.type == DataTypes.STRING) {
                            self.SetValue(property.char_limit);
                        }
                    }),
                (new EmuCheckbox(0, EMU_AUTO, element_width, element_height, "Don't localize?", false, function() {
                    self.root.root.GetSibling("PROPERTIES").GetSelectedItem().flags ^= DataPropertyFlags.NO_LOCALIZE;
                }))
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!!property && property.type == DataTypes.STRING) {
                            self.SetValue((property.flags & DataPropertyFlags.NO_LOCALIZE) > 0);
                        }
                    })
            ])
                .SetContentsInteractive(true)
                .SetOverrideRootCheck(true)
                .SetEnabled(false)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetEnabled(!!property && property.type == DataTypes.STRING);
                })
                .SetID("STRING DEFAULTS"),
            (new EmuCore(0, EMU_INLINE, element_width, element_height)).AddContent([
                (new EmuInput(0, 0, element_width, element_height, "Default:", "", "default number", 10, E_InputTypes.INT, function() {
                    var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                    if (property.type == DataTypes.INT) {
                        property.default_int = real(self.value);
                    } else {
                        property.default_real = real(self.value);
                    }
                }))
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!!property){
                            if (property.type == DataTypes.INT) {
                                self.SetValue(property.default_int);
                                self.SetValueType(E_InputTypes.INT);
                                self.SetRealNumberBounds(-0x800000, 0x7fffff)
                            } else if (property.type == DataTypes.FLOAT) {
                                self.SetValue(property.default_real);
                                self.SetValueType(E_InputTypes.REAL);
                                self.SetRealNumberBounds(-100000000, 100000000)
                            }
                        }
                    }),
                (new EmuInput(0, EMU_AUTO, element_width, element_height, "Min:", "", "min value", 10, E_InputTypes.INT, function() {
                    self.root.root.GetSibling("PROPERTIES").GetSelectedItem().range_min = real(self.value);
                }))
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!!property){
                            self.SetValue(property.range_min);
                            if (property.type == DataTypes.INT) {
                                self.SetValueType(E_InputTypes.INT);
                                self.SetRealNumberBounds(-0x80000000, 0x7fffffff)
                            } else if (property.type == DataTypes.FLOAT) {
                                self.SetValueType(E_InputTypes.REAL);
                                self.SetRealNumberBounds(-10000000000, 10000000000)
                            }
                        }
                    }),
                (new EmuInput(0, EMU_AUTO, element_width, element_height, "Max:", "", "max value", 10, E_InputTypes.INT, function() {
                    self.root.root.GetSibling("PROPERTIES").GetSelectedItem().range_max = real(self.value);
                }))
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!!property){
                            self.SetValue(property.range_max);
                            if (property.type == DataTypes.INT) {
                                self.SetValueType(E_InputTypes.INT);
                                self.SetRealNumberBounds(-0x80000000, 0x7fffffff)
                            } else if (property.type == DataTypes.FLOAT) {
                                self.SetValueType(E_InputTypes.REAL);
                                self.SetRealNumberBounds(-10000000000, 10000000000)
                            }
                        }
                    }),
                (new EmuRadioArray(0, EMU_AUTO, element_width, element_height, "Scale:", 0, function() {
                    self.root.root.GetSibling("PROPERTIES").GetSelectedItem().number_scale = self.value;
                }))
                    .AddOptions(["Linear", "Quadratic", "Exponential"])
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!!property && (property.type == DataTypes.INT || property.type == DataTypes.FLOAT)){
                            self.SetValue(property.number_scale);
                        }
                    }),
            ])
                .SetContentsInteractive(true)
                .SetOverrideRootCheck(true)
                .SetEnabled(false)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetEnabled(!!property && (property.type == DataTypes.INT || property.type == DataTypes.FLOAT));
                })
                .SetID("NUMERICAL DEFAULTS"),
            (new EmuCore(0, EMU_INLINE, element_width, element_height)).AddContent([
                (new EmuCheckbox(0, 0, element_width, element_height, "Default value", false, function() {
                    self.root.root.GetSibling("PROPERTIES").GetSelectedItem().default_int = self.value;
                }))
                    .SetRefresh(function() {
                        var property = self.root.root.GetSibling("PROPERTIES").GetSelectedItem();
                        if (!!property && property.type == DataTypes.BOOL) {
                            self.SetValue(property.default_int);
                        }
                    })
            ])
                .SetContentsInteractive(true)
                .SetOverrideRootCheck(true)
                .SetEnabled(false)
                .SetRefresh(function() {
                    var property = self.root.GetSibling("PROPERTIES").GetSelectedItem();
                    self.SetEnabled(!!property && property.type == DataTypes.BOOL);
                })
                .SetID("BOOL DEFAULTS"),
        ])
            .SetContentsInteractive(true)
            .SetOverrideRootCheck(true)
            .SetInteractive(true)
            .SetID("PROPERTY SETTINGS"),
        #endregion
    ]).AddDefaultCloseButton();
}