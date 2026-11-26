// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Water" 
{
	Properties 
	{
		_ReflDistort ("反射扭曲强度", Range (0,1)) = 0.1
		_BumpMap ("法线贴图 ", 2D) = "bump" {}
		_NormalScale("法线强度", Range(0,4)) = 1
		
		_WaveSpeed ("水流速度", Vector) = (1,1,1,1)
		
		_WaterColor ("水体颜色", COLOR)  = (0.1, 0.12, 0.17, 1)
		_HorizonColor ("简单水反射颜色", COLOR)  = (0.69,0.82,1,1)
		
		_FresnelPower ("菲涅尔强度", Range(0, 8))  = 2
		_Transparent ("透明度", Range(0, 1))  = 0.8

		[Space(10)]
		_SpecClr ("高光颜色", COLOR)  = (1,1,1,1)
		_SpecPower ("高光范围", Range(0.1, 10))  = 5
		_SpecIntensity ("高光强度", Range(0, 5))  = 1
		
		[Space(10)]
		_FoamTex ("波浪贴图 ", 2D) = "Black" {}
		_FoamSpeed("波浪速度", vector) = (0.1,0.1,0,0)
        _FoamBlend ("波浪混合", Range(0.01,10) ) = 0.15
        _FoamIntensity ("波浪强度", Float ) = 5
        _FoamContrast ("Foam Contrast", Range(0, 0.5)) = 0.25
        _FoamColor ("混合区域颜色", Color) = (0.5,0.5,0.5,1)
		
		[HideInInspector] _ReflectionTex ("反射贴图", 2D) = "" {}
		
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0
	}

	Subshader 
	{
		Tags { "RenderType"="Transparent" "LightMode" = "ForwardBase"}
		Blend [_SrcBlend] [_DstBlend]
		Cull Back 
		ZWrite [_ZWrite]
		
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma shader_feature ENABLE_REFLECTIVE
			#pragma shader_feature ENABLE_SOFTEDGE
			#pragma shader_feature ENABLE_SPECULAR
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			half4 _WaveSpeed;
			fixed4 _WaterColor;
			fixed4 _HorizonColor;
			sampler2D _BumpMap; half4 _BumpMap_ST;
			half _NormalScale;
			half _FresnelPower;
			half _Transparent;
			
			sampler2D _FoamTex; half4 _FoamTex_ST;
			half _FoamBlend;
			half _FoamIntensity;
			half _FoamContrast;
			fixed4 _FoamColor;
			half4 _FoamSpeed;
			
			#if ENABLE_REFLECTIVE
				sampler2D _ReflectionTex;
				fixed _ReflDistort;
			#endif
			
			#if ENABLE_SOFTEDGE
				sampler2D _CameraDepthTexture;
				fixed _EdgeFactor;
			#endif
			
			#if ENABLE_SPECULAR
				fixed4 _SpecClr; 
				half _SpecPower;
				half _SpecIntensity;
			#endif

			struct appdata 
			{
				half4 vertex : POSITION;
				half3 normal : NORMAL;
				half4 tangent : TANGENT;
				half2 uv : TEXCOORD0;
			};

			struct v2f 
			{
				half4 pos : SV_POSITION;
				half4 uv : TEXCOORD0;
				half4 uv1 : TEXCOORD1;
				half3 viewDir : TEXCOORD2;
				half3 normal : NORMAL;
				half4 tangent : TANGENT;
				
				#if ENABLE_SOFTEDGE || ENABLE_REFLECTIVE
					half4 projPos : TEXCOORD3;
				#endif
				
				UNITY_FOG_COORDS(4)
			};
			
			v2f vert(appdata v)
			{
				v2f o = (v2f)0;
				
				o.pos = UnityObjectToClipPos (v.vertex);
				
				#if ENABLE_SOFTEDGE || ENABLE_REFLECTIVE
					o.projPos = ComputeScreenPos (o.pos);
				#endif
				
				half2 nuv = TRANSFORM_TEX(v.uv, _BumpMap);
				half4 waveScale = half4(nuv, nuv.x * 0.4, nuv.y * 0.45);
				half4 waveOffset = _WaveSpeed * _Time.y * 0.05;
				o.uv = waveScale + frac(waveOffset);
				
				o.uv1.xy = TRANSFORM_TEX(v.uv, _FoamTex);
				
				o.viewDir = WorldSpaceViewDir(v.vertex);
				
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag( v2f i ) : SV_Target
			{
				fixed3 bump1 = UnpackNormal(tex2D( _BumpMap, i.uv.xy )).rgb;
				fixed3 bump2 = UnpackNormal(tex2D( _BumpMap, i.uv.zw )).rgb;
				fixed3 normal = bump1 + bump2;
				normal.xy *= _NormalScale;
				normal = normalize(normal);
				
				half3 viewDir = normalize(i.viewDir);
				fixed fresnelFac = 1 - (dot(viewDir, normal.xzy));
				fresnelFac = saturate(pow(fresnelFac, _FresnelPower) + 0.02);
				//fresnelFac *= fresnelFac * fresnelFac;
				
				fixed4 color = 1;
				#if !ENABLE_REFLECTIVE
					color.rgb = lerp(_WaterColor, _HorizonColor, fresnelFac);
				#else
					half4 refluv = i.projPos; 
					refluv.xy += normal * _ReflDistort;
					fixed4 reflColor = tex2Dproj(_ReflectionTex, UNITY_PROJ_COORD(refluv));
					color.rgb = lerp(_WaterColor.rgb, reflColor.rgb, fresnelFac);
				#endif

				#if ENABLE_SOFTEDGE
					half sceneZ = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos));
					sceneZ = LinearEyeDepth (sceneZ);
					half partZ = i.projPos.z;
					half edge = sceneZ - partZ;
					edge *= edge;
					half fade = saturate (_EdgeFactor * edge);
					color.a = fade * _Transparent;
					
					//foam part
					half2 recipObjScale = half2(length(unity_WorldToObject[0].xyz), length(unity_WorldToObject[2].xyz));
					
					_FoamSpeed *= _Time.y;
					
					half2 foamUV1 = (_FoamSpeed.xy + i.uv1.xy * fixed2(0.4,0.45)) * recipObjScale;
					half4 foamTex = tex2D(_FoamTex, foamUV1);
					
					i.uv1.xy += foamTex.xy * 0.2;
					half2 foamUV2 = (_FoamSpeed.zw + i.uv1.xy) * recipObjScale;
					half4 foamTex2 = tex2D(_FoamTex, foamUV2);
					
					fixed3 foam = saturate(foamTex * foamTex2 - _FoamContrast) * _FoamIntensity;
					
					fixed3 foamColor = foam + _FoamColor;
					
					fixed foamAera = saturate(1 - edge / _FoamBlend);
					foamColor *= foamAera;
					color.rgb += foamColor;
				#endif

				#if ENABLE_SPECULAR
					half3 lightDir = _WorldSpaceLightPos0.xyz;
					half3 halfDir = normalize(lightDir + viewDir);
					half spec = pow(saturate(dot(halfDir,normal.xzy)), _SpecPower * 128) * fresnelFac;
					half3 specColor = spec * _SpecClr * _SpecIntensity;
					color.rgb += specColor;
					color.a = max(color.a, spec);
				#endif
				
				
				UNITY_APPLY_FOG(i.fogCoord, color);
				return fixed4(color);
			}
			ENDCG
		}
	}
}
