{
    "id": "edfc6778-ab3b-4ddb-8396-c7302741b8c3",
    "modelName": "GMExtension",
    "mvc": "1.0",
    "name": "FMODGMS",
    "IncludedResources": [
        "Scripts\\FMODGMS\\FMODGMS_Util_BeatsToSamples",
        "Scripts\\FMODGMS\\FMODGMS_Util_SecondsToSamples",
        "Scripts\\FMODGMS\\FMODGMS_Util_SamplesToSeconds",
        "Scripts\\FMODGMS\\FMODGMS_Util_SamplesToBeats",
        "Scripts\\FMODGMS\\FMODGMS_Snd_TypeToString",
        "Scripts\\FMODGMS\\FMODGMS_Snd_TagDataTypeToString",
        "Scripts\\FMODGMS\\FMODGMS_Snd_TagTypeToString",
        "Scripts\\FMODGMS\\ReadMe_EffectParameters",
        "Scripts\\FMODGMS\\FMODGMS_Effect_TypeToString"
    ],
    "androidPermissions": [
        
    ],
    "androidProps": true,
    "androidactivityinject": "",
    "androidclassname": "",
    "androidinject": "",
    "androidmanifestinject": "",
    "androidsourcedir": "",
    "author": "",
    "classname": "",
    "copyToTargets": 202375362,
    "date": "2019-08-17 01:06:51",
    "description": "",
    "extensionName": "",
    "files": [
        {
            "id": "853be23e-fe1d-408d-846a-f9478fb831fa",
            "modelName": "GMExtensionFile",
            "mvc": "1.0",
            "ProxyFiles": [
                {
                    "id": "6a69e00f-a7b6-4f95-8fbe-bc5ae7d17e62",
                    "modelName": "GMProxyFile",
                    "mvc": "1.0",
                    "TargetMask": 2,
                    "proxyName": "libFMODGMS.dylib"
                },
                {
                    "id": "dc42a999-ce9d-4540-8ebf-399fa91bd18d",
                    "modelName": "GMProxyFile",
                    "mvc": "1.0",
                    "TargetMask": 134217856,
                    "proxyName": "libfmodgms.so"
                }
            ],
            "constants": [
                {
                    "id": "a21f1985-f1b8-4256-963d-324839a26eee",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_LOOPPOINT_START",
                    "hidden": false,
                    "value": "0"
                },
                {
                    "id": "61e226b9-12a4-41ed-be8d-bbdd18ccdef2",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_LOOPPOINT_END",
                    "hidden": false,
                    "value": "1"
                },
                {
                    "id": "1b57f224-b878-4588-82d1-aeeff52a3db2",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_UNKNOWN",
                    "hidden": false,
                    "value": "0"
                },
                {
                    "id": "a4a1130a-546f-48e5-a9d8-7eca95d412a0",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_AIFF",
                    "hidden": false,
                    "value": "1"
                },
                {
                    "id": "ae98f155-796b-4236-9149-fc4ba5d6cb7e",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_ASF",
                    "hidden": false,
                    "value": "2"
                },
                {
                    "id": "61799204-1c51-42d2-8aa7-0d21e781f560",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_DLS",
                    "hidden": false,
                    "value": "3"
                },
                {
                    "id": "89709de6-451c-4e82-9bf3-e4a9dc68ad96",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_FLAC",
                    "hidden": false,
                    "value": "4"
                },
                {
                    "id": "99efce5b-92f5-4ef5-a71c-6844d3ea3fca",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_FSB",
                    "hidden": false,
                    "value": "5"
                },
                {
                    "id": "9ea496d0-7b60-4108-ad62-afed0d9adb72",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_IT",
                    "hidden": false,
                    "value": "6"
                },
                {
                    "id": "04a81195-aabe-4cbd-a484-068d4122c5c1",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_MIDI",
                    "hidden": false,
                    "value": "7"
                },
                {
                    "id": "eb0a90ad-5771-407a-a171-1a5d3c703562",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_MOD",
                    "hidden": false,
                    "value": "8"
                },
                {
                    "id": "8ed2f7ab-0ff7-4a72-82a2-28ba6a283b0e",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_MPEG",
                    "hidden": false,
                    "value": "9"
                },
                {
                    "id": "423d6b99-d416-4227-97ec-085bdabb1290",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_OGGVORBIS",
                    "hidden": false,
                    "value": "10"
                },
                {
                    "id": "191eedf6-8c52-4027-8a04-b3ad017f3233",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_PLAYLIST",
                    "hidden": false,
                    "value": "11"
                },
                {
                    "id": "8ee676c6-9a73-4d2d-96af-307120fd5911",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_RAW",
                    "hidden": false,
                    "value": "12"
                },
                {
                    "id": "66c6626d-95c2-4fe8-a119-6ba749d185de",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_S3M",
                    "hidden": false,
                    "value": "13"
                },
                {
                    "id": "e749970c-82d3-4028-ad40-63851d1cc5eb",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_USER",
                    "hidden": false,
                    "value": "14"
                },
                {
                    "id": "3cad1842-c5d1-45d0-ba42-bb89caf89dd5",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_WAV",
                    "hidden": false,
                    "value": "15"
                },
                {
                    "id": "1a0455e9-3f50-44de-a5f3-dc8818f87c0d",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_XM",
                    "hidden": false,
                    "value": "16"
                },
                {
                    "id": "a6a185e8-e79e-4e7d-8e41-93c5b75b5e1c",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_XMA",
                    "hidden": false,
                    "value": "17"
                },
                {
                    "id": "6cf8df64-305c-4906-8b92-23dce5f150a9",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_AUDIOQUEUE",
                    "hidden": false,
                    "value": "18"
                },
                {
                    "id": "a46d7c5c-e89b-487e-a5a9-54366fe3ddd7",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_AT9",
                    "hidden": false,
                    "value": "19"
                },
                {
                    "id": "026bc688-7382-4ebb-84e0-9842f9630f96",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_VORBIS",
                    "hidden": false,
                    "value": "20"
                },
                {
                    "id": "d8bec146-dd5a-4083-b53b-031f87154281",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_MEDIA_FOUNDATION",
                    "hidden": false,
                    "value": "21"
                },
                {
                    "id": "16608869-c21f-4363-b135-76bf820d998e",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_MEDIA_CODEC",
                    "hidden": false,
                    "value": "22"
                },
                {
                    "id": "d2b7d34a-32dd-4ce7-b120-a1808c080c54",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_FADPCM",
                    "hidden": false,
                    "value": "23"
                },
                {
                    "id": "ea6e4ed2-2f14-47ee-a063-2981135f7d16",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_SOUND_TYPE_MAX",
                    "hidden": false,
                    "value": "24"
                },
                {
                    "id": "4ce02a66-335d-4b58-bfe0-07691551bfdd",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_BINARY",
                    "hidden": false,
                    "value": "0"
                },
                {
                    "id": "b698adfb-1ee5-4d3c-a060-a4b38e4a57ff",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_INT",
                    "hidden": false,
                    "value": "1"
                },
                {
                    "id": "0c3be843-585b-409c-8edc-c998d8b33519",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_FLOAT",
                    "hidden": false,
                    "value": "2"
                },
                {
                    "id": "36c7ecc1-b5d6-413c-8614-475c1aeb1858",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_STRING",
                    "hidden": false,
                    "value": "3"
                },
                {
                    "id": "789eddcd-8cd9-4144-b7f2-597137e835b0",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_STRING_UTF16",
                    "hidden": false,
                    "value": "4"
                },
                {
                    "id": "6ad4e244-060e-4c1b-9e78-e3528f96fdc9",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_STRING_UTF16BE",
                    "hidden": false,
                    "value": "5"
                },
                {
                    "id": "482f677e-044c-49ab-848e-13fc0f694171",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_STRING_UTF8",
                    "hidden": false,
                    "value": "6"
                },
                {
                    "id": "78ea24cc-4473-4e31-83fa-80bcb4290fe9",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_CDTOC",
                    "hidden": false,
                    "value": "7"
                },
                {
                    "id": "04bd536e-5780-4eeb-9646-55f006411136",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGDATATYPE_MAX",
                    "hidden": false,
                    "value": "8"
                },
                {
                    "id": "e9603d96-64cb-4a13-99c5-e34ee748101e",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_ID3V1",
                    "hidden": false,
                    "value": "0"
                },
                {
                    "id": "953a21d1-6f28-4d0a-8787-5cb5c163e4cd",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_ID3V2",
                    "hidden": false,
                    "value": "1"
                },
                {
                    "id": "1c3f2865-3021-4100-81f7-de6eb19ec144",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_VORBISCOMMENT",
                    "hidden": false,
                    "value": "2"
                },
                {
                    "id": "121be062-8c1c-43cf-9ddc-0f2bd18ad0c0",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_SHOUTCAST",
                    "hidden": false,
                    "value": "3"
                },
                {
                    "id": "8b1f67c3-3c6c-40af-a6a3-9eae01372fd4",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_ICECAST",
                    "hidden": false,
                    "value": "4"
                },
                {
                    "id": "cac01f6a-378b-4ab9-b033-9a03e12dd4dd",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_ASF",
                    "hidden": false,
                    "value": "5"
                },
                {
                    "id": "c2c54fac-113d-4286-ba00-88cf61c038af",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_MIDI",
                    "hidden": false,
                    "value": "6"
                },
                {
                    "id": "2a1e587a-487a-4e9e-9d53-5b36b365975b",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_PLAYLIST",
                    "hidden": false,
                    "value": "7"
                },
                {
                    "id": "c3c97d8d-189e-4b33-af0d-fea069f4d574",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_FMOD",
                    "hidden": false,
                    "value": "8"
                },
                {
                    "id": "2990c6b6-1f8b-4b8a-a718-6c83aa08dc50",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_USER",
                    "hidden": false,
                    "value": "9"
                },
                {
                    "id": "c57b27f2-9c7d-4f1f-b33a-97f6e6347c4d",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_TAGTYPE_MAX",
                    "hidden": false,
                    "value": "10"
                },
                {
                    "id": "feb9316c-4199-4de1-9272-8f68c38abba1",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_LOOPMODE_NONE",
                    "hidden": false,
                    "value": "0"
                },
                {
                    "id": "0663eb95-c90a-46e7-aea1-7890f79ecf22",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_LOOPMODE_NORMAL",
                    "hidden": false,
                    "value": "1"
                },
                {
                    "id": "5e534699-45b0-4f1c-9e83-6cac5072ac8b",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_LOOPMODE_BIDI",
                    "hidden": false,
                    "value": "2"
                },
                {
                    "id": "39a44176-7bbf-4039-ba24-41e7f14239fc",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_LOWPASS",
                    "hidden": false,
                    "value": "3"
                },
                {
                    "id": "24abf5dc-0855-44fd-85b8-19af892d4f97",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_HIGHPASS",
                    "hidden": false,
                    "value": "5"
                },
                {
                    "id": "c336b41a-ba0b-4a83-bd68-7582b7c3bef6",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_ECHO",
                    "hidden": false,
                    "value": "6"
                },
                {
                    "id": "3c3c0bcb-2dea-40d1-a6ff-fc88ba79cdaa",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_FLANGE",
                    "hidden": false,
                    "value": "8"
                },
                {
                    "id": "a0dc85bf-6c0e-49da-ae2f-61bbcbf767c1",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_DISTORTION",
                    "hidden": false,
                    "value": "9"
                },
                {
                    "id": "f46554ef-a71b-4abb-89e3-2ebd74cd364e",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_CHORUS",
                    "hidden": false,
                    "value": "14"
                },
                {
                    "id": "ccb7153a-dfc1-4d36-93ed-d631817e60b8",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_REVERB",
                    "hidden": false,
                    "value": "19"
                },
                {
                    "id": "18b3f917-3482-4854-8b99-865c6d46ee35",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_TREMOLO",
                    "hidden": false,
                    "value": "22"
                },
                {
                    "id": "d701e6d4-304b-4cce-8e4a-28f11bfd368f",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_EFFECT_PITCHSHIFT",
                    "hidden": false,
                    "value": "13"
                },
                {
                    "id": "fd6a0118-7393-4a52-8ec2-919b1ba1ff96",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_AUTODETECT",
                    "hidden": false,
                    "value": "0"
                },
                {
                    "id": "a0e689d3-f691-4289-98dd-e5cd588dc6c2",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_UNKNOWN",
                    "hidden": false,
                    "value": "1"
                },
                {
                    "id": "0f0bb98f-0e04-4561-8154-81dd98ac98c4",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_NOSOUND",
                    "hidden": false,
                    "value": "2"
                },
                {
                    "id": "81e435b4-c757-425d-b601-7ba9c714463b",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_WAVWRITER",
                    "hidden": false,
                    "value": "3"
                },
                {
                    "id": "f67f3c72-d358-4053-bda9-d6ecec46329f",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_NOSOUND_NRT",
                    "hidden": false,
                    "value": "4"
                },
                {
                    "id": "170a4d52-96e2-452f-9e66-105ddfcede0d",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_WAVWRITER_NRT",
                    "hidden": false,
                    "value": "5"
                },
                {
                    "id": "4972d247-cb4f-4450-b7c7-f8f710f37f16",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_DSOUND",
                    "hidden": false,
                    "value": "6"
                },
                {
                    "id": "0404aec7-817f-44cb-ad49-5e5160fc7cef",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_WINMM",
                    "hidden": false,
                    "value": "7"
                },
                {
                    "id": "ea248ce3-2b65-4a76-973b-d2fd8655f878",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_WASAPI",
                    "hidden": false,
                    "value": "8"
                },
                {
                    "id": "28d38c81-63fb-45e5-930e-c21b863763a3",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_ASIO",
                    "hidden": false,
                    "value": "9"
                },
                {
                    "id": "b0290001-114a-4c19-b9bb-4afaea9061f8",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_PULSEAUDIO",
                    "hidden": false,
                    "value": "10"
                },
                {
                    "id": "71850436-7904-4bfa-93bd-356331f0e24f",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_ALSA",
                    "hidden": false,
                    "value": "11"
                },
                {
                    "id": "f37a4db4-1c2e-4c23-90a0-9049028d716d",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_COREAUDIO",
                    "hidden": false,
                    "value": "12"
                },
                {
                    "id": "43f65ad6-8866-4e4f-a457-f809179b4641",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_XAUDIO",
                    "hidden": false,
                    "value": "13"
                },
                {
                    "id": "70597cfa-b68f-4f19-a073-fb8a74ac3ed9",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_PS3",
                    "hidden": false,
                    "value": "14"
                },
                {
                    "id": "cf2183be-6933-47b9-b7e1-9aeaa0b9047c",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_AUDIOTRACK",
                    "hidden": false,
                    "value": "15"
                },
                {
                    "id": "fc82d74f-b9da-4454-9d0a-b1db8e4fda8c",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_OPENSL",
                    "hidden": false,
                    "value": "16"
                },
                {
                    "id": "65188599-7766-410b-9e86-1dee5edf685b",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_WIIU",
                    "hidden": false,
                    "value": "17"
                },
                {
                    "id": "35de5caa-b2fb-41ce-ba39-b5ef111cd08e",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_AUDIOOUT",
                    "hidden": false,
                    "value": "18"
                },
                {
                    "id": "adf32497-78c8-473f-a86f-08a7266d62fd",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_AUDIO3D",
                    "hidden": false,
                    "value": "19"
                },
                {
                    "id": "77fb76e1-bdd5-4bbd-8ec5-34d97c7143e5",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_ATMOS",
                    "hidden": false,
                    "value": "20"
                },
                {
                    "id": "32ba8c1a-b292-4cb5-a4fe-934b5302e180",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "FMODGMS_OUTPUTTYPE_MAX",
                    "hidden": false,
                    "value": "21"
                }
            ],
            "copyToTargets": 202375362,
            "filename": "FMODGMS.dll",
            "final": "",
            "functions": [
                {
                    "id": "32faefb9-d70d-4704-974b-0415b1e0e501",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Create",
                    "help": "FMODGMS_Sys_Create()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Create",
                    "returnType": 2
                },
                {
                    "id": "f89e71b7-0a5c-439f-ad45-d79682dadaca",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Sys_Initialize",
                    "help": "FMODGMS_Sys_Initialize(maxChan)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Initialize",
                    "returnType": 2
                },
                {
                    "id": "542ea0c0-c2b1-4a28-ad78-bb6d2aae7c44",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Close",
                    "help": "FMODGMS_Sys_Close()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Close",
                    "returnType": 2
                },
                {
                    "id": "8aa17b8e-5b87-4b68-9617-4e5e74215f24",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "FMODGMS_Snd_LoadSound",
                    "help": "FMODGMS_Snd_LoadSound(filename)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_LoadSound",
                    "returnType": 2
                },
                {
                    "id": "bdd89403-04b8-4dbb-914c-7760b46ffaf5",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "FMODGMS_Snd_LoadStream",
                    "help": "FMODGMS_Snd_LoadStream(filename)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_LoadStream",
                    "returnType": 2
                },
                {
                    "id": "6817c767-68ac-407b-9ca8-c616673af6f0",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Unload",
                    "help": "FMODGMS_Snd_Unload(index)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Unload",
                    "returnType": 2
                },
                {
                    "id": "1eba8768-29a0-4898-9f62-0b9a57d27c9d",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_PlaySound",
                    "help": "FMODGMS_Snd_PlaySound(index, channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_PlaySound",
                    "returnType": 2
                },
                {
                    "id": "a49a5f52-0e13-4173-8501-8474cac82e25",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 3,
                    "args": [
                        2,
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Set_LoopMode",
                    "help": "FMODGMS_Snd_Set_LoopMode(index, mode, times)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Set_LoopMode",
                    "returnType": 2
                },
                {
                    "id": "3476dba0-fa4a-4ceb-b798-e3e6af6b3148",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 3,
                    "args": [
                        2,
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Set_LoopPoints",
                    "help": "FMODGMS_Snd_Set_LoopPoints(index, startTimeInSamples, endTimeInSamples)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Set_LoopPoints",
                    "returnType": 2
                },
                {
                    "id": "28360dbb-cc38-457a-a1c4-36af5238ba49",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_LoopPoints",
                    "help": "FMODGMS_Snd_Get_LoopPoints(index, whichOne)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_LoopPoints",
                    "returnType": 2
                },
                {
                    "id": "6eeecee8-5e0f-43b5-bd3d-a596a82e2550",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Chan_CreateChannel",
                    "help": "FMODGMS_Chan_CreateChannel()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_CreateChannel",
                    "returnType": 2
                },
                {
                    "id": "49373e8c-0540-41ea-b310-4c23554e3f33",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_RemoveChannel",
                    "help": "FMODGMS_Chan_RemoveChannel(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_RemoveChannel",
                    "returnType": 2
                },
                {
                    "id": "84cab966-7c68-4198-8d99-feb8a0c6a9c5",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": -1,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Util_GetErrorMessage",
                    "help": "FMODGMS_Util_GetErrorMessage()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Util_GetErrorMessage",
                    "returnType": 1
                },
                {
                    "id": "e6fce170-9b61-49e9-8cde-4d2597e4a786",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Get_CPUUsage",
                    "help": "FMODGMS_Sys_Get_CPUUsage()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Get_CPUUsage",
                    "returnType": 2
                },
                {
                    "id": "0c3698a2-7ef7-4c9a-a3f7-d51d204ca6e0",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Get_MaxSoundIndex",
                    "help": "FMODGMS_Sys_Get_MaxSoundIndex()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Get_MaxSoundIndex",
                    "returnType": 2
                },
                {
                    "id": "ca1982d0-04d3-4a95-8cc2-737ad1462c5d",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Get_MaxChannelIndex",
                    "help": "FMODGMS_Sys_Get_MaxChannelIndex()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Get_MaxChannelIndex",
                    "returnType": 2
                },
                {
                    "id": "d54c2904-245a-4a9b-bf91-23ff65e3a18c",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_NumTags",
                    "help": "FMODGMS_Snd_Get_NumTags(index)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_NumTags",
                    "returnType": 2
                },
                {
                    "id": "57e03ae3-bc81-44e7-88b2-9b1ccb586f71",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagName",
                    "help": "FMODGMS_Snd_Get_TagName(soundIndex, tagIndex)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagName",
                    "returnType": 1
                },
                {
                    "id": "961a1885-d38f-4325-baad-1f788c0d85c6",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_StopChannel",
                    "help": "FMODGMS_Chan_StopChannel(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_StopChannel",
                    "returnType": 2
                },
                {
                    "id": "670bc1fb-2d94-45d6-9802-2a054d8cae23",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_ModOrder",
                    "help": "FMODGMS_Chan_Get_ModOrder(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_ModOrder",
                    "returnType": 2
                },
                {
                    "id": "f18fdd6f-1ef8-4fbf-ab6e-1b10337226ff",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_ModPattern",
                    "help": "FMODGMS_Chan_Get_ModPattern(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_ModPattern",
                    "returnType": 2
                },
                {
                    "id": "c3c0865a-d8e6-4b01-9362-1d688fbd94fd",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_ModRow",
                    "help": "FMODGMS_Chan_Get_ModRow(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_ModRow",
                    "returnType": 2
                },
                {
                    "id": "c41441fa-fb0f-4ea7-8b34-a435abaa67c2",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_Type",
                    "help": "FMODGMS_Snd_Get_Type(index)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_Type",
                    "returnType": 2
                },
                {
                    "id": "2a97c1f1-2ef7-446d-b917-7d3da9ed733f",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_Position",
                    "help": "FMODGMS_Chan_Get_Position(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_Position",
                    "returnType": 2
                },
                {
                    "id": "bbf005b2-68a6-4f74-92cb-21531b899b18",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_PauseChannel",
                    "help": "FMODGMS_Chan_PauseChannel(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_PauseChannel",
                    "returnType": 2
                },
                {
                    "id": "cf178dd8-e984-4889-a791-ea58d05895ec",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_ResumeChannel",
                    "help": "FMODGMS_Chan_ResumeChannel(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_ResumeChannel",
                    "returnType": 2
                },
                {
                    "id": "d383cc86-5b59-40c8-9613-3840c53c1f86",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Update",
                    "help": "FMODGMS_Sys_Update()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Update",
                    "returnType": 2
                },
                {
                    "id": "1242ba8e-06cb-43c7-a7e5-3d1a86596b3d",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Set_Position",
                    "help": "FMODGMS_Chan_Set_Position(channel,pos)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Set_Position",
                    "returnType": 2
                },
                {
                    "id": "a27b5de1-91da-438c-807a-8f2333475427",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Set_Volume",
                    "help": "FMODGMS_Chan_Set_Volume(channel,vol)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Set_Volume",
                    "returnType": 2
                },
                {
                    "id": "6a68cdf8-294e-48a5-b5a7-d5f510fbaa1b",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Set_Frequency",
                    "help": "FMODGMS_Chan_Set_Frequency(channel,freq)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Set_Frequency",
                    "returnType": 2
                },
                {
                    "id": "01c35a5d-8850-472f-b94f-c4f467273ad3",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Set_Pitch",
                    "help": "FMODGMS_Chan_Set_Pitch(channel,pitch)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Set_Pitch",
                    "returnType": 2
                },
                {
                    "id": "8831d0c0-a1ea-4b8b-8038-b51edb474001",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Set_ModOrder",
                    "help": "FMODGMS_Chan_Set_ModOrder(channel,ord)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Set_ModOrder",
                    "returnType": 2
                },
                {
                    "id": "1a2889f9-7251-4a7e-9ee5-c3d2f014fadb",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Set_ModRow",
                    "help": "FMODGMS_Chan_Set_ModRow(channel,row)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Set_ModRow",
                    "returnType": 2
                },
                {
                    "id": "4599752b-3e86-4d5d-83a6-32c3ff4f4b6b",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_Volume",
                    "help": "FMODGMS_Chan_Get_Volume(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_Volume",
                    "returnType": 2
                },
                {
                    "id": "47eb34e8-d3bb-4595-89b2-0b3ae152e1bb",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_Frequency",
                    "help": "FMODGMS_Chan_Get_Frequency(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_Frequency",
                    "returnType": 2
                },
                {
                    "id": "81c85e71-e1b9-48ba-a7d0-40b33e315d63",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_Pitch",
                    "help": "FMODGMS_Chan_Get_Pitch(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_Pitch",
                    "returnType": 2
                },
                {
                    "id": "4543723a-fc53-4e17-9cc5-c96a09b7fcd7",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Sys_Set_SoftwareFormat",
                    "help": "FMODGMS_Sys_Set_SoftwareFormat(sampleRate, speakerMode)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Set_SoftwareFormat",
                    "returnType": 2
                },
                {
                    "id": "8ea7c16e-09ee-4796-bafb-2bad5cdcbbbc",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Get_SampleRate",
                    "help": "FMODGMS_Sys_Get_SampleRate()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Get_SampleRate",
                    "returnType": 2
                },
                {
                    "id": "91734ff6-1302-4ee4-a593-19f93b2c5a7c",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": -1,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_FFT_Get_DominantFrequency",
                    "help": "FMODGMS_FFT_Get_DominantFrequency()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_FFT_Get_DominantFrequency",
                    "returnType": 2
                },
                {
                    "id": "67032324-5b05-4729-af5a-e8ca99d0e232",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_FFT_Get_BinValue",
                    "help": "FMODGMS_FFT_Get_BinValue(index)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_FFT_Get_BinValue",
                    "returnType": 2
                },
                {
                    "id": "1783cd7e-9441-4b05-aa86-157dfdcc1172",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_FFT_Get_NumBins",
                    "help": "FMODGMS_FFT_Get_NumBins()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_FFT_Get_NumBins",
                    "returnType": 2
                },
                {
                    "id": "645c80b9-e17f-4b3a-a22e-f6e6cf90bc36",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_FFT_Set_WindowSize",
                    "help": "FMODGMS_FFT_Set_WindowSize(size)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_FFT_Set_WindowSize",
                    "returnType": 2
                },
                {
                    "id": "f8875ed7-8ae0-4941-bf80-a2de8acb8e69",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagTypeFromIndex",
                    "help": "FMODGMS_Snd_Get_TagTypeFromIndex(soundIndex,tagIndex)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagTypeFromIndex",
                    "returnType": 2
                },
                {
                    "id": "b23bff2a-179c-45b6-990d-bacf1981af35",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagDataTypeFromIndex",
                    "help": "FMODGMS_Snd_Get_TagDataTypeFromIndex(soundIndex,tagIndex)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagDataTypeFromIndex",
                    "returnType": 2
                },
                {
                    "id": "252535d3-cc56-441b-88dc-9f0de2da5e39",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagRealFromIndex",
                    "help": "FMODGMS_Snd_Get_TagRealFromIndex(soundIndex,tagIndex)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagRealFromIndex",
                    "returnType": 2
                },
                {
                    "id": "abf2f6e2-ec36-4a1b-9aa3-c07ba27c7a0d",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagStringFromIndex",
                    "help": "FMODGMS_Snd_Get_TagStringFromIndex(soundIndex,tagIndex)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagStringFromIndex",
                    "returnType": 1
                },
                {
                    "id": "b7c6901b-31b8-4721-ac89-2cb7b02e2926",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        1
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagTypeFromName",
                    "help": "FMODGMS_Snd_Get_TagTypeFromName(soundIndex,tagName)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagTypeFromName",
                    "returnType": 2
                },
                {
                    "id": "e654075f-a54e-4af0-a50e-92c6a2e9c41b",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        1
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagDataTypeFromName",
                    "help": "FMODGMS_Snd_Get_TagDataTypeFromName(soundIndex,tagName)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagDataTypeFromName",
                    "returnType": 2
                },
                {
                    "id": "4a09ed6c-9eb2-478a-8225-911f5a87f198",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        1
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagRealFromName",
                    "help": "FMODGMS_Snd_Get_TagRealFromName(soundIndex,tagName)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagRealFromName",
                    "returnType": 2
                },
                {
                    "id": "33869924-f690-4fc2-a938-e479b67a63a5",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        1
                    ],
                    "externalName": "FMODGMS_Snd_Get_TagStringFromName",
                    "help": "FMODGMS_Snd_Get_TagStringFromName(soundIndex,tagName)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_TagStringFromName",
                    "returnType": 1
                },
                {
                    "id": "9d85c7d5-547e-4d79-b3bc-a4bd3bc5206a",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 3,
                    "args": [
                        2,
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Set_ModChannelVolume",
                    "help": "FMODGMS_Snd_Set_ModChannelVolume(index, modChannel, vol)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Set_ModChannelVolume",
                    "returnType": 2
                },
                {
                    "id": "61472d80-c036-40fa-8ced-fc81b7362211",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_ModChannelVolume",
                    "help": "FMODGMS_Snd_Get_ModChannelVolume(index, modChannel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_ModChannelVolume",
                    "returnType": 2
                },
                {
                    "id": "547a8b22-6637-4c5a-944c-5389dae6ef68",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_ModNumChannels",
                    "help": "FMODGMS_Snd_Get_ModNumChannels(index)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_ModNumChannels",
                    "returnType": 2
                },
                {
                    "id": "89c8472c-a61c-423d-8bce-7ce70ef9ea8b",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Snd_Get_Length",
                    "help": "FMODGMS_Snd_Get_Length(index)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_Length",
                    "returnType": 2
                },
                {
                    "id": "7ea23cc6-eb43-4a8a-813b-1d4a1d188fee",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 3,
                    "args": [
                        2,
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Add_Effect",
                    "help": "FMODGMS_Chan_Add_Effect(channel, effect, index)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Add_Effect",
                    "returnType": 2
                },
                {
                    "id": "39487a18-18f5-4814-a14e-f4f2010292ca",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Remove_Effect",
                    "help": "FMODGMS_Chan_Remove_Effect(channel, effect)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Remove_Effect",
                    "returnType": 2
                },
                {
                    "id": "53de3c4e-5866-47c6-9e23-0e5538532ef0",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Effect_Create",
                    "help": "FMODGMS_Effect_Create(type)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Effect_Create",
                    "returnType": 2
                },
                {
                    "id": "46f94a33-ac50-41f6-ba49-7126cebfb4f8",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 3,
                    "args": [
                        2,
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Effect_Set_Parameter",
                    "help": "FMODGMS_Effect_Set_Parameter(effect, parameter, value)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Effect_Set_Parameter",
                    "returnType": 2
                },
                {
                    "id": "2aaedc16-55a1-42d9-a546-a84fa84f54fa",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Effect_Remove",
                    "help": "FMODGMS_Effect_Remove(effect)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Effect_Remove",
                    "returnType": 2
                },
                {
                    "id": "d954a64b-1e4e-40eb-acb1-04710f93deca",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Effect_RemoveAll",
                    "help": "FMODGMS_Effect_RemoveAll()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Effect_RemoveAll",
                    "returnType": 2
                },
                {
                    "id": "4d20c7e8-5d53-4343-ad08-d1aa915af3cc",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_FFT_Normalize",
                    "help": "FMODGMS_FFT_Normalize()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_FFT_Normalize",
                    "returnType": 2
                },
                {
                    "id": "2f05cd7e-f4e8-421b-a2c3-893b986fb5cc",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_Level",
                    "help": "FMODGMS_Chan_Get_Level(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_Level",
                    "returnType": 2
                },
                {
                    "id": "d73173fa-a72d-4d67-a082-ace1148920aa",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Get_Mute",
                    "help": "FMODGMS_Chan_Get_Mute(channel)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Get_Mute",
                    "returnType": 2
                },
                {
                    "id": "6f841336-9bc4-45fe-b6eb-ea3e52361585",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Chan_Set_Mute",
                    "help": "FMODGMS_Chan_Set_Mute(channel, mute)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Chan_Set_Mute",
                    "returnType": 2
                },
                {
                    "id": "49d6e54a-8571-43f7-8665-e781a9cbbd83",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_Sys_Set_OutputMode",
                    "help": "FMODGMS_Sys_Set_OutputMode(outputType)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Set_OutputMode",
                    "returnType": 2
                },
                {
                    "id": "7e085015-47d1-4202-aab0-4ccf68cca18d",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Get_OutputMode",
                    "help": "FMODGMS_Sys_Get_OutputMode()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Get_OutputMode",
                    "returnType": 2
                },
                {
                    "id": "dce202e4-1d28-4d02-9b64-843fad202585",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Get_SpeakerMode",
                    "help": "FMODGMS_Sys_Get_SpeakerMode()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Get_SpeakerMode",
                    "returnType": 2
                },
                {
                    "id": "a6789d55-b06f-43ed-a8e6-1df102bfebc2",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": -1,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Util_Handshake",
                    "help": "FMODGMS_Util_Handshake()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Util_Handshake",
                    "returnType": 1
                },
                {
                    "id": "db34e4fe-73ad-47bf-8bf5-f1c0e57f366e",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "FMODGMS_FFT_Init",
                    "help": "FMODGMS_FFT_Init(windowSize)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_FFT_Init",
                    "returnType": 2
                },
                {
                    "id": "7bc02dc5-7709-4361-ad14-8e27b44ec605",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "FMODGMS_Sys_Set_DSPBufferSize",
                    "help": "FMODGMS_Sys_Set_DSPBufferSize(size, numBuffers)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Set_DSPBufferSize",
                    "returnType": 2
                },
                {
                    "id": "0a4eb4b8-ef27-4ffe-ab54-eb406ac1b14a",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Get_DSPBufferSize",
                    "help": "FMODGMS_Sys_Get_DSPBufferSize()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Get_DSPBufferSize",
                    "returnType": 2
                },
                {
                    "id": "f492fce3-564b-4287-be9c-c1d1e3bdd4bf",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Sys_Get_NumDSPBuffers",
                    "help": "FMODGMS_Sys_Get_NumDSPBuffers()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Sys_Get_NumDSPBuffers",
                    "returnType": 2
                },
                {
                    "id": "ce9fdf69-74b3-4685-87b6-5bbdd1b2c14b",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "FMODGMS_Snd_Set_DLS",
                    "help": "FMODGMS_Snd_Set_DLS(filename)",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Set_DLS",
                    "returnType": 2
                },
                {
                    "id": "e1213716-d21b-4c7b-aada-8aaf034cf0d3",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Snd_Remove_DLS",
                    "help": "FMODGMS_Snd_Remove_DLS()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Remove_DLS",
                    "returnType": 2
                },
                {
                    "id": "1d0034f1-f86d-4f6e-86de-314026f30255",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": -1,
                    "args": [
                        
                    ],
                    "externalName": "FMODGMS_Snd_Get_DLS",
                    "help": "FMODGMS_Snd_Get_DLS()",
                    "hidden": false,
                    "kind": 12,
                    "name": "FMODGMS_Snd_Get_DLS",
                    "returnType": 1
                }
            ],
            "init": "",
            "kind": 1,
            "order": [
                "32faefb9-d70d-4704-974b-0415b1e0e501",
                "f89e71b7-0a5c-439f-ad45-d79682dadaca",
                "542ea0c0-c2b1-4a28-ad78-bb6d2aae7c44",
                "8aa17b8e-5b87-4b68-9617-4e5e74215f24",
                "bdd89403-04b8-4dbb-914c-7760b46ffaf5",
                "6817c767-68ac-407b-9ca8-c616673af6f0",
                "1eba8768-29a0-4898-9f62-0b9a57d27c9d",
                "a49a5f52-0e13-4173-8501-8474cac82e25",
                "3476dba0-fa4a-4ceb-b798-e3e6af6b3148",
                "28360dbb-cc38-457a-a1c4-36af5238ba49",
                "6eeecee8-5e0f-43b5-bd3d-a596a82e2550",
                "49373e8c-0540-41ea-b310-4c23554e3f33",
                "84cab966-7c68-4198-8d99-feb8a0c6a9c5",
                "e6fce170-9b61-49e9-8cde-4d2597e4a786",
                "0c3698a2-7ef7-4c9a-a3f7-d51d204ca6e0",
                "ca1982d0-04d3-4a95-8cc2-737ad1462c5d",
                "d54c2904-245a-4a9b-bf91-23ff65e3a18c",
                "57e03ae3-bc81-44e7-88b2-9b1ccb586f71",
                "961a1885-d38f-4325-baad-1f788c0d85c6",
                "670bc1fb-2d94-45d6-9802-2a054d8cae23",
                "f18fdd6f-1ef8-4fbf-ab6e-1b10337226ff",
                "c3c0865a-d8e6-4b01-9362-1d688fbd94fd",
                "c41441fa-fb0f-4ea7-8b34-a435abaa67c2",
                "2a97c1f1-2ef7-446d-b917-7d3da9ed733f",
                "bbf005b2-68a6-4f74-92cb-21531b899b18",
                "cf178dd8-e984-4889-a791-ea58d05895ec",
                "d383cc86-5b59-40c8-9613-3840c53c1f86",
                "1242ba8e-06cb-43c7-a7e5-3d1a86596b3d",
                "a27b5de1-91da-438c-807a-8f2333475427",
                "6a68cdf8-294e-48a5-b5a7-d5f510fbaa1b",
                "01c35a5d-8850-472f-b94f-c4f467273ad3",
                "8831d0c0-a1ea-4b8b-8038-b51edb474001",
                "1a2889f9-7251-4a7e-9ee5-c3d2f014fadb",
                "4599752b-3e86-4d5d-83a6-32c3ff4f4b6b",
                "47eb34e8-d3bb-4595-89b2-0b3ae152e1bb",
                "81c85e71-e1b9-48ba-a7d0-40b33e315d63",
                "4543723a-fc53-4e17-9cc5-c96a09b7fcd7",
                "8ea7c16e-09ee-4796-bafb-2bad5cdcbbbc",
                "91734ff6-1302-4ee4-a593-19f93b2c5a7c",
                "67032324-5b05-4729-af5a-e8ca99d0e232",
                "1783cd7e-9441-4b05-aa86-157dfdcc1172",
                "645c80b9-e17f-4b3a-a22e-f6e6cf90bc36",
                "f8875ed7-8ae0-4941-bf80-a2de8acb8e69",
                "b23bff2a-179c-45b6-990d-bacf1981af35",
                "252535d3-cc56-441b-88dc-9f0de2da5e39",
                "abf2f6e2-ec36-4a1b-9aa3-c07ba27c7a0d",
                "b7c6901b-31b8-4721-ac89-2cb7b02e2926",
                "e654075f-a54e-4af0-a50e-92c6a2e9c41b",
                "4a09ed6c-9eb2-478a-8225-911f5a87f198",
                "33869924-f690-4fc2-a938-e479b67a63a5",
                "9d85c7d5-547e-4d79-b3bc-a4bd3bc5206a",
                "61472d80-c036-40fa-8ced-fc81b7362211",
                "547a8b22-6637-4c5a-944c-5389dae6ef68",
                "89c8472c-a61c-423d-8bce-7ce70ef9ea8b",
                "7ea23cc6-eb43-4a8a-813b-1d4a1d188fee",
                "39487a18-18f5-4814-a14e-f4f2010292ca",
                "53de3c4e-5866-47c6-9e23-0e5538532ef0",
                "46f94a33-ac50-41f6-ba49-7126cebfb4f8",
                "2aaedc16-55a1-42d9-a546-a84fa84f54fa",
                "d954a64b-1e4e-40eb-acb1-04710f93deca",
                "4d20c7e8-5d53-4343-ad08-d1aa915af3cc",
                "2f05cd7e-f4e8-421b-a2c3-893b986fb5cc",
                "d73173fa-a72d-4d67-a082-ace1148920aa",
                "6f841336-9bc4-45fe-b6eb-ea3e52361585",
                "49d6e54a-8571-43f7-8665-e781a9cbbd83",
                "7e085015-47d1-4202-aab0-4ccf68cca18d",
                "dce202e4-1d28-4d02-9b64-843fad202585",
                "a6789d55-b06f-43ed-a8e6-1df102bfebc2",
                "db34e4fe-73ad-47bf-8bf5-f1c0e57f366e",
                "7bc02dc5-7709-4361-ad14-8e27b44ec605",
                "0a4eb4b8-ef27-4ffe-ab54-eb406ac1b14a",
                "f492fce3-564b-4287-be9c-c1d1e3bdd4bf",
                "ce9fdf69-74b3-4685-87b6-5bbdd1b2c14b",
                "e1213716-d21b-4c7b-aada-8aaf034cf0d3",
                "1d0034f1-f86d-4f6e-86de-314026f30255"
            ],
            "origname": "extensions\\FMODGMS.dll",
            "uncompress": false
        },
        {
            "id": "6468ff66-faa3-4ccd-87a8-2ba4b9e2171a",
            "modelName": "GMExtensionFile",
            "mvc": "1.0",
            "ProxyFiles": [
                
            ],
            "constants": [
                
            ],
            "copyToTargets": 1048640,
            "filename": "fmod.dll",
            "final": "",
            "functions": [
                
            ],
            "init": "",
            "kind": 1,
            "order": [
                
            ],
            "origname": "extensions\\fmod.dll",
            "uncompress": false
        },
        {
            "id": "a09d5942-e623-4e46-8f9a-8715bbd95b70",
            "modelName": "GMExtensionFile",
            "mvc": "1.0",
            "ProxyFiles": [
                
            ],
            "constants": [
                
            ],
            "copyToTargets": 67108866,
            "filename": "libfmod.dylib",
            "final": "",
            "functions": [
                
            ],
            "init": "",
            "kind": 1,
            "order": [
                
            ],
            "origname": "extensions\\libfmod.dylib",
            "uncompress": false
        }
    ],
    "gradleinject": "",
    "helpfile": "",
    "installdir": "",
    "iosProps": true,
    "iosSystemFrameworkEntries": [
        
    ],
    "iosThirdPartyFrameworkEntries": [
        
    ],
    "iosdelegatename": "",
    "iosplistinject": "",
    "license": "Free to use, also for commercial games.",
    "maccompilerflags": "",
    "maclinkerflags": "",
    "macsourcedir": "",
    "packageID": "",
    "productID": "ACBD3CFF4E539AD869A0E8E3B4B022DD",
    "sourcedir": "",
    "tvosProps": false,
    "tvosSystemFrameworkEntries": [
        
    ],
    "tvosThirdPartyFrameworkEntries": [
        
    ],
    "tvosclassname": "",
    "tvosdelegatename": "",
    "tvosmaccompilerflags": "",
    "tvosmaclinkerflags": "",
    "tvosplistinject": "",
    "version": "0.10.0"
}