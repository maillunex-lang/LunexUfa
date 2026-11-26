// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

// Unlit shader. Simplest possible textured shader.
// - SUPPORTS lightmap
// - no lighting
// - no per-material color

Shader "Mobile/Unlit (Supports Lightmap, emissive) -Mami" {
Properties {
	_Color ("Main Color", Color) = (2,2, 2, 2)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_EmissiveTex ("Base (RGB)", 2D) = "black" {}
	_DarkenDegree("***Do not edit***", Float) = 1
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	
	// Non-lightmapped
	Pass {
		Tags { "LightMode" = "Vertex" }
		Lighting Off
		SetTexture [_MainTex] {
		    constantColor [_Color]
		    combine texture * constant
	    } 
		SetTexture [_EmissiveTex] {
		    combine previous + texture
	    } 
		SetTexture [_MainTex] {
		    constantColor ([_DarkenDegree], [_DarkenDegree], [_DarkenDegree], 1)
		    combine previous * constant
	    } 
	}
	
	// Lightmapped, encoded as dLDR
    Pass {
    	Tags { "LightMode" = "VertexLM" }
      // Disable lighting, we're only using the lightmap
      Lighting Off
	  
      CGPROGRAM
      // Must be a vert/frag shader, not a surface shader: the necessary variables
      // won't be defined yet for surface shaders.
      #pragma vertex vert
      #pragma fragment frag

	  #pragma multi_compile GRAY_OFF GRAY_ON

      #include "UnityCG.cginc"

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv0 : TEXCOORD0;
		float2 uv1 : TEXCOORD1;
        float2 uv2 : TEXCOORD2;
      };

      struct appdata_lightmap {
        float4 vertex : POSITION;
        float2 texcoord : TEXCOORD0;
        float2 texcoord1 : TEXCOORD1;
      };

      // These are prepopulated by Unity
      // sampler2D unity_Lightmap;
      // float4 unity_LightmapST;

      sampler2D _MainTex;
      float4 _MainTex_ST; // Define this since its expected by TRANSFORM_TEX; it is also pre-populated by Unity.
      sampler2D _EmissiveTex;
      float4 _EmissiveTex_ST; // Define this since its expected by TRANSFORM_TEX; it is also pre-populated by Unity.
      fixed4 _Color;
      fixed  _DarkenDegree;

      v2f vert(appdata_lightmap i) {
        v2f o;
        o.pos = UnityObjectToClipPos(i.vertex);

        // UnityCG.cginc - Transforms 2D UV by scale/bias property
        // #define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
        o.uv0 = TRANSFORM_TEX(i.texcoord, _MainTex);
		o.uv1 = TRANSFORM_TEX(i.texcoord, _EmissiveTex);

        // Use `unity_LightmapST` NOT `unity_Lightmap_ST`
        o.uv2 = i.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        return o;
      }

      half4 frag(v2f i) : COLOR {
        half4 main_color = tex2D(_MainTex, i.uv0);

        // Decodes lightmaps:
        // - doubleLDR encoded on GLES
        // - RGBM encoded with range [0;8] on other platforms using surface shaders
        // inline fixed3 DecodeLightmap(fixed4 color) {
        // #if defined(SHADER_API_GLES) && defined(SHADER_API_MOBILE)
          // return 2.0 * color.rgb;
        // #else
          // return (8.0 * color.a) * color.rgb;
        // #endif
        // }

        main_color.rgb *= DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv2));
		main_color.rgb *= _Color;
		main_color.rgb += tex2D(_EmissiveTex, i.uv1);
		main_color.rgb *= _DarkenDegree;
		#ifdef GRAY_ON
		float3 togray = float3(0.299, 0.587,0.114);
		main_color.rgb = dot(main_color.rgb, togray);
		#endif // GRAY_ON
        return main_color;
      }
      ENDCG
    }
    
    
    // Lightmapped, encoded as RGBM
    Pass {
    	Tags { "LightMode" = "VertexLMRGBM" }
      // Disable lighting, we're only using the lightmap
      Lighting Off
	  
      CGPROGRAM
      // Must be a vert/frag shader, not a surface shader: the necessary variables
      // won't be defined yet for surface shaders.
      #pragma vertex vert
      #pragma fragment frag

	  #pragma multi_compile GRAY_OFF GRAY_ON

      #include "UnityCG.cginc"

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv0 : TEXCOORD0;
		float2 uv1 : TEXCOORD1;
        float2 uv2 : TEXCOORD2;
      };

      struct appdata_lightmap {
        float4 vertex : POSITION;
        float2 texcoord : TEXCOORD0;
        float2 texcoord1 : TEXCOORD1;
      };

      // These are prepopulated by Unity
      // sampler2D unity_Lightmap;
      // float4 unity_LightmapST;

      sampler2D _MainTex;
      float4 _MainTex_ST; // Define this since its expected by TRANSFORM_TEX; it is also pre-populated by Unity.
      sampler2D _EmissiveTex;
      float4 _EmissiveTex_ST; // Define this since its expected by TRANSFORM_TEX; it is also pre-populated by Unity.
      fixed4 _Color;
      fixed  _DarkenDegree;

      v2f vert(appdata_lightmap i) {
        v2f o;
        o.pos = UnityObjectToClipPos(i.vertex);

        // UnityCG.cginc - Transforms 2D UV by scale/bias property
        // #define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
        o.uv0 = TRANSFORM_TEX(i.texcoord, _MainTex);
		o.uv1 = TRANSFORM_TEX(i.texcoord, _EmissiveTex);

        // Use `unity_LightmapST` NOT `unity_Lightmap_ST`
        o.uv2 = i.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        return o;
      }

      half4 frag(v2f i) : COLOR {
        half4 main_color = tex2D(_MainTex, i.uv0);

        // Decodes lightmaps:
        // - doubleLDR encoded on GLES
        // - RGBM encoded with range [0;8] on other platforms using surface shaders
        // inline fixed3 DecodeLightmap(fixed4 color) {
        // #if defined(SHADER_API_GLES) && defined(SHADER_API_MOBILE)
          // return 2.0 * color.rgb;
        // #else
          // return (8.0 * color.a) * color.rgb;
        // #endif
        // }

        main_color.rgb *= DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv2));
		main_color.rgb *= _Color;
		main_color.rgb += tex2D(_EmissiveTex, i.uv1);
		main_color.rgb *= _DarkenDegree;
		#ifdef GRAY_ON
		float3 togray = float3(0.299, 0.587,0.114);
		main_color.rgb = dot(main_color.rgb, togray);
		#endif // GRAY_ON
        return main_color;
      }
      ENDCG
    }
}
}


