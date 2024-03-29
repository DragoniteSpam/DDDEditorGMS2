function omu_animation_properties(root) {
    var animation = root.root.active_animation;
    
    if (animation) {
        var dw = 720;
        var dh = 400;
        
        var dg = dialog_create(dw, dh, "Animation Properties", undefined, undefined, root);
        
        var columns = 2;
        var spacing = 16;
        var ew = dw / columns - spacing * 2;
        var eh = 24;
        
        var vx1 = ew / 2 + 16;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
        
        var b_width = 128;
        var b_height = 32;
        
        var yy = 64;
        var yy_base = yy;
        
        var el_name = create_input(16, yy, "Name:", ew, eh, function (input) {
            input.root.root.root.active_animation.name = input.value;
        }, animation.name, "text", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
        
        yy += el_name.height + spacing;
        
        var el_internal_name = create_input(16, yy, "Internal Name:", ew, eh, function(input) {
            if (!internal_name_get(input.value)) {
                internal_name_set(input.root.root.root.active_animation, input.value);
            }
        }, animation.internal_name, "Internal name", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
        el_internal_name.render = function(input, x, y) {
            var data = input.root.root.root.active_animation;
            var selection = ui_list_selection(input.root.root.root.el_master);
            var original_color = input.color;
            if (selection + 1) {
                var exists = internal_name_get(input.value);
                if (exists && exists != data) input.color = c_red;
            }
            ui_render_input(input, x, y);
            input.color = original_color;
        };
        
        yy += el_internal_name.height + spacing;
        
        var el_frame_rate = create_input(16, yy, "Moment rate:", ew, eh, function(input) {
            var animation = input.root.root.root.active_animation;
            animation.frames_per_second = real(input.value);
            input.root.el_seconds.text = "Duration (seconds): " + string(animation.moments / animation.frames_per_second);
        }, string(animation.frames_per_second), "integer", validate_int, 1, 96, 2, vx1, vy1, vx2, vy2, dg);
        
        yy += el_frame_rate.height + spacing;
        
        var el_moments = create_input(16, yy, "Moments:", ew, eh, function(input) {
            var animation = input.root.root.root.active_animation;
            input.root.el_seconds.text = "Duration (seconds): " + string(animation.moments / animation.frames_per_second);
        }, string(animation.moments), "integer", validate_int, 1, 65535, 3, vx1, vy1, vx2, vy2, dg);
        dg.el_moments = el_moments;
        
        yy += el_moments.height + spacing;
        
        var el_seconds = create_text(16, yy, "Duration (seconds): " + string(animation.moments / animation.frames_per_second), ew, eh, fa_left, ew, dg);
        dg.el_seconds = el_seconds;
        
        yy += el_seconds.height + spacing;
        
        vx1 = ew / 2 - 16;
        vy1 = 0;
        vx2 = ew;
        vy2 = eh;
        
        var el_code = create_button(16, yy, "Code", ew, eh, fa_middle, function() {
            emu_dialog_notice("create some new code editor sometime maybe");
        }, dg);
        
        yy += el_code.height + spacing;
        
        yy = yy_base;
        
        var el_explanation = create_text(dg.width / 2 + 16, dg.height / 2 - 16, "The moment rate only determines how many keyframes you can use per second - the actual animation will play at the same speed as the game (probably 60 fps).\n\nIf you shorten an animation, any keyframes after the end will continue to exist, they'll just be in accessible unless you add time back. If you want to get rid of them, click the button.", ew, eh, fa_left, ew, dg);
        yy += el_explanation.height + spacing;
        
        var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, function(button) {
            var animation = button.root.root.root.active_animation;
            var moments = button.root.el_moments.value;
            if (!validate_double(moments)) return;
            
            moments = real(moments);
            if (moments < animation.moments) {
                var dg = emu_dialog_confirm(button.root, "You are sizing the animation down. Are you sure you want to do this? Keyframes on the end will be lost!", function() {
                    self.root.animation.SetLength(self.root.moments);
                    self.root.Dispose();
                    self.root.root.Dispose();
                });
                dg.root = button.root;
                dg.animation = animation;
                dg.moments = moments;
            } else {
                animation.SetLength(moments);
                dmu_dialog_commit(button);
            }
        }, dg);
        
        ds_list_add(dg.contents,
            el_name,
            el_internal_name,
            el_frame_rate,
            el_moments,
            el_seconds,
            el_code,
            el_explanation,
            el_confirm
        );
    }
}