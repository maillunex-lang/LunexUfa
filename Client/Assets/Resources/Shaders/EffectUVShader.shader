
// by artsyli

Shader "Effect/UVShader"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Rotate ("UV Rotate", Range (0, 6.2831853)) = 0.0
        _UVParam ("UV Param", Vector) = (0, 0, 1, 1)
		_DarkenDegree("***Do not edit***", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
      	#pragma multi_compile UV_OFF UV_ON

        sampler2D _MainTex;
        fixed4 _Color;
        float4 _UVParam;
        float _Rotate;
		float _DarkenDegree;

        struct Input
        {
            float2 uv_MainTex;
        };
        
        float2 CalcUV(float2 uv, float4 uvParam, float4 uvTile, float uvRotate)
		{
			float2 outUV;
			float s;
			float c;
			s = sin(uvRotate);
			c = cos(uvRotate);
			
			outUV = uv - float2(0.5f, 0.5f);
			outUV = float2(outUV.x * c - outUV.y * s, outUV.x * s + outUV.y * c);
			outUV.x *= uvParam.z;
			outUV.y *= uvParam.w;
			outUV = outUV + uvParam.xy + float2(0.5f, 0.5f);
			
			outUV.x = (outUV.x * uvTile.z) + uvTile.x;
			outUV.y = (outUV.y * uvTile.w) + uvTile.y;
			
			return outUV;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
        	float2 outUV = IN.uv_MainTex;
        #ifdef UV_ON
        	outUV = CalcUV(IN.uv_MainTex, _UVParam, float4(0, 0, 1, 1), _Rotate);
        #endif
            fixed4 c = tex2D(_MainTex, outUV) * _Color;
            o.Albedo = c.rgb * _DarkenDegree;
            o.Alpha = c.a;
        }
        ENDCG  
	} 
	FallBack OFF
	CustomEditor "EffectMaterialEd"
}
