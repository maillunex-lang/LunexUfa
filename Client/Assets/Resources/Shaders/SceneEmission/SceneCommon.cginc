// Upgrade NOTE: replaced 'UNITY_PASS_TEXCUBE(unity_SpecCube1)' with 'UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1,unity_SpecCube0)'

#ifndef SCENE_COMMON_CG_INCLUDED
#define SCENE_COMMON_CG_INCLUDED


inline half3 MixLightmapWithRealtimeAttenuation_KS (half3 lightmap, half attenuation, fixed4 bakedColorTex, half3 normalWorld)
{
	// Let's try to make realtime shadows work on a surface, which already contains
	// baked lighting and shadowing from the current light.
	
#if IMPROVED_BAKED_AND_REALTIME_SHADOW_MIXING
	half shadowStrength = _LightShadowData.x;

	// Calculate possible value in the shadow by two very distinct ways:
	// 1) by subtracting estimated light contribution from the places occluded by realtime shadow:
	//		a) preserves other baked lights and light bounces
	//		b) eliminates shadows on the geometry facing away from the light
	// 2) by attenuating lightmap - usually produces results that are:
	// 		a) too dark in region where baked and realtime shadow overlap
	//		b) destroys other baked lights
	//		c) shadows are visible on the geometry facing away from the light
	// Then use min/max arbiter to get a solution.

	// 1) Gives good estimate of illumination as if light would've been shadowed during the bake.
	//    Preserves bounce and other baked lights
	//    No shadows on the geometry facing away from the light
	half ndotl = saturate(dot(normalWorld, _WorldSpaceLightPos0.xyz));
	half3 estimatedLightContributionMaskedByInverseOfShadow = ndotl * (1-attenuation) * _LightColor0.rgb * 10;
	half3 subtractedLightmap = lightmap - estimatedLightContributionMaskedByInverseOfShadow;

	// 2) Keeps lightmap tint in shadow when ShadowStrength < 1.
	//    Preserves unshadowed areas when ShadowStrength < 1.
	half3 lightmapTint = bakedColorTex.rgb;
	half3 attenuatedLightmap = lightmapTint * attenuation;

	// Arbiter. Pick lightest shadows or the lightmap value, if it is the darkest one.
	half3 realtimeShadow = max(attenuatedLightmap, subtractedLightmap);
	realtimeShadow = lerp(realtimeShadow, lightmap, shadowStrength);
	return min(lightmap, realtimeShadow);
#else
	// Generally do min(lightmap,shadow), with "shadow" taking overall lightmap tint into account.
	half3 shadowLightmapColor = bakedColorTex.rgb * attenuation;
	half3 darkerColor = min(lightmap, shadowLightmapColor);

	// However this can darken overbright lightmaps, since "shadow color" will
	// never be overbright. So take a max of that color with attenuated lightmap color.
	return max(darkerColor, lightmap * attenuation);
#endif
}


