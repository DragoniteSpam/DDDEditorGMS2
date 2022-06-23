This thing has come a long way since the original version.

# 2022.0.3

A bunch of extra tools have been added, existing ones have been improved, and performance has generally been improved [in much the same way as the terrain editor that I like to make](https://dragonite.itch.io/terrain/devlog/351687/major-update-new-features-improvements-and-other-such-things).

## Dark mode

 - To keep the PC gamers happy

## Performance

 - Expensive mesh operations that used to be done in GML are now executed by a DLL, courtesy of C++
 - No more VM/YYC versions, because all of the expensive stuff is done in a DLL anyway

## Import/export

 - D3D/GMMOD import is largely the same, although some redundant code has been removed so it should perform slightly better overall
 - OBJ import has been dramatically improved:
    - Objects with multiple materials will have all materials loaded as a separate submesh
    - Submeshes will retain all of their diffuse color properties, which can be modified later
    - Material color won't automatically be baked into the vertex color (although there is a setting to enable this)
    - Objects with multiple materials will have their diffuse textures rendered correctly in the 3D view
 - OBJ export has also been brought in line:
    - Objects with submeshes representing different materials will be exported as a single model with multiple materials/groups
    - Material color will be assigned whatever was set in the editor, rather than attempting to use the vertex color

## General

 - Status messages are shown for certain things such as importing meshes into the editor
    - You can turn these off in Preferences if they get annoying
 - New tools include:
    - Setting a full transform on a mesh, rather than just the scale
    - Center a mesh
    - Invert and reset vertex transparency
    - Bake material color to vertex color, and reset vertex color
    - Diffuse texture and color management
    - Combine meshes with multiple submesh into a single vertex buffer, or separate them into individual meshes
 - Did you know that you can draw a texture UV layout in a shader that simply swaps the texture coordinates for the input position? It's pretty wild.

## Viewer Settings

There are now too many of these to simply draw beneath the 3D render.

 - Draw filled meshes (vs wireframe only)
 - Draw wireframe
 - Draw the bounding box around a mesh
 - When selecting a submesh in the Submeshes or Materials dialogs, the relevant triangles will be shown in blue

# Bug reporting

I've probably found and dealt with some of the more common issues, but if an error message ever shows up let me know what it says and how you did it. (Screenshots and video help.)

There are some times when the program may hang for a few seconds (namely, importing large objects with a lot of materials), but as long as it doesn't crash outright things should be okay.