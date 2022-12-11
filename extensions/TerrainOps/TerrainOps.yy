{
  "resourceType": "GMExtension",
  "resourceVersion": "1.2",
  "name": "TerrainOps",
  "ConfigValues": {
    "Terrain": {"copyToTargets":"-1",},
  },
  "optionsFile": "options.json",
  "options": [],
  "exportToGame": true,
  "supportedTargets": -1,
  "extensionVersion": "0.0.1",
  "packageId": "",
  "productId": "",
  "author": "",
  "date": "2022-01-06T23:45:40.8228566-05:00",
  "license": "",
  "description": "",
  "helpfile": "",
  "iosProps": false,
  "tvosProps": false,
  "androidProps": false,
  "installdir": "",
  "files": [
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","filename":"TerrainOperations.dll","origname":"","init":"","final":"","kind":1,"uncompress":false,"functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_to_heightmap","externalName":"terrainops_to_heightmap","kind":1,"help":"__terrainops_to_heightmap(output)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_from_heightmap","externalName":"terrainops_from_heightmap","kind":1,"help":"__terrainops_from_heightmap(input, scale)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_build_settings","externalName":"terrainops_build_settings","kind":1,"help":"__terrainops_build_settings(save_all, swap_zup, swap_uv, center, density, scale, tex_size, color_scale, format, water_level, smooth_normals)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_version","externalName":"terrainops_version","kind":1,"help":"terrainops_version()","hidden":false,"returnType":1,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_generate_internal","externalName":"terrainops_generate_internal","kind":1,"help":"__terrainops_generate_internal(out)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_apply_scale","externalName":"terrainops_apply_scale","kind":1,"help":"__terrainops_apply_scale(scale)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_flatten","externalName":"terrainops_flatten","kind":1,"help":"__terrainops_flatten(height)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_mutate_set_noise","externalName":"terrainops_mutate_set_noise","kind":1,"help":"__terrainops_mutate_set_noise(noise, w, h, strength)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            2,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_mutate_set_texture","externalName":"terrainops_mutate_set_texture","kind":1,"help":"__terrainops_mutate_set_texture(data, w, h, strength)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            2,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_mutate","externalName":"terrainops_mutate","kind":1,"help":"__terrainops_mutate()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_deform_brush","externalName":"terrainops_deform_brush","kind":1,"help":"__terrainops_deform_brush(brush, w, h)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_deform_brush_settings","externalName":"terrainops_deform_brush_settings","kind":1,"help":"__terrainops_deform_brush_settings(radius, velocity)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_deform_brush_position","externalName":"terrainops_deform_brush_position","kind":1,"help":"__terrainops_deform_brush_position(x, y)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_deform_zero","externalName":"terrainops_deform_zero","kind":1,"help":"terrainops_deform_zero()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_deform_mold","externalName":"terrainops_deform_mold","kind":1,"help":"terrainops_deform_mold()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_deform_average","externalName":"terrainops_deform_average","kind":1,"help":"terrainops_deform_average()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_set_active_data","externalName":"terrainops_set_active_data","kind":1,"help":"terrainops_set_active_data(data, w, h)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_set_active_vertex_data","externalName":"terrainops_set_active_vertex_data","kind":1,"help":"terrainops_set_active_vertex_data(vertex)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_build_bounds","externalName":"terrainops_build_bounds","kind":1,"help":"__terrainops_build_bounds(x1, y1, x2, y2)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
            2,
            2,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_build_d3d","externalName":"terrainops_build_d3d","kind":1,"help":"terrainops_build_d3d(raw, length, out)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_build_vbuff","externalName":"terrainops_build_vbuff","kind":1,"help":"terrainops_build_vbuff(raw, length, out)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_build_obj","externalName":"terrainops_build_obj","kind":1,"help":"terrainops_build_obj(raw, length, out)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_build_texture","externalName":"terrainops_build_texture","kind":1,"help":"__terrainops_build_texture(buffer)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_build_vertex_colour","externalName":"terrainops_build_vertex_colour","kind":1,"help":"__terrainops_build_vertex_colour(buffer)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_set_lod_vertex_data","externalName":"terrainops_set_lod_vertex_data","kind":1,"help":"terrainops_set_lod_vertex_data(vertex_lod)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_generate_lod_internal","externalName":"terrainops_generate_lod_internal","kind":1,"help":"__terrainops_generate_lod_internal(out)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_max_height","externalName":"terrainops_max_height","kind":1,"help":"terrainops_max_height(data, length)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"terrainops_min_height","externalName":"terrainops_min_height","kind":1,"help":"terrainops_min_height(data, length)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__terrainops_build_internal","externalName":"terrainops_build_internal","kind":1,"help":"terrainops_build_internal(out)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
      ],"constants":[],"ProxyFiles":[],"copyToTargets":-1,"usesRunnerInterface":false,"order":[
        {"name":"terrainops_version","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"terrainops_set_active_data","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"terrainops_set_active_vertex_data","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"terrainops_set_lod_vertex_data","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"terrainops_deform_mold","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"terrainops_deform_average","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"terrainops_deform_zero","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_to_heightmap","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_from_heightmap","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build_settings","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build_bounds","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build_texture","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build_vertex_colour","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_generate_internal","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_generate_lod_internal","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_apply_scale","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_flatten","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_mutate_set_noise","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_mutate_set_texture","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_mutate","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_deform_brush","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_deform_brush_settings","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_deform_brush_position","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build_d3d","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build_vbuff","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build_obj","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"terrainops_max_height","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"terrainops_min_height","path":"extensions/TerrainOps/TerrainOps.yy",},
      ],},
  ],
  "classname": "",
  "tvosclassname": null,
  "tvosdelegatename": null,
  "iosdelegatename": "",
  "androidclassname": "",
  "sourcedir": "",
  "androidsourcedir": "",
  "macsourcedir": "",
  "maccompilerflags": "",
  "tvosmaccompilerflags": "",
  "maclinkerflags": "",
  "tvosmaclinkerflags": "",
  "iosplistinject": "",
  "tvosplistinject": "",
  "androidinject": "",
  "androidmanifestinject": "",
  "androidactivityinject": "",
  "gradleinject": "",
  "androidcodeinjection": "",
  "hasConvertedCodeInjection": true,
  "ioscodeinjection": "",
  "tvoscodeinjection": "",
  "iosSystemFrameworkEntries": [],
  "tvosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
  "IncludedResources": [],
  "androidPermissions": [],
  "copyToTargets": -1,
  "iosCocoaPods": "",
  "tvosCocoaPods": "",
  "iosCocoaPodDependencies": "",
  "tvosCocoaPodDependencies": "",
  "parent": {
    "name": "Extensions",
    "path": "folders/Extensions.yy",
  },
}