event_inherited();

/*
 * * * * * * * * * * AT00 * * AT16 * *
 *                 * AT00     AT17   *
 *                 * AT01     AT18   *
 *       Map       * AT02     AT19   *
 *      Tiles      * AT03     AT20   *
 *                 * AT04     AT21   *
 *                 * AT05     AT22   *
 *                 * AT06     AT23   *
 * * * * * * * * * * AT07     AT24   *
 *                   AT08     AT25   *
 *                   AT09     AT26   *
 *                   AT10     AT27   *
 *                   AT11     AT28   *
 *                   AT12     AT29   *
 *                   AT13     AT30   *
 *                   AT14     AT31   *
 *                   AT15     AT32   *
 * * * * * * * * * * * * * * * * * * *
 */

// filename
picture_name = "";
// the entire image is stored here
master = -1;

// these are just the indices, the actual autotiles are stored in Stuff
autotiles = array_create(AUTOTILE_MAX);
array_clear(autotiles, noone);

flags = noone;
at_flags = noone;