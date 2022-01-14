attribute vec3 in_Position;
attribute vec3 in_Normal;

varying float v_FragDistance;
varying vec4 v_vWorldPosition;
varying vec3 v_FragWorldPosition;
varying vec3 v_Barycentric;
varying vec3 v_Texcoord;

uniform vec2 u_TerrainSize;
uniform vec2 u_TextureTileSize;

void main() {
    v_vWorldPosition = vec4(floor(in_Position.xy), in_Position.z, 1);
    v_FragWorldPosition = (gm_Matrices[MATRIX_WORLD] * v_vWorldPosition).xyz;
    v_FragDistance = length((gm_Matrices[MATRIX_WORLD_VIEW] * v_vWorldPosition).xyz);
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * v_vWorldPosition;
    
    float f = fract(in_Position.x) * 8.0;
    v_Barycentric = vec3(
        1.0 - min(abs(1.0 - f), 1.0),
        1.0 - min(abs(2.0 - f), 1.0),
        1.0 - min(abs(4.0 - f), 1.0)
    );
    
    // the triangle internal texture offset gets squeezed into the fractional part of the Y coordinate, also
	//  - (U + tile size) coordinate: 0.25
	//  - (V + tile size) coordinate: 0.125
	v_Texcoord.x = floor(fract(in_Position.y * 2.0) * 2.0);
	v_Texcoord.y = floor(fract(in_Position.y * 4.0) * 2.0);
	v_Texcoord.xy /= u_TextureTileSize;
    
    // triangle index:
    //  - 0.0: first triangle (RG)
    //  - 0.5: second triangle (BA)
    v_Texcoord.z = floor(in_Position.y * 2.0);
}