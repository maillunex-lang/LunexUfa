// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "DZSMobile/CharacterColor" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	//_DiffuseWarpTex ("DiffuseWarp (RGB)", 2D) = "white" {}
	[Toggle] _Specular ("Specular?", Float) = 0
	fSpecularScale ("Specular Scale", float) = 1
	fSpecularExponent ("Specular Exponent", float) = 16
	_SpecTex ("Specular Map", 2D) = "white" {}
	[Toggle] _SelfIllu ("Self Illumination?", Float) = 0
	_SelfIlluTex ("Self Illumination Map", 2D) = "white" {}
	
//	[Toggle] _RimLight ("Rim Light?", Float) = 0
//	fRimLightColor ("Rim Light Color", Color) = (1, 1, 1, 1)
//	_RimLightParam ("Rim Size(X) Rim Smoothness(Y) Rim Intensity(Z)", Vector) = (0.5, 0.5, 0.5, 0.5)  // x:size  y : smoothness z:shadow w:intensity
//	_RimMaskTex ("Rim Mask Map", 2D) = "white" {}
	
	[Toggle] _RimLightRamp ("Rim Light Ramp?", Float) = 0
	fRimLightRampColor ("Rim Light Color", Color) = (1, 1, 1, 1)
	fRimLightScale ("Rim Light Scale", float) = 1
	_RimRampTex ("Rim Ramp Map", 2D) = "white" {}
	_RimMaskRampTex ("Rim Mask Map", 2D) = "white" {}
	_BobyColor ("Main Color", Color) = (1, 1, 1, 1)


}


