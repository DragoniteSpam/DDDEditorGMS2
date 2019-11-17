attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)
attribute vec4 extra;                        // (autotile id or 0, na, na, na)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

const int maxpositions = 12 * 16 * 8 * 2;
uniform float texoffset[maxpositions];

void main() {
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    // the zeroth and first elements should be 0 and 0 because they get added to the
    // existing coordinates. no branching because shaders don't like branching.
    
    // the autotiles need to have their texture coordinates set to 0, 0 because they're
    // stored in the array instead of in the vertex buffer.
    int base=2*int(extra.r*float(maxpositions));
    base=0;
//    v_vTexcoord = vec2(in_TextureCoord.x+texoffset[base], in_TextureCoord.y+texoffset[base+1]);
    v_vTexcoord = vec2(in_TextureCoord.x+texoffset[0], in_TextureCoord.y+texoffset[1]);
    //v_vTexcoord = vec2(in_TextureCoord.x+0.0, in_TextureCoord.y+0.0);
}

/*
 * yal.cc/r/gml autotile surroundings calculator
 * Hello!
 * Double-click the top panel to add a code tab.
 * Ctrl+Enter or F5 to run your code.
 * Also check out Help in the main menu.
 * Try copying the following to a new code tab for a test:
 */

/*
// init
value=0;

#define draw
// draw event code

for (var i=0; i<9; i++) {
    if (i!=4) {
        var xx=32+32*(i mod 3);
        var yy=32+32*(i div 3);
        var index=i;
        if (index>3) {
            index--;
        }
        if (mouse_x>xx&&mouse_x<xx+32&&mouse_y>yy&&mouse_y<yy+32) {
            if (mouse_check_button_pressed(mb_left)) {
                value=value^(1<<index);
            }
        }
        var c=c_blue;
        if (value&(1<<index)) {
            c=c_green;
        }
        draw_rectangle_colour(xx, yy, xx+32, yy+32, c, c, c, c, false);
    }
}

draw_text_colour(32, 160, value, c_black, c_black, c_black, c_black, 1);
*/

