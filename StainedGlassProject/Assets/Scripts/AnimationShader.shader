Shader "Unlit/AnimationShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TimePerTransition("Time per Transition", float) = 1
        _Color("Color", Color) = (1, 1, 1, 1)
        //_NumOfKeyframes("Num of Keyframes", float) = 1
        //_CurrentLocation("CurrentLocation", vector) = (0, 0, 0, 0)
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
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float3 _AnimationKeyframes[100];
            float _NumOfKeyframes;
            float _CurrentTime;
            float _TimePerTransition;
            float3 _Color;

            float4 _CurrentLocation;

            v2f vert (appdata v)
            {
                v2f o;
                
                int currentFrame = (_CurrentTime / _TimePerTransition) % _NumOfKeyframes;
                float interp = ((_CurrentTime / _TimePerTransition) % _NumOfKeyframes) - currentFrame;

                float3 offset;

                if (currentFrame + 1 == _NumOfKeyframes)
                    offset = _AnimationKeyframes[currentFrame] + ((_AnimationKeyframes[0] - _AnimationKeyframes[currentFrame]) * interp);
                else
                    offset = _AnimationKeyframes[currentFrame] + ((_AnimationKeyframes[currentFrame + 1] - _AnimationKeyframes[currentFrame]) * interp);
                
                float4 newLoc = float4(0, 0, 0, 0);
                    if (_NumOfKeyframes == 0)   
                        newLoc = v.vertex;
                    else
                        newLoc = float4(v.vertex + offset, 1.0);
                
                    _CurrentLocation = newLoc;
                    
                
                o.vertex = UnityObjectToClipPos(newLoc);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
            
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return vector(_Color, 1.0);
            }
            ENDCG
        }
    }
}
