attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                   // (x,y,z)
attribute vec2 in_TextureCoord;             // (u,v)
attribute vec4 in_Colour;                   // (r,g,b,a)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#define MAX_LIGHTS 6
uniform int lightEnabled;
uniform vec4 lightData[3 * MAX_LIGHTS];
uniform int lightCount;

void main() {
    vec4 position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
	vec3 worldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
    vec3 worldPosition = vec3(gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.));
	
	vec4 finalColor = vec4(0.);
	
	for (int i = 0; i < MAX_LIGHTS * 3; i += 3) {
		if (i >= lightCount * 3) {
			break;
		}
		
		vec3 lightPosition = lightData[i].xyz;
		float type = lightData[i].w;
		vec4 lightExt = lightData[i + 1];
		vec4 lightColor = vec4(lightData[i + 2].rgb, 1.);
		
		if (type == 0.) {
			// directional light: [|x, y, z, type,| |0, 0, 0, 0,| |r, g, b, 0|]
		    float NdotL = max(dot(worldNormal, lightPosition), 0.);
			things are breaking around here
		    finalColor = NdotL * lightColor;
		} else if (type == 1.) {
			// point light: [|x, y, z, type,| |0, 0, 0, range,| |r, g, b, 0|]
			/*float intensity = lightExt.w;
			vec3 lightDir = worldPosition - lightPosition;
			float dist = length(lightDir);
			float att = clamp((1. - dist * dist / (intensity * intensity)), 0., 1.);
			lightDir /= dist;
			*/
			//finalColor = finalColor + lightColor * max(0., -dot(worldNormal, lightDir)) * 1.;
		} else if (type == 2.) {
			// spot light: [|x, y, z, type,| |x', y', z', angle,| |r, g, b, intensity|]
			/*vec3 spotDirection = lightExt.xyz;
			float lightAngle = lightExt.w;
			float intensity = lightColor.w;
			vec3 lightDir = worldPosition - lightPosition;
			float dist = length(lightDir);
			float att;
			lightDir /= dist;
			
			if (dot(lightDir, spotDirection) > lightAngle) {
				att = clamp((1. - dist * dist / (intensity * intensity)), 0., 1.);
				att *= clamp(0., 1., 4. * (dot(lightDir, spotDirection) - lightAngle) / (1. - lightAngle));
			} else {
				lightColor = vec4(0.);
				att = 0.;
			}
			*/
			//finalColor = finalColor + lightColor * max(0., -dot(worldNormal, lightDir)) * att * in_Colour;
		}
	}
    
    gl_Position = position;
    v_vColour = vec4(min(finalColor, vec4(1.)).rgb, in_Colour.a);
    v_vTexcoord = in_TextureCoord;
}