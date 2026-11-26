// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'


Shader "CurrentZ/TerrainEmission4Map" {
    Properties {
        _control ("control", 2D) = "white" {}
        _Splat0 ("Splat0", 2D) = "white" {}
        _Normal0 ("Normal0", 2D) = "white" {}
        //_LightCtrl0 ("LightCtrl0", 2D) = "black" {}
        _Splat1 ("Splat1", 2D) = "white" {}
        _Normal1 ("Normal1", 2D) = "white" {}
        //_LightCtrl1 ("LightCtrl1", 2D) = "black" {}
        _Splat2 ("Splat2", 2D) = "white" {}
        _Normal2 ("Normal2", 2D) = "white" {}
        _LightCtrl2 ("LightCtrl2", 2D) = "black" {}
        _Splat3 ("Splat3", 2D) = "white" {}
        _Normal3 ("Normal3", 2D) = "white" {}
        _LightCtrl3 ("LightCtrl3", 2D) = "black" {}
		_BumpScale0("Layer1 NormalmapScale0", Float) = 1.0
		_BumpScale1("Layer2 NormalmapScale1", Float) = 1.0
		_BumpScale2("Layer3 NormalmapScale2", Float) = 1.0
		_BumpScale3("Layer4 NormalmapScale3", Float) = 1.0
		_Gloss1 ("Gloss1", Range(0, 2)) = 0.85
		_Gloss2 ("Gloss2", Range(0, 2)) = 0.85
		_Gloss3 ("Gloss3", Range(0, 2)) = 0.85
		_Gloss4 ("Gloss4", Range(0, 2)) = 0.85
		_RimRange ("RimRange", float) = 5
		_RimClampValue ("RimClampValue", float) = 1.2
		_Color ("Tint Color", Color) = (1.0,1.0,1.0,1.0)
		_TintColor ("Tint Color R", Color) = (1.0,1.0,1.0,1.0)
		_Brightness ("Brightness", float) = 1.0
		_WindDir("Wind Dir",Vector) = (1.0,0,0,0)
		_WaveStrength ("Wave Strength", float) = 0
		_WaveAttenuation ("Wave Attenuation", float) = 0

		_Splat1_Shininess ("Splat1_Shininess", Range(0, 1)) = 0
        _Splat2_Shininess ("Splat2_Shininess", Range(0, 1)) = 0
        _Splat3_Shininess ("Splat3_Shininess", Range(0, 1)) = 0
        _Splat4_Shininess ("Splat4_Shininess", Range(0, 1)) = 0
        _roughness1 ("roughness1", Range(0, 1)) = 0
        _roughness2 ("roughness2", Range(0, 1)) = 0
        _roughness3 ("roughness3", Range(0, 1)) = 0
        _roughness4 ("roughness4", Range(0, 1)) = 0
		_SepcValue1("value1",Float) = 0.3
		_SepcValue2("value2",Float) = 0.0
		_SepcValue3("value3",Float) = 0.3
		_SepcValue4("value4",Float) = 0.3
		_SpecularColor("SpecularColor", Color) = (1,0.654,0.219,0.6)
    }
	CGINCLUDE
    #include "UnityCG.cginc"
	uniform float _Gloss1;
	uniform float _Gloss2;
	uniform float _Gloss3;
	uniform float _Gloss4;
	half _BumpScale0, _BumpScale1, _BumpScale2, _BumpScale3;
	uniform float4 _WindDir;
	uniform float _WaveStrength;
	uniform float  _WaveAttenuation;
	half3 UnpackScaleNormal1(half4 packednormal, half bumpScale)
	{
#if defined(UNITY_NO_DXT5nm)
		fixed3 normal = packednormal.xyz * 2 - 1;
		normal.xy *= bumpScale;
		return normal;
#else
		half3 normal;
		normal.xy = packednormal.wy * 2 - 1;
		normal.xy *= bumpScale;
		normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
		return normal;
#endif
	}
	ENDCG
    SubShader {
        Tags {
			"Queue" = "Geometry+500"
            "RenderType"="Opaque"
        }
        LOD 230
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define _GLOSSYENV 1
			#include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
			#include "CurrentZSceneCommon.cginc"
			#include "CurrentZHeighFogCommon.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile LIGHTMAP_ON
            #pragma multi_compile __ FOG_LINEAR 
            #pragma exclude_renderers d3d11_9x xbox360 xboxone ps3 ps4 psp2 

            #pragma target 3.0
			uniform sampler2D _control; uniform float4 _control_ST;
			uniform sampler2D _Splat0; uniform float4 _Splat0_ST;
			uniform sampler2D _Splat1; uniform float4 _Splat1_ST;
			uniform sampler2D _Splat2; uniform float4 _Splat2_ST;
			uniform sampler2D _Splat3; uniform float4 _Splat3_ST;
			uniform sampler2D _Normal0; uniform float4 _Normal0_ST;
			uniform sampler2D _Normal1; uniform float4 _Normal1_ST;
			uniform sampler2D _Normal2; uniform float4 _Normal2_ST;
			uniform sampler2D _Normal3; uniform float4 _Normal3_ST;
			//uniform sampler2D _LightCtrl0;
			//uniform sampler2D _LightCtrl1;
			uniform sampler2D _LightCtrl2;
			uniform sampler2D _LightCtrl3;
			uniform float4 _GlobalColorScene;
			uniform float4 _Color;
			uniform float4 _TintColor;
			uniform float _Brightness;
			uniform float _RimClampValue;
			uniform float _RimRange;

			struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
                #if defined(LIGHTMAP_ON)
                    float4 ambientOrLightmapUV : TEXCOORD8;
                #endif
            };

            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
				float4 position_in_world_space = mul(unity_ObjectToWorld, v.vertex);
				float4 vPos = float4(position_in_world_space.xyz,1.0f);
				vPos = mul (UNITY_MATRIX_VP, vPos);	
				o.pos  = vPos;
				o.posWorld = position_in_world_space;
				UNITY_TRANSFER_FOG(o,o.pos);
				//CurrentZ_TRANSFER_HEIGH_FOG(o);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                fixed3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                fixed4 _controlRGBA = tex2D(_control,TRANSFORM_TEX(i.uv0, _control));

				fixed4 _Normal0_var = tex2D(_Normal0,TRANSFORM_TEX(i.uv0, _Splat0));
				fixed4 _Normal1_var = tex2D(_Normal1,TRANSFORM_TEX(i.uv0, _Splat1));
				fixed4 _Normal2_var = tex2D(_Normal2,TRANSFORM_TEX(i.uv0, _Splat2));
				fixed4 _Normal3_var = tex2D(_Normal3,TRANSFORM_TEX(i.uv0, _Splat3));
				float3 normalLocal = (_controlRGBA.r*UnpackScaleNormal1(_Normal0_var, _BumpScale0) + _controlRGBA.g*UnpackScaleNormal1(_Normal1_var, _BumpScale1) + _controlRGBA.b*UnpackScaleNormal1(_Normal2_var, _BumpScale2) + _controlRGBA.a*UnpackScaleNormal1(_Normal3_var, _BumpScale3));
				//float3 normalLocal = (_controlRGBA.g*UnpackScaleNormal1(_Normal1_var, _BumpScale1) + _controlRGBA.b*UnpackScaleNormal1(_Normal2_var, _BumpScale2) + _controlRGBA.a*UnpackScaleNormal1(_Normal3_var, _BumpScale3));
	
                //float3 normalLocal = ControlNormal(_controlRGBA, i.uv0);
				fixed3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 lightColor = _LightColor0.rgb;
                fixed3 halfDirection = normalize(viewDirection + lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                fixed3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                //fixed4 _LightCtrl0_var = tex2D(_LightCtrl0,TRANSFORM_TEX(i.uv0, _Splat0));
                //fixed4 _LightCtrl1_var = tex2D(_LightCtrl1,TRANSFORM_TEX(i.uv0, _Splat1));
                fixed4 _LightCtrl2_var = tex2D(_LightCtrl2,TRANSFORM_TEX(i.uv0, _Splat2));
                fixed4 _LightCtrl3_var = tex2D(_LightCtrl3,TRANSFORM_TEX(i.uv0, _Splat3));
				//float4 _LightCtrl_var = (_controlRGBA.r*_LightCtrl0_var * _Gloss1 + _controlRGBA.g*_LightCtrl1_var * _Gloss2 + _controlRGBA.b*_LightCtrl2_var * _Gloss3 + _controlRGBA.a*_LightCtrl3_var * _Gloss4);
				float4 _LightCtrl_var = (_controlRGBA.b*_LightCtrl2_var * _Gloss3 + _controlRGBA.a*_LightCtrl3_var * _Gloss4);
				float gloss = _LightCtrl_var.b;
				float perceptualRoughness = 1.0 - gloss;
                float roughness = perceptualRoughness * perceptualRoughness;
				float specPow = exp2( gloss * 10.0+1.0);
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                //lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
				float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = _LightCtrl_var.g;
                float specularMonochrome;
                fixed4 _Splat0_var = tex2D(_Splat0,TRANSFORM_TEX(i.uv0, _Splat0));
                fixed4 _Splat1_var = tex2D(_Splat1,TRANSFORM_TEX(i.uv0, _Splat1));
                fixed4 _Splat2_var = tex2D(_Splat2,TRANSFORM_TEX(i.uv0, _Splat2));
                fixed4 _Splat3_var = tex2D(_Splat3,TRANSFORM_TEX(i.uv0, _Splat3));
                fixed3 _MainTex_var = (_controlRGBA.r*_Splat0_var + _controlRGBA.g*_Splat1_var + _controlRGBA.b*_Splat2_var + _controlRGBA.a*_Splat3_var);
                float3 diffuseColor = lerp(1, _TintColor, _LightCtrl_var.r) * _MainTex_var.rgb * _Brightness * _Color; // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = saturate(1.0 - specularMonochrome);
                float NdotV = abs(dot(normalDirection, viewDirection));
                float NdotH = saturate(dot(normalDirection, halfDirection));
                float VdotH = saturate(dot(viewDirection, halfDirection));
                float visTerm = SmithJointGGXVisibilityTerm(NdotL, NdotV, roughness);
                float normTerm = max(0.0, GGXTerm(NdotH, roughness));
                float specularPBL = (NdotL * visTerm * normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0 - 0.28 * roughness * perceptualRoughness;
                #else
                    surfaceReduction = 1.0 / (roughness*roughness + 1.0);
                #endif
                float3 directSpecular = attenColor * specularPBL * FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = gi.indirect.specular;
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                indirectSpecular *= surfaceReduction;
                float3 specular = clamp((directSpecular + indirectSpecular), 0, 0.99);
/////// Diffuse:
				float3 directDiffuse = NdotL*attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                //indirectDiffuse += _GlobalColorScene.rgb; // Diffuse Ambient Light
                indirectDiffuse += gi.indirect.diffuse;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;

/// Final Color:
                fixed4 finalRGBA = fixed4(diffuse + specular, 1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				//CurrentZ_APPLY_HEIGH_FOG(i, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Legacy Shaders/Diffuse"
}
