function dialog_create_manager_audio(dialog, name, prefix, list, show_loop_controls) {
    var dw = 768;
    var dh = 480;
    
    var dg = dialog_create(dw, dh, name, dialog_default, dc_default, dialog);
    dg.prefix = prefix;
    dg.show_loop_controls = show_loop_controls;
    
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
            var audio = list.entries[| selection];
            ui_input_set_value(list.root.el_name, audio.name);
            ui_input_set_value(list.root.el_sample_rate, string(audio.fmod_rate));
            ui_input_set_value(list.root.el_name_internal, audio.internal_name);
            if (list.root.el_loop_start) ui_input_set_value(list.root.el_loop_start, string(audio.loop_start / audio.fmod_rate));
            if (list.root.el_loop_end) ui_input_set_value(list.root.el_loop_end, string(audio.loop_end / audio.fmod_rate));
            
            if (Stuff.fmod_sound) {
                FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
                Stuff.fmod_sound = -1;
            }
        }
    }, false, dg, list);
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.numbered = true;
    dg.el_list = el_list;
    
    var el_add = create_button(c2 + 16, yy, "Add", ew, eh, fa_center, function(button) {
        var fn = get_open_filename_audio_fmod();
        if (file_exists(fn)) {
            ds_list_add(button.root.el_list.entries, audio_add(fn, button.root.prefix, button.root.show_loop_controls));
        }
    }, dg);
    el_add.file_dropper_action = function(dropper, files) {
        var filtered_list = ui_handle_dropped_files_filter(files, [".wav", ".mid", ".ogg", ".mp3"]);
        for (var i = 0; i < array_length(filtered_list); i++) {
            ds_list_add(dropper.root.el_list.entries, audio_add(filtered_list[i], dropper.root.prefix, dropper.root.show_loop_controls));
        }
    };
    yy += el_add.height + spacing;
    var el_remove = create_button(c2 + 16, yy, "Delete", ew, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var data = list.entries[| selection];
            FMODGMS_Snd_Unload(data.fmod);
            ds_list_delete(list.entries, ds_list_find_index(list.entries, data));
            instance_activate_object(data);
            instance_destroy(data);
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
            input.root.el_list.entries[| selection].name = input.value;
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
            if (!already || already == list.entries[| selection]) {
                internal_name_remove(list.entries[| selection].internal_name);
                internal_name_set(list.entries[| selection], input.value);
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
            var what = list.entries[| selection];
            Stuff.fmod_sound = what.fmod;
            FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
            FMODGMS_Snd_PlaySound(Stuff.fmod_sound, Stuff.fmod_channel);
            FMODGMS_Chan_Set_Frequency(Stuff.fmod_channel, what.fmod_rate);
        }
    }, dg);
    xx = xx + ((ew - 32) / 4);
    var el_pause = create_button(xx, yy, "Pause", ew / 4, eh, fa_center, function(button) {
        if (Stuff.fmod_sound) {
            FMODGMS_Chan_PauseChannel(Stuff.fmod_channel);
            Stuff.fmod_paused = true;
        }
    }, dg);
    xx = xx + ((ew - 32) / 4);
    var el_resume = create_button(xx, yy, "Rsm.", ew / 4, eh, fa_center, function(button) {
        if (Stuff.fmod_sound) {
            FMODGMS_Chan_ResumeChannel(Stuff.fmod_channel);
            Stuff.fmod_paused = false;
        }
    }, dg);
    xx = xx + ((ew - 32) / 4);
    var el_stop = create_button(xx, yy, "Stop", ew / 4, eh, fa_center, function(button) {
        if (Stuff.fmod_sound) {
            FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
        }
    }, dg);
    
    yy += el_play.height + spacing * 2;
    var el_effects = create_text(c2 + 16, yy, "Effects such as volume, pitch, etc can be defined when the sound is played in-game.", ew, eh, fa_left, ew, dg);
    yy += el_effects.height + spacing * 2;
    
    var vx1 = dw / (columns * 2) - 16;
    var vy1 = 0;
    var vx2 = vx1 + 80 + 32;
    var vy2 = eh;
    
    yy = yy_base;
    
    var el_sample_rate = create_input(c3 + 16, yy, "Sample Rate:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            audio_set_sample_rate(list.entries[| selection], real(input.value));
        }
    }, 0, "hertz", validate_int, 0, 0xffffff, 8, vx1, vy1, vx2, vy2, dg);
    dg.el_sample_rate = el_sample_rate;
    yy += el_sample_rate.height + spacing;
    var xx = c3 + 16;
    var el_rate_441 = create_button(xx, yy, "44.1 KHz", ew / 2, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var what = list.entries[| selection];
            audio_set_sample_rate(what, 44100);
            ui_input_set_value(button.root.el_sample_rate, string(what.fmod_rate));
        }
    }, dg);
    xx = xx + ((ew - 32) / 2);
    var el_rate_48 = create_button(xx, yy, "48 KHz", ew / 2, eh, fa_center, function(button) {
        var list = button.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var what = list.entries[| selection];
            audio_set_sample_rate(what, 48000);
            ui_input_set_value(button.root.el_sample_rate, string(what.fmod_rate));
        }
    }, dg);
    xx = xx + ((ew - 32) / 2);
    yy += el_rate_441.height + spacing;
    var el_length = create_text(c3 + 16, yy, "Length: N/A", ew, eh, fa_left, ew, dg);
    el_length.render = function(text, x, y) {
        var list = text.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var audio = list.entries[| selection];
            text.text = "Length: " + string(FMODGMS_Snd_Get_Length(audio.fmod) / audio.fmod_rate) + " s";
        } else {
            text.text = "Length: N.A";
        }
        ui_render_text(text, x, y);
    };
    dg.el_length = el_length;
    yy += el_length.height + spacing;
    
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
    );
    
    if (show_loop_controls) {
        var el_loop_start = create_input(c3 + 16, yy, "Loop Start:", ew, eh, function(input) {
            var list = input.root.el_list;
            var selection = ui_list_selection(list);
            if (selection + 1) {
                var audio = list.entries[| selection];
                audio.loop_start = real(input.value) * audio.fmod_rate;
                var position = FMODGMS_Chan_Get_Position(audio.fmod);
                FMODGMS_Snd_Set_LoopPoints(audio.fmod, audio.loop_start, audio.loop_end);
                // setting a loop point while the sound is playing makes audio weird so we just stop it instead
                FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
                FMODGMS_Chan_Set_Position(Stuff.fmod_channel, position);
            }
        }, 0, "seconds", validate_double, 0, 10000, 5, vx1, vy1, vx2, vy2, dg);
        dg.el_loop_start = el_loop_start;
        yy += el_loop_start.height + spacing;
        var el_loop_end = create_input(c3 + 16, yy, "Loop End:", ew, eh, function(input) {
            var list = input.root.el_list;
            var selection = ui_list_selection(list);
            if (selection + 1) {
                var audio = list.entries[| selection];
                audio.loop_end = real(input.value) * audio.fmod_rate;
                var position = FMODGMS_Chan_Get_Position(audio.fmod);
                FMODGMS_Snd_Set_LoopPoints(audio.fmod, audio.loop_start, audio.loop_end);
                // setting a loop point while the sound is playing makes things weird so we just stop it instead
                FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
                FMODGMS_Chan_Set_Position(Stuff.fmod_channel, position);
            }
        }, 0, "seconds", validate_double, 0, 10000, 5, vx1, vy1, vx2, vy2, dg);
        dg.el_loop_end = el_loop_end;
        yy += el_loop_end.height + spacing;
        var el_loop_progress = create_progress_bar(c3 + 16, yy, ew, eh, function(progress) {
            FMODGMS_Chan_Set_Position(Stuff.fmod_channel, progress.value * FMODGMS_Snd_Get_Length(Stuff.fmod_sound));
        }, 8, 0, dg);
        el_loop_progress.render = function(progress, x, y) {
            if (Stuff.fmod_sound + 1) {
                progress.value = FMODGMS_Chan_Get_Position(Stuff.fmod_channel) / FMODGMS_Snd_Get_Length(Stuff.fmod_sound);
            }
            
            var list = progress.root.el_list;
            var selection = ui_list_selection(list);
            if (selection + 1) {
                var audio = list.entries[| selection];
                var length = FMODGMS_Snd_Get_Length(audio.fmod);
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
        yy += el_loop_progress.height + spacing;
        
        ds_list_add(dg.contents,
            el_loop_start,
            el_loop_end,
            el_loop_progress,
        );
    } else {
        dg.el_loop_start = undefined;
        dg.el_loop_end = undefined;
    }
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_confirm
    );
    
    return dg;
}