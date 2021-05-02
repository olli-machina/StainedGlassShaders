Shader "Unlit/BasicLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _AmbientColor("Ambient Color", Color) = (1, 1, 1, 1)
        _AmbientStrength("Ambient Strength", Range(0, 1)) = 0.1
        _SpecularStrength("Specular Strength", Range(0, 1)) = 0.1
        _SpecularReflectivity("Specular Reflectivity", int) = 32

        _GlassLocation("Glass Location", vector) = (0, 0, 0, 0)
        _GlassScale("Glass Scale", vector) = (0, 0, 0, 0)
        _GlassTint("Glass Tint", Color) = (1, 1, 1, 1)
        _GlassTintStrength("Glass Tint Strength", Range(0, 1)) = 0.1

        //_LightPos("Light Position", vector) = (0, 0, 0, 0)
        //_LightColor("Light Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags { "LightMode" = "ForwardAdd" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 objNormal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float3 worldSpace : TEXCOORD2;
                float3 viewDir : TEXCOORD3;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float3 _AmbientColor;
            float _AmbientStrength;
            float3 _LightPos;
            float _SpecularStrength;
            int _SpecularReflectivity;
            float3 _GlassLocation;
            float3 _GlassScale;
            float3 _GlassTint;
            float _GlassTintStrength;
            //float3 _LightColor;

            float4 _LightColor0;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldSpace = mul(unity_ObjectToWorld, v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.worldNormal = normalize(mul(float4(v.objNormal, 0.0), unity_WorldToObject).xyz);

                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 tex = tex2D(_MainTex, i.uv);


            // ambient lighting
            float3 ambientValueColor = _AmbientStrength *_AmbientColor;


            // diffuse lighting
            // i.worldNormal --normal vec
            float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldSpace); //light vec

            float diffuse = max(dot(i.worldNormal, lightDir), 0.0);
            float3 diffuseValueColor = diffuse * _LightColor0;

            // specular lighting
            // i.viewDir -- Viewing vector
            float3 reflectDir = reflect(-lightDir, i.worldNormal);

            float spec = pow(max(dot(i.viewDir, reflectDir), 0.0), _SpecularReflectivity);
            float3 specularValueColor = _SpecularStrength * spec * _LightColor0;



            // Shadow mapping
            float3 step = (i.worldSpace -_WorldSpaceLightPos0.xyz) * 0.01;
            bool shadow = false;
            
            float3 halfScale = _GlassScale.xyz * 0.5;

            for (int i = 0; i < 100; i++)
            {
                float3 stepPos = (_WorldSpaceLightPos0.xyz + (i * step));
                if (stepPos.x > _GlassLocation.x - halfScale.x && stepPos.x < _GlassLocation.x + halfScale.x
                    && stepPos.y > _GlassLocation.y - halfScale.y && stepPos.y < _GlassLocation.y + halfScale.y
                    && stepPos.z > _GlassLocation.z - halfScale.z && stepPos.z < _GlassLocation.z + halfScale.z)
                {
                    shadow = true;
                    break;
                }
            }


            // combine
            float3 result;
            float3 phong = (ambientValueColor + diffuseValueColor + specularValueColor) * tex.xyz;
            if (shadow)
                result = phong + (_GlassTint * _GlassTintStrength);
            else
                result = (ambientValueColor + diffuseValueColor + specularValueColor) * tex.xyz;

            fixed4 col = vector(result, 1.0);
                
                return col;
            }
            ENDCG
        }
    }
}
