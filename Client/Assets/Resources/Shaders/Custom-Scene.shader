Shader "Custom/Scene"
{
	Properties
	{
        [Toggle(ENABLE_CUTOUT)] _EnableCutout("Cutout", float) = 0
        _Cutout("Cutout", range(0,1)) = 0.5
        _MainTex("颜色贴图", 2D) = "white"{}
		_NormalTex("法线贴图", 2D) = "bump"{}
		_NormalScale("法线强度",Range(0,3)) = 1
		_SpecTex("高光贴图", 2D) = "white"{}
		_SpecPower("高光范围",Range(0.1,5)) = 1
		_SpecIntensity("高光强度",Range(0,10)) = 1
	}

	SubShader
	{
		pass
		{
			Tags{ "RenderType" = "Opaque" "LightMode"="ForwardBase"}
			Cull Back
			
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma shader_feature ENABLE_CUTOUT
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _SpecTex;
			sampler2D _NormalTex;
			half _NormalScale;
			half _SpecIntensity;
			half _SpecPower;

			fixed _Cutout;

            fixed4 _MLightColor;
            half3 _MLightDir;
            half _MLightIntensity;

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
				half2 uv : TEXCOORD1;  
				half3 normal : TEXCOORD0;
				half4 tangent : TEXCOORD4;
				half3 worldViewDir : TEXCOORD2;
            };

            v2f vert(appdata_tan v)
            {  
                v2f o = (v2f)0;  
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.texcoord;
				o.normal = v.normal;
				o.tangent = v.tangent;
				half3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldViewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {  
                fixed4 color = tex2D(_MainTex, i.uv);

                #if ENABLE_CUTOUT
                    clip(color.a - _Cutout);
                #endif

				fixed3 normalTex = UnpackNormal(tex2D(_NormalTex, i.uv)).rgb;
				half3 worldNormal = calculateWorldNormal(i.normal, i.tangent, normalTex, _NormalScale);
					
				fixed nv = saturate(dot(worldNormal, i.worldViewDir));

                half3 lightDir = _MLightDir;
                half3 halfDir = normalize(lightDir + i.worldViewDir);
                half spec = saturate(dot(halfDir, worldNormal));
				
				fixed3 specMask = tex2D(_SpecTex, i.uv).rgb;
				fixed3 specColor = pow(spec, _SpecPower * 128) * _SpecIntensity * specMask;

				color.rgb += specColor;
                color.rgb *= _MLightColor * _MLightIntensity;
				
                return fixed4(color.rgb, 1);
            }
			ENDCG
		}
	}
}