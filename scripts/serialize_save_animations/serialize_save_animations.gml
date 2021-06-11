/// @param buffer
function serialize_save_animations(argument0) {

    var buffer = argument0;

    buffer_write(buffer, buffer_u32, SerializeThings.ANIMATIONS);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);

    var n_animations = array_length(Game.animations);

    buffer_write(buffer, buffer_u16, n_animations);

    for (var i = 0; i < n_animations; i++) {
        var animation = Game.animations[i];
        serialize_save_generic(buffer, animation);
    
        buffer_write(buffer, buffer_u8, animation.frames_per_second);
        buffer_write(buffer, buffer_u16, animation.moments);
        buffer_write(buffer, buffer_string, animation.code);
    
        var bools = pack(animation.loops);
        buffer_write(buffer, buffer_u32, bools);
    
        var n_layers = ds_list_size(animation.layers);
        buffer_write(buffer, buffer_u8, n_layers);
    
        for (var j = 0; j < n_layers; j++) {
            var timeline_layer = animation.layers[| j];
        
            buffer_write(buffer, buffer_string, timeline_layer.name);
        
            bools = pack(timeline_layer.is_actor);
            buffer_write(buffer, buffer_u8, bools);
        
            buffer_write(buffer, buffer_f32, timeline_layer.xx);
            buffer_write(buffer, buffer_f32, timeline_layer.yy);
            buffer_write(buffer, buffer_f32, timeline_layer.zz);
            buffer_write(buffer, buffer_f32, timeline_layer.xrot);
            buffer_write(buffer, buffer_f32, timeline_layer.yrot);
            buffer_write(buffer, buffer_f32, timeline_layer.zrot);
            buffer_write(buffer, buffer_f32, timeline_layer.xscale);
            buffer_write(buffer, buffer_f32, timeline_layer.yscale);
            buffer_write(buffer, buffer_f32, timeline_layer.zscale);
        
            buffer_write(buffer, buffer_u32, timeline_layer.color);
            buffer_write(buffer, buffer_f32, timeline_layer.alpha);
        
            buffer_write(buffer, buffer_u8, timeline_layer.graphic_type);
            buffer_write(buffer, buffer_datatype, timeline_layer.graphic_sprite);
            buffer_write(buffer, buffer_datatype, timeline_layer.graphic_mesh);
        
            // this is not the same as animation.moments, since old keyframes can exist beyond the end
            // of the animation - or, the list might not be the same size as the animation in general
            var n_keyframes = array_length(timeline_layer.keyframes);
            buffer_write(buffer, buffer_u16, n_keyframes);
        
            for (var k = 0; k < n_keyframes; k++) {
                var keyframe = timeline_layer.keyframes[k];
                buffer_write(buffer, buffer_bool, !!keyframe);
            
                if (keyframe) {
                    buffer_write(buffer, buffer_u16, keyframe.moment);
                    buffer_write(buffer, buffer_u8, keyframe.timeline_layer);
                
                    buffer_write(buffer, buffer_f32, keyframe.xx);
                    buffer_write(buffer, buffer_f32, keyframe.yy);
                    buffer_write(buffer, buffer_f32, keyframe.zz);
                    buffer_write(buffer, buffer_f32, keyframe.xrot);
                    buffer_write(buffer, buffer_f32, keyframe.yrot);
                    buffer_write(buffer, buffer_f32, keyframe.zrot);
                    buffer_write(buffer, buffer_f32, keyframe.xscale);
                    buffer_write(buffer, buffer_f32, keyframe.yscale);
                    buffer_write(buffer, buffer_f32, keyframe.zscale);
            
                    buffer_write(buffer, buffer_u32, keyframe.color);
                    buffer_write(buffer, buffer_f32, keyframe.alpha);
            
                    buffer_write(buffer, buffer_u8, keyframe.graphic_type);
                    buffer_write(buffer, buffer_datatype, keyframe.graphic_sprite);
                    buffer_write(buffer, buffer_datatype, keyframe.graphic_mesh);
                    buffer_write(buffer, buffer_u32, keyframe.graphic_frame);
                    buffer_write(buffer, buffer_u8, keyframe.graphic_direction);
                
                    buffer_write(buffer, buffer_datatype, keyframe.audio);
                    buffer_write(buffer, buffer_string, keyframe.event);
            
                    buffer_write(buffer, buffer_u16, keyframe.tween.x);
                    buffer_write(buffer, buffer_u16, keyframe.tween.y);
                    buffer_write(buffer, buffer_u16, keyframe.tween.z);
                    buffer_write(buffer, buffer_u16, keyframe.tween.xrot);
                    buffer_write(buffer, buffer_u16, keyframe.tween.yrot);
                    buffer_write(buffer, buffer_u16, keyframe.tween.zrot);
                    buffer_write(buffer, buffer_u16, keyframe.tween.xscale);
                    buffer_write(buffer, buffer_u16, keyframe.tween.yscale);
                    buffer_write(buffer, buffer_u16, keyframe.tween.zscale);
            
                    buffer_write(buffer, buffer_u16, keyframe.tween.color);
                    buffer_write(buffer, buffer_u16, keyframe.tween.alpha);
                
                    buffer_write(buffer, buffer_s16, keyframe.relative);
                }
            }
        }
    }

    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

    return buffer_tell(buffer);


}
