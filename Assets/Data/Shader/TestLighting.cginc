#if !defined(TEST_LIGHTING_CGINC)
#define TEST_LIGHTING_CGINC

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

float4 _Tint;
sampler2D _MainTex;
float4 _MainTex_ST;
fixed4 _LightColor0;
float _Metallic;
float _Smoothness;

struct appdata
{
	float4 pos : POSITION;
    float2 texMain : TEXCOORD0;
    float3 normal: NORMAL;
};

struct v2f
{
	float4 pos : SV_POSITION;
	float2 uvMain : TEXCOORD0;
    float3 normal : TEXCOORD1;
    float3 worldPos: TEXCOORD2;
};

v2f vert(appdata i)
{
	v2f o;

	o.pos = UnityObjectToClipPos(i.pos);
	o.uvMain = TRANSFORM_TEX(i.texMain, _MainTex);
    o.normal = UnityObjectToWorldNormal(i.normal);
    o.worldPos = mul(unity_ObjectToWorld, i.pos);

	return o;
}

fixed4 frag(v2f i) : SV_Target
{
    i.normal = normalize(i.normal);

    float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
	float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

	float3 mainColor = tex2D(_MainTex, i.uvMain).rgb * _Tint.rgb;
    float3 diffuse = mainColor * _LightColor0 * saturate(dot(lightDir, i.normal));
    float3 specular = _LightColor0 * pow(saturate(dot(normalize(lightDir + viewDir), i.normal)), _Smoothness * 100);

    fixed3 finalColor = diffuse + specular;
    return fixed4(finalColor, 1);
}

#endif
