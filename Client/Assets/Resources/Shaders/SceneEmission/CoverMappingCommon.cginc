// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

#ifndef COVERMAPPING_COMMON_CG_INCLUDE
#define COVERMAPPING_COMMON_CG_INCLUDE

// ------------------------------------------------------------------
//  CoverMapping helpers
//
//	multi_compile_fog Will compile fog variants.
//	CurrentZ_COVERMAPPING_COORDS(texcoordindex) Declares the CoverMapping data interpolator.
//	CurrentZ_COVERMAPPING_VERTEX(outputStruct,clipspacePos) Outputs CoverMapping data from the vertex shader.
//	CurrentZ_COVERMAPPING_FRAGMENT(fogData,col) Applies CoverMapping to color "col". Automatically applies black CoverMapping when in forward-additive pass.

uniform sampler2D _GlobalCoverMappingTex;
uniform float4 _GlobalCoverMappingRect;

#define CurrentZ_COVERMAPPING_COORDS_PACKED(idx, vectype) vectype coverMapUV : TEXCOORD##idx;

#if defined(CurrentZ_COVERMAPPING)
	#define CurrentZ_COVERMAPPING_COORDS(idx) CurrentZ_COVERMAPPING_COORDS_PACKED(idx, float2)
    #define CurrentZ_COVERMAPPING_VERTEX(o) o.coverMapUV = (mul(unity_ObjectToWorld, v.vertex).xz - _GlobalCoverMappingRect.xy)/_GlobalCoverMappingRect.zw;
#else
	#define CurrentZ_COVERMAPPING_COORDS(idx)
	#define CurrentZ_COVERMAPPING_VERTEX(o)
#endif

#if defined(CurrentZ_COVERMAPPING)
	#define CurrentZ_APPLY_COVERMAPPING_COLOR(i, col) col = tex2D(_GlobalCoverMappingTex, i.coverMapUV)
#else
	#define CurrentZ_APPLY_COVERMAPPING_COLOR(i, col)
#endif

#ifdef UNITY_PASS_FORWARDADD
	#define CurrentZ_COVERMAPPING_FRAGMENT(i, col) CurrentZ_APPLY_COVERMAPPING_COLOR(i, col)
#else
	#define CurrentZ_COVERMAPPING_FRAGMENT(i, col) CurrentZ_APPLY_COVERMAPPING_COLOR(i, col)
#endif

#endif //COVERMAPPING_COMMON_CG_INCLUDE