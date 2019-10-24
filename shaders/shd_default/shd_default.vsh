attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;					 // (x,y,z)
attribute vec2 in_TextureCoord;              // (u,v)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec4 extra;                        // (autotiles - not used here)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    vec4 object_space_pos = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    vec4 vertex_colour = in_Colour;
	
	#if 0
	if (gm_VS_FogEnabled) {
		float f = clamp((length(object_space_pos.xyz) - gm_FogStart) / (gm_RcpFogRange - gm_FogStart), 0., 1.);
		vertex_colour = mix(vertex_colour, gmFogColour(), f);
	}
	#endif
	
	gl_Position = object_space_pos;
    
    v_vColour = vertex_colour;
    v_vTexcoord = in_TextureCoord;
}

#if 0
vec4 gmFogColour() {
	return vec4((gm_FogColour & 0x0000ff) * 1., ((gm_FogColour & 0x00ff00) >> 8) * 1., ((gm_FogColour & 0xff0000) >> 16) * 1., 1.);
}
#endif