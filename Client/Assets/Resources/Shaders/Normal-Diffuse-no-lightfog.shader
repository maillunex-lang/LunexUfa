Shader "Diffuse-no-lightfog" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_DarkenDegree("***Do not edit***", Float) = 1
}
 

SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass{
		Fog{ Mode Off }
		Lighting Off
		SetTexture[_MainTex]{ combine texture }
		SetTexture[_MainTex]
	{
		ConstantColor[_Color]
		 
	}
	}

}

Fallback "VertexLit"
}
