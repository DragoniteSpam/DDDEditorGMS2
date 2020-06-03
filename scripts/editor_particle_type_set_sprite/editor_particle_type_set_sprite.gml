/// @param ParticleType

var type = argument0;
var sprite = guid_get(type.sprite);

if (type.sprite_custom && sprite) {
    part_type_sprite(type.type, sprite.picture_with_frames, type.sprite_animated, type.sprite_stretched, type.sprite_random);
} else {
    part_type_shape(type.type, type.type_shapes[type.shape]);
}