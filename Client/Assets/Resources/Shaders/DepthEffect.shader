// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DepthEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainDepthTex ("Base (RGB)", 2D) = "white" {}
		_ColorTex("Base (RGB)", 2D) = "white" {}
		_BlendColor("Blend Color",Color)=(1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass
		{
			CGPROGRAM


			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _MainDepthTex;
			sampler2D _ColorTex;
			sampler2D _CameraDepthTexture;
			float4 _BlendColor;

			
			 struct Input {  
                float4 pos : POSITION;  
                float2 uv : TEXCOORD0;  
            };  
  
            struct v2f {  
                float4 pos : POSITION;  
                float2 uv : TEXCOORD0;  
            };  

			v2f vert( Input i) {  
                v2f o;  
                o.pos = UnityObjectToClipPos (i.pos);  
                o.uv = i.uv;  
                return o;  
            }  

			 half4 frag(v2f IN) : COLOR{ 
				half4 col = tex2D(_MainTex, IN.uv);
				half4 tex2 = tex2D(_ColorTex, IN.uv);
				float depthValue = UNITY_SAMPLE_DEPTH (tex2D(_CameraDepthTexture,IN.uv));
				float mainDepthValue = tex2D(_MainDepthTex,IN.uv).r;
				//return float4(depthValue,depthValue,depthValue,1);
				//return mainDepthValue;
				if( mainDepthValue < depthValue )
				{
					return col*_BlendColor;
				}
				else
				{
					return col*_BlendColor*(1-tex2.a)  + tex2*tex2.a;
				}
				
			 }
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
