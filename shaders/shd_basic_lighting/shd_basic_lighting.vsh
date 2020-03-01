attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                   // (x,y,z)
attribute vec2 in_TextureCoord;             // (u,v)
attribute vec4 in_Colour;                   // (r,g,b,a)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#pragma include("lighting.xsh")

void main() {
    vec4 position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
    vec3 worldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
    vec3 worldPosition = vec3(gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.));
    
    vec4 finalColor = CommonLighting(worldPosition, worldNormal);
    
    v_vColour = vec4(min(finalColor, vec4(1.)).rgb, in_Colour.a);
    gl_Position = position;
    v_vTexcoord = in_TextureCoord;
}