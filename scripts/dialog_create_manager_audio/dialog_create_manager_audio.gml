function dialog_create_manager_audio() {
    var dialog = new EmuDialog(768, 760, "Audio");
    dialog.audio_prefix = PREFIX_AUDIO_BGM;
    dialog.audio_list = Game.audio.bgm;
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 384;
    var col3 = 736;
    
    
    return dialog.AddContent([
        #region Assets
        (new EmuRadioArray(col1, EMU_AUTO, element_width, element_height, "Type:", 0, function() {
            switch (self.value) {
                case 0: self.root.audio_list = Game.audio.bgm; self.root.audio_prefix = PREFIX_AUDIO_BGM; break;
                case 1: self.root.audio_list = Game.audio.se; self.root.audio_prefix = PREFIX_AUDIO_SE; break;
            }
            self.GetSibling("LIST").Deselect().SetList(self.root.audio_list);
            self.root.Refresh({ list: self.root.audio_list, index: -1 });
        }))
            .AddOptions(["Background Music", "Sound Effects"])
            .SetTooltip("Choose the type of audio")
            .SetID("TYPE"),
        (new EmuList(col1, EMU_AUTO, element_width, element_height, "Audio files:", element_height, 16, function() {
            if (self.root) {
                self.root.Refresh({ list: self._entries, index: self.GetSelection() });
            }
        }))
            .SetNumbered(true)
            .SetList(Game.audio.bgm)
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetTooltip("All of the audio files of the selected type")
            .SetID("LIST"),
        #endregion
        #region Asset management
        (new EmuButton(col2, EMU_BASE, element_width, element_height, "Add Audio", function() {
            var fn = get_open_filename_image();
            if (file_exists(fn)) {
                // todo
                self.GetSibling("LIST").Deselect().Select(array_length(self.root.audio_list) - 1);
                self.root.Refresh({ list: self.root.audio_list, index: self.GetSibling("LIST").GetSelection() });
            }
        }))
            .SetTooltip("Add an audio file")
            .SetID("ADD"),
        (new EmuButton(col2, EMU_AUTO, element_width / 2, element_height, "Delete Audio", function() {
            var audio = self.GetSibling("LIST").GetSelectedItem();
            self.GetSibling("LIST").Deselect();
            array_delete(self.root.audio_list, array_search(self.root.audio_list, audio), 1);
            audio.Destroy();
            self.root.Refresh({ list: self.root.audio_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Delete the audio; any references to it elsewhere will become null")
            .SetID("DELETE"),
        (new EmuButton(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Export Audio", function() {
            try {
                var audio = self.GetSibling("LIST").GetSelectedItem();
                // todo
            } catch (e) {
                wtf("Could not save the audio: " + e.message);
            }
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Save the audio to a file")
            .SetID("EXPORT"),
        (new EmuButton(col2, EMU_AUTO, element_width / 2, element_height, "Reload Audio", function() {
            self.GetSibling("LIST").GetSelectedItem().Reload();
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Automatically reload the audio from its source file (if it exists on the disk)")
            .SetID("RELOAD"),
        (new EmuButton(col2 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "Change Audio", function() {
            var audio = self.GetSibling("LIST").GetSelectedItem();
            var fn = get_open_filename_audio();
            if (file_exists(fn)) {
                audio.source_filename = fn;
                // todo
            }
            self.root.Refresh({ list: self.root.graphics_list, index: self.GetSibling("LIST").GetSelection() });
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            })
            .SetInteractive(false)
            .SetTooltip("Replace the audio")
            .SetID("CHANGE"),
        #endregion
        #region Fundamentals
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Name:", "", "audio name", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            self.GetSibling("LIST").GetSelectedItem().name = self.value;
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].name);
            })
            .SetInteractive(false)
            .SetTooltip("The name of the asset visible in the editor (and/or player)")
            .SetID("NAME"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Internal name:", "", "audio internal name", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITS, function() {
            var audio = self.GetSibling("LIST").GetSelectedItem();
            var already = internal_name_get(self.value);
            if (!already || already == audio) {
                internal_name_remove(audio.internal_name);
                internal_name_set(audio, self.value);
            }
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].internal_name);
            })
            .SetTooltip("The unique internal name that the game can use to identify this asset")
            .SetID("INTERNAL NAME"),
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
        #endregion
    ]).AddDefaultCloseButton();
    
    
    
    var dw = 768;
    var dh = 480;
    
    var dg = dialog_create(dw, dh, name, dialog_default, dialog_destroy, dialog);
    dg.prefix = prefix;
    
    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var c2 = dw / columns;
    var c3 = dw * 2 / columns;
    
    var vx1 = 0;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_list = create_list(16, yy, name, "<no audio>", ew, eh, 12, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var audio = list.entries[selection];
            ui_input_set_value(list.root.el_name, audio.name);
            ui_input_set_value(list.root.el_sample_rate, string(audio.sample_rate));
            ui_input_set_value(list.root.el_name_internal, audio.internal_name);
            ui_input_set_value(list.root.el_loop_start, string(audio.loop_start / audio.sample_rate));
            ui_input_set_value(list.root.el_loop_end, string(audio.loop_end / audio.sample_rate));
        }
    }, false, dg, list);
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.numbered = true;
    dg.el_list = el_list;
    
    var el_add = create_button(c2 + 16, yy, "Add", ew, eh, fa_center, function(button) {
        var fn = get_open_filename_audio();
        if (file_exists(fn)) {
            array_push(button.root.el_list.entries, audio_add(fn, button.root.prefix, button.root.el_loop_start.interactive));
        }
    }, dg);
    el_add.file_dropper_action = function(dropper, files) {
        var filtered_list = ui_handle_dropped_files_filter(files, [".wav", ".mid", ".ogg", ".mp3"]);
        for (var i = 0; i < array_length(filtered_list); i++) {
            array_push(dropper.root.el_list.entries, audio_add(filtered_list[i], dropper.root.prefix, dropper.root.el_loop_start.interactive));
        }
    };
    yy += el_add.height + spacing;
    var el_remove = create_button(c2 + 16, yy, "Delete", ew, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var data = list.entries[selection];
            array_delete(list.entries, array_search(list.entries, data), 1);
            data.Destroy();
            ui_list_deselect(list);
            list.onvaluechange(list);
        }
    }, dg);
    yy += el_remove.height + spacing;
    
    var el_name_text = create_text(c2 + 16, yy, "Name:", ew, eh, fa_left, ew, dg);
    yy += el_name_text.height + spacing;
    var el_name = create_input(c2 + 16, yy, "", ew, eh, function(input) {
        var selection = ui_list_selection(input.root.el_list);
        if (selection + 1) {
            input.root.el_list.entries[selection].name = input.value;
        }
    }, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_name = el_name;
    yy += el_name.height + spacing;
    var el_name_internal_text = create_text(c2 + 16, yy, "Internal Name:", ew, eh, fa_left, ew, dg);
    yy += el_name_internal_text.height + spacing;
    var el_name_internal = create_input(c2 + 16, yy, "", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var already = internal_name_get(input.value);
            if (!already || already == list.entries[selection]) {
                internal_name_remove(list.entries[selection].internal_name);
                internal_name_set(list.entries[selection], input.value);
                input.color = c_black;
            } else {
                input.color = c_red;
            }
        }
    }, "", "A-Za-z0-9_", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    dg.el_name_internal = el_name_internal;
    yy += el_name_internal.height + spacing;
    
    var xx = c2 + 16;
    var el_play = create_button(xx, yy, "Play", ew / 4, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var what = list.entries[selection];
            wtf("To do - play audio");
        }
    }, dg);
    xx = xx + ((ew - 32) / 4);
    var el_pause = create_button(xx, yy, "Pause", ew / 4, eh, fa_center, function(button) {
            wtf("To do - pause audio");
    }, dg);
    xx = xx + ((ew - 32) / 4);
    var el_resume = create_button(xx, yy, "Rsm.", ew / 4, eh, fa_center, function(button) {
            wtf("To do - resume audio");
    }, dg);
    xx = xx + ((ew - 32) / 4);
    var el_stop = create_button(xx, yy, "Stop", ew / 4, eh, fa_center, function(button) {
            wtf("To do - stop audio");
    }, dg);
    
    yy += el_play.height + spacing * 2;
    var el_effects = create_text(c2 + 16, yy, "Effects such as volume, pitch, etc can be defined when the sound is played in-game.", ew, eh, fa_left, ew, dg);
    yy += el_effects.height + spacing * 2;
    
    vx1 = dw / (columns * 2) - 16;
    vy1 = 0;
    vx2 = vx1 + 80 + 32;
    vy2 = eh;
    
    yy = yy_base;
    
    var el_sample_rate = create_input(c3 + 16, yy, "Sample Rate:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            list.entries[selection].SetSampleRate(real(input.value));
        }
    }, 0, "hertz", validate_int, 0, 0xffffff, 8, vx1, vy1, vx2, vy2, dg);
    dg.el_sample_rate = el_sample_rate;
    yy += el_sample_rate.height + spacing;
    xx = c3 + 16;
    var el_rate_441 = create_button(xx, yy, "44.1 KHz", ew / 2, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var what = list.entries[selection];
            what.SetSampleRate(44100);
            ui_input_set_value(button.root.el_sample_rate, string(what.sample_rate));
        }
    }, dg);
    xx = xx + ((ew - 32) / 2);
    var el_rate_48 = create_button(xx, yy, "48 KHz", ew / 2, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var what = list.entries[selection];
            what.SetSampleRate(48000);
            ui_input_set_value(button.root.el_sample_rate, string(what.sample_rate));
        }
    }, dg);
    xx = xx + ((ew - 32) / 2);
    yy += el_rate_441.height + spacing;
    var el_length = create_text(c3 + 16, yy, "Length: N/A", ew, eh, fa_left, ew, dg);
    el_length.render = function(text, x, y) {
        var list = text.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var audio = list.entries[selection];
            text.text = "Length: N/A";
            wtf("To do - get audio length");
        } else {
            text.text = "Length: N/A";
        }
        ui_render_text(text, x, y);
    };
    dg.el_length = el_length;
    yy += el_length.height + spacing;
    
    var el_loop_start = create_input(c3 + 16, yy, "Loop Start:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var audio = list.entries[selection];
            audio.loop_start = real(input.value) * audio.sample_rate;
        }
    }, 0, "seconds", validate_double, 0, 10000, 8, vx1, vy1, vx2, vy2, dg);
    dg.el_loop_start = el_loop_start;
    yy += el_loop_start.height + spacing;
    var el_loop_end = create_input(c3 + 16, yy, "Loop End:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var audio = list.entries[selection];
            audio.loop_end = real(input.value) * audio.sample_rate;
        }
    }, 0, "seconds", validate_double, 0, 10000, 8, vx1, vy1, vx2, vy2, dg);
    dg.el_loop_end = el_loop_end;
    yy += el_loop_end.height + spacing;
    var el_loop_progress = create_progress_bar(c3 + 16, yy, ew, eh, function(progress) {
        /// @todo this
    }, 8, 0, dg);
    el_loop_progress.render = function(progress, x, y) {
        /// @todo this
        progress.value = 0;
        
        var list = progress.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var audio = list.entries[selection];
            var length = 1;
            var padding = 16;
            var x1 = x + progress.x + padding;
            var y1 = y + progress.y;
            var x2 = x1 + progress.width - padding * 2;
            var y2 = y1 + progress.height;
            
            var mid_yy = mean(y1, y2);
            var bar_y1 = mid_yy - progress.thickness / 2 + 2;
            var bar_y2 = mid_yy + progress.thickness / 2 - 2;
            var loop_start_x = x1 + audio.loop_start / length * (x2 - x1);
            var loop_end_x = x1 + audio.loop_end / length * (x2 - x1);
            
            draw_line_width_color(loop_start_x, bar_y1, loop_start_x, bar_y2, 2, c_red, c_red);
            draw_line_width_color(loop_end_x, bar_y1, loop_end_x, bar_y2, 2, c_red, c_red);
        }
        
        ui_render_progress_bar(progress, x, y);
    };
    dg.el_loop_progress = el_loop_progress;
    yy += el_loop_progress.height + spacing;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_list,
        el_add,
        el_remove,
        el_play,
        el_pause,
        el_resume,
        el_stop,
        el_name_text,
        el_name,
        el_name_internal_text,
        el_name_internal,
        el_effects,
        el_sample_rate,
        el_rate_441,
        el_rate_48,
        el_length,
        el_loop_start,
        el_loop_end,
        el_loop_progress,
        el_confirm
    );
    
    return dg;
}