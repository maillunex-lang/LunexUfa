// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// ------------------------------------------------------------------
//  高度雾说明
//
//	0.编译相关的设置
//	1.CurrentZ_HEIGH_FOG_COORDS(texcoordindex) 在输入输出结构里面声明数据结构
//	2.CurrentZ_TRANSFER_HEIGH_FOG(outputStruct,clipspacePos) 在vertex shader中输出高度雾数据.
//	3.CurrentZ_APPLY_HEIGH_FOG(fogData,col) 把雾效计算结果合并到最终颜色中
//	4.也可以使用CurrentZ_APPLY_HEIGH_FOG_COLOR来计算自己的雾效颜色(暂不支持)

// 在 g-buffer or shadow passes中关闭雾效


// ----------------------------------------------------------------------------
fixed4 CurrentZ_HeighFogColor;
// x = density / sqrt(ln(2)), useful for Exp2 mode
// y = density / ln(2), useful for Exp mode
// z = -1/(end-start), useful for Linear mode
// w = end/(end-start), useful for Linear mode
float4 CurrentZ_HeighFogParams;

#ifndef UNITY_Z_0_FAR_FROM_CLIPSPACE
    #if defined(UNITY_REVERSED_Z)
		//D3d with reversed Z => z clip range is [near, 0] -> remapping to [0, far]
		//max is required to protect ourselves from near plane not being correct/meaningfull in case of oblique matrices.
        #define UNITY_Z_0_FAR_FROM_CLIPSPACE(coord) max(((1.0-(coord)/_ProjectionParams.y)*_ProjectionParams.z),0)
    #elif UNITY_UV_STARTS_AT_TOP
		//D3d without reversed z => z clip range is [0, far] -> nothing to do
        #define UNITY_Z_0_FAR_FROM_CLIPSPACE(coord) (coord)
    #else 
		//Opengl => z clip range is [-near, far] -> should remap in theory but dont do it in practice to save some perf (range is close enought)
        #define UNITY_Z_0_FAR_FROM_CLIPSPACE(coord) (coord)
    #endif
#endif //#ifndef UNITY_Z_0_FAR_FROM_CLIPSPACE(coord)

#define CurrentZ_HEIGH_FOG_COORDS_PACKED(idx, vectype) vectype heighFogCoord : TEXCOORD##idx;


//雾效计算方式
// factor = (end-z)/(end-start) = z * (-1/(end-start)) + (end/(end-start))
#define CurrentZ_CALC_HEIGH_FOG_FACTOR_RAW(coord1, coord2, o) float CurrentZ_HeighFogFactor1 = (coord1) * CurrentZ_HeighFogParams.z + CurrentZ_HeighFogParams.w; float CurrentZ_HeighFogFactor2 = (coord2) * CurrentZ_HeighFogParams.x + CurrentZ_HeighFogParams.y; o.heighFogCoord.x = CurrentZ_HeighFogFactor1;o.heighFogCoord.y = CurrentZ_HeighFogFactor2

#if defined(FOG_LINEAR)
	#define CurrentZ_HEIGH_FOG_COORDS(idx) CurrentZ_HEIGH_FOG_COORDS_PACKED(idx, float2)
    #define CurrentZ_TRANSFER_HEIGH_FOG(o) CurrentZ_CALC_HEIGH_FOG_FACTOR_RAW(o.posWorld.y, UNITY_Z_0_FAR_FROM_CLIPSPACE(o.pos.z),o);
#else
	#define CurrentZ_HEIGH_FOG_COORDS(idx)
	#define CurrentZ_TRANSFER_HEIGH_FOG(o)
#endif


#define CurrentZ_HEIGH_FOG_LERP_COLOR(col,heighFogCol,fogFac) col.rgba = lerp((heighFogCol).rgba, (col).rgba, saturate(fogFac))

#if defined(FOG_LINEAR)
	#define CurrentZ_APPLY_HEIGH_FOG_COLOR(coord,col,heighFogCol) float4 afterHeighFogCol = col; CurrentZ_HEIGH_FOG_LERP_COLOR(afterHeighFogCol, heighFogCol, (coord).x);CurrentZ_HEIGH_FOG_LERP_COLOR(col, afterHeighFogCol, (coord).y)
#else
	#define CurrentZ_APPLY_HEIGH_FOG_COLOR(coord,col,heighFogCol)
#endif

#ifdef UNITY_PASS_FORWARDADD
    #define CurrentZ_APPLY_HEIGH_FOG(coord,col) CurrentZ_APPLY_HEIGH_FOG_COLOR(coord.heighFogCoord,col,fixed4(0,0,0,0))
#else
	#define CurrentZ_APPLY_HEIGH_FOG(coord,col) CurrentZ_APPLY_HEIGH_FOG_COLOR(coord.heighFogCoord,col,CurrentZ_HeighFogColor * _GlobalBrightness)
#endif





#if defined(FOG_LINEAR)
    // factor = (end-z)/(end-start) = z * (-1/(end-start)) + (end/(end-start))
    #define Song_CALC_FOG_FACTOR_RAW(coord) float unityFogFactor = (coord) * unity_FogParams.z + unity_FogParams.w
#elif defined(FOG_EXP)
    // factor = exp(-density*z)
    #define Song_CALC_FOG_FACTOR_RAW(coord) float unityFogFactor = unity_FogParams.y * (coord); unityFogFactor = exp2(-unityFogFactor)
#elif defined(FOG_EXP2)
    // factor = exp(-(density*z)^2)
    #define Song_CALC_FOG_FACTOR_RAW(coord) float unityFogFactor = unity_FogParams.x * (coord); unityFogFactor = exp2(-unityFogFactor*unityFogFactor)
#else
    #define Song_CALC_FOG_FACTOR_RAW(coord) float unityFogFactor = 0.0
#endif

#define Song_CALC_FOG_FACTOR(coord) Song_CALC_FOG_FACTOR_RAW(UNITY_Z_0_FAR_FROM_CLIPSPACE(coord))

#define Song_FOG_COORDS_PACKED(idx, vectype) vectype fogCoord : TEXCOORD##idx;

#if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
    #define Song_FOG_COORDS(idx) Song_FOG_COORDS_PACKED(idx, float1)

    #if (SHADER_TARGET < 30) || defined(SHADER_API_MOBILE)
        // mobile or SM2.0: calculate fog factor per-vertex
        #define Song_TRANSFER_FOG(o,outpos) Song_CALC_FOG_FACTOR((outpos).z); o.fogCoord.x = unityFogFactor
        #define Song_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,outpos) Song_CALC_FOG_FACTOR((outpos).z); o.tSpace1.y = tangentSign; o.tSpace2.y = unityFogFactor
        #define Song_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,outpos) Song_CALC_FOG_FACTOR((outpos).z); o.worldPos.w = unityFogFactor
    #else
        // SM3.0 and PC/console: calculate fog distance per-vertex, and fog factor per-pixel
        #define Song_TRANSFER_FOG(o,outpos) o.fogCoord.x = (outpos).z
        #define Song_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,outpos) o.tSpace2.y = (outpos).z
        #define Song_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,outpos) o.worldPos.w = (outpos).z
    #endif
#else
    #define Song_FOG_COORDS(idx)
    #define Song_TRANSFER_FOG(o,outpos)
    #define Song_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,outpos)
    #define Song_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,outpos)
#endif
