{
  "resourceType": "GMExtension",
  "resourceVersion": "1.2",
  "name": "MeshOps",
  "androidactivityinject": "",
  "androidclassname": "",
  "androidcodeinjection": "",
  "androidinject": "",
  "androidmanifestinject": "",
  "androidPermissions": [],
  "androidProps": false,
  "androidsourcedir": "",
  "author": "",
  "classname": "",
  "copyToTargets": -1,
  "date": "2022-01-05T15:56:03.7052178-05:00",
  "description": "",
  "exportToGame": true,
  "extensionVersion": "0.0.1",
  "files": [
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":-1,"filename":"MeshOperations.dll","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_version","argCount":0,"args":[],"documentation":"","externalName":"meshops_version","help":"meshops_version()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_init","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"meshops_init","help":"meshops_init(vertex_size)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_transform_center","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_transform_center","help":"meshops_transform_center(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_transform","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_transform","help":"meshops_transform(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_mirror_axis_x","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_mirror_axis_x","help":"meshops_mirror_axis_x(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_mirror_axis_y","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_mirror_axis_y","help":"meshops_mirror_axis_y(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_mirror_axis_z","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_mirror_axis_z","help":"meshops_mirror_axis_z(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_flip_tex_u","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_flip_tex_u","help":"meshops_flip_tex_u(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_flip_tex_v","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_flip_tex_v","help":"meshops_flip_tex_v(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_set_colour","argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_set_colour","help":"meshops_set_colour(data, length, colour)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_set_color","argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_set_colour","help":"meshops_set_color(data, length, color)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_set_alpha","argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_set_alpha","help":"meshops_set_alpha(data, length, alpha)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_set_colour_and_alpha","argCount":0,"args":[
            1,
            2,
            2,
            2,
          ],"documentation":"","externalName":"meshops_set_colour_and_alpha","help":"meshops_set_colour_and_alpha(data, length, colour, alpha)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_set_color_and_alpha","argCount":0,"args":[
            1,
            2,
            2,
            2,
          ],"documentation":"","externalName":"meshops_set_colour_and_alpha","help":"meshops_set_color_and_alpha(data, length, color, alpha)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_invert_alpha","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_invert_alpha","help":"meshops_invert_alpha(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_set_normals_flat","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_set_normals_flat","help":"meshops_set_normals_flat(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_rotate_up","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_rotate_up","help":"meshops_rotate_up(data, len)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_set_normals_smooth","argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_set_normals_smooth","help":"meshops_set_normals_smooth(data, length, threshold)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_export_d3d","argCount":0,"args":[
            1,
            2,
            1,
          ],"documentation":"","externalName":"meshops_export_d3d","help":"_meshops_export_d3d(data, length, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_vertex_formatted","argCount":0,"args":[
            1,
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_vertex_formatted","help":"__meshops_vertex_formatted(data, out, length, format)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_get_bounds","argCount":0,"args":[
            1,
            1,
            2,
          ],"documentation":"","externalName":"meshops_get_bounds","help":"__meshops_get_bounds(data, output, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_chunk_settings","argCount":0,"args":[
            2,
            2,
            2,
            2,
            2,
          ],"documentation":"","externalName":"meshops_chunk_settings","help":"__meshops_chunk_settings(chunk_size, startx, starty, endx, endy)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_chunk_analyze","argCount":0,"args":[
            1,
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_chunk_analyze","help":"__meshops_chunk_analyze(data, meta, data_length, meta_length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_chunk","argCount":0,"args":[
            1,
            1,
            2,
          ],"documentation":"","externalName":"meshops_chunk","help":"__meshops_chunk(data, meta, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_transform_set_matrix","argCount":0,"args":[
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
          ],"documentation":"","externalName":"meshops_transform_set_matrix","help":"__meshops_transform_set_matrix(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_transform_set_matrix_raw","argCount":0,"args":[
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
            2,
            2,
            2,
            2,
            2,
          ],"documentation":"","externalName":"meshops_transform_set_matrix_raw","help":"meshops_transform_set_matrix_raw(i11, i12, i13, i14, i21, i22, i23, i24, i31, i32, i33, i34, i41, i42, i43, i44)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_blend_color","argCount":0,"args":[
            1,
            2,
            2,
            2,
          ],"documentation":"","externalName":"meshops_blend_colour","help":"meshops_blend_colour(data, length, color, amount)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_blend_colour","argCount":0,"args":[
            1,
            2,
            2,
            2,
          ],"documentation":"","externalName":"meshops_blend_colour","help":"meshops_blend_colour(data, length, color, amount)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_reverse","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_reverse","help":"meshops_reverse(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_multiply_color","argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_multiply_colour","help":"meshops_multiply_color(data, length, target)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"meshops_multiply_colour","argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_multiply_colour","help":"meshops_multiply_colour(data, length, target)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_set_normals_smooth_multi_prepare","argCount":0,"args":[],"documentation":"","externalName":"meshops_set_normals_smooth_multi_prepare","help":"meshops_set_normals_smooth_multi_prepare()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_set_normals_smooth_multi_calculate","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"meshops_set_normals_smooth_multi_calculate","help":"__meshops_set_normals_smooth_multi_calculate(data, length)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__meshops_set_normals_smooth_multi_finalize","argCount":0,"args":[
            1,
            2,
            2,
          ],"documentation":"","externalName":"meshops_set_normals_smooth_multi_finalize","help":"__meshops_set_normals_smooth_multi_finalize(data, length, threshold)","hidden":false,"kind":1,"returnType":2,},
      ],"init":"","kind":1,"order":[
        {"name":"meshops_version","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_init","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_transform_center","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_transform","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_rotate_up","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_mirror_axis_x","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_mirror_axis_y","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_mirror_axis_z","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_flip_tex_u","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_flip_tex_v","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_set_colour","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_set_color","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_set_alpha","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_set_colour_and_alpha","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_set_color_and_alpha","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_invert_alpha","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_set_normals_flat","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_set_normals_smooth","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_export_d3d","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_vertex_formatted","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_get_bounds","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_chunk_settings","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_chunk_analyze","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_chunk","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_transform_set_matrix","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_transform_set_matrix_raw","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_blend_color","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_blend_colour","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_reverse","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_multiply_color","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"meshops_multiply_colour","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_set_normals_smooth_multi_prepare","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_set_normals_smooth_multi_calculate","path":"extensions/MeshOps/MeshOps.yy",},
        {"name":"__meshops_set_normals_smooth_multi_finalize","path":"extensions/MeshOps/MeshOps.yy",},
      ],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":-1,"filename":"AssimpOperations.dll","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_version","argCount":0,"args":[],"documentation":"","externalName":"version","help":"assops_version()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_obj","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_obj","help":"assops_convert_obj(input, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_fbx","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_fbx","help":"assops_convert_fbx(input, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_gltf","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_gltf","help":"assops_convert_glft(input, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_glb","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_glb","help":"assops_convert_glb(input, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_stl","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_stl","help":"assops_convert_stl(input, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_dae","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_dae","help":"assops_convert_dae(input, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_ply","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_ply","help":"assops_convert_ply(input, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_plyb","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_plyb","help":"assops_convert_plyb(input, output)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"assops_convert_3ds","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"convert_3ds","help":"assops_convert_3ds(input, output)","hidden":false,"kind":1,"returnType":2,},
      ],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":-1,"filename":"assimp-vc143-mt.dll","final":"","functions":[],"init":"","kind":1,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
  ],
  "gradleinject": "",
  "hasConvertedCodeInjection": true,
  "helpfile": "",
  "HTML5CodeInjection": "",
  "html5Props": false,
  "IncludedResources": [],
  "installdir": "",
  "iosCocoaPodDependencies": "",
  "iosCocoaPods": "",
  "ioscodeinjection": "",
  "iosdelegatename": "",
  "iosplistinject": "",
  "iosProps": false,
  "iosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "license": "",
  "maccompilerflags": "",
  "maclinkerflags": "",
  "macsourcedir": "",
  "options": [],
  "optionsFile": "options.json",
  "packageId": "",
  "parent": {
    "name": "Extensions",
    "path": "folders/Extensions.yy",
  },
  "productId": "",
  "sourcedir": "",
  "supportedTargets": -1,
  "tvosclassname": null,
  "tvosCocoaPodDependencies": "",
  "tvosCocoaPods": "",
  "tvoscodeinjection": "",
  "tvosdelegatename": null,
  "tvosmaccompilerflags": "",
  "tvosmaclinkerflags": "",
  "tvosplistinject": "",
  "tvosProps": false,
  "tvosSystemFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
}