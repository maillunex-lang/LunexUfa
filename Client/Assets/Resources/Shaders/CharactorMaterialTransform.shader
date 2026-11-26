// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// by artsyli
// 2014.4.30

Shader "lol/CharacterMaterialTransform"
{
	Properties 
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _DstTex ("Target (RGB)", 2D) = "white" {}
        _BlendTex ("Blend (RGB)", 2D) = "white" {}
        _Amount ("Amount", Range (0, 1)) = 0.5
        _Brightness ("Brightness", Float) = 1.3
		_DarkenDegree("***Do not edit***", Float) = 1
	}
	
	SubShader 
	{
		Tags 
		{ 
			"RenderType"="Opaque"
			"LightMode"="ForwardBase"
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _DstTex;
			sampler2D _BlendTex;
			float _Amount;
			float _Brightness;
			float4 _Color;
			float _DarkenDegree;
			
			struct VS_INPUT
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct VS_OUTPUT
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			VS_OUTPUT vert(VS_INPUT In)
			{
				VS_OUTPUT Out;
				Out.position = UnityObjectToClipPos(In.position);
				Out.uv = In.uv;
				
				return Out;
			}
			
			float4 frag(VS_OUTPUT In) : COLOR 
			{
				float4 color;
				float temp = tex2D(_BlendTex, In.uv).r;
				if(temp - _Amount >= 0.0f)
					color = tex2D(_MainTex, In.uv);
				else
					color = tex2D(_DstTex, In.uv);
				
				color.xyz *=_Brightness;
				color.xyz *=_Color.xyz * _DarkenDegree;
			
				return color;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}