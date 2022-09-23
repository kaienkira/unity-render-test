Shader "Custom/TestLighting"
{
	Properties
	{
		_MainTex("MainTexture", 2D) = "white" {}
        _SpecularTint ("SpecularTint", Color) = (0.5, 0.5, 0.5)
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
	}

	SubShader
	{
		Tags
        { 
            "Queue" = "Geometry"
            "IgnoreProjector" = "True"
        }

		Pass
		{
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            Blend One Zero

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
            fixed4 _LightColor0;
            float4 _SpecularTint;
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

                float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

				fixed4 mainColor = tex2D(_MainTex, i.uvMain);
                float3 diffuse = mainColor * _LightColor0 * saturate(dot(lightDir, i.normal));
                float3 specular = _SpecularTint.rgb * _LightColor0 * pow(saturate(dot(normalize(lightDir + viewDir), i.normal)), _Smoothness * 100);

                fixed3 finalColor = diffuse + specular;
                return fixed4(finalColor, 1);
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
