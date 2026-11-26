// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "sw/character/characterc_seperate/viewlight" {
	Properties {  
		_AmbientColor("_AmbientColor",Color)=(0.4,0.4,0.4,1)
		_DLightIntensity("_DLightIntensity",Float)= 1
		_DLightColor("_DLightColor",Color)= (1,1,1,1)

		_Cutoff("Cutout",Range(0,1)) = 0
		_MainTex("Main Tex", 2D)                 = "white" {}
		_BumpTex("Bump Tex", 2D)                 = "bump" {}

		_GlossChanneTex("_GlossChanneTex", 2D) = "white" {}
		_MetallicChanneTex("_MetallicChanneTex", 2D) = "white" {}
		_FlowChanneTex("_FlowChanneTex", 2D) = "white" {}
		_SpecHackTex ("_SpecHackTex(RGB)", 2D) = "white" {}
		_SpecHackIntensity("_SpecHackIntensity", Range(0,1)) = 1

		_Cube ("Reflection Cubemap", Cube) = "" {}
		_Metallic("Metallic(Channel G) ",Range(0,1))=1
		_Glossiness ("Gloss(Channel R)", Range(0,1)) = 1
	
		


		
		_LightTex ("Light Texture", 2D) = "black" {}
		_LightColor("Light Color",Color) = (1,1,1,1)
		_LightPower("Light Power",Range(0,5)) = 1
		_LightScale("Light Scale" , Range(0.5,5)) = 1
		_LightAngle("Light Angle",Range(-180,180)) = 1
		//每次持续时间，受Angle和Scale影响
		_LightDuration("Light Duration",Range(0,10)) = 1
		//时间间隔，受Angle和Scale影响
		_LightInterval("Light Interval",Range(0,20)) = 3
		//非线性，受Angle和Scale影响
		_LightOffSetX("Light OffSet ",Range(-10,10)) = 0

		[HideInInspector]	
		_FixedViewDir("Fixed ViewDir",float) =0	
		
	}  

	SubShader {  
		LOD 100
		Lighting Off		
		Tags{"RenderType"="TransparentCutoutAK" "QUEUE"="AlphaTest"  }  

		Pass {
			Tags { 
			"RenderType"="TransparentCutoutAK" 
			"LightMode"="ShadowCaster" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _Cutoff;
			struct v2f{
				V2F_SHADOW_CASTER;
				float2 uv:TEXCOORD2;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.uv = v.texcoord.xy;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
				return o;
			}

			float4 frag( v2f i ) : SV_Target
			{
				fixed alpha = tex2D(_MainTex, i.uv).a;
				clip(alpha -_Cutoff);
				SHADOW_CASTER_FRAGMENT(i)
			}

			ENDCG
		}

		Pass
		{

			ZTest LEqual
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11, Xbox360, OpenGL ES 2.0 because it uses unsized arrays
//#pragma exclude_renderers d3d11 xbox360 gles
// Upgrade NOTE: excluded shader from DX11 and Xbox360 because it uses wrong array syntax (type[size] name)
//#pragma exclude_renderers d3d11 xbox360
			#pragma vertex   vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			#include "UnityStandardConfig.cginc"
			#define INTERNAL_DATA
			#define WorldReflectionVector(data,normal) data.worldRefl


			// fragma input
			struct v2f
			{
				float4 pos      : SV_POSITION;
				float2 uv       : TEXCOORD0;
				float3 viewDir  : TEXCOORD1;
				float3 lightDir : TEXCOORD2;

				float3 reflViewDir  : TEXCOORD3;
				float3 normal : TEXCOORD4;
				float4 tangent : TEXCOORD5;
				UNITY_FOG_COORDS(6)
				float2 lightuv : TEXCOORD7;

			};
			float4 _AmbientColor;
			float4 _DLightColor;
			float _DLightIntensity;
			float4 _DLightDir;
			float _Cutoff;
			sampler2D _MainTex;
			sampler2D _BumpTex;

			sampler2D _GlossChanneTex;
			sampler2D _MetallicChanneTex;
			sampler2D _FlowChanneTex;

			sampler2D _SpecHackTex;
			float _SpecHackIntensity;
			float4    _Ambient;

		
			float  _Metallic;
			float _Glossiness;
			float _Intensity;


			UNITY_DECLARE_TEXCUBE(_Cube);

			
			float _LightMul;

			fixed	_FixedViewDir; 

			sampler2D _LightTex ;
			float4  _LightTex_ST;
			half _LightInterval ;
			half _LightDuration ;
			half4 _LightColor ;
			half _LightPower ;
			half _LightAngle ;
			half _LightScale ;
			half _LightOffSetX ;
			half _LightOffSetY ;



			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv  = v.texcoord;

	
				o.lightDir = float3(0,0,0);

				float3 wviewDir=WorldSpaceViewDir(v.vertex);
				o.viewDir =wviewDir;
				o.reflViewDir = -wviewDir;
				o.normal=v.normal;
				o.tangent = v.tangent;
				UNITY_TRANSFER_FOG(o,o.pos);

				fixed currentTimePassed = fmod(_Time.y,_LightInterval);

				//uv offset, Sprite wrap mode need "Clamp"
				fixed offsetX = currentTimePassed / _LightDuration;
				fixed offsetY = currentTimePassed / _LightDuration;

                float angleInRad = 0.0174444 * _LightAngle;
				float sinInRad = sin(angleInRad);
				float cosInRad = cos(angleInRad);

				float2 offset ;
				offset.x = offsetX ;
				offset.y = offsetY ;

				float2 base = v.texcoord ;
				base.x -= _LightOffSetX ;
				base.y -= _LightOffSetX ;
				base = base / _LightScale ;

				float2 base2 = v.texcoord;
				base2.x  = base.x * cosInRad - base.y * sinInRad ;
				base2.y  = base.y * cosInRad + base.x * sinInRad ;

				o.lightuv = base2 + offset ;

				o.lightuv    = TRANSFORM_TEX(o.lightuv, _LightTex);

				return o;
			}

			float4 frag(v2f i) : COLOR0
			{
				float3 viewDir  = normalize(i.viewDir);
				float3 lightDir= normalize(i.viewDir);

			
				 
				//取像素
				float3 channelCol;
				channelCol.r=tex2D(_GlossChanneTex,i.uv).r;
				channelCol.g=tex2D(_MetallicChanneTex,i.uv).r;
				channelCol.b=tex2D(_FlowChanneTex,i.uv).r;

				float4 clr  = tex2D(_MainTex, i.uv);//*channelCol.b;
				clip(clr.a - _Cutoff);
	
				float channelR=channelCol.r;
				float channelG=channelCol.g;
				float channelB=channelCol.b;
			
				

				//虚拟灯光brdf计算
				half3 halfDir=SafeNormalize(lightDir+viewDir);

				half3 normalDir;
				normalDir = calculateWorldNormal(i.normal, i.tangent,  UnpackNormal(tex2D(_BumpTex, i.uv)));

				half nl = DotClamped (normalDir, lightDir);
				half nh = DotClamped (normalDir, halfDir);
				half nv = DotClamped (normalDir, viewDir);
				half lh = DotClamped(lightDir,halfDir);



				half oneMinusRoughness=_Glossiness*(channelR);
				half roughness=	1-oneMinusRoughness;		
				half specularPower=RoughnessToSpecPower(roughness);

				half invV=lh*lh*oneMinusRoughness+roughness*roughness;
				half invF=lh;
				half specular = ((specularPower + 1) * pow (nh, specularPower)) / (8 * invV * invF + 1e-4h);
	#ifdef UNITY_COLORSPACE_GAMMA
				specular =sqrt(max(1e-4h, specular));
	#endif	
				#if SHADER_API_GLES || SHADER_API_GLES3
				specular = clamp(specular, 0.0, 100.0);
				#endif

				//反射
			
				half3 refDir = reflect(i.reflViewDir, normalDir);

				float4 c;
				float metallic=_Metallic*channelG;
				//灯光影响颜色计算
				half oneMinusReflectivity=0;
				half3 specColor=0;
				c.rgb = DiffuseAndSpecularFromMetallic (clr.rgb, _Metallic*channelG, /*out*/ specColor, /*out*/ oneMinusReflectivity);

				float3 specHackColor=tex2D(_SpecHackTex,i.uv).rgb;
				specHackColor = _SpecHackIntensity*specHackColor;
				half3 diffColor=c.rgb;

				//反射光滑度计算
				half realRoughness = roughness*roughness;		// need to square perceptual roughness
				half surfaceReduction = IsGammaSpace() ? 0.28 : (0.6 - 0.08*roughness);
				surfaceReduction = 1.0 - realRoughness*roughness*surfaceReduction;

				#if UNITY_OPTIMIZE_TEXCUBELOD
				half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(_Cube,refDir, 4);
				if(roughness > 0.5)
				rgbm = lerp(rgbm, UNITY_SAMPLE_TEXCUBE_LOD(_Cube, refDir, 8), 2*roughness-1);
				else
				rgbm = lerp(UNITY_SAMPLE_TEXCUBE(_Cube, refDir), rgbm, 2*roughness);
				#else
				half mip = roughness * 8;
				half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(_Cube, refDir, mip);
				#endif


				half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
				half3 relColor=(rgbm.rgb*metallic+clr.rgb*(1-metallic))*surfaceReduction* FresnelLerpFast (specColor, grazingTerm, nv);;
				
				c.rgb= (diffColor+specular*specColor*specHackColor)*nl*_DLightColor.rgb*_DLightIntensity+diffColor*_AmbientColor.rgb+relColor;
				//c.rgb = nl.rrr;
	
				//流光
				fixed4 lightCol  = tex2D(_LightTex, i.lightuv);
				lightCol *= _LightColor ;
				c.rgb+=lightCol.rgb* _LightPower*c.rgb*channelB;

				c.a=1;
				UNITY_APPLY_FOG(i.fogCoord, c.rgb);
				UNITY_OPAQUE_ALPHA(c.a);
				return c;
			}

			ENDCG

			CGINCLUDE
			#include "UnityCG.cginc"
			inline float3 calculateWorldNormal(float3 normal, float4 tangent, float3 texnormal)
			{
				normal         = normalize(normal);
				float3 tangetL = tangent.xyz;
				float  tW      = tangent.w;
				tangetL        = normalize(tangetL);
				float3 BinormalL = cross(normal,tangetL) * tW;
				float3x3 TBN = float3x3(tangetL, BinormalL, normal);
				
				float3 sampledNormalT = texnormal;

				
				//transform normalT to object space
				float3 normalL = sampledNormalT.x * TBN[0] +
												sampledNormalT.y * TBN[1] +
												sampledNormalT.z * TBN[2];


				float3 normalW = UnityObjectToWorldNormal(normalL);
				return normalize(normalW);	
			}

			inline half RoughnessToSpecPower (half roughness)
			{
				#if UNITY_GLOSS_MATCHES_MARMOSET_TOOLBAG2
				// from https://s3.amazonaws.com/docs.knaldtech.com/knald/1.0.0/lys_power_drops.html
				half n = 10.0 / log2((1-roughness)*0.968 + 0.03);
				#if defined(SHADER_API_PS3) || defined(SHADER_API_GLES) || defined(SHADER_API_GLES3)
				// Prevent fp16 overflow when running on platforms where half is actually in use.
				n = max(n,-255.9370);  //i.e. less than sqrt(65504)
				#endif
				return n * n;

				// NOTE: another approximate approach to match Marmoset gloss curve is to
				// multiply roughness by 0.7599 in the code below (makes SpecPower range 4..N instead of 1..N)
				#else
				half m = max(1e-4f, roughness * roughness);			// m is the true academic roughness.

				half n = (2.0 / (m*m)) - 2.0;						// https://dl.dropboxusercontent.com/u/55891920/papers/mm_brdf.pdf
				n = max(n, 1e-4f);									// prevent possible cases of pow(0,0), which could happen when roughness is 1.0 and NdotH is zero
				return n;
				#endif
			}
			inline half DotClamped (half3 a, half3 b)
			{
				#if (SHADER_TARGET < 30 || defined(SHADER_API_PS3))
				return saturate(dot(a, b));
				#else
				return max(0.0h, dot(a, b));
				#endif
			}
			inline half3 SafeNormalize(half3 inVec)
			{
				half dp3 = max(0.001f, dot(inVec, inVec));
				return inVec * rsqrt(dp3);
			}
			inline half3 FresnelLerpFast (half3 F0, half3 F90, half cosA)
			{
				half t =pow(1-cosA,4);// Pow4 (1 - cosA);
				return lerp (F0, F90, t); 
			}

			inline half OneMinusReflectivityFromMetallic(half metallic,float dielec)
			{
				half oneMinusDielectricSpec = 1-dielec;
				return oneMinusDielectricSpec - metallic * oneMinusDielectricSpec;
			}
			inline half3 DiffuseAndSpecularFromMetallic (half3 albedo, half metallic, out half3 specColor, out half oneMinusReflectivity)
			{
				float dielec =0.1;
				specColor = lerp (float3(dielec,dielec,dielec), albedo, metallic);
				oneMinusReflectivity = OneMinusReflectivityFromMetallic(metallic,dielec);
				return albedo * oneMinusReflectivity;
			}
			inline	half GetRoughness (float roughnessIn) 
			{
				half roughness = roughnessIn;			// MM: switched to this
				roughness = roughness*(1.7 - 0.7*roughness);
				return roughness;
			}

			ENDCG
		} 
	}

	SubShader {
		Tags {"RenderType"="TransparentCutoutAK" "QUEUE"="AlphaTest"  }
		LOD 10
		Pass {
			Tags { 
			"RenderType"="TransparentCutoutAK" 
			"LightMode"="ShadowCaster" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _Cutoff;
			struct v2f{
				V2F_SHADOW_CASTER;
				float2 uv:TEXCOORD2;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.uv = v.texcoord.xy;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
				return o;
			}

			float4 frag( v2f i ) : SV_Target
			{
				fixed alpha = tex2D(_MainTex, i.uv).a;
				clip(alpha -_Cutoff);
				SHADOW_CASTER_FRAGMENT(i)
			}

			ENDCG
		}

		Pass {  
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutoff;
			float4 _DLightColor;
			float _DLightIntensity;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 clr = tex2D(_MainTex, i.texcoord);
				clip(clr.a - _Cutoff);
				clr.rgb = clr.rgb*_DLightColor.rgb*_DLightIntensity;
				UNITY_APPLY_FOG(i.fogCoord, clr.rgb);

				return clr;
			}
		ENDCG
		}
	}

	Fallback "Diffuse"  
}
