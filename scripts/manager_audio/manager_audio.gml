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
                self.root.Refresh({ list: self.entries, index: self.GetSelection() });
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
        #region Playback
        (new EmuButton(col2 + 0 * element_width / 4, EMU_AUTO, element_width / 4, element_height, "Play", function() {
            // todo
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            }),
        (new EmuButton(col2 + 1 * element_width / 4, EMU_INLINE, element_width / 4, element_height, "Pause", function() {
            // todo
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            }),
        (new EmuButton(col2 + 2 * element_width / 4, EMU_INLINE, element_width / 4, element_height, "Resume", function() {
            // todo
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            }),
        (new EmuButton(col2 + 3 * element_width / 4, EMU_INLINE, element_width / 4, element_height, "Stop", function() {
            // todo
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            }),
        #endregion
        #region Sample stuff
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Sample rate:", "", "usually 44100 or 48000", 6, E_InputTypes.INT, function() {
            self.GetSibling("LIST").GetSelectedItem().SetSampleRate(real(self.value));
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].sample_rate);
            })
            .SetRealNumberBounds(22050, 192000)
            .SetInteractive(false)
            .SetTooltip("The sample rate of this audio clip")
            .SetID("SAMPLE RATE"),
        (new EmuButton(col2 + 0 * element_width / 2, EMU_AUTO, element_width / 2, element_height, "44,100 Hz", function() {
            self.GetSibling("LIST").GetSelectedItem().SetSampleRate(44100);
            self.GetSibling("SAMPLE RATE").SetValue(44100);
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            }),
        (new EmuButton(col2 + 1 * element_width / 2, EMU_INLINE, element_width / 2, element_height, "48,000 Hz", function() {
            self.GetSibling("LIST").GetSelectedItem().SetSampleRate(48000);
            self.GetSibling("SAMPLE RATE").SetValue(48000);
        }))
            .SetRefresh(function(data) {
                self.SetInteractive(data.index != -1);
            }),
        (new EmuText(col2, EMU_AUTO, element_width, 24, "Length: N/A"))
            .SetRefresh(function(data) {
                self.text = "Length: [c_orange]To do - get audio length";
            }),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Loop start:", "", "seconds", 8, E_InputTypes.REAL, function() {
            var audio = self.GetSibling("LIST").GetSelectedItem();
            audio.loop_start = real(self.value) * audio.sample_rate;
        }))
            .SetRefresh(function(data) {
                self.SetInteractive((data.index != -1) && (self.root.audio_list == Game.audio.bgm));
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].loop_start / data.list[data.index].sample_rate);
                self.SetRealNumberBounds(0, 100000);
                wtf("loop start - set real number bounds 0 through the length of the audio clip (in seconds)");
            })
            .SetInteractive(false)
            .SetTooltip("The starting point of the loop of this audio clip")
            .SetID("LOOP START"),
        (new EmuInput(col2, EMU_AUTO, element_width, element_height, "Loop end:", "", "seconds", 8, E_InputTypes.REAL, function() {
            var audio = self.GetSibling("LIST").GetSelectedItem();
            audio.loop_end = real(self.value) * audio.sample_rate;
        }))
            .SetRefresh(function(data) {
                self.SetInteractive((data.index != -1) && (self.root.audio_list == Game.audio.bgm));
                if (data.index == -1) return;
                self.SetValue(data.list[data.index].loop_end / data.list[data.index].sample_rate);
                self.SetRealNumberBounds(0, 100000);
                wtf("loop end - set real number bounds 0 through the length of the audio clip (in seconds)");
            })
            .SetInteractive(false)
            .SetTooltip("The ending point of the loop of this audio clip")
            .SetID("LOOP END"),
        #endregion
        (new EmuProgressBar(col2, EMU_AUTO, element_width, element_height, 12, 0, 1, false, 0, emu_null))
            .SetUpdate(function() {
                self.value = 0;
                // to do - playback head position
            })
            .SetInteractive(false)
            .SetTooltip("Audio playback status")
            .SetID("PLAYBACK BAR")
    ]).AddDefaultCloseButton();
}