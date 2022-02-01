varying float v_LightDepth;

const float SCALE_FACTOR = 16777215.0;
vec3 toDepthColor(float depth) {
	float int_kinda = depth * SCALE_FACTOR;
	return floor(vec3(mod(int_kinda, 256.0), mod(int_kinda / 256.0, 256.0), int_kinda / 65536.0)) / 255.0;
}

void main() {
    gl_FragColor = vec4(toDepthColor(v_LightDepth), 1);
}