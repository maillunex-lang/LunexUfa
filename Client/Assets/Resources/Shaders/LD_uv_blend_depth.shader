// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.30 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.30;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:14,ufog:False,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.8235294,fgcg:0.8539554,fgcb:1,fgca:1,fgde:0.01,fgrn:0,fgrf:500,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:33884,y:32527,varname:node_4013,prsc:2|emission-2616-OUT,alpha-1204-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:33186,y:32311,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:7322,x:32545,y:32829,ptovrint:False,ptlb:U,ptin:_U,varname:node_7322,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:5657,x:32556,y:32925,ptovrint:False,ptlb:V,ptin:_V,varname:node_5657,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Append,id:3134,x:32710,y:32850,varname:node_3134,prsc:2|A-7322-OUT,B-5657-OUT;n:type:ShaderForge.SFN_Tex2d,id:5166,x:33107,y:32502,ptovrint:False,ptlb:wenli,ptin:_wenli,varname:node_5166,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-4924-OUT;n:type:ShaderForge.SFN_Time,id:7139,x:32561,y:32630,varname:node_7139,prsc:2;n:type:ShaderForge.SFN_Multiply,id:6974,x:32878,y:32762,varname:node_6974,prsc:2|A-7139-T,B-3134-OUT;n:type:ShaderForge.SFN_Add,id:4924,x:33037,y:32636,varname:node_4924,prsc:2|A-3305-OUT,B-6974-OUT;n:type:ShaderForge.SFN_TexCoord,id:7083,x:32601,y:32255,varname:node_7083,prsc:2,uv:0;n:type:ShaderForge.SFN_Tex2d,id:308,x:33153,y:32781,ptovrint:False,ptlb:mask,ptin:_mask,varname:node_308,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2616,x:33593,y:32558,varname:node_2616,prsc:2|A-5166-RGB,B-308-RGB,C-1304-RGB,D-4468-OUT;n:type:ShaderForge.SFN_Multiply,id:1204,x:33586,y:32877,varname:node_1204,prsc:2|A-5166-A,B-308-A,C-4468-OUT,D-2524-OUT;n:type:ShaderForge.SFN_Slider,id:4468,x:32932,y:32991,ptovrint:False,ptlb:qiangdu,ptin:_qiangdu,varname:node_4468,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2.350427,max:5;n:type:ShaderForge.SFN_VertexColor,id:1156,x:33072,y:33103,varname:node_1156,prsc:2;n:type:ShaderForge.SFN_Multiply,id:2524,x:33480,y:33098,varname:node_2524,prsc:2|A-1304-A,B-1156-A;n:type:ShaderForge.SFN_TexCoord,id:8581,x:32576,y:32418,varname:node_8581,prsc:2,uv:1;n:type:ShaderForge.SFN_SwitchProperty,id:3305,x:32814,y:32363,ptovrint:False,ptlb:uv,ptin:_uv,varname:node_3305,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7083-UVOUT,B-8581-UVOUT;proporder:1304-5166-308-7322-5657-4468-3305;pass:END;sub:END;*/

Shader "LD/LD_uv_blend_depth" {
    Properties {
        [HDR]_Color ("Color", Color) = (1,1,1,1)
        _wenli ("wenli", 2D) = "white" {}
        _mask ("mask", 2D) = "white" {}
        _U ("U", Float ) = 1
        _V ("V", Float ) = 1
        _qiangdu ("qiangdu", Range(0, 5)) = 2.350427
        [MaterialToggle] _uv ("uv", Float ) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            
            ColorMask RGB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform float _U;
            uniform float _V;
            uniform sampler2D _wenli; uniform float4 _wenli_ST;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            uniform float _qiangdu;
            uniform fixed _uv;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_7139 = _Time + _TimeEditor;
                float2 node_4924 = (lerp( i.uv0, i.uv1, _uv )+(node_7139.g*float2(_U,_V)));
                float4 _wenli_var = tex2D(_wenli,TRANSFORM_TEX(node_4924, _wenli));
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                float3 emissive = (_wenli_var.rgb*_mask_var.rgb*_Color.rgb*_qiangdu);
                float3 finalColor = emissive;
                return fixed4(finalColor,(_wenli_var.a*_mask_var.a*_qiangdu*(_Color.a*i.vertexColor.a)));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
