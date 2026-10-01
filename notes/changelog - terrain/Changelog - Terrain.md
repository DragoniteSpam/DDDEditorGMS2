Yeah I really should get better at maintaining this. See the documentation for more details:
https://github.com/DragoniteSpam/Documentation/wiki/TerrainOps

# Changes in <new version>

 - The cursor flashes a little faster, I found it got lost sometimes at a period of two seconds
 - Updated Scribble to 8.7

# Changes in 2022.12

 - Can export smooth normals
 - Changed the way the terrain models are generated to make them more consistent across all export options
 - Importing a new texture won't automatically erase the existing texture
 - Maximum chunk size is now 1024

# Changes in 2022.0.5

 - Added an option to highlight upward-facing triangles to make it easier to create smooth surfaces for roads, etc
    You can define the threshold for highlighting upward-facing triangles, in terms of degrees away from the up vector

# Changes since 2022.0.2.78

 - Added a "Reset" button to the viewer settings dialog
 - "Add to Project" button works (this will not affect much, since the rest of the editor is locked down in the terrain editor)
    "Export Scale" is ignored for these terrains