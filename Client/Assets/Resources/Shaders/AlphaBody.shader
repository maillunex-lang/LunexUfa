Shader "SG/AlphaBody" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap("Bumpmap", 2D) = "bump" {}
		_AmbientColor ("Ambient Color", Color) = (0.1, 0.1, 0.1, 1.0)
		_SpecularColor ("Specular Color", Color) = (0.12, 0.31, 0.47, 1.0)
		_Glossiness ("Gloss", Range(1.0,512.0)) = 80.0
		_RimColor ("Rim Color", Color) = (0.12, 0.31, 0.47, 1.0)
		_RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0
		_Ramp ("Shading Ramp", 2D) = "gray" {}
		_BodyAlpha ("Body Alpha", Range(0, 1.0)) = 1.0
	}
	SubShader {
		Tags { 
		"Queue" = "Transparent"
		"RenderType"="Transparent" 
		}
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma surface surf CustomBlinnPhong exclude_path:prepass

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _Ramp;
		
		fixed4 _AmbientColor;
		fixed4 _SpecularColor;
		half _Glossiness;
		
		fixed4 _RimColor;
		half _RimPower;
		half _BodyAlpha;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			half3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a * _BodyAlpha;
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));

			fixed tmpS = dot (normalize(IN.viewDir), o.Normal);
			fixed rim = max(0,min(1.0, tmpS));
			//fixed rim = 1.0 ;//- saturate (dot (normalize(IN.viewDir), o.Normal));
			o.Emission = (_RimColor.rgb * pow (rim, _RimPower));
		}
		inline fixed4 LightingCustomBlinnPhong (SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten) 
		{
			fixed3 ambient = s.Albedo * _AmbientColor.rgb;

			fixed tmpS = dot (s.Normal, lightDir);
			fixed NdotL = max(0,min(1.0, tmpS));
			//fixed NdotL = 1;//saturate(dot (s.Normal, lightDir)); 
			fixed diff = NdotL * 0.5 + 0.5;
			fixed3 ramp = tex2D (_Ramp, float2(diff, diff)).rgb;
			fixed3 diffuse = s.Albedo * _LightColor0.rgb * ramp;
					
			fixed3 h = normalize (lightDir + viewDir); 

			tmpS = dot (s.Normal, h);
			fixed nh = max(0,min(1.0, tmpS));
			//float nh = 1;//saturate(dot (s.Normal, h)); 
			float specPower = pow (nh, _Glossiness);
			fixed3 specular = _LightColor0.rgb * specPower * _SpecularColor.rgb;

			fixed4 c;
			c.rgb = (ambient + diffuse + specular) * (atten * 2);
			c.a = s.Alpha + (_LightColor0.a * _SpecularColor.a * specPower * atten);

			return c;
		}
		ENDCG
		
		
	} 
	FallBack "Diffuse"
}
