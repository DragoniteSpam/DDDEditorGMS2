# DDDEditorGMS2
Migrating to GMS2, or attempting to

The original GMS1 project can be found [here](https://github.com/DragoniteSpam/DDDEditor), but I probably won't be updating it a whole lot after this

### Contributors
 - DragoniteSpam
 - RatcheT2498

### Original readme:
Game data editor to go along with [DoOrDieDragonite](https://github.com/DragoniteSpam/PokemonDoOrDie).

The plan is to create a fully-featured game editor that will be able to handle all of the information that the main game stores externally, such as maps, monster data, item data, and probably a bunch of other stuff. The map editor portion is going to take priority for the time being though.

#### Known Issues

 - **Semi-transparency in 3D space** - if you try to draw surface underneath an existing semi-transparent surface, it won't work. This is a Game Maker-wide problem and I'll probably either deal with depth sorting later, or just get rid of semi-transparent textures.
 
 - **Deleting custom data types and their properties** - edge cases, that is all
