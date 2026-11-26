Shader "Custom/Unlit-Blend" 
{
	Properties
	{
		_Emissive("亮度", range(0,5)) = 1.0
		_Color ("颜色", Color) = (1,1,1,1)
		_MainTex("贴图", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert  
			#pragma fragment frag  
			#include "UnityCG.cginc"

			sampler2D _MainTex; half4 _MainTex_ST;
			half _Emissive;
			fixed4 _Color;

			struct appdata_t
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
			};

			struct v2f 
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
			};

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex,i.texcoord);
				
				col *= _Emissive * _Color;
				
				return col;
			}
			ENDCG
		}
	}
}