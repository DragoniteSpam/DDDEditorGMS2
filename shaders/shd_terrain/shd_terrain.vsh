attribute vec2 in_Position;
attribute vec4 in_Colour;

varying float v_FragDistance;
varying vec4 v_WorldPosition;
varying vec3 v_Barycentric;
varying vec2 v_Texcoord;

uniform float u_TerrainSize;
uniform vec2 u_TerrainSizeV;
uniform vec2 u_TextureTileSize;

uniform mat4 u_LightVP;
uniform vec2 u_WorldOffset;

uniform sampler2D samp_heightmap;

varying float v_LightDistance;
varying vec2 v_ShadowTexcoord;

void main() {
    v_WorldPosition = vec4(in_Position + u_WorldOffset, 0, 1);
    v_WorldPosition.z = texture2DLod(samp_heightmap, v_WorldPosition.xy / u_TerrainSize, 0.0).r;
    v_FragDistance = length((gm_Matrices[MATRIX_WORLD_VIEW] * v_WorldPosition).xyz);
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * v_WorldPosition;
    
    v_Barycentric = in_Colour.rgb;
    
    // the triangle internal texture offset gets squeezed into the fractional part of the Y coordinate, also
    //  - (U + tile size) coordinate: 0.25
    //  - (V + tile size) coordinate: 0.125
    
    // this will eventually be read from another texture
    v_Texcoord = vec2(0);
    
    //v_Texcoord = floor(vec2(fract(in_Position.y * 2.0), fract(in_Position.y * 4.0)) * 2.0) / u_TextureTileSize;
    // get rid of the one pixel seam at the edge of tiles
    //v_Texcoord -= (1.0 / u_TerrainSizeV) * ceil(v_Texcoord);
    /*
    vec4 screenSpace = u_LightVP * v_WorldPosition;
    
    v_LightDistance = screenSpace.z / screenSpace.w;
    v_ShadowTexcoord = ((screenSpace.xy / screenSpace.w) * 0.5) + 0.5;
    */
}