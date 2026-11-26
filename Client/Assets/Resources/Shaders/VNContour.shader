// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "YY/VNContour" {
	Properties
	{
		_ContourColor("ContourColor",Color)=(1,0.3, 0.3,1)
		_BeginValue("BeginValue",float)=0.1		
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+2" }		
	
		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			ZWrite Off			
			ZTest LEqual			
			Blend One One
			
			CGPROGRAM		
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"

			float4 _ContourColor ;
			float _BeginValue ;
			
			struct VS_Output
			{
				float4 position : SV_POSITION ;
				float3 viewDir : TEXCOORD0 ;
				float3 worldNormal : TEXCOORD1 ;
			};
			
			VS_Output vert(appdata_full data)
			{
				VS_Output OUT ;				
				OUT.position = UnityObjectToClipPos(data.vertex) ;
				OUT.worldNormal = mul((float3x3)unity_ObjectToWorld,data.normal) ;
				OUT.viewDir = WorldSpaceViewDir(data.vertex) ;				
				return OUT ;
			}
			
			fixed4 frag(VS_Output data):COLOR0
			{
				float3 n = normalize(data.worldNormal) ;
				float3 v = normalize(data.viewDir) ;
				
				float rim = 1.0-max(0.0,dot(n,v)) ;
				rim = smoothstep(_BeginValue,1.0,rim) ;
				if(rim<0.01)
					discard ;
				return fixed4(_ContourColor.rgb*rim,1.0) ;
			}
			
			ENDCG
		}
	} 
	
}
