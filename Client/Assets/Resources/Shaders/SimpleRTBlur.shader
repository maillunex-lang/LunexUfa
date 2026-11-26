// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//By paulwu

Shader "Moba/SimpleRTBlur" {
    Properties {
         _blurTexture ("Base (RGB) Trans (A)", 2D) = "white" {}
    }

	// hight quality
    SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque" }
		LOD 250
		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Offset -1, -1

 
        Pass {
            Tags { "LightMode" = "Always" }
               
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
               
            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord: TEXCOORD0;
				fixed4 color : COLOR;
            };
               
            struct v2f {
                float4 vertex : POSITION;
                float4 uvgrab : TEXCOORD0;
				fixed4 color : COLOR;
            };
               
            v2f vert (appdata_t v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //#if UNITY_UV_STARTS_AT_TOP
                //float scale = 1.0;
                //#else
                //float scale = 1.0;
                //#endif
                o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y) + o.vertex.w) * 0.5;
                o.uvgrab.zw = o.vertex.zw;
				o.color = v.color;
                return o;
            }
               
            //mpler2D _blurTexture : register(s6);
			sampler2D _blurTexture;

               
            fixed4 frag( v2f i ) : COLOR {


				fixed4 color = tex2Dproj(_blurTexture , UNITY_PROJ_COORD(half4(i.uvgrab.x, i.uvgrab.y , i.uvgrab.z, i.uvgrab.w)));
				color *= i.color;
				return color;
            }
            ENDCG
        }
    
    }

	// low quality
    SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100
		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Offset -1, -1

 
        Pass {
            Tags { "LightMode" = "Always" }
               
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
               
            struct appdata_t {
                float4 vertex : POSITION;
                //float2 texcoord: TEXCOORD0;
				fixed4 color : COLOR;
            };
               
            struct v2f {
                float4 vertex : POSITION;
                //float4 uvgrab : TEXCOORD0;
				fixed4 color : COLOR;
            };
               
            v2f vert (appdata_t v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //#if UNITY_UV_STARTS_AT_TOP
                //float scale = 1.0;
                //#else
                //float scale = -1.0;
                //#endif
                //o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                //o.uvgrab.zw = o.vertex.zw;
				o.color = v.color;
                return o;
            }
               
            //smpler2D _blurTexture : register(s6);
			//smpler2D _blurTexture;

               
            fixed4 frag( v2f i ) : COLOR {

				fixed4 color = fixed4(0.0f,0.0f,0.0f,1.0f);
				color.a *= 0.6f;
				return color;
            }
            ENDCG
        }
    
    }
}
