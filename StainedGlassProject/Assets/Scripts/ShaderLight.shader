Shader "Custom/lightingShader"

{
    Properties
    {
        _Position("Light Pos", vector) = (11,-6,0)
        _Radius("Light Size", Range(0, 20)) = 3
        _OuterRingSize("Outline Size", Range(0,5)) = 1
        _ColorTint("Outside Light Color", Color) = (0,0,0,0)
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

                float3 worldPos : TEXCOORD1; //structure to send to the fragment
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Position;
            float _Radius;
            float _OuterRingSize;
            float4 _ColorTint;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; //moving from float4 to float3, need .xyz

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = 0; //1 digit fills set: (0,0,0,0)
                
                float dist = distance(i.worldPos, _Position.xyz); //distance inbetween two pixels

                //spotlight section
                if (dist < _Radius)
                    col = tex2D(_MainTex, i.uv);

                //ring section (bland)
                //outer section (color tint)
    
                return col;
            }
            ENDCG
        }
    }
}
