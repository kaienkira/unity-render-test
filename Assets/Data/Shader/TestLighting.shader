Shader "Custom/TestLighting"
{
	Properties
	{
		_MainTex("Abedo", 2D) = "white" {}
		_Tint ("Abedo Tint", Color) = (1, 1, 1, 1)
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
        _NormalMap ("NormalMap", 2D) = "bump" {}
        _BumpScale ("BumpScale", Float) = 1
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
            Name "ForwardBase"
            Tags
            {
                "LightMode" = "ForwardBase"
            }

			CGPROGRAM

            #pragma target 3.0
            #pragma multi_compile DIRECTIONAL
            #define USER_FORWARD_BASE_PASS
            #include "TestLighting.cginc"

			ENDCG
		}

        Pass
        {
            Name "ForwardAdd"
            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            Blend One One
			ZWrite Off

			CGPROGRAM

            #pragma target 3.0
            #pragma multi_compile DIRECTIONAL POINT SPOT
            #include "TestLighting.cginc"

			ENDCG
        }

        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            CGPROGRAM

            #pragma target 3.0
            #pragma multi_compile SHADOWS_DEPTH
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata i)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.pos = UnityApplyLinearShadowBias(o.pos);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return 0;
            }

            ENDCG
        }
	}
}
