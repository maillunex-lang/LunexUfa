Shader "Custom/Boss"  
{  
    Properties
	{  
        _Diffuse("颜色", Color) = (1,1,1,1)
		_Emissive("自发光强度", Range(0,3)) = 1.0
        _NormalScale("法线强度", Range(0, 3)) = 1
		
		[Header(Rim)]
        _RimColor("边缘光颜色", Color) = (1,1,1,1)  
        _RimPower("边缘光强度", Range(0, 20.0)) = 0.1
        _RimWidth( "边缘光范围", Range( 1, 10 ) ) = 5
		
		[Header(OutLine)]
        _OutlineColor("描边颜色", Color) = (0.7, 0.15, 0.15, 1)  
        _OutlineWidth("描边粗细", Range(0, 0.2)) = 0.1
        _OutlineDepth("描边深度调整", float) = 1
		
		[Header(Texture)]
        _MainTex("颜色贴图", 2D) = "white"{}
        _NormalTex("法线贴图", 2D) = "bump"{}
    }  
  
    SubShader
    {  
		Tags {"RenderType"="Opaque"}
	   	Lighting Off
        Pass 
        {  
            CGPROGRAM
			#pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			
            fixed4 _Diffuse;
            sampler2D _MainTex, _NormalTex;
            fixed4 _RimColor;
            fixed _RimPower;
            fixed _RimWidth;
			fixed _Emissive;
			fixed _NormalScale;
			
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
				half3 normalW = mul(normalL, (half3x3)unity_WorldToObject);
				return normalize(normalW);	
			}
			
            struct v2f
            {  
                float4 pos : SV_POSITION;
                half3 normal : TEXCOORD0;  
                half4 tangent : TEXCOORD3;  
                half2 uv : TEXCOORD1;  
                half3 worldViewDir : TEXCOORD2;
            };
			
            v2f vert(appdata_tan v)
            {  
                v2f o;  
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.normal = v.normal;
                o.tangent = v.tangent;
				
                half3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldViewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);
                return o;
            }
  
            fixed4 frag(v2f i) : SV_Target
            {  
				fixed3 normaltex = UnpackNormal(tex2D(_NormalTex, i.uv)).xyz;
                half3 worldNormal = calculateWorldNormal(i.normal, i.tangent, normaltex, _NormalScale);
                fixed4 color = tex2D(_MainTex, i.uv);
				
                half rim = 1 - saturate(dot( i.worldViewDir, worldNormal));
				rim = pow(rim, _RimWidth) * _RimPower;
				
                fixed3 rimColor = _RimColor * rim;

                color.rgb = color.rgb * _Emissive + rimColor;

                return fixed4(color);
            }
            ENDCG
        } 
		
		//OutLine Pass
		Pass
		{
			Cull Front
			Offset [_OutlineDepth],[_OutlineDepth]
			
			CGPROGRAM
			#pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			
			fixed4 _OutlineColor;
			half _OutlineWidth;
			
			struct v2f
            {  
                half4 pos : SV_POSITION;
                fixed3 outlineColor : TEXCOORD0;
            };
			
            v2f vert(appdata_base v)
            {  
                v2f o;  
				
				v.vertex.xyz += v.normal * _OutlineWidth;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				o.outlineColor = _OutlineColor;
                return o;
            }
  
            fixed4 frag(v2f i) : SV_Target
            {  
                return fixed4(i.outlineColor, 1);
            }
			
			ENDCG
		}
    }
}