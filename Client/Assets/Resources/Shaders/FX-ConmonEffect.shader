Shader "AK47NewShader/FX/ConmonEffect" 
{
    Properties 
	{
        _MainTex ("Main Tex", 2D) = "white" {}
        _MainTexUVAni ("MainTex Ani", Vector) = (0,0,0,0)
        _DistortMap ("Distort Tex", 2D) = "white" {}
        _MaskMap ("Mask Tex", 2D) = "white" {}
		
		_DistortFactor ("扭曲强度", Range(0,0.5) ) = 0.15
        _UVAnination ("Distort Ani", Vector) = (0,0,0,0)
		
        _TintColor("Color", Color) = (1,1,1,1)  
		_ColorFactor("Color Factor", Range(0,5)) = 1.5
		
		_rimPower("Rim Power", Range(0,10)) = 5
		_rimFactor("Rim Factor", Range(0,10)) = 1
        _rimColor("rimColor", Color) = (1,1,1,1)  
		
        _DissolveFactor("dissolve factor", Range(0,1.01)) = 0.5
        _DissolveMap ("Dissolve Tex", 2D) = "white" {}
		
		[Toggle(ENABLE_DISTORT)] _Distort ("扭曲", Float) = 0
		[Toggle(ENABLE_MASK)] _Mask ("遮罩", Float) = 0
		[Toggle(ENABLE_RIM)] _Rim ("Rim", Float) = 0
		[Toggle(ENABLE_DISSOLVE)] _Dissolve ("Dissolve", Float) = 0
		[Toggle(ENABLE_CLIP)] _Clip ("Clip", Float) = 0
		
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _CullMode ("__CullMode", Float) = 0.0
		[HideInInspector] _Cull ("__Cull", Float) = 0.0
    }
    SubShader 
	{
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
        }
        Pass 
		{
            Blend [_SrcBlend] [_DstBlend]
            ZWrite Off
			Cull [_Cull]
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 2.0
			#pragma shader_feature ENABLE_DISTORT
			#pragma shader_feature ENABLE_MASK
			#pragma shader_feature ENABLE_RIM
			#pragma shader_feature ENABLE_DISSOLVE
			#pragma shader_feature ENABLE_CLIP
			#pragma shader_feature _ADDITIVESOFT_ON
			#pragma shader_feature _MULTIPLY_ON
			#pragma fragmentoption ARB_precision_hint_fastest
			
            sampler2D _MainTex; half4 _MainTex_ST;
			half4 _MainTexUVAni;			
			#if ENABLE_DISTORT
            sampler2D _DistortMap; half4 _DistortMap_ST;
			half4 _UVAnination;
			half _DistortFactor;
			#endif
			
			#if ENABLE_MASK
            sampler2D _MaskMap; half4 _MaskMap_ST;
			#endif
			
			#if ENABLE_DISSOLVE
            sampler2D _DissolveMap; half4 _DissolveMap_ST;
			float _DissolveFactor;
			#endif

			#if ENABLE_RIM
			half _rimPower;
			half _rimFactor;
			fixed4 _rimColor;
			#endif
			
			#if ENABLE_CLIP
			float4 _ClipRect;  //xy矩形左下角坐标, zw矩形右上角坐标
			float4 _ClipParam;  // xy圆心世界坐标, z半径, w=0圆形裁剪, w=1矩形裁剪
			#endif
			
			fixed4 _TintColor;
			half _ColorFactor;
			
            struct VertexInput 
			{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 vertexColor : COLOR;
				#if ENABLE_RIM
				half3 normal : NORMAL;
				#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };
			
            struct v2f 
			{
                float4 pos : SV_POSITION;
                half4 uv : TEXCOORD0;
				#if ENABLE_MASK || ENABLE_DISSOLVE
                half4 uv1 : TEXCOORD1;
				#endif
				#if ENABLE_RIM
				half3 normal :TEXCOORD2;
				half3 viewDir :TEXCOORD3;
				#endif
				#if ENABLE_CLIP
				half2 clipPos : TEXCOORD4;
				#endif
				fixed4 vColor : COLOR;
				UNITY_VERTEX_OUTPUT_STEREO
            };
			
            v2f vert (VertexInput v) 
			{
                v2f o = (v2f)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				
                o.pos = UnityObjectToClipPos( v.vertex );
				
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.xy += frac(half2(_MainTexUVAni.xy * _Time.y));
				
				#if ENABLE_DISTORT
                o.uv.zw = TRANSFORM_TEX(v.uv, _DistortMap);
				o.uv.zw += frac(half2((_UVAnination.z * _Time.y),(_UVAnination.w * _Time.y)));
				#endif
				
				#if ENABLE_MASK
				o.uv1.xy = TRANSFORM_TEX(v.uv, _MaskMap);
				#endif
				
				#if ENABLE_DISSOLVE
				o.uv1.zw = TRANSFORM_TEX(v.uv, _DissolveMap);
				#endif
				
				#if ENABLE_CLIP || ENABLE_RIM
				half3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				
				#if ENABLE_RIM
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);
				#endif
				
				#if ENABLE_CLIP
				o.clipPos = worldPos.xy;
				#endif
				
				o.vColor = v.vertexColor;
				
                return o;
            }
			
            fixed4 frag(v2f i) : SV_Target 
			{
				fixed4 _MainTexColor;
				
				#if !ENABLE_DISTORT
					_MainTexColor = tex2D(_MainTex, i.uv);
				#else
					half _DistortTex_var = tex2D(_DistortMap,i.uv.zw).r * 2 - 1;
					_DistortTex_var *= _DistortFactor;
					half2 distortUV = i.uv.xy + _DistortTex_var;
					_MainTexColor = tex2D(_MainTex, distortUV);
				#endif
				
				#if ENABLE_DISSOLVE
					float ClipTex;
					#if !ENABLE_DISTORT
						ClipTex = tex2D(_DissolveMap, i.uv1.zw).r;
					#else
						distortUV = i.uv1.zw + _DistortTex_var;
						ClipTex = tex2D(_DissolveMap, distortUV).r;
					#endif
					ClipTex = step(0, ClipTex - _DissolveFactor);
					_MainTexColor *= ClipTex;
				#endif
				
				half3 colorFactor = _MainTexColor.rgb * _TintColor.rgb * i.vColor.rgb * _ColorFactor;
				fixed alphaFactor = _MainTexColor.a * _TintColor.a * i.vColor.a * _ColorFactor;
				
				fixed4 col;
				col.rgb = colorFactor;
				col.a = alphaFactor;
				
				#if ENABLE_MASK
					fixed4 masktex = tex2D(_MaskMap, i.uv1.xy);
					fixed mask = min(masktex.r, masktex.a);
					col.a *= mask;
				#endif

				#if ENABLE_RIM
					half rim = 1 - abs(dot(i.normal, i.viewDir));
					rim = pow(rim, _rimPower) * i.vColor.a * _ColorFactor;
					fixed3 rimColor = rim * _rimColor * _rimFactor * _ColorFactor;
					col.rgb += rimColor;
					col.a += rim;
				#endif

				#if _ADDITIVESOFT_ON
					col.rgb *= col.a;
				#endif
				
				#if _MULTIPLY_ON
					col = lerp(fixed4(0.5,0.5,0.5,0.5), col, col.a);
				#endif
				
				#if ENABLE_CLIP
					float2 inside = step(_ClipRect.xy, i.clipPos)  * step(i.clipPos, _ClipRect.zw);
					fixed c = inside.x * inside.y;
					float dis = distance(_ClipParam.xy, i.clipPos);
					dis = step (dis, _ClipParam.z);
					
					fixed finalclip = lerp(dis, c, _ClipParam.w);
					
					col *= finalclip;
				#endif
				
                return col;
            }
            ENDCG
        }
    }
	CustomEditor "CustomFXShaderGUI"
}
