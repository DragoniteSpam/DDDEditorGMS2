{
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
    {"filename":"TerrainOperations.dll","origname":"","init":"","final":"","kind":1,"uncompress":false,"functions":[
        {"externalName":"terrainops_to_heightmap","kind":1,"help":"__terrainops_to_heightmap(data, output, length, scale)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            1,
            2,
            2,
          ],"resourceVersion":"1.0","name":"__terrainops_to_heightmap","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"terrainops_from_heightmap","kind":1,"help":"__terrainops_from_heightmap(data, input, length, scale)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            1,
            2,
            2,
          ],"resourceVersion":"1.0","name":"__terrainops_from_heightmap","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"terrainops_build","kind":1,"help":"__terrainops_build(data, out, length)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            1,
            2,
          ],"resourceVersion":"1.0","name":"__terrainops_build","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"terrainops_build_settings","kind":1,"help":"__terrainops_build_settings(save_all, swap_zup, swap_uv, center, density, width, height, scale)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
          ],"resourceVersion":"1.0","name":"__terrainops_build_settings","tags":[],"resourceType":"GMExtensionFunction",},
      ],"constants":[],"ProxyFiles":[],"copyToTargets":-1,"order":[
        {"name":"__terrainops_to_heightmap","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_from_heightmap","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build","path":"extensions/TerrainOps/TerrainOps.yy",},
        {"name":"__terrainops_build_settings","path":"extensions/TerrainOps/TerrainOps.yy",},
      ],"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMExtensionFile",},
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
  "hasConvertedCodeInjection": false,
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
  "resourceVersion": "1.2",
  "name": "TerrainOps",
  "tags": [],
  "resourceType": "GMExtension",
}