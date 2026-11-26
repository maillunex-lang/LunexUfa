

Shader "Mobile/Unlit (Supports Lightmap) -Transparent" {
Properties {
	_Color ("Main Color", Color) = (1, 1, 1, 1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_DarkenDegree("***Do not edit***", Float) = 1
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off  ZWrite Off
	LOD 100

	// Non-lightmapped
	Pass {
		Tags { "LightMode" = "Vertex" }
		Lighting Off
		SetTexture [_MainTex] {
		    constantColor [_Color]
		    combine texture * constant
	    } 
		SetTexture [_MainTex] {
		    constantColor ([_DarkenDegree], [_DarkenDegree], [_DarkenDegree], 1)
		    combine previous * constant
	    } 
	}
	
	// Lightmapped, encoded as dLDR
	Pass {
		Tags { "LightMode" = "VertexLM" }

		Lighting Off
		BindChannels {
			Bind "Vertex", vertex
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
			Bind "texcoord", texcoord1 // main uses 1st uv
		}
		
		SetTexture [unity_Lightmap] {
			matrix [unity_LightmapMatrix]
			constantColor [_Color]
			combine texture * constant
		}
		SetTexture [_MainTex] {
			combine texture * previous DOUBLE, texture * primary
		}
		SetTexture [_MainTex] {
		    constantColor ([_DarkenDegree], [_DarkenDegree], [_DarkenDegree], 1)
		    combine previous * constant
	    } 
	}
	
	// Lightmapped, encoded as RGBM
	Pass {
		Tags { "LightMode" = "VertexLMRGBM" }
		
		Lighting Off
		BindChannels {
			Bind "Vertex", vertex
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
			Bind "texcoord", texcoord1 // main uses 1st uv
		}
		
		SetTexture [unity_Lightmap] {
			matrix [unity_LightmapMatrix]
			combine texture * texture alpha DOUBLE
		}

		SetTexture [_MainTex] 
		{
			constantColor [_Color]
			combine previous * constant
		 }

		SetTexture [_MainTex] {
			combine texture * previous QUAD, texture * primary
		}
		SetTexture [_MainTex] {
		    constantColor ([_DarkenDegree], [_DarkenDegree], [_DarkenDegree], 1)
		    combine previous * constant
	    } 
	}	
	

}
}



