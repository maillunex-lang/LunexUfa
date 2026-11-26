// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:33588,y:32423,varname:node_4013,prsc:2|emission-6730-OUT,alpha-9571-A,clip-7440-OUT;n:type:ShaderForge.SFN_TexCoord,id:1810,x:31878,y:32716,varname:node_1810,prsc:2,uv:0;n:type:ShaderForge.SFN_Panner,id:3613,x:32114,y:32686,varname:node_3613,prsc:2,spu:-1,spv:0.5|UVIN-1810-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:8304,x:32388,y:32705,ptovrint:False,ptlb:wenli01,ptin:_wenli01,varname:node_8304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-3613-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:8865,x:32422,y:32929,ptovrint:False,ptlb:wenli02,ptin:_wenli02,varname:node_8865,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b82836ae3a73fd84c9d5b2a24c319895,ntxv:0,isnm:False|UVIN-3613-UVOUT;n:type:ShaderForge.SFN_Multiply,id:6392,x:32606,y:32775,varname:node_6392,prsc:2|A-8304-R,B-8865-R;n:type:ShaderForge.SFN_Tex2d,id:684,x:32622,y:32956,ptovrint:False,ptlb:mask,ptin:_mask,varname:node_684,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:4523,x:32838,y:32775,varname:node_4523,prsc:2|A-6392-OUT,B-684-R,C-5528-OUT;n:type:ShaderForge.SFN_Multiply,id:5726,x:33080,y:32574,varname:node_5726,prsc:2|A-8628-A,B-4523-OUT;n:type:ShaderForge.SFN_VertexColor,id:8628,x:32720,y:32479,varname:node_8628,prsc:2;n:type:ShaderForge.SFN_Multiply,id:6730,x:33237,y:32418,varname:node_6730,prsc:2|A-9571-RGB,B-5726-OUT;n:type:ShaderForge.SFN_Color,id:9571,x:32935,y:32325,ptovrint:False,ptlb:node_9571,ptin:_node_9571,varname:node_9571,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:7440,x:33280,y:32720,varname:node_7440,prsc:2|A-5726-OUT,B-8628-A;n:type:ShaderForge.SFN_Slider,id:5528,x:32544,y:33153,ptovrint:False,ptlb:node_5528,ptin:_node_5528,varname:node_5528,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;proporder:8304-8865-684-9571-5528;pass:END;sub:END;*/

Shader "LD/LD_yuanhuan_kuosan" {
    Properties {
        _wenli01 ("wenli01", 2D) = "white" {}
        _wenli02 ("wenli02", 2D) = "white" {}
        _mask ("mask", 2D) = "white" {}
        _node_9571 ("node_9571", Color) = (0.5,0.5,0.5,1)
        _node_5528 ("node_5528", Range(0, 5)) = 0
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
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _wenli01; uniform float4 _wenli01_ST;
            uniform sampler2D _wenli02; uniform float4 _wenli02_ST;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            uniform float4 _node_9571;
            uniform float _node_5528;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 node_2834 = _Time + _TimeEditor;
                float2 node_3613 = (i.uv0+node_2834.g*float2(-1,0.5));
                float4 _wenli01_var = tex2D(_wenli01,TRANSFORM_TEX(node_3613, _wenli01));
                float4 _wenli02_var = tex2D(_wenli02,TRANSFORM_TEX(node_3613, _wenli02));
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                float node_5726 = (i.vertexColor.a*((_wenli01_var.r*_wenli02_var.r)*_mask_var.r*_node_5528));
                clip((node_5726*i.vertexColor.a) - 0.5);
////// Lighting:
////// Emissive:
                float3 emissive = (_node_9571.rgb*node_5726);
                float3 finalColor = emissive;
                return fixed4(finalColor,_node_9571.a);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _wenli01; uniform float4 _wenli01_ST;
            uniform sampler2D _wenli02; uniform float4 _wenli02_ST;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            uniform float _node_5528;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 node_2766 = _Time + _TimeEditor;
                float2 node_3613 = (i.uv0+node_2766.g*float2(-1,0.5));
                float4 _wenli01_var = tex2D(_wenli01,TRANSFORM_TEX(node_3613, _wenli01));
                float4 _wenli02_var = tex2D(_wenli02,TRANSFORM_TEX(node_3613, _wenli02));
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                float node_5726 = (i.vertexColor.a*((_wenli01_var.r*_wenli02_var.r)*_mask_var.r*_node_5528));
                clip((node_5726*i.vertexColor.a) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
