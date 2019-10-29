attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                   // (x,y,z)
attribute vec2 in_TextureCoord;             // (u,v)
attribute vec4 in_Colour;                   // (r,g,b,a)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#define MAX_LIGHTS 8
uniform int lightEnabled;
uniform vec4 lightPositions[MAX_LIGHTS];
uniform int lightCount;

void main() {
    vec4 position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
	vec3 worldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
    vec3 worldPosition = vec3(gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.));
	
	vec4 finalColor = vec4(0.);
	
	for (int i = 0; i < MAX_LIGHTS; i++) {
		if (i >= lightCount) {
			break;
		}
		
		float type = lightPositions[i].w;
		vec3 lightPosition = lightPositions[i].xyz;
		
		if (type < 1.) {
			// directional light
		    vec3 lightDir = -normalize(lightPosition.xyz);
		    float NdotL = max(dot(worldNormal, lightDir), 0.);
		    finalColor = finalColor + NdotL * in_Colour;
		} else if (type < 2.) {
			float intensity = (type - 1.) * 10000.;
			// point light
			vec3 lightDir = worldPosition - lightPosition;
			float dist = length(lightDir);
			float att = clamp((1.0 - dist * dist / (intensity * intensity)), 0.0, 1.0);
			lightDir /= dist;
			att *= att;
			//finalColor = finalColor + vec4(1.) * att;
			finalColor += vec4(1.) * max(0., -dot(worldNormal, lightDir)) * 1.;
			//finalColor = vec4(0., .5, 0., 1.);
		} else {
			
		}
	}
    
    gl_Position = position;
    v_vColour = vec4(min(finalColor, vec4(1.)).rgb, in_Colour.a);
    v_vTexcoord = in_TextureCoord;
}