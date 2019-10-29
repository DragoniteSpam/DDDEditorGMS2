attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                   // (x,y,z)
attribute vec2 in_TextureCoord;             // (u,v)
attribute vec4 in_Colour;                   // (r,g,b,a)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int lightEnabled;
uniform vec3 lightPosition;
uniform int lightCount;

void main() {
    vec4 position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
    
    vec3 worldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
    vec3 lightDir = normalize(lightPosition);
    float NdotL = max(dot(worldNormal, lightDir), 0.);
    vec4 diffuse = NdotL * vec4(1., 1., 1., 1.);
    
    gl_Position = position;
    v_vColour = diffuse;
    v_vTexcoord = in_TextureCoord;
}