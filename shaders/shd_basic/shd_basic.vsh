attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                   // (x,y,z)
attribute vec2 in_TextureCoord;             // (u,v)
attribute vec4 in_Colour;                   // (r,g,b,a)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#define MAXLIGHTS 8
uniform int lightEnabled;
uniform vec3 lightPosition;
uniform int lightCount;

vec4 ApplyDirLight(vec3 ws_normal, vec4 dir, vec4 diffusecol);
vec4 ApplyPointLight(vec3 ws_pos, vec3 ws_normal, vec4 posrange, vec4 diffusecol);
vec4 ApplyLighting(vec4 vertexcolour, vec4 objectspacepos, vec3 objectspacenormal);

void main() {
    vec4 position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position.xyz, 1.);
    vec4 colour = ApplyLighting(in_Colour, position, in_Normal);
    
    gl_Position = position;
    v_vColour = colour;
    v_vTexcoord = in_TextureCoord;
}

vec4 ApplyDirLight(vec3 ws_normal, vec4 dir, vec4 diffusecol) {
    float dotresult = dot(ws_normal, dir.xyz);
	dotresult = max(0.0, dotresult);
    
	return dotresult * diffusecol;
}

vec4 ApplyPointLight(vec3 ws_pos, vec3 ws_normal, vec4 posrange, vec4 diffusecol) {
	vec3 diffvec = ws_pos - posrange.xyz;
	float veclen = length(diffvec);
	diffvec /= veclen;	// normalise
	// This is based on the Win32 D3D and OpenGL falloff model, where:
	// Attenuation = 1.0f / (factor0 + (d * factor1) + (d*d * factor2))
	// For some reason, factor0 is set to 0.0f while factor1 is set to 1.0f/lightrange (on both D3D and OpenGL)
	// This'll result in no visible falloff as 1.0f / (d / lightrange) will always be larger than 1.0f (if the vertex is within range)
	float atten = 1.0 / (veclen / posrange.w);
	if (veclen > posrange.w) {
		atten = 0.0;
	}
	float dotresult = dot(ws_normal, diffvec);
	dotresult = max(0.0, dotresult);
    
	return dotresult * atten * diffusecol;
}

vec4 ApplyLighting(vec4 vertexcolour, vec4 objectspacepos, vec3 objectspacenormal) {
	if (lightEnabled == 1) {
		// Normally we'd have the light positions\\directions back-transformed from world to object space
		// But to keep things simple for the moment we'll just transform the normal to world space
		vec4 objectspacenormal4 = vec4(objectspacenormal, 0.0);
		vec3 ws_normal;
		ws_normal = (gm_Matrices[MATRIX_WORLD_VIEW] * objectspacenormal4).xyz;
		ws_normal = -normalize(ws_normal);
        
		vec3 ws_pos;
		ws_pos = (gm_Matrices[MATRIX_WORLD] * objectspacepos).xyz;
        
		// Accumulate lighting from different light types
		vec4 accumcol = vec4(0.0, 0.0, 0.0, 0.0);		
		for (int i = 0; i < MAXLIGHTS; i++) {
			//accumcol += ApplyDirLight(ws_normal, lightArray[i], vec4(1., 1., 1., 1.));
		}
        accumcol += ApplyDirLight(ws_normal, vec4(lightPosition.xyz, 1.), vec4(1., 1., 1., 1.));
        
		for(int i = 0; i < MAX_VS_LIGHTS; i++) {
			//accumcol += ApplyPointLight(ws_pos, ws_normal, gm_Lights_PosRange[i], gm_Lights_Colour[i]);
		}
        
		accumcol *= vertexcolour;
		accumcol += vec4(0., 0., 0., 0.);
		accumcol = min(vec4(1.0, 1.0, 1.0, 1.0), accumcol);
		accumcol.a = vertexcolour.a;
		return accumcol;
	} else {
		return vertexcolour;
	}
}