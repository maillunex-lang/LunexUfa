// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_LightmapInd', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER


Shader "Mobile/Dzs Specular" {
Properties {
	_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_MaskTex ("Maskmap", 2D) = "white" {}
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
#pragma multi_compile_fwdbase nodirlightmap
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
#pragma multi_compile _FOG_OFF  _FOG_ON
#pragma target 3.0

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 10 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

//#pragma surface surf DzsMobileSpecular exclude_path:prepass halfasview

struct DzsSpecularOutput {
	fixed3 Albedo;
	fixed3 SpecularMask;
	fixed3 Normal;
	fixed3 WorldNormal;
	fixed3 Emission;
	half Specular;
	fixed Alpha;
};

inline fixed4 LightingDzsMobileSpecular (DzsSpecularOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
{
	fixed diff = max (0, dot (s.WorldNormal, lightDir));
	fixed nh = max (0, dot (s.WorldNormal, halfDir));
	fixed spec = pow (nh, s.Specular*128);
	
	fixed4 c;
	c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * s.SpecularMask.rgb) * (atten*2);
	c.a = 0.0;
	return c;
}

inline fixed4 LightingDzsMobileOnlySpecular (DzsSpecularOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
{
	fixed nh = max (0, dot (s.WorldNormal, halfDir));
	fixed spec = pow (nh, s.Specular*128);
	
	fixed4 c;
	c.rgb = (_LightColor0.rgb * spec * s.SpecularMask.rgb) * (atten*2);
	c.a = 0.0;
	return c;
}

sampler2D _MainTex;
sampler2D _MaskTex;
half _Shininess;

struct Input {
	float2 uv_MainTex;
	float3 worldNormal;
};

void surf (Input IN, inout DzsSpecularOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb;
	tex = tex2D(_MaskTex, IN.uv_MainTex);
	o.SpecularMask = tex.rgb;
	o.Alpha = tex.a;
	o.Specular = _Shininess;
	o.WorldNormal = IN.worldNormal;
}


// vertex-to-fragment interpolation data
#ifdef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  fixed3 worldNormal : TEXCOORD1;
  fixed3 normal : TEXCOORD2;
  fixed3 vlight : TEXCOORD3;
  fixed3 viewDir : TEXCOORD4;
  LIGHTING_COORDS(5,6)
  #ifdef  _FOG_ON
  float2 fogdensity : TEXCOORD8;
  #endif
};
#endif
#ifndef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  fixed3 worldNormal : TEXCOORD1;
  float2 lmap : TEXCOORD2;
  fixed3 normal : TEXCOORD3;
  fixed3 vlight : TEXCOORD4;
  fixed3 viewDir : TEXCOORD5;
  LIGHTING_COORDS(6,7)
  #ifdef  _FOG_ON
  float2 fogdensity : TEXCOORD8;
  #endif
};
#endif
#ifndef LIGHTMAP_OFF
// float4 unity_LightmapST;
#endif
float4 _MainTex_ST;
#ifdef  _FOG_ON
float4 _FogParam; //float2(0.0, 10.0)
fixed4 _HeightFogColor; //fixed3(0.3,0.2,0.1)
fixed4 _DistanceFogColor; //fixed3(0.3,0.2,0.1)
#endif

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  v2f_surf o;
  o.pos = UnityObjectToClipPos (v.vertex);
  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
  o.worldNormal = mul ((float3x3)unity_ObjectToWorld, v.normal);
  #ifndef LIGHTMAP_OFF
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #endif
  float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
  o.normal = worldN;
  float3 viewDirForLight = WorldSpaceViewDir( v.vertex );
  o.viewDir = normalize (_WorldSpaceLightPos0.xyz + normalize(viewDirForLight));

  // SH/ambient and vertex lights
  float3 shlight = ShadeSH9 (float4(worldN,1.0));
  o.vlight = shlight;
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  #ifdef VERTEXLIGHT_ON
  
  o.vlight += Shade4PointLights (
    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
    unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
    unity_4LightAtten0, worldPos, worldN );
  #endif // VERTEXLIGHT_ON
  #ifdef  _FOG_ON
  o.fogdensity.x = (worldPos.y - _FogParam.y) / (_FogParam.x - _FogParam.y);
  o.fogdensity.y = (o.pos.w - _FogParam.w) / (_FogParam.z - _FogParam.w);
  #endif

  // pass lighting information to pixel shader
  TRANSFER_VERTEX_TO_FRAGMENT(o);
  return o;
}
#ifndef LIGHTMAP_OFF
// sampler2D unity_Lightmap;
#ifndef DIRLIGHTMAP_OFF
// sampler2D unity_LightmapInd;
#endif
#endif

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  // prepare and unpack data
  #ifdef UNITY_COMPILER_HLSL
  Input surfIN = (Input)0;
  #else
  Input surfIN;
  #endif
  surfIN.uv_MainTex = IN.pack0.xy;
  surfIN.worldNormal = IN.worldNormal;
  #ifdef UNITY_COMPILER_HLSL
  DzsSpecularOutput o = (DzsSpecularOutput)0;
  #else
  DzsSpecularOutput o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Specular = 0.0;
  o.Alpha = 0.0;
  o.Normal = IN.normal;

  //return fixed4(IN.fogdensity.xxx,1.0f);

  // call surface function
  surf (surfIN, o);

  // compute lighting & shadowing factor
  fixed atten = LIGHT_ATTENUATION(IN);
  fixed4 c = 0;

  // realtime lighting: call lighting function
  #ifdef LIGHTMAP_OFF
  c = LightingDzsMobileSpecular (o, _WorldSpaceLightPos0.xyz, IN.viewDir, atten);
  c.rgb += o.Albedo * IN.vlight;
  #else
  c = LightingDzsMobileOnlySpecular (o, _WorldSpaceLightPos0.xyz, IN.viewDir, atten);
  #endif // LIGHTMAP_OFF

  // lightmaps:
  #ifndef LIGHTMAP_OFF
    #ifndef DIRLIGHTMAP_OFF
      // directional lightmaps
      fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
      fixed4 lmIndTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap, IN.lmap.xy);
      half3 lm = LightingLambert_DirLightmap(o, lmtex, lmIndTex, 0).rgb;
    #else // !DIRLIGHTMAP_OFF
      // single lightmap
      fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
      fixed3 lm = DecodeLightmap (lmtex);
    #endif // !DIRLIGHTMAP_OFF

    // combine lightmaps with realtime shadows
    #ifdef SHADOWS_SCREEN
      #if (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3)) && defined(SHADER_API_MOBILE)
      c.rgb += o.Albedo * min(lm, atten*2);
      #else
      c.rgb += o.Albedo * max(min(lm,(atten*2)*lmtex.rgb), lm*atten);
      #endif
    #else // SHADOWS_SCREEN
      c.rgb += o.Albedo * lm;
    #endif // SHADOWS_SCREEN
	#ifdef  _FOG_ON
	//c.rgb = lerp(c.rgb,_HeightFogColor.rgb,saturate(IN.fogdensity.x));

	float tmpS = IN.fogdensity.x;
	c.rgb = lerp(_HeightFogColor.rgb,c.rgb,max(0,min(1.0, tmpS)));
	//c.rgb = lerp(_HeightFogColor.rgb,c.rgb,1);//saturate(IN.fogdensity.x));

	float tmpS1 = IN.fogdensity.y;
	c.rgb = lerp(_DistanceFogColor.rgb,c.rgb,max(0,min(1.0, tmpS1)));
	//c.rgb = lerp(_DistanceFogColor.rgb,c.rgb,1)//saturate(IN.fogdensity.y));
	#endif
  c.a = o.Alpha;
  #endif // LIGHTMAP_OFF

  return c;
}

