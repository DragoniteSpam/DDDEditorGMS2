function ui_init_particle(mode) {
    // this one's not tabbed, it's just a bunch of elements floating in space
    with (instance_create_depth(0, 0, 0, UIMain)) {
        #macro PART_MAXIMUM_EMITTERS 16
        #macro PART_MAXIMUM_TYPES 255
        
        home_row_y = 64;
        var columns = 3;
        var spacing = 16;
        var legal_x = 32;
        var legal_y = home_row_y + 32;
        var legal_width = (room_width / 2) - 64;
        
        var col_width = legal_width / columns;
        var ew = col_width - spacing * 2;
        var eh = 24;
        
        var vx1 = ew / 2;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
        
        var b_width = 128;
        var b_height = 32;
        
        var yy_header = 64;
        var yy = 64 + eh;
        var yy_base = yy;
        
        // it would be best if you don't ask to access these later but if you need to these are just
        // object variables so you can look them up
        t_system = create_tab("System", 0, id);
        t_emitter = create_tab("Emitters", 0, id);
        t_type = create_tab("Types", 0, id);
        
        // the game will crash if you create a tab row with zero width.
        var tr_general = ds_list_create();
        ds_list_add(tr_general, t_system, t_emitter, t_type);
        
        ds_list_add(tabs, tr_general);
        
        active_tab = t_system;
        
        var col1_x = legal_x + col_width * 0 + spacing;
        var col2_x = legal_x + col_width * 1 + spacing;
        var col3_x = legal_x + col_width * 2 + spacing;
        
        var button_width = 128;
        
        #region tab: system
        yy = legal_y;
        
        var element = create_text(col1_x, yy, "Settings", ew, eh, fa_left, ew, t_system);
        element.color = c_blue;
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_color_picker(col1_x, yy, "Back:", ew, eh, function(picker) {
            Stuff.particle.back_color = picker.value;
            Settings.oarticle.back = picker.value;
        }, mode.back_color, vx1, vy1, vx2, vy2, t_system);
        element.tooltip = "The background color.";
        element.active_shade = false;
        ds_list_add(t_system.contents, element);
        t_system.back_color = element;
        
        yy += element.height + spacing;
        
        element = create_checkbox(col1_x, yy, "Automatic Update?", ew, eh, function(checkbox) {
            Stuff.particle.system_auto_update = checkbox.value;
            checkbox.root.manual_update.interactive = !checkbox.value;
            part_system_automatic_update(Stuff.particle.system, checkbox.value);
            Settings.particle.auto_update = checkbox.value;
        }, mode.system_auto_update, t_system);
        element.tooltip = "Whehter or not the particle system will update automatically. If this is turned off, you must update the system manually.";
        ds_list_add(t_system.contents, element);
        t_system.automatic_update = element;
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Update", ew, eh, fa_center, function(button) {
            part_system_update(Stuff.particle.system);
        }, t_system);
        element.tooltip = "Update the particle system by one step.";
        element.interactive = !mode.system_auto_update;
        ds_list_add(t_system.contents, element);
        t_system.manual_update = element;
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Clear All Particles", ew, eh, fa_center, function(button) {
            part_particles_clear(Stuff.particle.system);
        }, t_system);
        element.tooltip = "Clear all particles currently in the system.";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Reset System", ew, eh, fa_center, function(button) {
            editor_particle_reset();
        }, t_system);
        element.tooltip = "Destroy all particle types and emitters.";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col1_x, yy, "Snap Emitter to Grid?", ew, eh, function(checkbox) {
            Stuff.particle.emitter_set_snap = checkbox.value;
        }, mode.emitter_set_snap, t_system);
        element.tooltip = "When clicking on the particle view to set emitter regions, you may find it helpful to snap to the grid.";
        ds_list_add(t_system.contents, element);
        t_system.emitter_set_snap = element;
        
        yy += element.height + spacing;
        
        element = create_input(col1_x, yy, "Distance:", ew, eh, function(input) {
            Stuff.particle.emitter_set_snap_size = real(input.value);
        }, mode.emitter_set_snap_size, "reasonable integer", validate_int, 1, 128, 3, vx1, vy1, vx2, vy2, t_system);
        element.tooltip = "The grid-snapping distance.";
        ds_list_add(t_system.contents, element);
        t_system.emitter_set_snap_size = element;
        
        yy = legal_y;
        
        element = create_text(col2_x, yy, "Save / Load", ew, eh, fa_left, ew, t_system);
        element.color = c_blue;
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Save Buffer", ew, eh, fa_center, function(button) {
            var fn = get_save_filename("DDD Particle files|*" + EXPORT_EXTENSION_PARTICLES, "");
            if (fn == "") return;
            var fbuffer = buffer_create(1024, buffer_grow, 1);
            serialize_save_particles(fbuffer);
            buffer_save(fbuffer, fn);
            buffer_delete(fbuffer);
        }, t_system);
        element.tooltip = "Save a buffer containing particle information, which you can load later (or use in your game itself).";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Load Buffer", ew, eh, fa_center, function(button) {
            var fn = get_open_filename("DDD Particle files|*" + EXPORT_EXTENSION_PARTICLES, "");
            if (!file_exists(fn)) return;
            var fbuffer = buffer_load(fn);
            var version = buffer_peek(fbuffer, 0, buffer_u32);
            serialize_load_particles(fbuffer, version);
            buffer_delete(fbuffer);
        }, t_system);
        element.tooltip = "Load a previously saved buffer containing particle information.";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Export Code", ew, eh, fa_center, function(button) {
            var fn = get_save_filename_gml("particles.gml");
            if (fn == "") return;
            var text = editor_particle_generate_code();
            var fbuffer = buffer_create(1024, buffer_grow, 1);
            buffer_write(fbuffer, buffer_text, text);
            buffer_save(fbuffer, fn);
            buffer_delete(fbuffer);
        }, t_system);
        element.tooltip = "Save the GML code that will generate the particles to a file.";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Copy Code", ew, eh, fa_center, function(button) {
            clipboard_set_text(editor_particle_generate_code());
            (emu_dialog_notice("Code has been copied to the clipboard!")).active_shade = false;
        }, t_system);
        element.tooltip = "Copy the GML code that will generate the particles to the Windows clipboard.";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        yy = legal_y;
        
        element = create_text(col3_x, yy, "Demo Particle Types", ew, eh, fa_left, ew, t_system);
        element.color = c_blue;
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col3_x, yy, "Fire", ew, eh, fa_center, function(button) {
            emu_dialog_confirm(button.root, "Would you like to load the demo fire particles? (Any current particle types and emitters will be cleared.)", function() {
                var version = buffer_peek(Stuff.particle.demo_fire, 0, buffer_u32);
                serialize_load_particles(Stuff.particle.demo_fire, version);
                buffer_seek(Stuff.particle.demo_fire, buffer_seek_start, 0);
                ui_list_select(Stuff.particle.ui.t_emitter.list, 0);
                ui_list_select(Stuff.particle.ui.t_type.list, 0);
                Stuff.particle.ui.t_emitter.list.onvaluechange(Stuff.particle.ui.t_emitter.list);
                Stuff.particle.ui.t_type.list.onvaluechange(Stuff.particle.ui.t_type.list);
                self.root.Dispose();
            });
        }, t_system);
        element.tooltip = "A demo of fire and smoke";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col3_x, yy, "Waterfall", ew, eh, fa_center, function(button) {
            emu_dialog_confirm(button.root, "Would you like to load the demo water particles? (Any current particle types and emitters will be cleared.)", function() {
                var version = buffer_peek(Stuff.particle.demo_water, 0, buffer_u32);
                serialize_load_particles(Stuff.particle.demo_water, version);
                buffer_seek(Stuff.particle.demo_water, buffer_seek_start, 0);
                ui_list_select(Stuff.particle.ui.t_emitter.list, 0);
                ui_list_select(Stuff.particle.ui.t_type.list, 0);
                Stuff.particle.ui.t_emitter.list.onvaluechange(Stuff.particle.ui.t_emitter.list);
                Stuff.particle.ui.t_type.list.onvaluechange(Stuff.particle.ui.t_type.list);
                self.root.Dispose();
            });
        }, t_system);
        element.tooltip = "A demo of water";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col3_x, yy, "Glowing Blobs", ew, eh, fa_center, function(button) {
            emu_dialog_confirm(button.root, "Would you like to load the demo glow particles? (Any current particle types and emitters will be cleared.)", function() {
                var version = buffer_peek(Stuff.particle.demo_glow, 0, buffer_u32);
                serialize_load_particles(Stuff.particle.demo_glow, version);
                buffer_seek(Stuff.particle.demo_glow, buffer_seek_start, 0);
                ui_list_select(Stuff.particle.ui.t_emitter.list, 0);
                ui_list_select(Stuff.particle.ui.t_type.list, 0);
                Stuff.particle.ui.t_emitter.list.onvaluechange(Stuff.particle.ui.t_emitter.list);
                Stuff.particle.ui.t_type.list.onvaluechange(Stuff.particle.ui.t_type.list);
                self.root.Dispose();
            });
        }, t_system);
        element.tooltip = "A demo of glowing particles that you can draw on the screen and stuff with (click the mouse to spawn particles at the cursor location)";
        ds_list_add(t_system.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: emitters
        yy = legal_y + spacing;
        
        element = create_list(col1_x, yy, "Particle Emitters", "<no emitters>", ew, eh, 26, function(list) {
            var selection = ui_list_selection(list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                list.root.shape.value = emitter.region_shape;
                list.root.distr.value = emitter.region_distribution;
                list.root.streaming.value = emitter.streaming;
                list.root.draw.value = emitter.draw_region;
                ui_input_set_value(list.root.name, string(emitter.name));
                ui_input_set_value(list.root.xmin, string(emitter.region_x1));
                ui_input_set_value(list.root.ymin, string(emitter.region_y1));
                ui_input_set_value(list.root.xmax, string(emitter.region_x2));
                ui_input_set_value(list.root.ymax, string(emitter.region_y2));
                ui_input_set_value(list.root.rate, string(emitter.rate));
                ui_list_deselect(list.root.types);
                ui_list_select(list.root.types, array_search(Stuff.particle.types, emitter.type));
            }
        }, false, t_emitter, mode.emitters);
        element.tooltip = "All of the currently-defined emitters types.";
        element.evaluate_text = function(list, index) {
            var emitter = list.entries[index];
            var text = emitter.name;
            if (!emitter.streaming) text = "(" + text + ")";
            return text;
        };
        element.entries_are = ListEntries.SCRIPT;
        t_emitter.list = element;
        ds_list_add(t_emitter.contents, element);
        
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(col1_x, yy, "Add Emitter", ew, eh, fa_center, function(button) {
            array_push(Stuff.particle.emitters, new ParticleEmitter("Emitter " + string(array_length(Stuff.particle.emitters))));
        }, t_emitter);
        element.tooltip = "Add a particle emitter.";
        ds_list_add(t_emitter.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Remove Emitter", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                Stuff.particle.emitters[selection].Destroy();
                array_delete(Stuff.particle.emitters, selection, 1);
                ui_list_deselect(button.root.list);
            }
        }, t_emitter);
        element.tooltip = "Remove a particle emitter.";
        ds_list_add(t_emitter.contents, element);
        
        yy = legal_y + spacing;
        
        element = create_input(col2_x, yy, "Name:", ew, eh, function(button) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                Stuff.particle.emitters[selection].name = input.value;
            }
        }, "Part Emitter", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, t_emitter);
        ds_list_add(t_emitter.contents, element);
        t_emitter.name = element;
        
        yy += element.height + spacing;
        
        element = create_radio_array(col2_x, yy, "Shape:", ew, eh, function(radio) {
            var selection = ui_list_selection(radio.root.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.region_shape = radio.value;
                var shape = emitter.emitter_shapes[emitter.region_shape];
                var distribution = emitter.emitter_distributions[emitter.region_distribution];
                part_emitter_region(Stuff.particle.system, emitter.emitter, emitter.region_x1, emitter.region_x2, emitter.region_y1, emitter.region_y2, shape, distribution);
                editor_particle_emitter_create_region(emitter);
            }
        }, PartEmitterShapes.ELLIPSE, t_emitter);
        create_radio_array_options(element, ["Rectangle", "Ellipse", "Diamond", "Line"]);
        element.tooltip = "The shape of the emitter, stretched between the start and end points. Check the \"draw region\" option to see what it looks like.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.shape = element;
        
        yy += element.GetHeight() + spacing;
        
        element = create_radio_array(col2_x, yy, "Distribution:", ew, eh, function(radio) {
            var selection = ui_list_selection(radio.root.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.region_distribution = radio.value;
                var shape = emitter.emitter_shapes[emitter.region_shape];
                var distribution = emitter.emitter_distributions[emitter.region_distribution];
                part_emitter_region(Stuff.particle.system, emitter.emitter, emitter.region_x1, emitter.region_x2, emitter.region_y1, emitter.region_y2, shape, distribution);
                editor_particle_emitter_create_region(emitter);
            }
        }, PartEmitterDistributions.LINEAR, t_emitter);
        create_radio_array_options(element, ["Linear", "Gaussian", "Inverse Gaussian"]);
        element.tooltip = "How the particles are distributed over the emission region.\n\nLinear: particles have an equal chance of spawning across the entire region\nGaussian: particles have a greater chance of spawning towards the center of the region.\nInverse Gaussian: particles have a greater chance of spawning towards the edges of the region.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.distr = element;
        
        yy += element.GetHeight() + spacing;
        
        element = create_button(col2_x, yy, "Set Region", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            // 250 ms delay between when you kill the region and when you can click it again
            if (current_time - button.click_time < 250) return;
            if (selection + 1) {
                Stuff.particle.emitter_setting = Stuff.particle.emitters[selection];
                Stuff.particle.emitter_first_corner = true;
                // this is the all-time worst hack for disabling the UI i have ever come up with
                var bad = emu_dialog_notice("");
                bad.x = -10000;
                bad.y = -10000;
                bad.active_shade = false;
                Stuff.particle.ghost_dialog = bad;
                part_system_automatic_update(Stuff.particle.system, false);
            }
        }, t_emitter);
        element.click_time = -100000;
        element.tooltip = "Set the emission region by clicking on the particle view.";
        el_set_region = element;
        ds_list_add(t_emitter.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "Draw Region?", ew, eh, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.draw_region = checkbox.value;
            }
        }, false, t_emitter);
        element.tooltip = "You can display the emitter's region on the screen if you'd like.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.draw = element;
        
        yy += element.height + spacing;
        
        var ovx1 = ew / 4;
        var ovy1 = 0;
        var ovx2 = ew / 2;
        var ovy2 = eh;
        
        element = create_input(col2_x, yy, "X1:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.region_x1 = input.value;
                editor_particle_emitter_set_region(emitter);
                editor_particle_emitter_create_region(emitter);
            }
        }, 160, "int", validate_int, -CW / 2, floor(1.5 * CW), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
        element.tooltip = "The lower bound of the emission region.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.xmin = element;
        
        element = create_input(col2_x + ew / 2, yy, "Y1:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.region_y1 = input.value;
                editor_particle_emitter_set_region(emitter);
                editor_particle_emitter_create_region(emitter);
            }
        }, 160, "int", validate_int, -CH / 2, floor(1.5 * CH), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
        element.tooltip = "The lower bound of the emission region.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.ymin = element;
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "X2:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.region_x2 = input.value;
                editor_particle_emitter_set_region(emitter);
                editor_particle_emitter_create_region(emitter);
            }
        }, 240, "int", validate_int, -CW / 2, floor(1.5 * CW), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
        element.tooltip = "The upper bound of the emission region.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.xmax = element;
        
        element = create_input(col2_x + ew / 2, yy, "Y2:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.region_y2 = input.value;
                editor_particle_emitter_set_region(emitter);
                editor_particle_emitter_create_region(emitter);
            }
        }, 240, "int", validate_int, -CH / 2, floor(1.5 * CH), 4, ovx1, ovy1, ovx2, ovy2, t_emitter);
        element.tooltip = "The upper bound of the emission region.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.ymax = element;
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "Streaming?", ew, eh, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.streaming = checkbox.value;
                if (emitter.type) {
                    editor_particle_emitter_set_region(emitter);
                    editor_particle_emitter_set_emission(emitter);
                }
            }
        }, false, t_emitter);
        element.tooltip = "Whether or not the emitter is currently streaming particles.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.streaming = element;
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Rate", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                emitter.rate = real(input.value);
                if (emitter.type) {
                    editor_particle_emitter_set_emission(emitter);
                }
            }
        }, 120, "", validate_int, 0, 1000, 5, vx1, vy1, vx2, vy2, t_emitter);
        element.tooltip = "How many particles will be emitted per second (or per burst). Values less than 60 will result in a random chance of a particle being emitted every update.";
        ds_list_add(t_emitter.contents, element);
        t_emitter.rate = element;
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Burst", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                if (emitter.type) {
                    editor_particle_emitter_set_region(emitter);
                    part_emitter_burst(Stuff.particle.system, emitter.emitter, emitter.type.type, emitter.rate);
                }
            }
        }, t_emitter);
        element.tooltip = "Create a one-time burst of particles. The number of particles created is defined by the emission rate. Right-click in the paricle view to create a stream at the position of the mouse, or left-click to create a one-time burst.";
        ds_list_add(t_emitter.contents, element);
        
        yy = legal_y + spacing;
        
        element = create_list(col3_x, yy, "Type", "<no particle types>", ew, eh, 26, function(list) {
            var selected_type = ui_list_selection(list);
            var selection = ui_list_selection(list.root.list);
            if (selection + 1) {
                var emitter = Stuff.particle.emitters[selection];
                editor_particle_emitter_set_region(emitter);
                if (selected_type + 1) {
                    emitter.type = Stuff.particle.types[selected_type];
                    editor_particle_emitter_set_emission(emitter);
                } else {
                    emitter.type = noone;
                    part_emitter_stream(Stuff.particle.system, emitter.emitter, -1, 0);
                }
            }
        }, false, t_emitter, mode.types);
        element.tooltip = "The particle type attached to the emitter.";
        element.entries_are = ListEntries.INSTANCES;
        t_emitter.types = element;
        ds_list_add(t_emitter.contents, element);
        
        yy += ui_get_list_height(element) + spacing;
        
        t_emitter.name.next = t_emitter.xmin;
        t_emitter.xmin.next = t_emitter.ymin;
        t_emitter.ymin.next = t_emitter.xmax;
        t_emitter.xmax.next = t_emitter.ymax;
        t_emitter.ymax.next = t_emitter.rate;
        t_emitter.rate.next = t_emitter.name;
        
        t_emitter.name.previous = t_emitter.rate;
        t_emitter.xmin.previous = t_emitter.name;
        t_emitter.ymin.previous = t_emitter.xmin;
        t_emitter.xmax.previous = t_emitter.ymin;
        t_emitter.ymax.previous = t_emitter.xmax;
        t_emitter.rate.previous = t_emitter.ymax;
        #endregion
        
        #region tab: types
        yy = legal_y + spacing;
        
        f_part_type_select = function(element) {
            var list = element.root.list;
            var selection = ui_list_selection(list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                ui_input_set_value(list.root.name, type.name);
                ui_input_set_value(list.root.speed_min, string_format(type.speed_min, 1, 3));
                ui_input_set_value(list.root.speed_max, string_format(type.speed_max, 1, 3));
                ui_input_set_value(list.root.speed_incr, string_format(type.speed_incr, 1, 3));
                ui_input_set_value(list.root.speed_wiggle, string_format(type.speed_wiggle, 1, 3));
                list.root.direction_min.value = type.direction_min / 360;
                list.root.direction_max.value = type.direction_max / 360;
                ui_input_set_value(list.root.direction_incr, string_format(type.direction_incr, 1, 3));
                ui_input_set_value(list.root.direction_wiggle, string_format(type.direction_wiggle, 1, 3));
                list.root.orientation_min.value = type.orientation_min / 360;
                list.root.orientation_max.value = type.orientation_max / 360;
                ui_input_set_value(list.root.orientation_incr, string_format(type.orientation_incr, 1, 3));
                ui_input_set_value(list.root.orientation_wiggle, string_format(type.orientation_wiggle, 1, 3));
                list.root.orientation_relative.value = type.orientation_relative;
                ui_input_set_value(list.root.gravity, string_format(type.gravity, 1, 3));
                list.root.gravity_direction.value = type.gravity_direction / 360;
                list.root.use_sprite.value = type.sprite_custom;
                ui_list_deselect(list.root.shape);
                ui_list_select(list.root.shape, type.shape, true);
                list.root.base_color_1a.value = type.color_1a;
                list.root.base_color_1a.alpha = type.alpha_1;
                list.root.base_color_1b.value = type.color_1b;
                list.root.base_color_1b_enabled.value = type.color_1b_enabled;
                list.root.base_color_2.value = type.color_2;
                list.root.base_color_2.alpha = type.alpha_2;
                list.root.base_color_2_enabled.value = type.color_2_enabled;
                list.root.base_color_3.value = type.color_3;
                list.root.base_color_3.alpha = type.alpha_3;
                list.root.base_color_3_enabled.value = type.color_3_enabled;
                list.root.additive_blending.value = type.blend;
                ui_input_set_value(list.root.xscale, string_format(type.xscale, 1, 3));
                ui_input_set_value(list.root.yscale, string_format(type.yscale, 1, 3));
                ui_input_set_value(list.root.size_min, string_format(type.size_min, 1, 3));
                ui_input_set_value(list.root.size_max, string_format(type.size_max, 1, 3));
                ui_input_set_value(list.root.size_incr, string_format(type.size_incr, 1, 3));
                ui_input_set_value(list.root.size_wiggle, string_format(type.size_wiggle, 1, 3));
                ui_input_set_value(list.root.life_min, string_format(type.life_min, 1, 3));
                ui_input_set_value(list.root.life_max, string_format(type.life_max, 1, 3));
            }
        };
        
        element = create_list(col1_x, yy, "Particle Types", "<no particle types>", ew, eh, 26, f_part_type_select, false, t_type, mode.types);
        element.tooltip = "All of the currently-defined particle types.";
        element.entries_are = ListEntries.INSTANCES;
        t_type.list = element;
        ds_list_add(t_type.contents, element);
        
        yy += ui_get_list_height(element) + spacing;
        
        element = create_button(col1_x, yy, "Add Type", ew, eh, fa_center, function(button) {
            if (array_length(Stuff.particle.types) < PART_MAXIMUM_TYPES) {
                array_push(Stuff.particle.types, new ParticleType("Type " + string(array_length(Stuff.particle.types))));
            }
        }, t_type);
        element.tooltip = "Add a particle type.";
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col1_x, yy, "Remove Type", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                for (var i = 0; i < array_length(Stuff.particle.emitters); i++) {
                    var emitter = Stuff.particle.emitters[i];
                    emitter.type = (emitter.type == type) ? noone : emitter.type;
                }
                type.Destroy();
                array_delete(Stuff.particle.types, selection, 1);
                ui_list_deselect(button.root.list);
            }
        }, t_type);
        element.tooltip = "Remove a particle type. Any references to the particle type elsewhere will be reset.";
        ds_list_add(t_type.contents, element);
        
        yy = legal_y + spacing;
        
        element = create_input(col2_x, yy, "Name:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.name = input.value;
            }
        }, "Part Type", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, t_type);
        element.tooltip = "The name of the particle type.";
        ds_list_add(t_type.contents, element);
        t_type.name = element;
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Motion", ew, eh, fa_left, ew, t_type);
        element.color = c_blue;
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Speed:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "min:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.speed_min = real(input.value);
                part_type_speed(type.type, type.speed_min, type.speed_max, type.speed_incr, type.speed_wiggle);
            }
        }, 160, "float", validate_double, -400, 400, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "The minimum starting speed of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.speed_min = element;
        
        element = create_input(col2_x + ew / 2, yy, "max:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.speed_max = real(input.value);
                part_type_speed(type.type, type.speed_min, type.speed_max, type.speed_incr, type.speed_wiggle);
            }
        }, 160, "float", validate_double, -400, 400, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "The maximum starting speed of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.speed_max = element;
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "incr:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.speed_incr = real(input.value);
                part_type_speed(type.type, type.speed_min, type.speed_max, type.speed_incr, type.speed_wiggle);
            }
        }, 0, "float", validate_double, -100, 100, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "How much the particle speed should increase or decrease each update.";
        ds_list_add(t_type.contents, element);
        t_type.speed_incr = element;
        
        element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.speed_wiggle = real(input.value);
                part_type_speed(type.type, type.speed_min, type.speed_max, type.speed_incr, type.speed_wiggle);
            }
        }, 0, "float", validate_double, -100, 100, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "How much should randomly be added or subtracted to particle speed each update.";
        ds_list_add(t_type.contents, element);
        t_type.speed_wiggle = element;
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Direction:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "min:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, function(bar) {
            var selection = ui_list_selection(bar.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_min = round(bar.value * 360);
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
            }
        }, 4, 0, t_type);
        element.tooltip = "The minimum starting direction of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.direction_min = element;
        
        yy += element.height + spacing;
        
        element = create_button(col2_x + 0 * ew / 5, yy,   "0°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_min = 0;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 1 * ew / 5, yy,  "90°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_min = 90;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 2 * ew / 5, yy, "180°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_min = 180;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 3 * ew / 5, yy, "270°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_min = 270;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 4 * ew / 5, yy, "360°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_min = 360;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "max:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, function(bar) {
            var selection = ui_list_selection(bar.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_max = round(bar.value * 360);
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
            }
        }, 4, 0, t_type);
        element.tooltip = "The maximum starting direction of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.direction_max = element;
        
        yy += element.height + spacing;
        
        element = create_button(col2_x + 0 * ew / 5, yy,   "0°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_max = 0;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 1 * ew / 5, yy,  "90°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
        
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_max = 90;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 2 * ew / 5, yy, "180°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_max = 180;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 3 * ew / 5, yy, "270°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_max = 270;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 4 * ew / 5, yy, "360°", ew / 5, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_max = 360;
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "incr:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_incr = real(input.value);
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
            }
        }, 0, "float", validate_double, -100, 100, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "How much the particle direction should increase or decrease each update.";
        ds_list_add(t_type.contents, element);
        t_type.direction_incr = element;
        
        element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.direction_wiggle = real(input.value);
                part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
            }
        }, 0, "float", validate_double, -100, 100, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "How much should randomly be added or subtracted to particle direction each update.";
        ds_list_add(t_type.contents, element);
        t_type.direction_wiggle = element;
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Rotation:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "min:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, function(bar) {
            var selection = ui_list_selection(bar.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.orientation_min = round(bar.value * 360);
                part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
            }
        }, 4, 0, t_type);
        element.tooltip = "The minimum starting rotation of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.orientation_min = element;
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "max:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, function(bar) {
            var selection = ui_list_selection(bar.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.orientation_max = round(bar.value * 360);
                part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
            }
        }, 4, 0, t_type);
        element.tooltip = "The maximum starting rotation of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.orientation_max = element;
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "incr:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.orientation_incr = real(input.value);
                part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
            }
        }, 0, "float", validate_double, -100, 100, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "How much the particle orientation should increase or decrease each update.";
        ds_list_add(t_type.contents, element);
        t_type.orientation_incr = element;
        
        element = create_input(col2_x + ew / 2, yy, "wgl:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.orientation_wiggle = real(input.value);
                part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
            }
        }, 0, "float", validate_double, -100, 100, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "How much should randomly be added or subtracted to particle orientation each update.";
        ds_list_add(t_type.contents, element);
        t_type.orientation_wiggle = element;
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "Relative?", ew, eh, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.orientation_relative = checkbox.value;
                part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
            }
        }, false, t_type);
        element.tooltip = "Whether the particle's rotation is relative to its direction of motion or not.";
        ds_list_add(t_type.contents, element);
        t_type.orientation_relative = element;
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Gravity:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.gravity = real(input.value);
                part_type_gravity(type.type, type.gravity, type.gravity_direction);
            }
        }, 0, "float", validate_double, 0, 10, 6, vx1, vy1, vx2, vy2, t_type);
        element.tooltip = "The strength of gravity acting on the particle, in pixels per step.";
        ds_list_add(t_type.contents, element);
        t_type.gravity = element;
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "direction:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        element = create_progress_bar(col2_x + ew / 2, yy, ew / 2, eh, function(input) {
            var selection = ui_list_selection(bar.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.gravity_direction = round(bar.value * 360);
                part_type_gravity(type.type, type.gravity, type.gravity_direction);
            }
        }, 4, 0.75, t_type);
        element.tooltip = "The minimum starting rotation of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.gravity_direction = element;
        
        yy += element.height + spacing / 2;
        
        element = create_button(col2_x + 0 * ew / 4, yy,   "0°", ew / 4, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.gravity_direction = 0;
                part_type_gravity(type.type, type.gravity, type.gravity_direction);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        element.tooltip = "Gravity attracts things to the right";
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 1 * ew / 4, yy,  "90°", ew / 4, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.gravity_direction = 90;
                part_type_gravity(type.type, type.gravity, type.gravity_direction);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        element.tooltip = "Gravity attracts things upwards";
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 2 * ew / 4, yy, "180°", ew / 4, eh, fa_center, function(input) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.gravity_direction = 180;
                part_type_gravity(type.type, type.gravity, type.gravity_direction);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        element.tooltip = "Gravity attracts things to the left";
        ds_list_add(t_type.contents, element);
        element = create_button(col2_x + 3 * ew / 4, yy, "270°", ew / 4, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.gravity_direction = 270;
                part_type_gravity(type.type, type.gravity, type.gravity_direction);
                f_part_type_select(button.root.list);
            }
        }, t_type);
        element.tooltip = "Gravity attracts things downwards";
        ds_list_add(t_type.contents, element);
        
        yy = legal_y + spacing;
        
        element = create_text(col3_x, yy, "Graphics", ew, eh, fa_left, ew, t_type);
        element.color = c_blue;
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col3_x, yy, "Use sprite?", ew, eh, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.sprite_custom = checkbox.value;
                editor_particle_type_set_sprite(type);
            }
        }, false, t_type);
        element.tooltip = "You can use a custom particle sprite. If no sprite is selected, the particle will draw its built-in shape instead.";
        ds_list_add(t_type.contents, element);
        t_type.use_sprite = element;
        
        yy += element.height + spacing;
        
        element = create_button(col3_x, yy, "Sprite", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
            
                var dw = 320;
                var dh = 540;
            
                var dg = dialog_create(dw, dh, "Particle Sprite", dialog_default, dialog_destroy, button);
                dg.type = type;
                dg.active_shade = false;
            
                var columns = 1;
                var spacing = 16;
                var ew = dw / columns - spacing * 2;
                var eh = 24;
            
                var col1_x = dw * 0 / columns + spacing;
            
                var vx1 = ew / 2;
                var vy1 = 0;
                var vx2 = ew;
                var vy2 = eh;
            
                var yy = 64;
                var yy_base = yy;
            
                var el_update_list = create_list(col1_x, yy, "Particle Sprites", "<no particle sprites>", ew, eh, 10, function(list) {
                    var type = list.root.type;
                    var selection = ui_list_selection(list);
                    if (selection + 1) {
                        type.sprite = Game.graphics.particles[selection].GUID;
                        editor_particle_type_set_sprite(type);
                    }
                }, false, dg, Game.graphics.particles);
                var sprite = guid_get(type.sprite);
                ui_list_select(el_update_list, array_search(Game.graphics.particles, sprite), true);
                el_update_list.tooltip = "The custom sprite to be used by the particle type. Go to Data > Graphics > Particles to manage particle sprites. When you import the generated code into your game, make sure your project has a sprite with the same Internal Name as the sprite used here.";
                el_update_list.entries_are = ListEntries.INSTANCES;
            
                yy += ui_get_list_height(el_update_list) + spacing;
            
                var el_animated = create_checkbox(col1_x, yy, "Animated?", ew, eh, function(checkbox) {
                    var type = checkbox.root.type;
                    type.sprite_animated = checkbox.value;
                    editor_particle_type_set_sprite(type);
                }, type.sprite_animated, dg);
                el_animated.tooltip = "Should the particles follow the sprite's animation?";
            
                yy += el_animated.height + spacing;
            
                var el_stretched = create_checkbox(col1_x, yy, "Animation stretched?", ew, eh, function(checkbox) {
                    var type = checkbox.root.type;
                    type.sprite_stretched = checkbox.value;
                    editor_particle_type_set_sprite(type);
                }, type.sprite_stretched, dg);
                el_stretched.tooltip = "Should the particle's animation be stretched out over the lifespan of the particle, or play at a rate of one frame per step?";
            
                yy += el_stretched.height + spacing;
            
                var el_random = create_checkbox(col1_x, yy, "Random subimage?", ew, eh, function(checkbox) {
                    var type = checkbox.root.type;
                    type.sprite_random = checkbox.value;
                    editor_particle_type_set_sprite(type);
                }, type.sprite_random, dg);
                el_random.tooltip = "Should the particles start with a random subimage of the sprite?";
            
                yy += el_random.height + spacing;
            
                var b_width = 128;
                var b_height = 32;
                var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dialog_destroy, dg);
        
                ds_list_add(dg.contents,
                    el_update_list,
                    el_animated,
                    el_stretched,
                    el_random,
                    el_confirm
                );
            }
        }, t_type);
        element.tooltip = t_type.use_sprite.tooltip;
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_list(col3_x, yy, "Shape:", "", ew, eh, 5, function(list) {
            var shape_selection = ui_list_selection(list);
            var selection = ui_list_selection(list.root.list);
            if (selection + 1 && shape_selection + 1) {
                var type = Stuff.particle.types[selection];
                type.shape = shape_selection;
                part_type_shape(type.type, type.type_shapes[type.shape]);
            }
        }, false, t_type);
        create_list_entries(element, "Pixel", "Disk", "Square", "Line", "Star", "Circle", "Ring", "Sphere", "Flare", "Spark", "Explosion", "Cloud", "Smoke", "Snow");
        element.tooltip = "The shape of the particle type. (Support for custom particle sprites may be added later.)";
        ds_list_add(t_type.contents, element);
        t_type.shape = element;
        
        yy += ui_get_list_height(element) + spacing;
        
        element = create_color_picker(col3_x, yy, "Color 1A:", ew, eh, function(picker) {
            var selection = ui_list_selection(picker.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.color_1a = picker.value;
                type.alpha_1 = picker.alpha;
                editor_particle_type_set_color(type);
            }
        }, c_white, vx1, vy1, vx2, vy2, t_type);
        element.tooltip = "The beginning range of colors the particle may be at the beginning of its lifetime. (If multiple colors are disabled, it will be the only color.)";
        element.allow_alpha = true;
        element.active_shade = false;
        ds_list_add(t_type.contents, element);
        t_type.base_color_1a = element;
        
        yy += element.height;
        
        element = create_checkbox(col3_x - spacing, yy, "", 64, eh, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.color_1b_enabled = checkbox.value;
                editor_particle_type_set_color(type);
            }
        }, false, t_type);
        element.tooltip = "Enable or disable starting color range. (Enabling staring color range will override color transitions.)";
        ds_list_add(t_type.contents, element);
        t_type.base_color_1b_enabled = element;
        
        element = create_color_picker(col3_x, yy, "        1B:", ew, eh, function(picker) {
            var selection = ui_list_selection(picker.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.color_1b = picker.value;
                editor_particle_type_set_color(type);
            }
        }, c_white, vx1, vy1, vx2, vy2, t_type);
        element.tooltip = "The end range of colors the particle may be at the beginning of its lifetime. (Color ranges do not support alpha.)";
        element.active_shade = false;
        ds_list_add(t_type.contents, element);
        t_type.base_color_1b = element;
        
        yy += element.height;
        
        element = create_checkbox(col3_x - spacing, yy, "", 64, eh, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.color_2_enabled = checkbox.value;
                editor_particle_type_set_color(type);
            }
        }, false, t_type);
        element.tooltip = "Enable or disable two-color transition. (Enabling staring color range will override color transitions.)";
        ds_list_add(t_type.contents, element);
        t_type.base_color_2_enabled = element;
        
        element = create_color_picker(col3_x, yy, "        2:", ew, eh, function(picker) {
            var selection = ui_list_selection(picker.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.color_2 = picker.value;
                type.alpha_2 = picker.alpha;
                editor_particle_type_set_color(type);
            }
        }, c_white, vx1, vy1, vx2, vy2, t_type);
        element.tooltip = "The color the particle will be halfway through its lifetime.";
        element.allow_alpha = true;
        element.active_shade = false;
        ds_list_add(t_type.contents, element);
        t_type.base_color_2 = element;
        
        yy += element.height;
        
        element = create_checkbox(col3_x - spacing, yy, "", 64, eh, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.color_3_enabled = checkbox.value;
                editor_particle_type_set_color(type);
            }
        }, false, t_type);
        element.tooltip = "Enable or disable three-color transition. (Enabling staring color range will override color transitions.)";
        ds_list_add(t_type.contents, element);
        t_type.base_color_3_enabled = element;
        
        element = create_color_picker(col3_x, yy, "        3:", ew, eh, function(picker) {
            var selection = ui_list_selection(picker.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.color_3 = picker.value;
                type.alpha_3 = picker.alpha;
                editor_particle_type_set_color(type);
            }
        }, c_white, vx1, vy1, vx2, vy2, t_type);
        element.tooltip = "The color the particle will be at the end of its lifetime.";
        element.allow_alpha = true;
        element.active_shade = false;
        ds_list_add(t_type.contents, element);
        t_type.base_color_3 = element;
        
        yy += element.height + spacing;
        
        element = create_checkbox(col3_x, yy, "Additive blending?", ew, eh, function(checkbox) {
            var selection = ui_list_selection(checkbox.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.blend = checkbox.value;
                part_type_blend(type.type, type.blend);
            }
        }, false, t_type);
        element.tooltip = "Enable or disable additive color blending.";
        ds_list_add(t_type.contents, element);
        t_type.additive_blending = element;
        
        yy += element.height + spacing;
        
        element = create_text(col3_x, yy, "Base Scale:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col3_x, yy, "x:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.xscale = real(input.value);
                part_type_scale(type.type, type.xscale, type.yscale);
            }
        }, 1, "float", validate_double, 0, 40, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "The horizontal scale of the particle, before particle size (below) is applied.";
        ds_list_add(t_type.contents, element);
        t_type.xscale = element;
        
        element = create_input(col3_x + ew / 2, yy, "y:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
        
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.yscale = real(input.value);
                part_type_scale(type.type, type.xscale, type.yscale);
            }
        }, 1, "float", validate_double, 0, 40, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "The vertical scale of the particle, before particle size (below) is applied.";
        ds_list_add(t_type.contents, element);
        t_type.yscale = element;
        
        yy += element.height + spacing;
        
        element = create_text(col3_x, yy, "Size:", ew, eh, fa_left, ew, t_type);
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col3_x, yy, "min:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.size_min = real(input.value);
                part_type_size(type.type, type.size_min, type.size_max, type.size_incr, type.size_wiggle);
            }
        }, 1, "float", validate_double, 0, 40, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "The minimum starting size of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.size_min = element;
        
        element = create_input(col3_x + ew / 2, yy, "max:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.size_max = real(input.value);
                part_type_size(type.type, type.size_min, type.size_max, type.size_incr, type.size_wiggle);
            }
        }, 1, "float", validate_double, 0, 40, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "The maximum starting size of the particle.";
        ds_list_add(t_type.contents, element);
        t_type.size_max = element;
        
        yy += element.height + spacing;
        
        element = create_input(col3_x, yy, "incr:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.size_incr = real(input.value);
                part_type_size(type.type, type.size_min, type.size_max, type.size_incr, type.size_wiggle);
            }
        }, 0, "float", validate_double, -10, 10, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "How much the particle size should increase or decrease each update.";
        ds_list_add(t_type.contents, element);
        t_type.size_incr = element;
        
        element = create_input(col3_x + ew / 2, yy, "wgl:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.size_wiggle = real(input.value);
                part_type_size(type.type, type.size_min, type.size_max, type.size_incr, type.size_wiggle);
            }
        }, 0, "float", validate_double, -10, 10, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "How much should randomly be added or subtracted to particle size each update.";
        ds_list_add(t_type.contents, element);
        t_type.size_wiggle = element;
        
        yy += element.height + spacing;
        
        element = create_text(col3_x, yy, "Life and Death", ew, eh, fa_left, ew, t_type);
        element.color = c_blue;
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col3_x, yy, "min:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.life_min = real(input.value);
                var f = game_get_speed(gamespeed_fps);
                part_type_life(type.type, type.life_min * f, type.life_max * f);
            }
        }, 10, "float", validate_double, 0.1, 60, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "The minimum lifetime of the particle type, in seconds.";
        ds_list_add(t_type.contents, element);
        t_type.life_min = element;
        
        element = create_input(col3_x + ew / 2, yy, "max:", ew, eh, function(input) {
            var selection = ui_list_selection(input.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
                type.life_max = real(input.value);
                var f = game_get_speed(gamespeed_fps);
                part_type_life(type.type, type.life_min * f, type.life_max * f);
            }
        }, 10, "float", validate_double, 0.1, 60, 6, ovx1, ovy1, ovx2, ovy2, t_type);
        element.tooltip = "The maximum lifetime of the particle type, in seconds.";
        ds_list_add(t_type.contents, element);
        t_type.life_max = element;
        
        yy += element.height + spacing;
        
        element = create_button(col3_x, yy, "Secondary Emission", ew, eh, fa_center, function(button) {
            var selection = ui_list_selection(button.root.list);
            if (selection + 1) {
                var type = Stuff.particle.types[selection];
            
                var dw = 640;
                var dh = 480;
            
                var dg = dialog_create(dw, dh, "Secondary Emission", dialog_default, dialog_destroy, button);
                dg.type = type;
                dg.active_shade = false;
            
                var columns = 2;
                var spacing = 16;
                var ew = dw / columns - spacing * 2;
                var eh = 24;
            
                var col1_x = dw * 0 / columns + spacing;
                var col2_x = dw * 1 / columns + spacing;
            
                var vx1 = ew / 2;
                var vy1 = 0;
                var vx2 = ew;
                var vy2 = eh;
            
                var yy = 64;
                var yy_base = yy;
            
                var el_update_list = create_list(col1_x, yy, "Update", "", ew, eh, 10, function(list) {
                    var selection = ui_list_selection(list);
                    var type = list.root.type;
                
                    if (selection + 1) {
                        var emissive_type = Stuff.particle.types[selection];
                        while (emissive_type) {
                            if (emissive_type == type) {
                                emu_dialog_notice("Please don't recursively create particles. This will most likely slow down the editor and cause it to crash within seconds.");
                                ui_list_deselect(list);
                                ui_list_select(list, array_search(Stuff.particle.types, type.update_type), false);
                                return;
                            }
                            if (emissive_type == emissive_type.update_type) break;
                            emissive_type = emissive_type.update_type;
                        }
                    
                        emissive_type = Stuff.particle.types[selection];
                        while (emissive_type) {
                            if (emissive_type == type) {
                                emu_dialog_notice("Please don't recursively create particles. This will most likely slow down the editor and cause it to crash within seconds.");
                                ui_list_deselect(list);
                                ui_list_select(list, array_search(Stuff.particle.types, type.update_type), false);
                                return;
                            }
                            if (emissive_type == emissive_type.death_type) break;
                            emissive_type = emissive_type.death_type;
                        }
                    
                        type.update_type = Stuff.particle.types[selection];
                        part_type_step(type.type, type.update_rate * Stuff.dt, type.update_type.type);
                    } else {
                        type.update_type = noone;
                        part_type_step(type.type, 0, -1);
                    }
                }, false, dg, Stuff.particle.types);
                ui_list_select(el_update_list, array_search(Stuff.particle.types, type.update_type), true);
                el_update_list.tooltip = "The secondary particles emitted over the lifetime of the particle. You're free to create a fork bomb by spawning particles recursively, although I'd like to ask that you don't, and if people abuse this power I'll remove it.";
                el_update_list.entries_are = ListEntries.INSTANCES;
            
                yy += ui_get_list_height(el_update_list) + spacing;
            
                var el_update_rate = create_input(col1_x, yy, "Rate:", ew, eh, function(input) {
                    var type = input.root.type;
                    type.update_rate = real(input.value);
                    if (type.update_type) {
                        var odds = editor_particle_rate_odds(type.update_rate);
                        part_type_step(type.type, odds, type.update_type.type);
                    }
                }, type.update_rate, "particles per second", validate_double, -1000, 1000, 6, vx1, vy1, vx2, vy2, dg);
                el_update_rate.tooltip = "How the rate at which secondary particles are emitted per second. Negative values will result in a fractional chance of emitting a particle.";
            
                yy = yy_base;
            
                var el_death_list = create_list(col2_x, yy, "Death", "", ew, eh, 10, function(list) {
                    var selection = ui_list_selection(list);
                    var type = list.root.type;
                    
                    if (selection + 1) {
                        var emissive_type = Stuff.particle.types[selection];
                        while (emissive_type) {
                            if (emissive_type == type) {
                                emu_dialog_notice("Please don't recursively create particles. This will most likely slow down the editor and cause it to crash within seconds.");
                                ui_list_deselect(list);
                                ui_list_select(list, array_search(Stuff.particle.types, type.death_type), false);
                                return;
                            }
                            if (emissive_type == emissive_type.update_type) break;
                            emissive_type = emissive_type.update_type;
                        }
                        
                        emissive_type = Stuff.particle.types[selection];
                        while (emissive_type) {
                            if (emissive_type == type) {
                                emu_dialog_notice("Please don't recursively create particles. This will most likely slow down the editor and cause it to crash within seconds.");
                                ui_list_deselect(list);
                                ui_list_select(list, array_search(Stuff.particle.types, type.death_type), false);
                                return;
                            }
                            if (emissive_type == emissive_type.death_type) break;
                            emissive_type = emissive_type.death_type;
                        }
                        
                        type.death_type = Stuff.particle.types[selection];
                        part_type_death(type.type, type.death_rate, type.death_type.type);
                    } else {
                        type.death_type = noone;
                        part_type_death(type.type, 0, -1);
                    }
                }, false, dg, Stuff.particle.types);
                ui_list_select(el_death_list, array_search(Stuff.particle.types, type.death_type), true);
                el_death_list.tooltip = "The secondary particles emitted when the particle is destroyed. You're free to create a fork bomb by spawning particles recursively, although I'd like to ask that you don't.";
                el_death_list.entries_are = ListEntries.INSTANCES;
            
                yy += ui_get_list_height(el_death_list) + spacing;
            
                var el_death_rate = create_input(col2_x, yy, "Count:", ew, eh, function(input) {
                    var type = input.root.type;
                    type.death_rate = real(input.value);
                    if (type.death_type) {
                        part_type_death(type.type, type.death_rate, type.death_type.type);
                    }
                }, type.death_rate, "particles per second", validate_double, 0, 1000, 6, vx1, vy1, vx2, vy2, dg);
                el_death_rate.tooltip = "The number of secondary particles emitted when the particle is destroyed.";
            
                yy += el_death_rate.height + spacing;
            
                var b_width = 128;
                var b_height = 32;
                var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dialog_destroy, dg);
        
                ds_list_add(dg.contents,
                    el_update_list,
                    el_update_rate,
                    el_death_list,
                    el_death_rate,
                    el_confirm
                );
            }
        }, t_type);
        element.tooltip = "Particles can emit other particles when they update, or upon death.";
        ds_list_add(t_type.contents, element);
        
        yy += element.height + spacing;
        
        t_type.name.next = t_type.speed_min;
        t_type.speed_min.next = t_type.speed_max;
        t_type.speed_max.next = t_type.speed_incr;
        t_type.speed_incr.next = t_type.speed_wiggle;
        t_type.speed_wiggle.next = t_type.direction_incr;
        t_type.direction_incr.next = t_type.direction_wiggle;
        t_type.direction_wiggle.next = t_type.orientation_incr;
        t_type.orientation_incr.next = t_type.orientation_wiggle;
        t_type.orientation_wiggle.next = t_type.gravity;
        t_type.gravity.next = t_type.xscale;
        t_type.xscale.next = t_type.yscale;
        t_type.yscale.next = t_type.size_min;
        t_type.size_min.next = t_type.size_max;
        t_type.size_max.next = t_type.size_incr;
        t_type.size_incr.next = t_type.size_wiggle;
        t_type.size_wiggle.next = t_type.life_min;
        t_type.life_min.next = t_type.life_max;
        t_type.life_max.next = t_type.name;
        
        t_type.name.previous = t_type.life_max;
        t_type.speed_min.previous = t_type.name;
        t_type.speed_max.previous = t_type.speed_min;
        t_type.speed_incr.previous = t_type.speed_max;
        t_type.speed_wiggle.previous = t_type.speed_incr;
        t_type.direction_incr.previous = t_type.speed_wiggle;
        t_type.direction_wiggle.previous = t_type.direction_incr;
        t_type.orientation_incr.previous = t_type.direction_wiggle;
        t_type.orientation_wiggle.previous = t_type.orientation_incr;
        t_type.gravity.previous = t_type.orientation_wiggle;
        t_type.xscale.previous = t_type.gravity;
        t_type.yscale.previous = t_type.xscale;
        t_type.size_min.previous = t_type.yscale;
        t_type.size_max.previous = t_type.size_min;
        t_type.size_incr.previous = t_type.size_max;
        t_type.size_wiggle.previous = t_type.size_incr;
        t_type.life_min.previous = t_type.size_wiggle;
        t_type.life_max.previous = t_type.life_min;
        #endregion
        
        return id;
    }
}