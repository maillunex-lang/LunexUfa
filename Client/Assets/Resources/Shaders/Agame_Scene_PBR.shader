Shader "A-game Shaders/Scene/Specular PBR" {
Properties {
	_MainColor("MainColor",Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
	_ShininessL0 ("Layer1Shininess", Range (0.03, 1)) = 0.078125
	_Splat0 ("MainTex", 2D) = "white" {}
	_Splat0PBR("PBRTex", 2D) = "white" {}
	_lay1MetallicAdjust("layer 1 Metallic Adjust", Range(0, 1.5)) = 1
	_lay1RoughnessAdjust("layer 1 Roughness Adjust", Range(0, 1.5)) = 1
	_BumpSplat0 ("Layer1Normalmap", 2D) = "bump" {}
	_EmissionTex("EmissionTex", 2D) = "white" {}
	_EmissionScale("Emission Scale", Range(0,1)) = 0
	_RainTexBump	("RainBump", 2D) = "bump" {}
	_RainCtrl ("RainCtrl", Range (0.00, 1)) = 0.0
	_Snow ("Snow Level", Range(0, 1.1)) = 1.1  
    _SnowColor ("Snow Color", Color) = (1, 1, 1, 1)  
    _SnowDirection ("Snow Direction", Vector) = (0, 1, 0)  

}

SubShader {
	Tags {
		"SplatCount" = "3"
		"RenderType" = "Opaque"
	}
CGPROGRAM
//#pragma surface surf BlinnPhong
//#pragma surface surf Standard fullforwardshadows
#pragma surface surf Standard 
#pragma exclude_renderers xbox360 ps3 flash
#pragma target 3.0
//inline fixed4 LightingMYBlinnPhong (SurfaceOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
//{
//	fixed diff = max (0, dot (s.Normal, lightDir));
//	fixed nh = max (0, dot (s.Normal, halfDir));
//	fixed spec = pow (nh, s.Specular*128) * s.Gloss;
//	
//	fixed4 c;
//	c.rgb = (s.Albedo * _LightColor0.rgb * diff + _SpecColor.rgb * spec) * (atten*2);
//	c.a = 0.0;
//	return c;
//}

struct Input {

	float2 uv_Control : TEXCOORD0;
	float2 uv_Splat0: TEXCOORD1;
//	float2 uv_Splat1 : TEXCOORD2;
//	float2 uv_Splat2 : TEXCOORD3;
//	float2 uv_Splat3 : TEXCOORD4;
	float3 worldNormal;
	INTERNAL_DATA
};
sampler2D _Control;
sampler2D _Splat0;
sampler2D _Splat0PBR;
sampler2D _BumpSplat0,_RainTexBump,_EmissionTex;
fixed _ShininessL0;
fixed _EmissionScale;
fixed _RainCtrl;
fixed _lay1RoughnessAdjust;
fixed _lay1MetallicAdjust;
float4 _SnowDirection;  
float _Snow;  
float4 _SnowColor,_MainColor;


void surf (Input IN, inout SurfaceOutputStandard o) {
	fixed4 splat_control = tex2D (_Control, IN.uv_Control).rgba;

	fixed4 Emissiont = tex2D(_EmissionTex,IN.uv_Splat0).rgba;
		
	fixed4 lay1 = tex2D (_Splat0, IN.uv_Splat0).rgba;
  	fixed4 lay1pbr = tex2D (_Splat0PBR, IN.uv_Splat0).rgba;
  	fixed3 rainN = UnpackNormal (tex2D(_RainTexBump,IN.uv_Splat0)).rgb;

	o.Alpha = 0.0;
//	o.Albedo.rgb = (lay1.rgb * splat_control.r + lay2.rgb * splat_control.g+ lay3.rgb * splat_control.b);
	
	fixed3 lay1B = UnpackNormal (tex2D(_BumpSplat0, IN.uv_Splat0)).rgb;
		if (saturate( dot(WorldNormalVector(IN, lay1B), _SnowDirection.xyz)) >  _Snow)  
    {  
        o.Albedo = _SnowColor.rgb;  
    }else  
    {
	o.Albedo.rgb = lay1.rgb * _MainColor;
    }
//	o.Albedo.rgb = lay1.rgb;
	fixed rainctrl =abs( _RainCtrl-1);
	o.Normal = rainN * _RainCtrl+ lay1B.rgb*rainctrl;
	o.Smoothness = lay1pbr.r*_lay1RoughnessAdjust;
	o.Metallic = lay1pbr.g* _lay1MetallicAdjust;
	o.Emission = Emissiont.rgb*_EmissionScale;
}
ENDCG  
}
FallBack "Diffuse"
}