Shader "Custom/TestDetailTexture"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_DetailTex("Detail Texture", 2D) = "gray" {}
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
			sampler2D _DetailTex;
			float4 _DetailTex_ST;

			struct appdata
			{
				float4 pos : POSITION;
                float2 texMain : TEXCOORD0;
                float2 texDetail: TEXCOORD1;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uvMain : TEXCOORD0;
				float2 uvDetail: TEXCOORD1;
			};

			v2f vert(appdata i)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(i.pos);
				o.uvMain = TRANSFORM_TEX(i.texMain, _MainTex);
				o.uvDetail = TRANSFORM_TEX(i.texDetail, _DetailTex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 mainColor = tex2D(_MainTex, i.uvMain);
                mainColor *= tex2D(_DetailTex, i.uvDetail) * unity_ColorSpaceDouble;

				return mainColor;
			}

			ENDCG
		}
	}
}
