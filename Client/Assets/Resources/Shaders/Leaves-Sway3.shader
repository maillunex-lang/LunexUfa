Shader "Custom/Leaves-Sway3" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Pos("Position",Vector) = (0,0,0,0)
		_Direction("Direction",Vector) = (0,0,0,0)
		_TimeScale("TimeScale",float) = 1
		_TimeDelay("TimeDelay",float) = 1
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader{
	Tags{ "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
	LOD 200

	CGPROGRAM
#pragma surface surf Lambert vertex:vert alphatest:_Cutoff
	sampler2D _MainTex;
	fixed4 _Pos;
	fixed4 _Direction;
	half _TimeScale;
	half _TimeDelay;

	struct Input
	{
		half2 uv_MainTex;
	};
	void surf(Input IN, inout SurfaceOutput o) {
		half4 c = tex2D(_MainTex, IN.uv_MainTex);
		o.Albedo = c.rgb;
		o.Alpha = c.a;
	}
	void vert(inout appdata_full v)
	{
		half dis = distance(v.vertex, _Pos);
		half time = (_Time.y + _TimeDelay) * _TimeScale;
		v.vertex.xyz += dis * (sin(time) * cos(time * 2 / 3) + 1) * _Direction.xyz;
	}
	ENDCG
	}
	Fallback "Transparent/Cutout/VertexLit"
}
