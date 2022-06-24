function dialog_create_entity_event_page(page) {
    var entity = Stuff.map.selected_entities[| 0];
    var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 640, "Event Page");
    dialog.entity = entity;
    dialog.page = page;
    var element_width = 320;
    var element_height = 32;
    
    var col1 = 32;
    var col2 = 32 + 320 + 32;
    
    var indent = 64;
    
    dialog.initialized = false;
    
    dialog.AddContent([
        (new EmuInput(col1, EMU_BASE, element_width, element_height, "Name:", page.name, "Name of the event", VISIBLE_NAME_LENGTH, E_InputTypes.STRING, function() {
            self.root.page.name = self.value;
        }))
            .SetTooltip("The name of the event. You alread knew that."),
        (new EmuCheckbox(col1, EMU_AUTO, element_width, element_height, "Enabled", page.enabled, function() {
            self.root.page.enabled = self.value;
        }))
            .SetTooltip("Disabling the event will prevent it from firing."),
        new EmuText(col1, EMU_AUTO, element_width, element_height, "[c_aqua]Conditions:"),
        (new EmuCheckbox(col1, EMU_AUTO, indent, element_height, "", page.condition_switch_global_enabled, function() {
            self.root.page.condition_switch_global_enabled = self.value;
        })),
        (new EmuButton(col1 + indent, EMU_INLINE, element_width - indent, element_height, "Global Switch", function() {
            omu_event_condition_attain_switch_data();
        }))
            .SetTooltip("Require a global switch to be set to a particular value in order for this event to fire."),
        (new EmuCheckbox(col1, EMU_AUTO, indent, element_height, "", page.condition_variable_global_enabled, function() {
            self.root.page.condition_variable_global_enabled = self.value;
        })),
        (new EmuButton(col1 + indent, EMU_INLINE, element_width - indent, element_height, "Global Variable", function() {
            omu_event_condition_attain_variable_data();
        }))
            .SetTooltip("Require a global variable to be set to a particular value in order for this event to fire."),
        (new EmuCheckbox(col1, EMU_AUTO, indent, element_height, "", page.condition_switch_self_enabled, function() {
            self.root.page.condition_switch_self_enabled = self.value;
        })),
        (new EmuButton(col1 + indent, EMU_INLINE, element_width - indent, element_height, "Self Switch", function() {
            omu_event_condition_attain_switch_self_data();
        }))
            .SetTooltip("Require an entity switch to be set to a particular value in order for this event to fire."),
        (new EmuCheckbox(col1, EMU_AUTO, indent, element_height, "", page.condition_variable_self_enabled, function() {
            self.root.page.condition_variable_self_enabled = self.value;
        })),
        (new EmuButton(col1 + indent, EMU_INLINE, element_width - indent, element_height, "Self Variable", function() {
            omu_event_condition_attain_variable_self_data();
        }))
            .SetTooltip("Require a entity variable to be set to a particular value in order for this event to fire."),
        (new EmuCheckbox(col1, EMU_AUTO, indent, element_height, "", page.condition_code_enabled, function() {
            self.root.page.condition_code_enabled = self.value;
        }))
            .SetInteractive(false),
        (new EmuButton(col1 + indent, EMU_INLINE, element_width - indent, element_height, "Code", function() {
            // who knows if we'll be bringing tis back ¯\_(ツ)_/¯
        }))
            .SetInteractive(false)
            .SetTooltip("Evaluate a bit of code in order for this event to fire."),
        new EmuText(col1, EMU_AUTO, element_width, element_height * 4, "If no conditions are enabled, the event will always execute when triggered. If more than one are enabled, the event will only execute when all of them are met."),
        (new EmuList(col2, EMU_BASE, element_width, element_height, "Trigger Method(s)", element_height, 8, function() {
            if (!self.root) return;
            if (!self.root.initialized) return;
            self.root.page.trigger = 0;
            for (var i = 0, n = array_length(Game.vars.triggers); i < n; i++) {
                if (self.GetSelected(i)) {
                    self.root.page.trigger |= 1 << i;
                }
            }
        }))
            .SetList(Game.vars.triggers)
            .SetMultiSelect(true, true, true)
            .SetRefresh(function() {
                self.Deselect();
                for (var i = 0; i < array_length(Game.vars.triggers); i++) {
                    if (self.root.page.trigger & (1 << i)) {
                        self.Select(i);
                    }
                }
            })
            .SetTooltip("A list of trigger methods that may cause events to fire; go to Game Settings > Event Triggers to define some more of your own."),
        (new EmuButton(col2, EMU_AUTO, element_width, element_height, "Select Event", function() {
            emu_dialog_get_event(guid_get(self.root.page.event_entrypoint), function() {
                var selection = self.GetSibling("ENTRYPOINTS").GetSelectedItem();
                self.root.data.root.page.event_entrypoint = selection ? selection.GUID : NULL;
                self.root.data.Refresh();
            }, self);
        }))
            .SetRefresh(function() {
                var entrypoint = guid_get(self.root.page.event_entrypoint);
                self.text = entrypoint ? entrypoint.GetShortName() : "Select Event";
            })
            .SetTooltip("The event node that is attached to this event page."),
    ]).AddDefaultCloseButton().Refresh();
    
    dialog.initialized = true;
    
    return dialog;
}
