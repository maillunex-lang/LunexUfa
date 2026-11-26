// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Distort Effect" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_DistortTex("",2D) = "black"{}
}

SubShader {
	Pass {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }
				
CGPROGRAM
#pragma vertex vert_img_AA
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest 
#pragma multi_compile DISTORT_ON DISTORT_OFF
#include "UnityCG.cginc"

uniform sampler2D _MainTex;
uniform sampler2D _DistortTex;
uniform half4 _MainTex_TexelSize;

struct v2f_simple 
		{
			float4 pos : SV_POSITION; 
			half2 uv : TEXCOORD0;

        #if UNITY_UV_STARTS_AT_TOP
				half2 uv2 : TEXCOORD1;
		#endif
		};

v2f_simple vert_img_AA( appdata_img v )
{
	v2f_simple o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = v.texcoord;		
        	
    #if UNITY_UV_STARTS_AT_TOP
    	o.uv2 = v.texcoord;				
    	if (_MainTex_TexelSize.y < 0.0)
    		o.uv.y = 1.0 - o.uv.y;
    #endif
	return o;
}

fixed4 frag (v2f_simple i) : COLOR
{	
#ifdef DISTORT_ON
	#if UNITY_UV_STARTS_AT_TOP
			
	fixed4 distort = tex2D (_DistortTex, i.uv);
	fixed4 original = tex2D(_MainTex, i.uv2 + distort.xy*0.1);
	
	#else

	fixed4 distort = tex2D (_DistortTex, i.uv);
	fixed4 original = tex2D(_MainTex, i.uv + distort.xy*0.1);
				
	#endif
#endif

#ifdef DISTORT_OFF
	#if UNITY_UV_STARTS_AT_TOP
	fixed4 original = tex2D(_MainTex, i.uv2);
	#else
	fixed4 original = tex2D(_MainTex, i.uv);			
	#endif
#endif
	
	
//	fixed Y = dot (fixed3(0.299, 0.587, 0.114), original.rgb);
//
//	// Convert to Sepia Tone by adding constant
//	fixed4 sepiaConvert = float4 (0.191, -0.054, -0.221, 0.0);
//	fixed4 output = sepiaConvert + Y;
//	output.a = original.a;
	
	return original;
}
ENDCG

	}
}

Fallback off

}