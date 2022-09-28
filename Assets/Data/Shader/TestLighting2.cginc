#if !defined(TEST_LIGHTING2_CGINC)
#define TEST_LIGHTING2_CGINC

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

struct appdata
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
};

#if defined(SHADOWS_CUBE)

struct v2f
{
    float4 pos : SV_POSITION;
    float3 lightVec : TEXCOORD0;
};

v2f vert(appdata v)
{
    v2f o;

    o.pos = UnityObjectToClipPos(v.vertex);
    o.lightVec = mul(unity_ObjectToWorld, v.vertex).xyz -
        _LightPositionRange.xyz;

    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    float depth = length(i.lightVec) + unity_LightShadowBias.x;
    depth *= _LightPositionRange.w;
    return UnityEncodeCubeShadowDepth(depth);
}

#else

struct v2f
{
    float4 pos : SV_POSITION;
};

v2f vert(appdata v)
{
    v2f o;
    o.pos = UnityClipSpaceShadowCasterPos(v.vertex.xyz, v.normal);
    o.pos = UnityApplyLinearShadowBias(o.pos);

    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    return 0;
}

#endif

#endif
