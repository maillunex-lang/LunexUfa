// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// by artsyli

Shader "Effect_Mid/Additive Rim" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_Brightness ("Brightness", Float) = 1.0
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MaskTex ("Mask Texture (A)", 2D) = "white" {}
        _UVParam ("UV Param", Vector) = (0, 0, 1, 1)
        _UVTile ("UV Tile", Vector) = (0, 0, 1, 1)
        _Rotate ("UV Rotate", Range (0, 360.0)) = 0.0
        _MaskUVParam ("Mask UV Param", Vector) = (0, 0, 1, 1)
        _MaskRotate ("Mask UV Rotate", Range (0, 360.0)) = 0.0
        _RimLightParam ("RimLight Param", Vector) = (1, 1, 0, 0)
        _RimColor ("RimLight Color", Color) = (0, 0, 0, 1)
		_DarkenDegree("***Do not edit***", Float) = 1
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
			Blend SrcAlpha One
			Cull Off
			Lighting Off
	        Fog { Color (0,0,0,0) }
			Name "Effect"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile MASK_OFF MASK_ON
			#pragma multi_compile RIMLIGHT_OFF RIMLIGHT_ON
			#pragma target 2.0
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _Color;
			float _Brightness;
			float4 _UVParam;
			float4 _UVTile;
			float _Rotate;
			float4 _MaskUVParam;
			float _MaskRotate;
			float4 _RimLightParam;
			float4 _RimColor;
			float _DarkenDegree;
			
			float4 _MainTex_ST;  // build in var
			
			float2 CalcUV(float2 uv, float4 uvParam, float4 uvTile, float uvRotate)
			{
				float2 outUV;
				float s;
				float c;
				s = sin(uvRotate);
				c = cos(uvRotate);
				
				outUV = uv - float2(0.5f, 0.5f);
				outUV = float2(outUV.x * c - outUV.y * s, outUV.x * s + outUV.y * c);
				outUV.x *= uvParam.z;
				outUV.y *= uvParam.w;
				outUV = outUV + uvParam.xy + float2(0.5f, 0.5f);
				
				outUV.x = (outUV.x * uvTile.z) + uvTile.x;
				outUV.y = (outUV.y * uvTile.w) + uvTile.y;
				
				return outUV;
			}
			
			struct VS_INPUT
			{
				float4 position : POSITION;
			#ifdef RIMLIGHT_ON
				float3 normal : NORMAL;
			#endif
				float4 color : COLOR;
				float2 uv : TEXCOORD0;
			};

			struct VS_OUTPUT
			{
				float4 position : SV_POSITION;
				float4 color : COLOR;
				float4 uv : TEXCOORD0;
			#ifdef RIMLIGHT_ON
				float3 viewDir : TEXCOORD1;
				float3 normal : TEXCOORD2;
			#endif
			};

			VS_OUTPUT vert(VS_INPUT In)
			{
				VS_OUTPUT Out;
				Out.position = UnityObjectToClipPos(In.position);
				float2 uv = In.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				Out.uv.xy = CalcUV(uv, _UVParam, _UVTile, _Rotate/57.2957796);
				Out.uv.zw = In.uv;
			#ifdef MASK_ON
				Out.uv.zw = CalcUV(In.uv, _MaskUVParam, float4(0, 0, 1, 1), _MaskRotate/57.2957796);
			#endif
				Out.color = In.color;
				
			#ifdef RIMLIGHT_ON
				float3 campos = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0f)).xyz;
				Out.viewDir = normalize(campos - In.position);
				Out.normal = In.normal;
			#endif
				
				return Out;
			}
			
			float4 frag(VS_OUTPUT In) : COLOR 
			{
				float4 texcolor = tex2D(_MainTex, In.uv.xy);
				float4 color = texcolor;
				color *= In.color;
			#ifdef MASK_ON
				color.a *= tex2D(_MaskTex, In.uv.zw).r;
			#endif
				color.rgba *= _Color.rgba;
				
			#ifdef RIMLIGHT_ON
				float tmpS =dot(In.viewDir, In.normal);
				float vn = max(0,min(1.0, tmpS));
				//float vn = 1;//saturate(dot(In.viewDir, In.normal));
				float rim = 1 - vn;
				rim = pow(rim, _RimLightParam.y);
				texcolor.rgb += _RimColor.rgb;
				color.rgb += rim * texcolor.rgb * _RimLightParam.x;
				color.a *= pow(vn, _RimLightParam.z);
			//	color.rgb = float3(vn,vn,vn);
			#endif
				
				color.rgb *= _Brightness;
				color.rgb *= _DarkenDegree;
				
				return color;
			}

			ENDCG
		}
	}
	FallBack "Diffuse-Mami"
	CustomEditor "EffectMaterialRimEd"
}
