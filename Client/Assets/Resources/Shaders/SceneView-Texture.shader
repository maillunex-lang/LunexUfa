// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Hidden/Scene View Show Texture" {
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
	sampler2D _MainTex;

	struct Input {
		float2 uv_MainTex;
		float3 worldNormal;
	};

	struct v2f_surf {
	  float4 pos : SV_POSITION;
	  float4 uv : TEXCOORD0;

	};


	// vertex shader
	v2f_surf vert_surf (appdata_full v) {
	  v2f_surf o;
	  o.pos = UnityObjectToClipPos (v.vertex);
		o.uv.xy = v.texcoord.xy;
	  return o;
	}
	// fragment shader
	fixed4 frag_surf (v2f_surf IN) : SV_Target {

		fixed4 tex = tex2D(_MainTex, IN.uv.xy);
		return tex;
  
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


	#include "UnityCG.cginc"
	
	sampler2D _MainTex;

	fixed _Cutoff;

	struct Input {
		float2 uv_MainTex;
		float3 worldNormal;
	};


	struct v2f_surf {
	  float4 pos : SV_POSITION;
	 float4 uv : TEXCOORD0;
	};

	

	// vertex shader
	v2f_surf vert_surf (appdata_full v) {
	  v2f_surf o;
	  o.pos = UnityObjectToClipPos (v.vertex);
	  o.uv.xy = v.texcoord.xy;
  
	  return o;
	}


	// fragment shader
	fixed4 frag_surf (v2f_surf IN) : SV_Target {

	
	  fixed4 c = 0;

	 fixed4 tex = tex2D(_MainTex, IN.uv.xy);
	clip(tex.a - _Cutoff);

	  return tex;
  
	}
	ENDCG
	}
	}

FallBack "Mobile/VertexLit"
}
