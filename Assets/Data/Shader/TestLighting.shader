Shader "Custom/TestLighting"
{
	Properties
	{
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("MainTex", 2D) = "white" {}
		_Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.1
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

            #pragma multi_compile DIRECTIONAL
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

            #pragma multi_compile POINT DIRECTIONAL SPOT
            #include "TestLighting.cginc"

			ENDCG
        }
	}
}
