// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:14,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:33741,y:32672,varname:node_4013,prsc:2|emission-9439-OUT,alpha-2802-A;n:type:ShaderForge.SFN_Tex2d,id:3920,x:32884,y:32571,ptovrint:False,ptlb:wenli,ptin:_wenli,varname:node_7034,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-8698-OUT;n:type:ShaderForge.SFN_Color,id:1102,x:32787,y:32871,ptovrint:False,ptlb:wenli_color,ptin:_wenli_color,varname:node_6687,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:7898,x:32380,y:32878,ptovrint:False,ptlb:liuguang,ptin:_liuguang,varname:node_611,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-7208-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:4568,x:32192,y:32369,varname:node_4568,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:8698,x:32590,y:32619,varname:node_8698,prsc:2|A-4568-UVOUT,B-6847-OUT,C-7898-RGB;n:type:ShaderForge.SFN_Multiply,id:6847,x:32192,y:32697,varname:node_6847,prsc:2|A-1443-T,B-2598-OUT;n:type:ShaderForge.SFN_Append,id:2598,x:31971,y:32747,varname:node_2598,prsc:2|A-3321-OUT,B-5470-OUT;n:type:ShaderForge.SFN_Time,id:1443,x:31814,y:32552,varname:node_1443,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:3321,x:31714,y:32760,ptovrint:False,ptlb:u_copy,ptin:_u_copy,varname:_u_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:5470,x:31736,y:32894,ptovrint:False,ptlb:v_copy,ptin:_v_copy,varname:_v_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:7208,x:32142,y:32853,varname:node_7208,prsc:2,uv:0;n:type:ShaderForge.SFN_VertexColor,id:2802,x:33209,y:33153,varname:node_2802,prsc:2;n:type:ShaderForge.SFN_Multiply,id:9439,x:33300,y:32683,varname:node_9439,prsc:2|A-3920-RGB,B-1102-RGB,C-1102-A;proporder:7898-1102-3920-3321-5470;pass:END;sub:END;*/

Shader "LD/LD_bing" {
    Properties {
        _liuguang ("liuguang", 2D) = "white" {}
        [HDR]_wenli_color ("wenli_color", Color) = (0.5,0.5,0.5,1)
        _wenli ("wenli", 2D) = "white" {}
        _u_copy ("u_copy", Float ) = 0
        _v_copy ("v_copy", Float ) = 0
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
            ZWrite Off
            ColorMask RGB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _wenli; uniform float4 _wenli_ST;
            uniform float4 _wenli_color;
            uniform sampler2D _liuguang; uniform float4 _liuguang_ST;
            uniform float _u_copy;
            uniform float _v_copy;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_1443 = _Time + _TimeEditor;
                float4 _liuguang_var = tex2D(_liuguang,TRANSFORM_TEX(i.uv0, _liuguang));
                float3 node_8698 = (float3(i.uv0,0.0)+float3((node_1443.g*float2(_u_copy,_v_copy)),0.0)+_liuguang_var.rgb);
                float4 _wenli_var = tex2D(_wenli,TRANSFORM_TEX(node_8698, _wenli));
                float3 emissive = (_wenli_var.rgb*_wenli_color.rgb*_wenli_color.a);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,i.vertexColor.a);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
