// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// - Unlit
// - Per-vertex (virtual) camera space specular light
// - SUPPORTS lightmap

Shader "DZSMobile/TransCharacter" {
Properties {
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "black" {}
	[Toggle] _RimLightRamp ("Rim Light Ramp?", Float) = 0
	fRimLightRampColor ("Rim Light Color", Color) = (1, 1, 1, 1)
	fRimLightScale ("Rim Light Scale", float) = 1
	_RimRampTex ("Rim Ramp Map", 2D) = "white" {}
	_RimMaskRampTex ("Rim Mask Map", 2D) = "white" {}
	_Color ("Main Color", Color) = (1.0, 1.0, 1.0, 0.0)
}

SubShader {
	Tags {"Queue"="Transparent" "RenderType"="Geomerty" "LightMode"="ForwardBase" "IgnoreProjector"="True"}
	LOD 100
	
	Blend SrcAlpha OneMinusSrcAlpha
	Cull back 
	ZWrite On
	Fog { Mode Off }
	
	CGINCLUDE
	#include "UnityCG.cginc"
	#include "TerrainEngine.cginc"
	sampler2D _MainTex;
	float4 _MainTex_ST;
	samplerCUBE _ReflTex;
	half4 fRimLightRampColor; 
	half fRimLightScale;
	sampler2D _RimRampTex; 
	sampler2D _RimMaskRampTex; 
	fixed4 _Color;
	
	#ifndef LIGHTMAP_OFF
	// float4 unity_LightmapST;
	// sampler2D unity_Lightmap;
	#endif
	struct v2f {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		//float4 color : COLOR;
		float3 worldNormal : TEXCOORD1;
		//#ifdef _RIMLIGHTRAMP_ON
		float3 viewVec : TEXCOORD2;
		//#endif
		//fixed3 spec : TEXCOORD3;
	};

	
	v2f vert (appdata_full v)
	{
		v2f o;
		
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
		//o.spec = v.color;
		//o.color = v.color;
		//#ifndef _RIMLIGHTRAMP_ON
		o.viewVec=  normalize( WorldSpaceViewDir(v.vertex));
		//#endif
		return o;
	}
	ENDCG


	Pass {
		CGPROGRAM
		#pragma debug
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest	
		
		#pragma multi_compile _RIMLIGHTRAMP_OFF  _RIMLIGHTRAMP_ON
				
		fixed4 frag (v2f i) : COLOR
		{
			float3 N = i.worldNormal;
		
			fixed4 tex = tex2D (_MainTex, i.uv);
			
			fixed4 c;
			c.rgb = tex.rgb;
			c.a = tex.a;
			c.a *=_Color.a;
			
			
			#ifdef _RIMLIGHTRAMP_ON
			float3 V = normalize(i.viewVec);
			float VdotN = saturate( dot( V, N ) );
			//return fixed4(VdotN.xxx,1.0f);
			
			float3 FresnelTerm = tex2D( _RimRampTex, float2( VdotN, 0.5f )).rgb;
			float3 flRimMask = tex2D( _RimMaskRampTex, i.uv );
			float3 rimLighting = (FresnelTerm * fRimLightScale) * flRimMask; 
			//rimLighting *= saturate(dot(N, float3( 0.0, 1.0, 0.0 ))); 
			rimLighting *= fRimLightRampColor;
//			final += rimLighting;;
			c +=fixed4(rimLighting,0.0);
			#endif
			return c;
		}
		ENDCG 
	}
	
}
	//FallBack "Diffuse-Mami"
	//CustomEditor "EffectMaterialEd"	
}


