using UnityEngine;
using UnityEngine.Rendering;

[CreateAssetMenu(menuName = "Custom/CustomRenderPipelineAsset")]
public sealed class CustomRenderPipelineAsset : RenderPipelineAsset
{
    protected override RenderPipeline CreatePipeline()
    {
        return null;
    }
}