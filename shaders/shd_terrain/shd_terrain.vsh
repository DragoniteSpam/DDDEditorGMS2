attribute vec3 in_Position;

varying float v_FragDistance;
varying vec4 v_WorldPosition;
varying vec3 v_Barycentric;
varying vec2 v_Texcoord;

uniform float u_TerrainScale;
uniform vec2 u_TerrainSizeV;
uniform vec2 u_TextureTileSize;

uniform mat4 u_LightVP;

varying float v_LightDistance;
varying vec2 v_ShadowTexcoord;

void main() {
    v_WorldPosition = vec4(floor(in_Position.xy), in_Position.z, 1);
    v_WorldPosition.z *= u_TerrainScale;
    v_FragDistance = length((gm_Matrices[MATRIX_WORLD_VIEW] * v_WorldPosition).xyz);
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * v_WorldPosition;
    
    float f = fract(in_Position.x) * 8.0;
    v_Barycentric = vec3(
        1.0 - min(abs(1.0 - f), 1.0),
        1.0 - min(abs(2.0 - f), 1.0),
        1.0 - min(abs(4.0 - f), 1.0)
    );
    
    // the triangle internal texture offset gets squeezed into the fractional part of the Y coordinate, also
	//  - (U + tile size) coordinate: 0.25
	//  - (V + tile size) coordinate: 0.125
	v_Texcoord = floor(vec2(fract(in_Position.y * 2.0), fract(in_Position.y * 4.0)) * 2.0) / u_TextureTileSize;
	// get rid of the one pixel seam at the edge of tiles
	v_Texcoord -= (1.0 / u_TerrainSizeV) * ceil(v_Texcoord);
    /*
    vec4 screenSpace = u_LightVP * v_WorldPosition;
    
    v_LightDistance = screenSpace.z / screenSpace.w;
    v_ShadowTexcoord = ((screenSpace.xy / screenSpace.w) * 0.5) + 0.5;
    */
}