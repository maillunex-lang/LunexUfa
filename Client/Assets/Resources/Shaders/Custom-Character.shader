Shader "Custom/Character"
{
	Properties
	{
        [Toggle(ENABLE_CUTOUT)] _EnableCutout("Cutout", float) = 0
        _Cutout("Cutout", range(0,1)) = 0.5
        _MainTex("颜色贴图", 2D) = "white"{}
		[HideInInspector]_NormalTex("法线贴图", 2D) = "bump"{}
		[HideInInspector]_NormalScale("法线强度",Range(0,3)) = 1
		_SpecTex("高光贴图", 2D) = "white"{}
		_SpecPower("高光范围",Range(0.1,5)) = 1
		_SpecIntensity("高光强度",Range(0,10)) = 1
		_SpecPower2("副高光范围",Range(0.1,5)) = 1
		_SpecIntensity2("副高光强度",Range(0,10)) = 1

		[Toggle(ENABLE_FLOW)] _EnableFlow("流光", float) = 0
		_FlowTex("流光贴图", 2D) = "black"{}
		_FlowMaskTex("流光遮罩", 2D) = "white"{}
		_FlowAni("流光动画", vector) = (0,0,0,0)
		_FlowColor("流光颜色", color) = (1,1,1,1)
		_FlowIntensity("流光亮度", range(0,3)) = 1

	}

	SubShader
	{
		pass
		{
			Tags{ "RenderType" = "Opaque"}
			Cull Back
			
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma shader_feature ENABLE_CUTOUT
            #pragma shader_feature ENABLE_FLOW
			#pragma multi_compile _FOG_OFF  _FOG_ON
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _SpecTex;
			//sampler2D _NormalTex;
			//half _NormalScale;
			half _SpecIntensity;
			half _SpecPower;
			half _SpecPower2;
			half _SpecIntensity2;

			fixed _Cutout;

            fixed4 _SLightColor;
            half3 _SLightDir;
            half _SLightIntensity;

			#if ENABLE_FLOW
				sampler2D _FlowTex; half4 _FlowTex_ST;
				sampler2D _FlowMaskTex;
				half4 _FlowAni;
				fixed4 _FlowColor;
				half _FlowIntensity;
			#endif
			#ifdef  _FOG_ON
				float4 _FogParam;
				fixed4 _HeightFogColor;
				fixed4 _DistanceFogColor;
			#endif

			inline half3 calculateWorldNormal(half3 normal, half4 tangent, fixed3 texnormal, half normalScale)
			{
				normal         = normalize(normal);
				half3 tangetL = tangent.xyz;
				half  tW      = tangent.w;
				tangetL        = normalize(tangetL);
				half3 BinormalL = cross(normal,tangetL) * tW;
				half3x3 TBN = half3x3(tangetL, BinormalL, normal);
				
				texnormal.xy *= normalScale;
				//transform normalT to object space
				half3 normalL = texnormal.x * TBN[0] +
								texnormal.y * TBN[1] +
								texnormal.z * TBN[2];
				half3 normalW = UnityObjectToWorldNormal(normalL);
				return normalize(normalW);	
			}

            struct v2f
            {  
                float4 pos : SV_POSITION;
				half4 uv : TEXCOORD1;  
				half3 normal : TEXCOORD0;
				half4 tangent : TEXCOORD4;
				half3 worldViewDir : TEXCOORD2;
				#ifdef  _FOG_ON
				half2 fogdensity : TEXCOORD3;
				#endif
            };

            v2f vert(appdata_full v)
            {  
                v2f o = (v2f)0;  
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.texcoord;

				#if ENABLE_FLOW
					o.uv.zw = v.texcoord1 * _FlowTex_ST.xy + _FlowTex_ST.zw;
					o.uv.zw += frac(_FlowAni.xy * _Time.y);
				#endif

				o.normal = v.normal;
				o.tangent = v.tangent;
				half3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldViewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);
				#ifdef  _FOG_ON
					o.fogdensity.x = (worldPos.y - _FogParam.y) / (_FogParam.x - _FogParam.y);
					o.fogdensity.y = (o.pos.w - _FogParam.w) / (_FogParam.z - _FogParam.w);
				#endif

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {  
                fixed4 color = tex2D(_MainTex, i.uv.xy);

                #if ENABLE_CUTOUT
                    clip(color.a - _Cutout);
                #endif
				
				//fixed3 normalTex = UnpackNormal(tex2D(_NormalTex, i.uv.xy)).rgb;
				//half3 worldNormal = calculateWorldNormal(i.normal, i.tangent, normalTex, _NormalScale);
				half3 worldNormal = normalize(mul((half3x3)unity_ObjectToWorld, i.normal).xyz);

				fixed3 specMask = tex2D(_SpecTex, i.uv.xy).rgb;

				fixed nv = (dot(worldNormal, i.worldViewDir));
				fixed3 specColor1 = pow(saturate(nv), _SpecPower * 128) * _SpecIntensity * specMask;

				fixed falloff = nv * 0.3 + 0.7;
				color.rgb *= falloff;

				half3 halfDir = normalize(_SLightDir + i.worldViewDir);
				half spec2 = saturate(dot(halfDir, worldNormal));
				fixed3 specColor2 = pow(spec2, _SpecPower2 * 32) * _SpecIntensity2 * specMask;
				specColor2 *= _SLightColor * _SLightIntensity;

				color.rgb += specColor1 + specColor2;

				#if ENABLE_FLOW
					fixed4 flowTex = tex2D(_FlowTex, i.uv.zw);
					fixed4 flowMask = tex2D(_FlowMaskTex, i.uv.xy);
					color.rgb += flowTex.r * _FlowColor * flowMask.r * _FlowIntensity;
				#endif

				#ifdef  _FOG_ON
					float tmpS1 = i.fogdensity.x;
					color.rgb = lerp(_HeightFogColor.rgb, color.rgb, max(0, min(1.0, tmpS1)));
					//color.rgb = lerp(_HeightFogColor.rgb,color.rgb,1);//saturate(i.fogdensity.x));

					float tmpS2 = i.fogdensity.y;

					color.rgb = lerp(_DistanceFogColor.rgb, color.rgb, max(0, min(1.0, tmpS2)));
					//color.rgb = lerp(_DistanceFogColor.rgb,color.rgb,1);//saturate(i.fogdensity.y));
				#endif

                return fixed4(color.rgb, 1);
            }
			ENDCG
		}
	}
}