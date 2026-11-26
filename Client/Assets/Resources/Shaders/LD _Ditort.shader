// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:14,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.308391,fgcg:0.4784692,fgcb:0.6764706,fgca:1,fgde:0.01,fgrn:10,fgrf:100,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:32984,y:32611,varname:node_4013,prsc:2|alpha-2364-OUT,refract-3057-OUT;n:type:ShaderForge.SFN_Vector1,id:2364,x:32667,y:32802,varname:node_2364,prsc:2,v1:0;n:type:ShaderForge.SFN_TexCoord,id:9855,x:31505,y:32754,varname:node_9855,prsc:2,uv:0;n:type:ShaderForge.SFN_ComponentMask,id:8453,x:32430,y:32890,varname:node_8453,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-8778-OUT;n:type:ShaderForge.SFN_Slider,id:224,x:32039,y:33078,ptovrint:False,ptlb:RefractionTNT,ptin:_RefractionTNT,varname:node_224,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:0.2;n:type:ShaderForge.SFN_Multiply,id:2341,x:32568,y:33128,varname:node_2341,prsc:2|A-224-OUT,B-7915-OUT;n:type:ShaderForge.SFN_Vector1,id:7915,x:32260,y:33351,varname:node_7915,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Multiply,id:3057,x:32657,y:32942,varname:node_3057,prsc:2|A-8453-OUT,B-2341-OUT;n:type:ShaderForge.SFN_ValueProperty,id:23,x:31517,y:33254,ptovrint:False,ptlb:U,ptin:_U,varname:node_23,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_ValueProperty,id:9266,x:31491,y:33384,ptovrint:False,ptlb:V,ptin:_V,varname:node_9266,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Append,id:3347,x:31717,y:33311,varname:node_3347,prsc:2|A-23-OUT,B-9266-OUT;n:type:ShaderForge.SFN_Time,id:7163,x:31386,y:33007,varname:node_7163,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4153,x:31748,y:33077,varname:node_4153,prsc:2|A-7163-T,B-3347-OUT;n:type:ShaderForge.SFN_Tex2d,id:466,x:32030,y:32742,ptovrint:False,ptlb:node_466,ptin:_node_466,varname:node_466,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6529-OUT;n:type:ShaderForge.SFN_Add,id:6529,x:31768,y:32821,varname:node_6529,prsc:2|A-9855-UVOUT,B-4153-OUT;n:type:ShaderForge.SFN_Multiply,id:8778,x:32215,y:32821,varname:node_8778,prsc:2|A-466-RGB,B-466-A;proporder:224-23-9266-466;pass:END;sub:END;*/

Shader "LD/LD_Ditort" {
    Properties {
        _RefractionTNT ("RefractionTNT", Range(0, 0.2)) = 0
        _U ("U", Float ) = 0.5
        _V ("V", Float ) = 0.5
        _node_466 ("node_466", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
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
            uniform sampler2D _GrabTexture;
            uniform float4 _TimeEditor;
            uniform float _RefractionTNT;
            uniform float _U;
            uniform float _V;
            uniform sampler2D _node_466; uniform float4 _node_466_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float4 node_7163 = _Time + _TimeEditor;
                float2 node_6529 = (i.uv0+(node_7163.g*float2(_U,_V)));
                float4 _node_466_var = tex2D(_node_466,TRANSFORM_TEX(node_6529, _node_466));
                float node_3057 = ((_node_466_var.rgb*_node_466_var.a).r*(_RefractionTNT*0.1));
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + float2(node_3057,node_3057);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
                float3 finalColor = 0;
                return fixed4(lerp(sceneColor.rgb, finalColor,0.0),1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
