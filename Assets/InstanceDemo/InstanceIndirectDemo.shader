Shader "Unlit/InstanceIndirectDemo"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog
            // #pragma multi_compile_instancing
            // #pragma target 4.5
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            struct MeshProperties
            {
                float4x4 mat;
                float4 color;
            };

            StructuredBuffer<MeshProperties> _Properties;

            
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v, uint instanceID: SV_InstanceID)
            {
                // Allow instancing.
                
                v2f o;
                float4 pos = mul(_Properties[instanceID].mat, v.vertex);
                o.vertex = UnityObjectToClipPos(pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = _Properties[instanceID].color;


                
                // UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col = i.color;
                // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
