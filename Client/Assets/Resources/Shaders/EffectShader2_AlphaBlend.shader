
// by artsyli

Shader "Effect_Back/Alpha Blend" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_Brightness ("Brightness", Float) = 1.0
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MaskTex ("Mask Texture (A)", 2D) = "white" {}
        _UVParam ("UV Param", Vector) = (0, 0, 1, 1)
        _UVTile ("UV Tile", Vector) = (0, 0, 1, 1)
        _Rotate ("UV Rotate", Range (0, 6.2831853)) = 0.0
        _MaskUVParam ("Mask UV Param", Vector) = (0, 0, 1, 1)
        _MaskRotate ("Mask UV Rotate", Range (0, 6.2831853)) = 0.0
		_DarkenDegree("***Do not edit***", Float) = 1
	}
	SubShader 
	{
		Tags 
		{ 
			"Queue"="Transparent+1"
			"IgnoreProjector"="True"
			"RenderType"="Transparent" 
		}
		UsePass "Effect_Mid/Alpha Blend/EFFECT"
	}
	FallBack "Diffuse-Mami"
	CustomEditor "EffectMaterialEd"
}
