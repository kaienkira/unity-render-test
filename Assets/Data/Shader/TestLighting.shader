Shader "Custom/TestLighting"
{
	Properties
	{
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("MainTex", 2D) = "white" {}
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5

        _NormalMap ("NormalMap", 2D) = "bump" {}
        _BumpScale ("BumpScale", Float) = 0.25
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

			CGPROGRAM

            #pragma target 3.0
            #pragma multi_compile DIRECTIONAL
            #define USER_FORWARD_BASE_PASS
            #include "TestLighting.cginc"

			ENDCG
		}

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            Blend One One
			ZWrite Off

			CGPROGRAM

            #pragma target 3.0
            #pragma multi_compile POINT DIRECTIONAL SPOT
            #include "TestLighting.cginc"

			ENDCG
        }
	}
}
