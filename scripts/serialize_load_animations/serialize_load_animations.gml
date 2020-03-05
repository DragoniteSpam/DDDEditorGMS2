/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var addr_next = buffer_read(buffer, buffer_u64);

var n_animations = buffer_read(buffer, buffer_u16);

repeat (n_animations) {
    var animation = animation_create();
    var default_layer = animation.layers[| 0];
    instance_activate_object(default_layer);
    instance_destroy(default_layer);
    ds_list_clear(animation.layers);
    serialize_load_generic(buffer, animation, version);
    
    animation.frames_per_second = buffer_read(buffer, buffer_u8);
    animation.moments = buffer_read(buffer, buffer_u16);
    animation.code = buffer_read(buffer, buffer_string);
    
    var bools = buffer_read(buffer, buffer_u32);
    animation.loops = unpack(bools, 0);
    
    var n_layers = buffer_read(buffer, buffer_u8);
    repeat (n_layers) {
        var layer_name = buffer_read(buffer, buffer_string);
        var timeline_layer = animation_layer_create(animation, layer_name);
        
        var layer_bools = buffer_read(buffer, buffer_u8);
        timeline_layer.is_actor = unpack(layer_bools, 0);
        
        timeline_layer.xx = buffer_read(buffer, buffer_f32);
        timeline_layer.yy = buffer_read(buffer, buffer_f32);
        timeline_layer.zz = buffer_read(buffer, buffer_f32);
        timeline_layer.xrot = buffer_read(buffer, buffer_f32);
        timeline_layer.yrot = buffer_read(buffer, buffer_f32);
        timeline_layer.zrot = buffer_read(buffer, buffer_f32);
        timeline_layer.xscale = buffer_read(buffer, buffer_f32);
        timeline_layer.yscale = buffer_read(buffer, buffer_f32);
        timeline_layer.zscale = buffer_read(buffer, buffer_f32);
        
        timeline_layer.color = buffer_read(buffer, buffer_u32);
        timeline_layer.alpha = buffer_read(buffer, buffer_f32);
        
        timeline_layer.graphic_type = buffer_read(buffer, buffer_u8);
        timeline_layer.graphic_sprite = buffer_read(buffer, buffer_datatype);
        timeline_layer.graphic_mesh = buffer_read(buffer, buffer_datatype);
        if (version >= DataVersions.EXTRA_ANIMATION_DATA) {
        } else {
            buffer_read(buffer, buffer_f32);
        }
        
        var n_keyframes = buffer_read(buffer, buffer_u16);
        repeat (n_keyframes) {
            var exists = buffer_read(buffer, buffer_bool);
            
            if (exists) {
                var moment = buffer_read(buffer, buffer_u16);
                var layer_number = buffer_read(buffer, buffer_u8);
                var keyframe = animation_add_keyframe(animation, layer_number, moment);
                
                keyframe.xx = buffer_read(buffer, buffer_f32);
                keyframe.yy = buffer_read(buffer, buffer_f32);
                keyframe.zz = buffer_read(buffer, buffer_f32);
                keyframe.xrot = buffer_read(buffer, buffer_f32);
                keyframe.yrot = buffer_read(buffer, buffer_f32);
                keyframe.zrot = buffer_read(buffer, buffer_f32);
                keyframe.xscale = buffer_read(buffer, buffer_f32);
                keyframe.yscale = buffer_read(buffer, buffer_f32);
                keyframe.zscale = buffer_read(buffer, buffer_f32);
        
                keyframe.color = buffer_read(buffer, buffer_u32);
                keyframe.alpha = buffer_read(buffer, buffer_f32);
                
                keyframe.graphic_type = buffer_read(buffer, buffer_u8);
                keyframe.graphic_sprite = buffer_read(buffer, buffer_datatype);
                keyframe.graphic_mesh = buffer_read(buffer, buffer_datatype);
                keyframe.graphic_frame = buffer_read(buffer, buffer_u32);
                if (version >= DataVersions.EXTRA_ANIMATION_DATA) {
                    keyframe.graphic_direction = buffer_read(buffer, buffer_u8);
                }
                
                keyframe.audio = buffer_read(buffer, buffer_datatype);
                keyframe.event = buffer_read(buffer, buffer_string);
                
                keyframe.tween_xx = buffer_read(buffer, buffer_u16);
                keyframe.tween_yy = buffer_read(buffer, buffer_u16);
                keyframe.tween_zz = buffer_read(buffer, buffer_u16);
                keyframe.tween_xrot = buffer_read(buffer, buffer_u16);
                keyframe.tween_yrot = buffer_read(buffer, buffer_u16);
                keyframe.tween_zrot = buffer_read(buffer, buffer_u16);
                keyframe.tween_xscale = buffer_read(buffer, buffer_u16);
                keyframe.tween_yscale = buffer_read(buffer, buffer_u16);
                keyframe.tween_zscale = buffer_read(buffer, buffer_u16);
                
                keyframe.tween_color = buffer_read(buffer, buffer_u16);
                keyframe.tween_alpha = buffer_read(buffer, buffer_u16);
                
                keyframe.relative = buffer_read(buffer, buffer_s16);
            }
        }
    }
}