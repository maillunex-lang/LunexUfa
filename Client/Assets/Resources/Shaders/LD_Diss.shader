// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:14,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:9361,x:34737,y:32222,varname:node_9361,prsc:2|emission-7828-OUT,alpha-2249-OUT,clip-8999-OUT;n:type:ShaderForge.SFN_Tex2d,id:7904,x:32965,y:32064,ptovrint:False,ptlb:node_7904,ptin:_node_7904,varname:node_7904,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:7828,x:33300,y:32256,varname:node_7828,prsc:2|A-7904-RGB,B-6587-RGB,C-5661-RGB,D-5275-OUT;n:type:ShaderForge.SFN_VertexColor,id:6587,x:32922,y:32312,varname:node_6587,prsc:2;n:type:ShaderForge.SFN_Color,id:5661,x:32949,y:32503,ptovrint:False,ptlb:node_5661,ptin:_node_5661,varname:node_5661,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Vector1,id:5275,x:33016,y:32686,varname:node_5275,prsc:2,v1:2;n:type:ShaderForge.SFN_Multiply,id:2448,x:33377,y:32439,varname:node_2448,prsc:2|A-7904-A,B-6587-A,C-5661-A,D-6172-OUT;n:type:ShaderForge.SFN_Tex2d,id:9364,x:32981,y:32797,ptovrint:False,ptlb:node_9364,ptin:_node_9364,varname:node_9364,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6265-UVOUT;n:type:ShaderForge.SFN_Desaturate,id:9470,x:33216,y:32799,varname:node_9470,prsc:2|COL-9364-RGB;n:type:ShaderForge.SFN_Multiply,id:6172,x:33438,y:32799,varname:node_6172,prsc:2|A-9470-OUT,B-9364-A;n:type:ShaderForge.SFN_SwitchProperty,id:2249,x:33688,y:32365,ptovrint:False,ptlb:node_2249,ptin:_node_2249,varname:node_2249,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-1383-OUT,B-2448-OUT;n:type:ShaderForge.SFN_Vector1,id:1383,x:33433,y:32191,varname:node_1383,prsc:2,v1:1;n:type:ShaderForge.SFN_Slider,id:561,x:33785,y:32550,ptovrint:False,ptlb:node_561,ptin:_node_561,varname:node_561,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Step,id:8999,x:33879,y:32792,varname:node_8999,prsc:2|A-561-OUT,B-2448-OUT;n:type:ShaderForge.SFN_TexCoord,id:2188,x:32506,y:32771,varname:node_2188,prsc:2,uv:0;n:type:ShaderForge.SFN_Panner,id:6265,x:32743,y:32763,varname:node_6265,prsc:2,spu:0.1,spv:0.1|UVIN-2188-UVOUT;proporder:7904-5661-9364-2249-561;pass:END;sub:END;*/

Shader "LD/LD_Diss" {
    Properties {
        _node_7904 ("node_7904", 2D) = "white" {}
        _node_5661 ("node_5661", Color) = (0.5,0.5,0.5,1)
        _node_9364 ("node_9364", 2D) = "white" {}
        [MaterialToggle] _node_2249 ("node_2249", Float ) = 1
        _node_561 ("node_561", Range(0, 1)) = 0
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
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _node_7904; uniform float4 _node_7904_ST;
            uniform float4 _node_5661;
            uniform sampler2D _node_9364; uniform float4 _node_9364_ST;
            uniform fixed _node_2249;
            uniform float _node_561;
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
                float4 _node_7904_var = tex2D(_node_7904,TRANSFORM_TEX(i.uv0, _node_7904));
                float4 node_8268 = _Time + _TimeEditor;
                float2 node_6265 = (i.uv0+node_8268.g*float2(0.1,0.1));
                float4 _node_9364_var = tex2D(_node_9364,TRANSFORM_TEX(node_6265, _node_9364));
                float node_2448 = (_node_7904_var.a*i.vertexColor.a*_node_5661.a*(dot(_node_9364_var.rgb,float3(0.3,0.59,0.11))*_node_9364_var.a));
                clip(step(_node_561,node_2448) - 0.5);
////// Lighting:
////// Emissive:
                float3 emissive = (_node_7904_var.rgb*i.vertexColor.rgb*_node_5661.rgb*2.0);
                float3 finalColor = emissive;
                return fixed4(finalColor,lerp( 1.0, node_2448, _node_2249 ));
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            ColorMask RGB
            
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
            uniform sampler2D _node_7904; uniform float4 _node_7904_ST;
            uniform float4 _node_5661;
            uniform sampler2D _node_9364; uniform float4 _node_9364_ST;
            uniform float _node_561;
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
                float4 _node_7904_var = tex2D(_node_7904,TRANSFORM_TEX(i.uv0, _node_7904));
                float4 node_2804 = _Time + _TimeEditor;
                float2 node_6265 = (i.uv0+node_2804.g*float2(0.1,0.1));
                float4 _node_9364_var = tex2D(_node_9364,TRANSFORM_TEX(node_6265, _node_9364));
                float node_2448 = (_node_7904_var.a*i.vertexColor.a*_node_5661.a*(dot(_node_9364_var.rgb,float3(0.3,0.59,0.11))*_node_9364_var.a));
                clip(step(_node_561,node_2448) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
