// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "lol/FX/animtexture" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NumTexTiles("Number tex tiles", Vector) = (4,4,0,0)
		_ReplaySpeed("Replay speed _FPS",float) = 4
		_Color("Color",Color) = (1,1,1,1)
		_DarkenDegree("***Do not edit***", Float) = 1
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 300
		
		Blend SrcAlpha One
		ZWrite Off Cull Off Lighting Off Fog {Color(0,0,0,0)}
		
		CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float4 _NumTexTiles;
		float _ReplaySpeed;
		float4 _Color;
		float _DarkenDegree;
		
		struct v2f {
			float4 pos : SV_POSITION;
			float4 uv : TEXCOORD0;
			fixed4 col: COLOR;
		};
		
		v2f vert(appdata_full v) {
			v2f o;

			float time =( (1) * 60 + _Time.y ) * _ReplaySpeed ;
			float itime = floor(time);
			float ntime = itime + 1;
			float ftime = time - itime;
			
			float2 texTileSize = 1.0f/_NumTexTiles.xy;
			float4 tile;						
			tile.xy = float2(itime, floor(itime/_NumTexTiles.x));
			tile.zw = float2(ntime, floor(ntime/_NumTexTiles.x));
			
			tile = fmod(tile, _NumTexTiles.xyxy);
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = (v.texcoord.xyxy + tile) * texTileSize.xyxy;

			o.col = fixed4(v.color.xyz * _Color * _DarkenDegree,ftime);
			
			
			return o;
		}
		
		
		ENDCG
		
		
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
			
			float4 frag(v2f IN) : COLOR {
				half4 c = lerp(tex2D (_MainTex, IN.uv.xy),tex2D (_MainTex, IN.uv.zw),IN.col.a) * IN.col;
				return c;
//				return IN.col;
				
			}
			ENDCG
		}
	}
}