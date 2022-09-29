#if !defined(TEST_LIGHTING_CGINC)
#define TEST_LIGHTING_CGINC

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"

float4 _Tint;
sampler2D _MainTex;
float4 _MainTex_ST;
float _Metallic;
float _Smoothness;
sampler2D _NormalMap;
float _BumpScale;

struct appdata
{
    float4 vertex : POSITION;
    float2 uv: TEXCOORD0;
    float3 normal: NORMAL;
    float4 tangent : TANGENT;
};

struct v2f
{
    float4 pos : SV_POSITION;
    float2 uv: TEXCOORD0;
    float3 normal : TEXCOORD1;
    float3 tangent : TEXCOORD2;
    float3 binormal : TEXCOORD3;
    float3 worldPos: TEXCOORD4;
    SHADOW_COORDS(5)
};

v2f vert(appdata v)
{
    v2f o;

    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
    o.binormal = cross(o.normal, o.tangent.xyz) *
        (v.tangent.w * unity_WorldTransformParams.w);
    o.worldPos = mul(unity_ObjectToWorld, v.vertex);

    TRANSFER_SHADOW(o);

	return o;
}

fixed4 frag(v2f i) : SV_Target
{
    float3 tangentSpaceNormal =
        UnpackScaleNormal(tex2D(_NormalMap, i.uv), _BumpScale);
    i.normal = normalize(
        tangentSpaceNormal.x * i.tangent +
        tangentSpaceNormal.y * i.binormal +
        tangentSpaceNormal.z * i.normal);

	float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
    float3 specular;
    float oneMinusReflectivity;
    albedo = DiffuseAndSpecularFromMetallic(
        albedo, _Metallic, specular, oneMinusReflectivity);

    UNITY_LIGHT_ATTENUATION(attenuation, i, i.worldPos);
    UnityLight directLight;
    directLight.dir = normalize(UnityWorldSpaceLightDir(i.worldPos));
    directLight.color = _LightColor0.rgb * attenuation;

    UnityIndirect indirectLight;
    indirectLight.diffuse = 0;
    indirectLight.specular = 0;
#if defined(USER_FORWARD_BASE_PASS)
    indirectLight.diffuse += max(0, ShadeSH9(float4(i.normal, 1)));
#endif

    return UNITY_BRDF_PBS(
        albedo, specular, oneMinusReflectivity, _Smoothness,
        i.normal, viewDir,
        directLight, indirectLight);
}

#endif
