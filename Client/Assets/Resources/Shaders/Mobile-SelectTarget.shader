Shader "Mobile/SelectTarget" {
Properties {
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100

	Pass {
		Lighting Off
		SetTexture [_MainTex] {
		    constantColor (1, 0, 0, 1)
		    combine constant
	    } 
	}
}
}