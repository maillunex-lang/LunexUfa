#ifndef COMMON_CG_INCLUDE
#define COMMON_CG_INCLUDE

inline fixed3 UnpackNormal_KS(fixed4 packednormal)
{
	fixed3 normal;
	normal.xy = packednormal.xy * 2 - 1;
	normal.z = 1;
	return normal;
}
#endif//COMMON_CG_INCLUDE