// hight quality
SubShader {
	Tags {
		"Queue" = "Transparent"
		"RenderType"="Transparent" 
		"LightMode"="ForwardBase"
	  }

	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off

	CGINCLUDE
	#include "UnityCG.cginc"
	ENDCG	

	Pass {
		Name "ForwardBase"

		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest	
		#pragma target 2.0
		
		#pragma multi_compile _SPECULAR_OFF  _SPECULAR_ON
		#pragma multi_compile _SELFILLU_OFF  _SELFILLU_ON
//		#pragma multi_compile _RIMLIGHT_OFF  _RIMLIGHT_ON
		#pragma multi_compile _RIMLIGHTRAMP_OFF  _RIMLIGHTRAMP_ON
		#pragma multi_compile _FOG_OFF  _FOG_ON

	
		//uniform half4 _LightColor0;
		uniform sampler2D _MainTex;
		//uniform sampler2D _DiffuseWarpTex;
		#ifdef _SPECULAR_ON
		half fSpecularExponent;
		half fSpecularScale;
		sampler2D _SpecTex;
		#endif
		
		#ifdef _SELFILLU_ON
		sampler2D _SelfIlluTex;
		#endif
		
//		#ifdef _RIMLIGHT_ON
//		half4 fRimLightColor; 
//		half4 _RimLightParam; 
//		sampler2D _RimMaskTex; 
//		#endif
		
		#ifdef _RIMLIGHTRAMP_ON
		half4 fRimLightRampColor; 
		half fRimLightScale;
		sampler2D _RimRampTex; 
		sampler2D _RimMaskRampTex; 
		#endif

		#ifdef  _FOG_ON
		float4 _FogParam; 
		fixed4 _HeightFogColor; 
		fixed4 _DistanceFogColor; 
		#endif
		
//		#define LINEARCOLORSPACE

		fixed4 _BobyColor;

		struct VertexInput {
	        float4 vertex : POSITION;
	        float3 normal : NORMAL;
	        float4 texcoord : TEXCOORD0;
	    };
	    struct VertexOutput {
	        float4 pos : SV_POSITION;
	        float2 uv : TEXCOORD0;
			float3 worldNormal : TEXCOORD1;
//			#if _SPECULAR_ON || _RIMLIGHT_ON ||_RIMLIGHTRAMP_ON
			#if _SPECULAR_ON  ||_RIMLIGHTRAMP_ON
			float3 viewVec : TEXCOORD2;
			#endif
			#ifdef  _FOG_ON
			half2 fogdensity : TEXCOORD3;
			#endif
	    };


	    VertexOutput vert (VertexInput v)
		{
			VertexOutput o = (VertexOutput)0;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
//			#if _SPECULAR_ON || _RIMLIGHT_ON ||_RIMLIGHTRAMP_ON
			#if _SPECULAR_ON  ||_RIMLIGHTRAMP_ON
			o.viewVec =  normalize( WorldSpaceViewDir(v.vertex));
			#endif
			o.uv = v.texcoord.xy;

			#ifdef  _FOG_ON
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			o.fogdensity.x = (worldPos.y - _FogParam.y) / (_FogParam.x - _FogParam.y);
			o.fogdensity.y = (o.pos.w - _FogParam.w) / (_FogParam.z - _FogParam.w);
			#endif

			return o;
		}

		fixed4 frag (VertexOutput i) : COLOR
		{
			float3 N = i.worldNormal;
			
			float3 mainTexColor = tex2D(_MainTex, i.uv);
			#ifdef LINEARCOLORSPACE
			mainTexColor = pow(mainTexColor, 2.2f);
			#endif
			
			// Do lighting ...   _LightColor0;
			//float3 L = normalize(_WorldSpaceLightPos0.xyz);
			//float NdotL = dot(N,L);
			//float halfLambert = NdotL * 0.5 + 0.5;
			//float3 diffuseLight = tex2D(_DiffuseWarpTex,float2(halfLambert,0.25f));
			//diffuseLight *= _LightColor0.rgb;
			float3 diffuseLight = float3(1, 1, 1);

			#if _SPECULAR_ON  ||_RIMLIGHTRAMP_ON
			float3 V = normalize(i.viewVec);
			#endif
			
//			#ifdef _RIMLIGHTRAMP_ON
//			float VdotN = saturate( dot( V, N ) );
//			
//			float3 FresnelTerm = tex2D( _RimRampTex, float2( VdotN, 0.5f )).rgb;
//			float3 flRimMask = tex2D( _RimMaskRampTex, i.uv );
//			float3 rimLighting = (FresnelTerm * fRimLightScale) * flRimMask; 
//			rimLighting *= saturate(dot(N, float3( 0.0, 1.0, 0.0 ))); 
//			rimLighting *= fRimLightRampColor;
//			diffuseLight += rimLighting;
//			#endif
			
			
			#ifdef   _SPECULAR_ON
//			float3 R = reflect( V, N ); 
//			float RdotL = saturate( dot( L, -R ) );
			//float3 H = normalize(V + L);
			float3 H = normalize(V);

			float tmpS = dot( H, N);
			float HdotN = max(0,min(1.0, tmpS));
			//float HdotN = 1;//saturate( dot( H, N));
			float3 specColor = tex2D(_SpecTex, i.uv);
			specColor *= pow(HdotN,fSpecularExponent);
			//specColor *= _LightColor0.rgb * fSpecularScale;
			specColor *= fSpecularScale;
			diffuseLight += specColor;
			
			#endif
			
			float3 final = mainTexColor * diffuseLight;
			

			
			
//			#ifdef   _SPECULAR_ON
////			float3 R = reflect( V, N ); 
////			float RdotL = saturate( dot( L, -R ) );
//			float3 H = normalize(V + L);
//			float HdotN = saturate( dot( H, N));
//			float3 specColor = tex2D(_SpecTex, i.uv);
//			specColor *= pow(HdotN,fSpecularExponent);
//			specColor *= _LightColor0.rgb * fSpecularScale;
//			final += specColor;
//			
//			#endif
			
			#ifdef _SELFILLU_ON
			final +=tex2D(_SelfIlluTex, i.uv); 
			#endif
			
			
//			#ifdef _RIMLIGHT_ON
//			float rim = -0.2  -  abs(dot(N, V)) + _RimLightParam.x;
//			rim  = rim/max(0.05, _RimLightParam.y) + 0.5;
//			rim = clamp(rim , 0.0, 1.0);
//			rim *= saturate(dot(N, float3( 0.0, 1.0, 0.0 ))); 			
//			half4 rimMask = tex2D( _RimMaskTex, i.uv );
//			final += rim * rimMask.rgb * fRimLightColor * _RimLightParam.z;
//			#endif
			
			#ifdef _RIMLIGHTRAMP_ON
			float tmpS1 = dot( V, N);
			float VdotN = max(0,min(1.0, tmpS1));
			//float VdotN = 1;//saturate( dot( V, N ) );
			
			float3 FresnelTerm = tex2D( _RimRampTex, float2( VdotN, 0.5f )).rgb;
			//return fixed4(FresnelTerm,1.0);
			float3 flRimMask = tex2D( _RimMaskRampTex, i.uv );
			float3 rimLighting = (FresnelTerm * fRimLightScale) * flRimMask; 
			float tmpS2 = dot(N, float3( 0.0, 1.0, 0.0 ));
			rimLighting *= max(0,min(1.0, tmpS2));   
			//rimLighting *= 1;//saturate(dot(N, float3( 0.0, 1.0, 0.0 ))); 
			rimLighting *= fRimLightRampColor;
			final += rimLighting;
			#endif

			final *= _BobyColor;
			
			#ifdef  _FOG_ON
			float tmpS3 = i.fogdensity.x;
			final.rgb = lerp(_HeightFogColor.rgb,final.rgb,max(0,min(1.0, tmpS3)));
			//final.rgb = lerp(_HeightFogColor.rgb,final.rgb,1);//saturate(i.fogdensity.x));

			float tmpS4 = i.fogdensity.y;
			final.rgb = lerp(_DistanceFogColor.rgb,final.rgb,max(0,min(1.0, tmpS4)));
			//final.rgb = lerp(_DistanceFogColor.rgb,final.rgb,1);//saturate(i.fogdensity.y));
			#endif

			#ifdef LINEARCOLORSPACE
			return fixed4(pow(final, 0.4545f),_BobyColor.a);
			#else
			return fixed4(final,_BobyColor.a);
			#endif
			
			
		}
		ENDCG 
	}
	 // x:size  y : smoothness z:shadow w:intensity
}

}





