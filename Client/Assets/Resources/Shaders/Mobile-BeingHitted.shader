
Shader "Mobile/BeingHitted" {
Properties {
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100

	Pass {
		Lighting Off
		SetTexture [_MainTex] {
		    constantColor (0.4, 0.1, 0.1, 1)
		    combine constant
	    } 
	}
}
}