ENDCG

}

	// ---- forward rendering additive lights pass:
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_fwdadd nodirlightmap
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
#define UNITY_PASS_FORWARDADD
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 10 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

//#pragma surface surf DzsMobileSpecular exclude_path:prepass halfasview

struct DzsSpecularOutput {
	fixed3 Albedo;
	fixed3 SpecularMask;
	fixed3 Normal;
	fixed3 WorldNormal;
	fixed3 Emission;
	half Specular;
	fixed Alpha;
};

inline fixed4 LightingDzsMobileSpecular (DzsSpecularOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
{
	fixed diff = max (0, dot (s.WorldNormal, lightDir));
	fixed nh = max (0, dot (s.WorldNormal, halfDir));
	fixed spec = pow (nh, s.Specular*128);
	
	fixed4 c;
	c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * s.SpecularMask.rgb) * (atten*2);
	c.a = 0.0;
	return c;
}

inline fixed4 LightingDzsMobileOnlySpecular (DzsSpecularOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
{
	fixed nh = max (0, dot (s.WorldNormal, halfDir));
	fixed spec = pow (nh, s.Specular*128);
	
	fixed4 c;
	c.rgb = (_LightColor0.rgb * spec * s.SpecularMask.rgb) * (atten*2);
	c.a = 0.0;
	return c;
}

sampler2D _MainTex;
sampler2D _MaskTex;
half _Shininess;

struct Input {
	float2 uv_MainTex;
	float3 worldNormal;
};

void surf (Input IN, inout DzsSpecularOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb;
	tex = tex2D(_MaskTex, IN.uv_MainTex);
	o.SpecularMask = tex.rgb;
	o.Alpha = tex.a;
	o.Specular = _Shininess;
	o.WorldNormal = IN.worldNormal;
}


// vertex-to-fragment interpolation data
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  fixed3 worldNormal : TEXCOORD1;
  fixed3 normal : TEXCOORD2;
  half3 lightDir : TEXCOORD3;
  half3 viewDir : TEXCOORD4;
  LIGHTING_COORDS(5,6)
};
float4 _MainTex_ST;

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  v2f_surf o;
  o.pos = UnityObjectToClipPos (v.vertex);
  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
  o.worldNormal = mul ((float3x3)unity_ObjectToWorld, v.normal);
  o.normal = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
  float3 lightDir = WorldSpaceLightDir( v.vertex );
  o.lightDir = lightDir;
  float3 viewDirForLight = WorldSpaceViewDir( v.vertex );
  o.viewDir = normalize (normalize(lightDir) + normalize(viewDirForLight));

  // pass lighting information to pixel shader
  TRANSFER_VERTEX_TO_FRAGMENT(o);
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  // prepare and unpack data
  #ifdef UNITY_COMPILER_HLSL
  Input surfIN = (Input)0;
  #else
  Input surfIN;
  #endif
  surfIN.uv_MainTex = IN.pack0.xy;
  surfIN.worldNormal = IN.worldNormal;
  #ifdef UNITY_COMPILER_HLSL
  DzsSpecularOutput o = (DzsSpecularOutput)0;
  #else
  DzsSpecularOutput o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Specular = 0.0;
  o.Alpha = 0.0;
  o.Normal = IN.normal;

  // call surface function
  surf (surfIN, o);
  #ifndef USING_DIRECTIONAL_LIGHT
  fixed3 lightDir = normalize(IN.lightDir);
  #else
  fixed3 lightDir = IN.lightDir;
  #endif
  #ifdef LIGHTMAP_OFF
  fixed4 c = LightingDzsMobileSpecular (o, lightDir, IN.viewDir, LIGHT_ATTENUATION(IN));
  #else
  fixed4 c = LightingDzsMobileOnlySpecular (o, lightDir, IN.viewDir, LIGHT_ATTENUATION(IN));
  #endif // LIGHTMAP_OFF
  c.a = 0.0;
  return c;
}

ENDCG

}

#LINE 57

}

FallBack "Mobile/VertexLit"
}
