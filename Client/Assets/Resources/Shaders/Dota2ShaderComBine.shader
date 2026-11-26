// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Dota2Shader" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
//	_BumpMap ("Normalmap", 2D) = "bump" {}
	_Mask1Tex ("Mask1 (RGBA)", 2D) = "white" {}
	_FresnelWarpTex ("FresnelWarp (RGB)", 2D) = "white" {}
	_DiffuseWarpTex ("DiffuseWarp (RGB)", 2D) = "white" {}
	fSpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
	fSpecularExponent ("Specular Exponent", float) = 16
	fSpecularScale ("Specular Scale", float) = 1

	fRimLightColor ("Rim Light Color", Color) = (1, 1, 1, 1)
	fRimLightScale ("Rim Light Scale", float) = 1

	fSelfIllumStrength ("Self-Illum Strength", float) = 1

	//fbb ("bb", bool) = true

}


// hight quality
SubShader {
	Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}

	Cull Off

	CGINCLUDE
	#include "UnityCG.cginc"
	ENDCG	

	Pass {
		Name "ForwardBase"

		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest	
		#pragma target 3.0

	
		uniform half4 _LightColor0;
		uniform sampler2D _MainTex;
//		uniform sampler2D _BumpMap;
		uniform sampler2D _Mask1Tex;
		uniform sampler2D _FresnelWarpTex;
		uniform sampler2D _DiffuseWarpTex;
		uniform half4   fSpecularColor;
		uniform float	fSpecularExponent;
		uniform float   fSpecularScale;
		uniform half4 fRimLightColor;
		uniform half  fRimLightScale;
		uniform half  fSelfIllumStrength;
		



		struct VertexInput {
	        float4 vertex : POSITION;
	        float3 normal : NORMAL;
	        float4 texcoord : TEXCOORD0;
//			float3 tangent	: TANGENT;
	    };
	    struct VertexOutput {
	        float4 pos : SV_POSITION;
	        float4 uv : TEXCOORD0;
	        float3 worldPosition : TEXCOORD1;
			float3 worldNormal : TEXCOORD2;
//			float3 worldTangent : TEXCOORD3;
//			float3 worldBinormal : TEXCOORD4;
			float3 viewVec : TEXCOORD5;
			//float3 viewPosition : TEXCOORD6;
	    };

		float Fresnel( float3 N, float3 V, float X )
		{
			fixed tmpS = dot( N, V );
			fixed Fresnel = 1.0 - max(0,min(1.0, tmpS));
			//float Fresnel = 1.0 ;//- saturate( dot( N, V ) );
			return pow(Fresnel, X);
		}

		// If ( x * Tangent, y * Binormal, z * Normal ) is used, normal maps need swizzle
		float3 swizzle( float3 ref )
		{
			return float3(ref.y, ref.x, ref.z); // swizzle it
		}


	    
	    VertexOutput vert (VertexInput v)
		{
			VertexOutput o = (VertexOutput)0;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.viewVec =  normalize( WorldSpaceViewDir(v.vertex));


			#ifdef OPTIMIZE
			o.worldNormal = (mul((float3x3)unity_ObjectToWorld, v.normal));
//			o.worldTangent = (mul((float3x3)_Object2World, v.tangent));
//			o.worldBinormal = (cross(o.worldNormal,o.worldTangent));
			#else
			o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
//			o.worldTangent = normalize(mul((float3x3)_Object2World, v.tangent));
//			o.worldBinormal = normalize(cross(o.worldNormal,o.worldTangent));
			#endif
			
			o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
			o.uv.xy = v.texcoord.xy;
			return o;
		}

		fixed4 frag (VertexOutput i) : COLOR
		{
			float2 texCoord = i.uv.xy;
			float3 V = normalize(i.viewVec);

//			float3 normalMap = tex2D(_BumpMap,texCoord).rgb * 2.0f - 1.0f;
			//float3 normalMap = UnpackNormal(tex2D(_BumpMap,texCoord));
//			float3x3 tSpace = float3x3((i.worldTangent),(i.worldBinormal),(i.worldNormal)); 
			float3 N = i.worldNormal;


			float4 mask1 = tex2D(_Mask1Tex, texCoord);


			
	
			float flSpecularMask      = mask1.r;
			float flSpecularExponent  = mask1.g;
			float flRimMask           = mask1.b;
			//float flMetalnessMask	= mask1.a;  //remove Metal
			float glowMask	= mask1.a;


			fixed tmpS = dot( N, V );
			fixed VdotN = max(0,min(1.0, tmpS));
			//float VdotN = 1;//saturate( dot( V, N ) );
			float3 FresnelTerm = tex2D( _FresnelWarpTex, float2( VdotN, 0.5f )).rgb;
			//FresnelTerm.b = max( FresnelTerm.b, flMetalnessMask);   //remove Metal

			float3 mainTexColor = tex2D(_MainTex, texCoord);
			//return fixed4(diffuseColor,1.0);
			 mainTexColor = pow(mainTexColor, 2.2f);

			
			float3 diffuseColor = lerp( mainTexColor, float3(0.0,0.0,0.0), FresnelTerm.g );
			//return fixed4(diffuseColor,1.0f);

			// Do lighting ...   _LightColor0;
			float3 L = normalize(_WorldSpaceLightPos0.xyz);
			float NdotL = dot(N,L);
			float halfLambert = NdotL * 0.5 + 0.5;
			
			float3 diffuseLight = tex2D(_DiffuseWarpTex,float2(halfLambert,0.25f));
			diffuseLight *= _LightColor0.rgb;
			//return fixed4(diffuseLight,1.0f);

			tmpS = NdotL;
			NdotL = max(0,min(1.0, tmpS));
			//NdotL = 1;//saturate( NdotL );
			float3 R = reflect( V, N ); 

			tmpS = dot( L, -R );
			float RdotL = max(0,min(1.0, tmpS));
			//float RdotL = 1;//saturate( dot( L, -R ) );
			
			//return fixed4(mask1.g.xxx,1.0f);
			
			flSpecularExponent *= fSpecularExponent;
			float flSpecularIntensity = NdotL * pow( RdotL, flSpecularExponent );
			float3 SpecularLighting = flSpecularIntensity.xxx; //float3( flSpecularIntensity, flSpecularIntensity, flSpecularIntensity );
			SpecularLighting *= _LightColor0.rgb;

			float3 final = diffuseLight * diffuseColor;
			//return fixed4(final,1.0);
			float3 cSpecular = SpecularLighting * fSpecularScale;
			cSpecular *= flSpecularMask;
			cSpecular *= fSpecularColor;
			cSpecular *= FresnelTerm.b;
			
			final += cSpecular;
			//return fixed4(cSpecular,1.0f);

			//return fixed4(flMetalnessMask.xxx,1.0);

			//float3 metalness = cSpecular;

			//final = lerp( final, cSpecular, flMetalnessMask );  //remove Metal

			float3 rimLighting = (FresnelTerm.r * fRimLightScale) * flRimMask; 

			tmpS = dot(N, float3( 0.0, 1.0, 0.0 ));
			rimLighting *= max(0,min(1.0, tmpS));
			//rimLighting *= 1;//saturate(dot(N, float3( 0.0, 1.0, 0.0 ))); 
			rimLighting *= fRimLightColor;
			// rimLighting *= ( 1.0 - flMetalnessMask); // Metalness  //remove Metal

			final += rimLighting;
			//return fixed4(SpecularLighting,1.0f);

			//自发光
			final += fSelfIllumStrength * mainTexColor * glowMask;


			//final =cSpecular;        /////   高光
			//final = rimLighting;		/////   边缘光
			//final = diffuseLight ;	/////   漫反射光照
			//final =  diffuseLight * diffuseColor;    /////   漫反射光照+漫反射贴图

			return fixed4(pow(final, 0.4545f),1.0);
			
		}
		ENDCG 
	}
	 // x:size  y : smoothness z:shadow w:intensity
}

}