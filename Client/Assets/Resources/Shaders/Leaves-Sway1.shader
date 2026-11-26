Shader "Custom/Leaves-Sway1" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Dist("Distance", float) = 0.04
		_Speed("Speed", float) = 0.2
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader{
		LOD 100
		Tags{ "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
		CGPROGRAM

		#pragma surface surf Lambert vertex:vert alphatest:_Cutoff
		struct Input
		{
			half2 uv_MainTex;
		};
		sampler2D _MainTex;
		fixed _Dist;
		fixed _Speed;
		struct appdata_t {
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
			float2 texcoord2 : TEXCOORD2;
			float3 normal : NORMAL;
		};

		void vert(inout appdata_t v)
		{
			float4 vertex = mul(v.vertex, unity_ObjectToWorld);
			float a = vertex.x * vertex.z;
			v.vertex.xyz += float3(1, 0, 1) * _Dist * sin(_Time.w * (_Speed)+a);
		}
		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	}
	FallBack "Transparent/Cutout/VertexLit"
}
