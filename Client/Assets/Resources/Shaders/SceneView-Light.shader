// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D


Shader "Hidden/Scene View Show Light" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader { 
		Tags { "RenderType"="Opaque" }
		LOD 250
	
		// ---- forward rendering base pass:
		Pass {
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Fog { Mode Off }
	CGPROGRAM
	// compile directives
	#pragma vertex vert_surf
	#pragma fragment frag_surf

	#pragma multi_compile LIGHTMAP_OFF  LIGHTMAP_ON

	#include "UnityCG.cginc"
	half4 _LightColor0;
	struct Input {
		float2 uv_MainTex;
		float3 worldNormal;
	};


	// vertex-to-fragment interpolation data
	#ifdef LIGHTMAP_OFF
	struct v2f_surf {
	  float4 pos : SV_POSITION;
	  float4 uv : TEXCOORD0;
	  fixed3 worldNormal : TEXCOORD1;
	  fixed3 vlight : TEXCOORD4;
	};
	#endif

	#ifndef LIGHTMAP_OFF
	struct v2f_surf {
	  float4 pos : SV_POSITION;
	 float4 uv : TEXCOORD0;
	  fixed3 worldNormal : TEXCOORD1;
	};
	#endif

	#ifndef LIGHTMAP_OFF
	// float4 unity_LightmapST;
	// sampler2D unity_Lightmap;
	#endif


	// vertex shader
	v2f_surf vert_surf (appdata_full v) {
	  v2f_surf o;
	  o.pos = UnityObjectToClipPos (v.vertex);
		o.worldNormal = mul ((float3x3)unity_ObjectToWorld, v.normal);

	  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
	  #ifndef LIGHTMAP_OFF
	  o.uv.zw = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	  #endif
  
  
	  #ifdef LIGHTMAP_OFF
	  float3 shlight = ShadeSH9 (float4(o.worldNormal,1.0));
	  o.vlight = shlight;
	   #ifdef VERTEXLIGHT_ON
	  o.vlight += Shade4PointLights (
		unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
		unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
		unity_4LightAtten0, worldPos, worldN );
	  #endif // VERTEXLIGHT_ON
	  #endif
  
	  return o;
	}


	// fragment shader
	fixed4 frag_surf (v2f_surf IN) : SV_Target {

	
	  fixed4 c = 0;
	 #if  LIGHTMAP_OFF || _SPECULAR_ON	
		half3 N = normalize(IN.worldNormal);
	
	 #endif
	  #ifdef LIGHTMAP_OFF
		float3 lightDir = _WorldSpaceLightPos0.xyz;
		fixed diff = max(0, dot(N, lightDir));	
		c.rgb += _LightColor0.rgb*diff*2.0;
		c.rgb +=  IN.vlight;
	
	  #else
		fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap,IN.uv.zw);
		fixed3 lm = DecodeLightmap(lmtex);
		c.rgb += lm;
	  #endif // LIGHTMAP_OFF
	  return fixed4(c.rgb*0.5,1.0f);
  
	}
	ENDCG
	}
	}



	SubShader { 
		Tags { "RenderType"="TransparentCutout" }
		LOD 250
	
		// ---- forward rendering base pass:
		Pass {
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			Fog { Mode Off }
	CGPROGRAM
	// compile directives
	#pragma vertex vert_surf
	#pragma fragment frag_surf

	#pragma multi_compile LIGHTMAP_OFF  LIGHTMAP_ON

	#include "UnityCG.cginc"
	half4 _LightColor0;
	sampler2D _MainTex;
	#ifndef LIGHTMAP_OFF
	// float4 unity_LightmapST;
	// sampler2D unity_Lightmap;
	#endif
	fixed _Cutoff;

	struct Input {
		float2 uv_MainTex;
		float3 worldNormal;
	};


	// vertex-to-fragment interpolation data
	#ifdef LIGHTMAP_OFF
	struct v2f_surf {
	  float4 pos : SV_POSITION;
	  float4 uv : TEXCOORD0;
	  fixed3 worldNormal : TEXCOORD1;
	  fixed3 vlight : TEXCOORD4;
	};
	#endif

	#ifndef LIGHTMAP_OFF
	struct v2f_surf {
	  float4 pos : SV_POSITION;
	 float4 uv : TEXCOORD0;
	  fixed3 worldNormal : TEXCOORD1;
	};
	#endif

	

	// vertex shader
	v2f_surf vert_surf (appdata_full v) {
	  v2f_surf o;
	  o.pos = UnityObjectToClipPos (v.vertex);
	  o.uv.xy = v.texcoord.xy;
		o.worldNormal = mul ((float3x3)unity_ObjectToWorld, v.normal);

	  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
	  #ifndef LIGHTMAP_OFF
	  o.uv.zw = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	  #endif
  
  
	  #ifdef LIGHTMAP_OFF
	  float3 shlight = ShadeSH9 (float4(o.worldNormal,1.0));
	  o.vlight = shlight;
	   #ifdef VERTEXLIGHT_ON
	  o.vlight += Shade4PointLights (
		unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
		unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
		unity_4LightAtten0, worldPos, worldN );
	  #endif // VERTEXLIGHT_ON
	  #endif
  
	  return o;
	}


	// fragment shader
	fixed4 frag_surf (v2f_surf IN) : SV_Target {

	
	  fixed4 c = 0;
	 #if  LIGHTMAP_OFF || _SPECULAR_ON	
		half3 N = normalize(IN.worldNormal);
	
	 #endif
	  #ifdef LIGHTMAP_OFF
		float3 lightDir = _WorldSpaceLightPos0.xyz;
		fixed diff = max(0, dot(N, lightDir));	
		c.rgb += _LightColor0.rgb*diff*2.0;
		c.rgb +=  IN.vlight;
	
	  #else
		fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap,IN.uv.zw);
		fixed3 lm = DecodeLightmap(lmtex);
		c.rgb += lm;
	  #endif // LIGHTMAP_OFF

	 fixed4 tex = tex2D(_MainTex, IN.uv.xy);
	clip(tex.a - _Cutoff);

	  return fixed4(c.rgb*0.5,1.0f);
  
	}
	ENDCG
	}
	}

FallBack "Mobile/VertexLit"
}
