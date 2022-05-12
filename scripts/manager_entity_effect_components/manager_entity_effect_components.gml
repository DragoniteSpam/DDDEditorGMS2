function dialog_create_entity_effect_com_lighting() {
    var list = Stuff.map.selected_entities;
    var single = (ds_list_size(list) == 1);
    var first = list[| 0];
    var com_light = first ? first.com_light : undefined;
    var com_dir = (com_light && com_light.type == LightTypes.DIRECTIONAL) ? com_light : undefined;
    var com_point = (com_light && com_light.type == LightTypes.POINT) ? com_light : undefined;
    var com_spot = (com_light && com_light.type == LightTypes.SPOT) ? com_light : undefined;
    
    var element_width = 400 - 64;
    var element_height = 32;
    
    var dialog = new EmuDialog(400, 576, "Effect Component: Lighting");
    dialog.first = first;
    
    return dialog.AddContent([
        (new EmuRadioArray(32, EMU_AUTO, element_width, element_height, "Type", (single ? (com_light ? com_light.type : 0) : -1), function() {
            static component_light_types = [undefined, ComponentDirectionalLight, ComponentPointLight, ComponentSpotLight];
            var light_type = component_light_types[self.value];
            
            map_foreach_selected(function(entity, component) {
                if (component) component = new component(entity);
                // we if you select the same light type that the entity already
                // has, we won't change it
                if (instanceof(entity.com_light) == instanceof(component)) return;
                entity.com_light = component;
            }, light_type);
            
            var first = self.root.first.com_light;
            
            self.GetSibling("COLOR").SetInteractive(false);
            self.GetSibling("SCRIPT").SetInteractive(false);
            self.GetSibling("DX").SetInteractive(false);
            self.GetSibling("DY").SetInteractive(false);
            self.GetSibling("DZ").SetInteractive(false);
            self.GetSibling("RADIUS").SetInteractive(false);
            self.GetSibling("CONE ANGLE INNER").SetInteractive(false);
            self.GetSibling("CONE ANGLE OUTER").SetInteractive(false);
            
            switch (light_type) {
                case ComponentDirectionalLight:
                    self.GetSibling("COLOR").SetInteractive(true);
                    self.GetSibling("COLOR").SetValue(first.light_colour);
                    self.GetSibling("DX").SetInteractive(true);
                    self.GetSibling("DX").SetValue(first.light_dx);
                    self.GetSibling("DY").SetInteractive(true);
                    self.GetSibling("DY").SetValue(first.light_dy);
                    self.GetSibling("DZ").SetInteractive(true);
                    self.GetSibling("DZ").SetValue(first.light_dz);
                    break;
                case ComponentPointLight:
                    self.GetSibling("COLOR").SetInteractive(true);
                    self.GetSibling("COLOR").SetValue(first.light_colour);
                    self.GetSibling("RADIUS").SetInteractive(true);
                    self.GetSibling("RADIUS").SetValue(first.light_radius);
                    break;
                case ComponentSpotLight:
                    self.GetSibling("COLOR").SetInteractive(true);
                    self.GetSibling("COLOR").SetValue(first.light_colour);
                    self.GetSibling("DX").SetInteractive(true);
                    self.GetSibling("DX").SetValue(first.light_dx);
                    self.GetSibling("DY").SetInteractive(true);
                    self.GetSibling("DY").SetValue(first.light_dy);
                    self.GetSibling("DZ").SetInteractive(true);
                    self.GetSibling("DZ").SetValue(first.light_dz);
                    self.GetSibling("RADIUS").SetInteractive(true);
                    self.GetSibling("RADIUS").SetValue(first.light_radius);
                    self.GetSibling("CONE ANGLE INNER").SetInteractive(true);
                    self.GetSibling("CONE ANGLE INNER").SetValue(first.light_cutoff_inner);
                    self.GetSibling("CONE ANGLE OUTER").SetInteractive(true);
                    self.GetSibling("CONE ANGLE OUTER").SetValue(first.light_cutoff_inner);
                    break;
            }
        }))
            .AddOptions(["None", "Directional", "Point", "Spot (Cone)"])
            .SetID("TYPE")
            .SetTooltip("The lighting data to be attached to this effect.\n - Directional lights are infinite an illuminate everything\n - Point lights illuminate everything within a radius, fading out smoothly\n - Spot lights can be thought of as a combination of point and directional lights, illuminating everything in a certain direction"),
        #region common stuff
        (new EmuColorPicker(32, EMU_AUTO, element_width, element_height, "Light color:", com_light ? com_light.light_colour : c_white, function() {
            map_foreach_selected(function(entity, colour) {
                entity.com_light.light_colour = colour;
            }, self.value);
        }))
            .SetInteractive(!!com_light)
            .SetID("COLOR")
            .SetTooltip("The color of the light. White is fine, in most cases. Black makes no sense."),
        (new EmuInput(32, EMU_AUTO, element_width, element_height, "Script call:", com_light ? com_light.script_call : "", "function name", INTERNAL_NAME_LENGTH, E_InputTypes.LETTERSDIGITS, function() {
            map_foreach_selected(function(entity, name) {
                entity.com_light.script_call = name;
            }, self.value);
        }))
            .SetInteractive(!!com_light)
            .SetID("SCRIPT"),
        #endregion
        #region directional lights
        new EmuText(32, EMU_AUTO, element_width, element_height, "Direction:"),
        (new EmuInput(32 + element_width * 3 / 6, EMU_INLINE, element_width / 6, element_height, "", com_dir ? com_dir.light_dx: "", "X", 4, E_InputTypes.REAL, function() {
            map_foreach_selected(function(entity, dx) {
                entity.com_light.light_dx = dx;
            }, real(self.value));
        }))
            .SetInputBoxPosition(0, 0)
            .SetRealNumberBounds(-1, 1)
            .SetInteractive(!!com_dir)
            .SetTooltip("The X component of the light direction vector. If the total magnitude of the vector is zero, it will be set to (0, 0, -1) instead.")
            .SetID("DX"),
        (new EmuInput(32 + element_width * 4 / 6, EMU_INLINE, element_width / 6, element_height, "", com_dir ? com_dir.light_dy: "", "Y direction", 4, E_InputTypes.REAL, function() {
            map_foreach_selected(function(entity, dy) {
                entity.com_light.light_dz = dy;
            }, real(self.value));
        }))
            .SetInputBoxPosition(0, 0)
            .SetRealNumberBounds(-1, 1)
            .SetInteractive(!!com_dir)
            .SetTooltip("The Y component of the light direction vector. If the total magnitude of the vector is zero, it will be set to (0, 0, -1) instead.")
            .SetID("DY"),
        (new EmuInput(32 + element_width * 5 / 6, EMU_INLINE, element_width / 6, element_height, "", com_dir ? com_dir.light_dz: "", "Z direction", 4, E_InputTypes.REAL, function() {
            map_foreach_selected(function(entity, dz) {
                entity.com_light.light_dz = dz;
            }, real(self.value));
        }))
            .SetInputBoxPosition(0, 0)
            .SetRealNumberBounds(-1, 1)
            .SetInteractive(!!com_dir)
            .SetTooltip("The Z component of the light direction vector. If the total magnitude of the vector is zero, it will be set to (0, 0, -1) instead.")
            .SetID("DZ"),
        #endregion
        #region point lights
        (new EmuInput(32, EMU_AUTO, element_width, element_height, "Radius:", com_point ? com_point.light_radius: "", "radius", 4, E_InputTypes.REAL, function() {
            map_foreach_selected(function(entity, radius) {
                entity.com_light.light_radius = radius;
            }, real(self.value));
        }))
            .SetRealNumberBounds(0, 0x7fffffff)
            .SetInteractive(!!com_point)
            .SetTooltip("The light's range. A value between 100 and 1000 is normally fine. A value that's very small or very large doesn't make much sense, but will still work.")
            .SetID("RADIUS"),
        #endregion
        #region spot lights
        (new EmuInput(32, EMU_AUTO, element_width, element_height, "Inner Cutoff:", com_spot ? com_spot.light_cutoff_inner: "", "radius", 4, E_InputTypes.REAL, function() {
            map_foreach_selected(function(entity, radius) {
                entity.com_light.light_cutoff_inner = radius;
            }, real(self.value));
        }))
            .SetRealNumberBounds(0, 89)
            .SetInteractive(!!com_spot)
            .SetTooltip("The inner angle of the cone. Only space inside the cone angle will be lit.")
            .SetID("CONE ANGLE INNER"),
        (new EmuInput(32, EMU_AUTO, element_width, element_height, "Outer Cutoff:", com_spot ? com_spot.light_cutoff_outer: "", "radius", 4, E_InputTypes.REAL, function() {
            map_foreach_selected(function(entity, radius) {
                entity.com_light.light_cutoff_outer = radius;
            }, real(self.value));
        }))
            .SetRealNumberBounds(0, 89)
            .SetInteractive(!!com_spot)
            .SetTooltip("The outer angle of the cone. Only space inside the cone angle will be lit.")
            .SetID("CONE ANGLE OUTER"),
        #endregion
    ])
        .AddDefaultCloseButton();
}

function dialog_create_entity_effect_com_markers() {
    var list = Stuff.map.selected_entities;
    var single = (ds_list_size(list) == 1);
    var first = list[| 0];
    var marker = single ? first.com_marker : -1;
    
    var element_width = 400 - 64;
    var element_height = 32;
    
    var dialog = new EmuDialog(400, 576, "Effect Component: Marker");
    dialog.first = first;
    
    return dialog.AddContent([
        (new EmuList(32, EMU_AUTO, element_width, element_height, "Type", element_height, 14, function() {
            var selection = self.GetSelection();
            if (selection == -1) return;
            
            map_foreach_selected(function(entity, selection) {
                entity.com_marker = selection;
            }, selection);
        }))
            .SetVacantText("No marker types defined")
            .SetID("LIST")
            .Select(marker)
    ])
        .AddDefaultCloseButton();
}