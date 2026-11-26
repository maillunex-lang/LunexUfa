// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "DZSMobile/Shadow" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base (RGB)", 2D) = "white" {}

	}
	SubShader 
	{
		Tags 
		{ 
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent" 
		}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			BlendOp RevSub
			Cull Off
			Lighting Off
	        ZWrite Off
	        Fog { Mode Off }
			Name "Effect"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			
			float4 _Color;
			float _Brightness;
			
			
			
			struct VS_INPUT
			{
				float4 position : POSITION;
				float4 color : COLOR;
				float2 uv : TEXCOORD0;
			};

			struct VS_OUTPUT
			{
				float4 position : SV_POSITION;
				float4 color : COLOR;
				float4 uv : TEXCOORD0;
			};

			VS_OUTPUT vert(VS_INPUT In)
			{
				VS_OUTPUT Out;
				Out.position = UnityObjectToClipPos(In.position);
				Out.uv.xy = In.uv.xy ;
				Out.color = In.color;
				return Out;
			}
			
			float4 frag(VS_OUTPUT In) : COLOR 
			{
				float4 color = tex2D(_MainTex, In.uv.xy);
				color *= In.color;
				color.rgba *= _Color.rgba;
				
				return color;
			}

			ENDCG
		}
	}
	FallBack "Diffuse-Mami"
}
