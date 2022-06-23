I recently did a major update on this thing since the original release. Here's a list of change and additions from the last version. It's mostly finished, but I'll probably still do smaller fixes and minor additions from time to time.

## Performance

 - The whole thing is much, much faster in pretty much all regards
 - Certain tasks that used to be done in GML are now executed by a DLL, courtesy of C++
 - No more VM/YYC versions, because all of the expensive stuff is done in a DLL anyway
 - The editor internally uses chunking and LOD systems to drastically cut down on unnecessary work, and as such increasing the size of the terrain has little to no impact on the software's performance

#### Import/export

 - Less buggy heightmap import/export
 - Export a vertex buffer directly
 - Many, many export options have been added:
   - Multiple LOD levels, with the settings for the number of LOD levels and the reduction factor
   - Smooth normals on export
   - Split the terrain up into chunks (this works very well with LODs)
   - Customize the vertex format

#### General editing

 - Max terrain size is now 5400x5400, and it performs pretty well, even while editing
   - I would have made the limit even bigger except GameMaker doesn't allow buffers larger than about 2 GB, to my immeasurable disappointment
 - Brushes for all terrain editing modes
   - You may also import your own brushes

#### Height

 - "Average" and "Zero" tools now morph the terrain height towards the target, rather than doing it all at once
 - Mutate the terrain based on Perlin noise
 - Mutate the terrain based on a heightmap

#### Texture

 - Texture tile size can now be set by the user

#### Painting

 - Import/export the paint canvas as an image
 - Obj does NOT support vertex color; in the past this was spoofed using materials, but I have no intent to do this again going forward

## Visuals

 - Better water shader
 - The UI is less awkward overall
 - Draw a wireframe on the terrain
 - Viewer modes for diffuse color, vertex position, vertex normal, heightmap, and barycentric coordinates
 - Plenty of other minor settings
 - Terrain stats

## Other stuff

 - A metric buttload of internal changes, optimizations, and bug fixes
 - Project save/load is incompatible with saved versions from the original version(s), although for what it's worth I'm pretty sure those didn't work anyway

## WIP items and known issues

You probably want to know about some of the things that are incomplete, or some of the features from the last version that are (currently) not available in the beta.

 - Documentation: there is none (yet)
 - Editing: at some point I'd like to add the ability to rotate a brush, but that doesn't feel like a priority
 - Editing: layered/blended textures
 - Exporting: obj currently doesn't support smooth normals
 - Lighting: settings not yet implemented, aside from the default light; this also doesn't feel like a priority
 - Procedural tools: this is honestly probably best saved for another major release

## Bug reporting

I've probably found and dealt with some of the more common issues, but if an error message ever shows up let me know what it says and how you did it. (Screenshots and video help.)

There are some times when the program may hang for a few seconds (especially when doing operations on large terrains, such as normal smoothing), but as long as it doesn't crash outright things should be okay.