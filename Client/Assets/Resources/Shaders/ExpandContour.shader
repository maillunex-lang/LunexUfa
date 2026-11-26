// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "YY/ExpandContour" {
	Properties
	{
		_ContourColor("ContourColor",Color)=(1,1,1,1)
		_Bias("Bias",float)=0.1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }		
	
		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			ZWrite Off			
			ZTest LEqual
			Cull Front
			
			CGPROGRAM		
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"

			float4 _ContourColor ;
			float _Bias ;
			
			float4 vert(appdata_full data):SV_POSITION
			{
				float3 worldNormal = mul((float3x3)unity_ObjectToWorld,data.normal) ;
				float4 worldVertex = mul(unity_ObjectToWorld,data.vertex);
				worldVertex.xyz /= worldVertex.w ;
				worldVertex.w=1.0 ;
				worldVertex.xyz += worldNormal * _Bias ;
				return mul(UNITY_MATRIX_VP,worldVertex) ;
			}
			
			fixed4 frag():COLOR0
			{
				return _ContourColor ;
			}
			
			ENDCG
		}
	} 
	
}
