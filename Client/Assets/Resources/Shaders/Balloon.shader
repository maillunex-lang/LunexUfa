// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'

Shader "DZSMobile/Balloon" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_Amount ("Baloon Amount", Range(0.0, 0.1)) = 0.01
		_Cutoff ("Alpha Cutoff", Range(0.0, 5.0)) = 0.8
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 100
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off Lighting Off Fog { Mode Off }

			CGPROGRAM
			//	#pragma exclude_renderers flash
			//	#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				fixed4 _Color;
				fixed _Amount, _Cutoff;

				struct a2f {
					float4 vertex : POSITION;
					fixed3 normal : NORMAL;
					fixed4 color  : COLOR;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					fixed3 NorW : TEXCOORD0;
					half3 VieW : TEXCOORD1;
					fixed4 color: COLOR;
				};

				v2f vert (a2f v) {
					v2f o;
					//o.NorW = mul((float3x3)_World2Object, v.normal);
					o.NorW = mul((float3x3)unity_ObjectToWorld, v.normal * 1.0);
					float4 Po = v.vertex;
					Po += (_Amount * normalize(fixed4(v.normal.xyz, 0)));
					o.VieW = _WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, Po);
					o.Pos = UnityObjectToClipPos(Po);
					o.color = v.color;
					return o;
				}

				fixed4 frag( v2f i ) : COLOR {
					fixed3 Nn = normalize(i.NorW);
					fixed3 Vn = normalize(i.VieW);
					fixed edge = 1.0 - dot(Vn, Nn);
					edge = pow(edge, _Cutoff);
					fixed3 res = edge * _Color.rgb;
					res *= i.color.rgb;
					edge *= i.color.a;
					return fixed4(res, edge);
				}
			ENDCG
		}
	} 
	FallBack Off
}