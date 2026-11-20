See the documentation for more details:
https://github.com/DragoniteSpam/Documentation/wiki/Drago3D

# Changes in 1.8.4

### This update adds a few optimization for scene lights, GameMaker 2024.14 is required

- Shapes will not be drawn if they are not in view of the camera
    - this can dramatically speed up scenes where most of the content is not in view
    - for more information, see [here](https://www.youtube.com/watch?v=-MeNNAVrCjI&t=240s)
- Most transform matrices are recycled
    - d3d aggressively uses transform matrices to avoid having to rebuild geometry whenever possible
    - this seems to provide a 10%-20% speed boost for most shapes (some moreso than others)
    - for more information, see [here](https://www.youtube.com/watch?v=try2RX4IVlQ)

# Changes since 1.1.0

 - Added Feather documentation comments to everything

# Changes since 1.0.0
 
 - World transform is used correctly
 - Fixed cones