// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "SGShader/DynamicTransparentDiffuse"{
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_Alpha ("Alpha Range", Range(0.0,1.0)) = 0.2
}
SubShader {
	Tags { "Queue"="Transparent" "RenderType"="Transparent" }
	LOD 150
	Blend SrcAlpha OneMinusSrcAlpha
	Cull off
	AlphaTest Off

CGPROGRAM
#pragma surface surf Lambert noforwardadd approxview halfasview


sampler2D _MainTex;
half _Alpha;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = c.rgb;
	fixed4 tmpS =_Alpha;
	o.Alpha = c.a * max(0,min(1.0, tmpS));
	//o.Alpha = c.a * 1;//saturate(_Alpha);
}
ENDCG
}

Fallback "SGShader/Environment/Base/TransparentVertexLit"
}
