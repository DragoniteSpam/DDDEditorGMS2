varying float v_LightDepth;

const float SCALE_FACTOR = 16777215.0;
vec4 toDepthColor(float depth) {
	float int_kinda = depth * SCALE_FACTOR;
	return vec4(
		floor(mod(int_kinda, 256.0) / 256.0),
		floor(mod(int_kinda / 256.0, 256.0) / 256.0),
		floor(int_kinda / 65536.0) / 256.0,
		1
	);
}

void main() {
    gl_FragColor = toDepthColor(v_LightDepth);
}