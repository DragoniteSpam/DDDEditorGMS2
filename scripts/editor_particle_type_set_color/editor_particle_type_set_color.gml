/// @param ParticleType

var type = argument0;

if (type.color_1b_enabled) {
    part_type_color_mix(type.type, type.color_1a, type.color_1b);
    part_type_alpha1(type.type, type.alpha_1);
} else {
    if (type.color_3_enabled) {
        part_type_color3(type.type, type.color_1a, type.color_2, type.color_3);
        part_type_alpha3(type.type, type.alpha_1, type.alpha_2, type.alpha_3);
    } else if (type.color_2_enabled) {
        part_type_color2(type.type, type.color_1a, type.color_2);
        part_type_alpha2(type.type, type.alpha_1, type.alpha_2);
    } else {
        part_type_color1(type.type, type.color_1a);
        part_type_alpha1(type.type, type.alpha_1);
    }
}