Shader "Mobile/BRDFLit (Supports Backlight)_dzs" {
Properties {
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "grey" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_BRDFTex ("NdotL NdotH (RGBA)", 2D) = "white" {}

	_BackLightDirection("Back Light Direction", Vector) = (-0.3,0.4,-0.8,0)
	_RimPower("Rim Power", float) = 2.5
	_RimPara("Rim Para", float) = 8
	_RimColor("Rim Color", Color) = (0.2,0.45,0.58,1)
	_RimMask ("RimMask(RGB) ", 2D) = "white" {}
}	
SubShader { 
	Tags { "RenderType"="Opaque+100" "LightMode"="ForwardBase" }
	LOD 400

ZTest Greater
ZWrite Off

CGPROGRAM
#pragma surface surf Lambert exclude_path:prepass nolightmap noforwardadd alpha
#pragma target 3.0

sampler2D _MainTex;
struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb + fixed3(0.4, 0.3, 0.5);
	o.Alpha = 0.5;
}

ENDCG

ZTest LEqual
ZWrite On

CGPROGRAM
#pragma surface surf PseudoBRDF exclude_path:prepass nolightmap noforwardadd approxview
#pragma target 3.0

struct MySurfaceOutput {
	fixed3 Albedo;
	fixed3 Normal;
	fixed3 Emission;
	half Specular;
	fixed Gloss;
	fixed Alpha;
};

sampler2D _BRDFTex;
half4 _BackLightDirection; 
float _RimPower;
half _RimPara;
half3 _RimColor;
sampler2D _RimMask;

inline fixed4 LightingPseudoBRDF (MySurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
{
	// Half vector
	fixed3 halfDir = normalize (lightDir + viewDir);
	
	// N.L
	fixed NdotL = dot (s.Normal, lightDir);
	// N.H
	fixed NdotH = dot (s.Normal, halfDir);
	
	// remap N.L from [-1..1] to [0..1]
	// this way we can shade pixels facing away from the light - helps to simulate bounce lights
	fixed biasNdotL = NdotL * 0.5 + 0.5;
	
	// lookup light texture
	//  rgb = diffuse term
	//    a = specular term
	fixed4 l = tex2D (_BRDFTex, fixed2(biasNdotL, NdotH));

	fixed4 c;
	// mask specular term by Gloss factor
	// modulate specular with Albedo to allow metalic-ish look
	c.rgb = s.Albedo * (l.rgb + s.Gloss * l.a) * 2;
	c.a = 0;
	
	return c;
}


sampler2D _MainTex;
sampler2D _BumpMap;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float3 worldNormal; //internal, required for the WorldNormalVector macro
	INTERNAL_DATA
	float3 viewDir;
};

void surf (Input IN, inout MySurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb;
	o.Gloss = tex.a;
	o.Alpha = tex.a;
	//o.Normal = tex2D(_BumpMap, IN.uv_BumpMap).rgb * 2.0 - 1.0;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	//Rim Light
	float3 worldN = WorldNormalVector (IN, o.Normal);
	//_BackLightDirection= normalize(_BackLightDirection);
	//worldN = normalize(worldN);
	
	float tmpS = dot(normalize(o.Normal), normalize(IN.viewDir));
	float VDN = max(0,min(1.0, tmpS));
	//float VDN = 1;//saturate (dot(normalize(o.Normal), normalize(IN.viewDir)));
//				float fr = saturate(1.0f - pow(VDN, _RimPower)) * _RimPara * saturate(dot(normalize(_BackLightDirection.xyz),worldN));
	

	float tmpsP = dot(normalize(_BackLightDirection.xyz),worldN);
	tmpS = pow((1.0f - VDN), _RimPower);
	float fr = max(0,min(1.0, tmpS))* _RimPara * max(0,min(1.0, tmpsP));
	//float fr = 1;//saturate(pow((1.0f - VDN), _RimPower)) * _RimPara * saturate(dot(normalize(_BackLightDirection.xyz),worldN));
//				float fr = saturate(pow((1.0f - VDN), _RimPower)) * _RimPara * saturate(dot(normalize(_WorldSpaceLightPos0.xyz),worldN));
	//fr = VDN;
	half4 rimMask = tex2D( _RimMask, IN.uv_MainTex );
	half3 rimLight = fr* _RimColor * rimMask.r;
	o.Emission += rimLight;
	//o.Emission = fr.xxx;
}
ENDCG

	}

FallBack "Mobile/Diffuse"
}
