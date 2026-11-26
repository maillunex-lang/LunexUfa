// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.30 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.30;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:14,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.04844289,fgcg:0.1561627,fgcb:0.4705882,fgca:1,fgde:0.01,fgrn:7.81,fgrf:46.3,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:33741,y:32672,varname:node_4013,prsc:2|emission-4641-OUT,alpha-2802-A;n:type:ShaderForge.SFN_Tex2d,id:5708,x:32371,y:32534,ptovrint:False,ptlb:liuguang01,ptin:_liuguang01,varname:_liuguang01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:0622471c47a961f4bae23af749bd83ff,ntxv:0,isnm:False|UVIN-190-OUT;n:type:ShaderForge.SFN_TexCoord,id:7909,x:31376,y:32346,varname:node_7909,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:190,x:32066,y:32478,varname:node_190,prsc:2|A-7909-UVOUT,B-9085-OUT,C-7898-RGB;n:type:ShaderForge.SFN_Multiply,id:9085,x:31590,y:32607,varname:node_9085,prsc:2|A-9669-T,B-6368-OUT;n:type:ShaderForge.SFN_Append,id:6368,x:31361,y:32668,varname:node_6368,prsc:2|A-5987-OUT,B-8095-OUT;n:type:ShaderForge.SFN_Time,id:9669,x:31130,y:32473,varname:node_9669,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:5987,x:31069,y:32659,ptovrint:False,ptlb:u,ptin:_u,varname:_u,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_ValueProperty,id:8095,x:31087,y:32897,ptovrint:False,ptlb:v,ptin:_v,varname:_v,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Color,id:6260,x:32056,y:32223,ptovrint:False,ptlb:liuguang_color,ptin:_liuguang_color,varname:_liuguang_color,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:8314,x:32939,y:32490,varname:node_8314,prsc:2|A-6260-RGB,B-6260-A,C-5708-RGB;n:type:ShaderForge.SFN_Add,id:4641,x:33297,y:32655,varname:node_4641,prsc:2|A-8314-OUT,B-8229-OUT;n:type:ShaderForge.SFN_Tex2d,id:3920,x:32382,y:32750,ptovrint:False,ptlb:wenli,ptin:_wenli,varname:_wenli,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b577aea7f6772194b99f755b80969942,ntxv:0,isnm:False|UVIN-8698-OUT;n:type:ShaderForge.SFN_Multiply,id:8229,x:33012,y:32723,varname:node_8229,prsc:2|A-3920-RGB,B-1102-RGB;n:type:ShaderForge.SFN_Color,id:1102,x:32382,y:32971,ptovrint:False,ptlb:wenli_color,ptin:_wenli_color,varname:_wenli_color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:7898,x:31815,y:32800,ptovrint:False,ptlb:liuguang,ptin:_liuguang,varname:_liuguang,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:4eb1efe1565d1e44b987e8d119b2bc2a,ntxv:0,isnm:False|UVIN-7208-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:4568,x:31617,y:33084,varname:node_4568,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:8698,x:32149,y:32957,varname:node_8698,prsc:2|A-7898-RGB,B-4568-UVOUT,C-6847-OUT;n:type:ShaderForge.SFN_Multiply,id:6847,x:31646,y:33246,varname:node_6847,prsc:2|A-1443-T,B-2598-OUT;n:type:ShaderForge.SFN_Append,id:2598,x:31414,y:33310,varname:node_2598,prsc:2|A-3321-OUT,B-5470-OUT;n:type:ShaderForge.SFN_Time,id:1443,x:31268,y:33101,varname:node_1443,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:3321,x:31179,y:33323,ptovrint:False,ptlb:u_copy,ptin:_u_copy,varname:_u_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:5470,x:31179,y:33457,ptovrint:False,ptlb:v_copy,ptin:_v_copy,varname:_v_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_TexCoord,id:7208,x:31481,y:32843,varname:node_7208,prsc:2,uv:0;n:type:ShaderForge.SFN_VertexColor,id:2802,x:32924,y:33109,varname:node_2802,prsc:2;n:type:ShaderForge.SFN_Slider,id:6908,x:32874,y:33014,ptovrint:False,ptlb:Alpha,ptin:_Alpha,varname:_Alpha,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.7524226,max:1;proporder:6908-6260-7898-5708-5987-8095-1102-3920-3321-5470;pass:END;sub:END;*/

Shader "LD/LD_water" {
    Properties {
        _Alpha ("Alpha", Range(0, 1)) = 0.7524226
        [HDR]_liuguang_color ("liuguang_color", Color) = (0.5,0.5,0.5,1)
        _liuguang ("liuguang", 2D) = "white" {}
        _liuguang01 ("liuguang01", 2D) = "white" {}
        _u ("u", Float ) = 0.1
        _v ("v", Float ) = 0
        _wenli_color ("wenli_color", Color) = (0.5,0.5,0.5,1)
        _wenli ("wenli", 2D) = "white" {}
        _u_copy ("u_copy", Float ) = 0
        _v_copy ("v_copy", Float ) = 0.1
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
            uniform sampler2D _liuguang01; uniform float4 _liuguang01_ST;
            uniform float _u;
            uniform float _v;
            uniform float4 _liuguang_color;
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
                float4 node_9669 = _Time + _TimeEditor;
                float4 _liuguang_var = tex2D(_liuguang,TRANSFORM_TEX(i.uv0, _liuguang));
                float3 node_190 = (float3(i.uv0,0.0)+float3((node_9669.g*float2(_u,_v)),0.0)+_liuguang_var.rgb);
                float4 _liuguang01_var = tex2D(_liuguang01,TRANSFORM_TEX(node_190, _liuguang01));
                float4 node_1443 = _Time + _TimeEditor;
                float3 node_8698 = (_liuguang_var.rgb+float3(i.uv0,0.0)+float3((node_1443.g*float2(_u_copy,_v_copy)),0.0));
                float4 _wenli_var = tex2D(_wenli,TRANSFORM_TEX(node_8698, _wenli));
                float3 emissive = ((_liuguang_color.rgb*_liuguang_color.a*_liuguang01_var.rgb)+(_wenli_var.rgb*_wenli_color.rgb));
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
