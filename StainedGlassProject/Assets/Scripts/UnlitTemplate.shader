Shader "Testing/UnlitTemplate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Position("Light Pos", vector) = (11,-6,0)
        _Diffuse("Diffuse", vector) = 0
        _Specular("Specular", vector) = 0
        _Constant("Constant", float) = 0f
        _Linear("Linear", float) = 0f
        _Quadratic("Quadratic", float) = 0f
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

            #include "UnityCG.cginc"            
            #include "UnityCG.glslinc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            _Constant = 1f;
            _Linear = 0.09f;
            _Quadratic = 0.032f;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float distance = length(_Position - FragPos);//??
                float attenuation = 1.0 / (_Constant + _Linear * distance + _Quadratic * (distance * distance));

                return col;
            }
            ENDCG
        }
    }
}
