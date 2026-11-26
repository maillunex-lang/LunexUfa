// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

Shader "SG_Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_DarkenDegree("***Do not edit***", Float) = 1
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

#pragma multi_compile _FOG_OFF  _FOG_ON
#pragma multi_compile LIGHTMAP_OFF  LIGHTMAP_ON

//#pragma surface surf Lambert

sampler2D _MainTex;
fixed4 _Color;
fixed  _DarkenDegree;
half4 _LightColor0;


struct Input {
	float2 uv_MainTex;
	float3 worldNormal;
};


#include "UnityCG.cginc"
#ifdef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float4 uv : TEXCOORD0;
  fixed3 worldNormal : TEXCOORD1;
  
  #ifdef  _FOG_ON
  half2 fogdensity : TEXCOORD3;
  #endif
  fixed3 vlight : TEXCOORD4;
};
#endif

#ifndef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float4 uv : TEXCOORD0;

  fixed3 worldNormal : TEXCOORD1;

  
  #ifdef  _FOG_ON
  half2 fogdensity : TEXCOORD3;
  #endif
};
#endif

#ifndef LIGHTMAP_OFF
// float4 unity_LightmapST;
// sampler2D unity_Lightmap;
#endif

#ifdef  _FOG_ON
float4 _FogParam; //float2(0.0, 10.0)
fixed4 _HeightFogColor; //fixed3(0.3,0.2,0.1)
fixed4 _DistanceFogColor; //fixed3(0.3,0.2,0.1)
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
  
 
  #ifdef  _FOG_ON
  o.fogdensity.x = (worldPos.y - _FogParam.y) / (_FogParam.x - _FogParam.y);
  o.fogdensity.y = (o.pos.w - _FogParam.w) / (_FogParam.z - _FogParam.w);
  #endif
  return o;
}



// fragment shader
fixed4 frag_surf (v2f_surf IN) : COLOR{

	
  fixed4 c = 0;

	half3 N = normalize(IN.worldNormal);

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
  

  
	fixed4 tex = tex2D(_MainTex, IN.uv.xy)*_Color;
	c.rgb *= tex.rgb;
	
 
  
	#ifdef  _FOG_ON

	float tmpS = IN.fogdensity.y;
	c.rgb = lerp(_DistanceFogColor.rgb,c.rgb,max(0,min(1.0, tmpS)));

	tmpS = IN.fogdensity.x;
	c.rgb = lerp(_HeightFogColor.rgb,c.rgb,max(0,min(1.0, tmpS)));
	
	//c.rgb = lerp(_DistanceFogColor.rgb,c.rgb,1);//saturate(IN.fogdensity.y));
	//c.rgb = lerp(_HeightFogColor.rgb,c.rgb,1);//saturate(IN.fogdensity.x));
	
	#endif



  return c;
}

ENDCG
}
}

Fallback "VertexLit"
}
