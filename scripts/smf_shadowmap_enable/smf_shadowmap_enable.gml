/// @description smf_shadowmap_enable(smoothingLevel(0-2), shadowmapIndex, [shadowmapIndex2])
/// @param smoothingLevel(0-2)
/// @param shadowmapIndex
/// @param [shadowmapIndex2]
SMF_shadowmapSmoothing = argument[0];
SMF_shadowmapEnabled = [];
SMF_shadowmapEnabled[0] = argument[1];

if argument_count > 2
{
    SMF_shadowmapEnabled[1] = argument[2];
}