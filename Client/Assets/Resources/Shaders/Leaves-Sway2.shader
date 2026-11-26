Shader "Custom/Leaves-Sway2" {
	Properties{
		_MainTex("Base ( RGB) ", 2D) = "white" {}
		_Speed("Speed", Range(0.1, 80)) = 5
		_Frequency("Frequency", Range(0, 5)) = 2
		_Amplitude("Amplitude", Range(-1, 1)) = 1
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader{
	LOD 100
	Tags{ "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
	CGPROGRAM

	#pragma surface surf Lambert vertex:vert alphatest:_Cutoff
	struct Input
	{
		float2 uv_MainTex;
		//float3 vertColor;
	};
	sampler2D _MainTex;
	float _Speed;
	float _Frequency;
	float _Amplitude;
	float _OffsetVal;

	void vert(inout appdata_full v, out Input o)
	{
		UNITY_INITIALIZE_OUTPUT(Input, o);
		float time = _Time * _Speed;
		float waveValueA = sin(time + v.vertex.x * _Frequency) * _Amplitude;
		v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveValueA,
			v.vertex.z);
		v.normal = normalize(float3(v.normal.x + waveValueA, v.normal.y,
			v.normal.z));
		//o.vertColor = float3(waveValueA, waveValueA, waveValueA);
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