inline UnityGI UnityGI_Base_KS(UnityGIInput data, half occlusion, half3 normalWorld)
{
	UnityGI o_gi;
	ResetUnityGI(o_gi);

	o_gi.light.color*= 2;
	#if !defined(LIGHTMAP_ON)
		o_gi.light = data.light;
		o_gi.light.color *= data.atten;
	#endif

	//#if UNITY_SHOULD_SAMPLE_SH
	//	o_gi.indirect.diffuse = ShadeSHPerPixel (normalWorld, data.ambient, data.worldPos);
	//#endif

	#if defined(LIGHTMAP_ON)
		// Baked lightmaps
		fixed4 bakedColorTex = UNITY_SAMPLE_TEX2D(unity_Lightmap, data.lightmapUV.xy);
		half3 bakedColor = DecodeLightmap(bakedColorTex);

		#ifdef DIRLIGHTMAP_COMBINED
			fixed4 bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER (unity_LightmapInd, unity_Lightmap, data.lightmapUV.xy);
			//o_gi.indirect.diffuse = DecodeDirectionalLightmap (bakedColor, bakedDirTex, normalWorld) * 20;

			#ifdef SHADOWS_SCREEN
				o_gi.indirect.diffuse = MixLightmapWithRealtimeAttenuation_KS (o_gi.indirect.diffuse, data.atten, bakedColorTex, normalWorld);
			#endif // SHADOWS_SCREEN

		#elif DIRLIGHTMAP_SEPARATE
			// Left halves of both intensity and direction lightmaps store direct light; right halves - indirect.

			// Direct
			fixed4 bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, data.lightmapUV.xy);
			o_gi.indirect.diffuse = DecodeDirectionalSpecularLightmap (bakedColor, bakedDirTex, normalWorld, false, 0, o_gi.light);

			// Indirect
			float2 uvIndirect = data.lightmapUV.xy + float2(0.5, 0);
			bakedColor = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, uvIndirect));
			bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, uvIndirect);
			o_gi.indirect.diffuse += DecodeDirectionalSpecularLightmap (bakedColor, bakedDirTex, normalWorld, false, 0, o_gi.light2);

			#ifdef SHADOWS_SCREEN
				o_gi.light.color = MixLightmapWithRealtimeAttenuation_KS(o_gi.light.color, data.atten, bakedColorTex, normalWorld);
				o_gi.light2.color = MixLightmapWithRealtimeAttenuation_KS(o_gi.light2.color, data.atten, bakedColorTex, normalWorld);
				o_gi.indirect.diffuse = MixLightmapWithRealtimeAttenuation_KS (o_gi.indirect.diffuse, data.atten, bakedColorTex, normalWorld);
			#endif // SHADOWS_SCREEN

		#else // not directional lightmap
			o_gi.indirect.diffuse = bakedColor;

			#ifdef SHADOWS_SCREEN
				o_gi.indirect.diffuse = MixLightmapWithRealtimeAttenuation_KS (o_gi.indirect.diffuse, data.atten, bakedColorTex, normalWorld);
			#endif // SHADOWS_SCREEN
		#endif
	#endif

	#ifdef DYNAMICLIGHTMAP_ON
		// Dynamic lightmaps
		fixed4 realtimeColorTex = UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, data.lightmapUV.zw);
		half3 realtimeColor = DecodeRealtimeLightmap (realtimeColorTex);

		#ifdef DIRLIGHTMAP_COMBINED
			half4 realtimeDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, data.lightmapUV.zw);
			o_gi.indirect.diffuse += DecodeDirectionalLightmap (realtimeColor, realtimeDirTex, normalWorld);

		#elif DIRLIGHTMAP_SEPARATE
			half4 realtimeDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, data.lightmapUV.zw);
			half4 realtimeNormalTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicNormal, unity_DynamicLightmap, data.lightmapUV.zw);
			o_gi.indirect.diffuse += DecodeDirectionalSpecularLightmap (realtimeColor, realtimeDirTex, normalWorld, true, realtimeNormalTex, o_gi.light3);
		#else
			o_gi.indirect.diffuse += realtimeColor;
		#endif
	#endif

	o_gi.indirect.diffuse *= occlusion;
	return o_gi;
}

//half perceptualRoughnessToMipmapLevel(half perceptualRoughness)
//{
//    return perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
//}
inline half3 SongDecodeHDR(half4 data, half4 decodeInstructions)
{
    // Take into account texture alpha if decodeInstructions.w is true(the alpha value affects the RGB channels)
    half alpha = decodeInstructions.w * (data.a - 1.0) + 1.0;

    // If Linear mode is not supported we can skip exponent part
#if defined(UNITY_COLORSPACE_GAMMA)
        return (decodeInstructions.x * alpha) * data.rgb;
#else
#if defined(UNITY_USE_NATIVE_HDR)
            return decodeInstructions.x * data.rgb; // Multiplier for future HDRI relative to absolute conversion.
#else
    return (decodeInstructions.x * pow(alpha, decodeInstructions.y)) * data.rgb;
#endif
#endif
}

inline UnityGI UnityGlobalIllumination_KS (UnityGIInput data, half occlusion, half3 normalWorld, Unity_GlossyEnvironmentData glossIn)
{
	UnityGI o_gi = UnityGI_Base_KS(data, occlusion, normalWorld);
    o_gi.indirect.specular = UnityGI_IndirectSpecular(data, occlusion, glossIn);
	return o_gi;
}

#endif