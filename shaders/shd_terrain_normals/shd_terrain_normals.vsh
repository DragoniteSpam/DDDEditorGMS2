attribute vec3 in_Position;

varying vec4 v_WorldPosition;

uniform float u_TerrainScale;

void main() {
    v_WorldPosition = vec4(floor(in_Position.xy), in_Position.z, 1);
    v_WorldPosition.z *= u_TerrainScale;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * v_WorldPosition;
}