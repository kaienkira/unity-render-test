Shader "Custom/PlanarReflection"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry" "IgnoreProjector" = "true" }

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct appdata
			{
				float4 pos : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uvMain : TEXCOORD0;
			};

			v2f vert(appdata i)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(i.pos);
				float4 screenPos = ComputeScreenPos(o.pos);
				float2 uv = screenPos.xy / screenPos.w;
				uv.x = 1 - uv.x;
#if UNITY_UV_START_AT_TOP
				uv.y = 1 - uv.y;
#endif
				o.uvMain = TRANSFORM_TEX(uv, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 mainColor = tex2D(_MainTex, i.uvMain);

				return mainColor;
			}

			ENDCG
		}
	}
}
