Shader "Custom/Diffuse"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "IgnoreProjector" = "True"
        }

        Pass
        {
            CGPROGRAM

            #pragma multi_compile_instancing
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct appdata
            {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uvMain : TEXCOORD0;
            };

            v2f vert(appdata i)
            {
                UNITY_SETUP_INSTANCE_ID(i);

                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.uvMain = TRANSFORM_TEX(i.uv, _MainTex);

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
