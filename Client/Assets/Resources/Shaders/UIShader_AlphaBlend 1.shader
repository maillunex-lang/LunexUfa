// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// by artsyli

Shader "Hidden/Unlit/Transparent Colored Mask 1"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_MaskTex ("Mask Texture (A)", 2D) = "white" {}
	}
	
	SubShader
	{
		LOD 100

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Offset -1, -1
		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
				
			#include "UnityCG.cginc"
	
			float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
			float2 _ClipArgs0 = float2(1000.0, 1000.0);
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
				float2 uv : TEXCOORD0;
				float2 worldPos : TEXCOORD1;
			};
	
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _MainTex_ST;
				
			VS_OUTPUT vert (VS_INPUT In)
			{
				VS_OUTPUT Out;
				Out.position = UnityObjectToClipPos(In.position);
				Out.uv = In.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				Out.color = In.color;
				
				Out.worldPos = In.position.xy * _ClipRange0.zw + _ClipRange0.xy;
				return Out;
			}
				
			float4 frag (VS_OUTPUT In) : COLOR
			{
				// Softness factor
				float2 factor = (float2(1.0, 1.0) - abs(In.worldPos)) * _ClipArgs0;
			
				// Sample the texture
				float4 color = tex2D(_MainTex, In.uv) * In.color;
				color.a *= tex2D(_MaskTex, In.uv).r;
				color.a *= clamp( min(factor.x, factor.y), 0.0, 1.0);
				
				return color;
			}
			ENDCG
		}
	}
}
