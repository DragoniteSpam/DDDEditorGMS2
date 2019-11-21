varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// not sure why this works but gm_AlphaRefValue is not
#define ALPHA_REF 0.2

void main() {
    vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    //if ((color.a * 255.0) < gm_AlphaRefValue) {
    if (color.a < ALPHA_REF) {
        discard;
    }
    
    gl_FragColor = color;
}