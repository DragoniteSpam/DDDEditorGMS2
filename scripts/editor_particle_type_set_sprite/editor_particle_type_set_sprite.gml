/// @param ParticleType

var type = argument0;

if (type.sprite_custom) {
    if (type.sprite) {
        part_type_sprite(type.type, type.sprite.picture, type.sprite_animated, type.sprite_stretched, type.sprite_random);
    }
} else {
    part_type_shape(type.type, type.type_shapes[type.shape]);
}