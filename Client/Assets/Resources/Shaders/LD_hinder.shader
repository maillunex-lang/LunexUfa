// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:3,spmd:0,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.1357353,fgcg:0.1797034,fgcb:0.284,fgca:1,fgde:0.01,fgrn:10,fgrf:50,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1168,x:33823,y:32900,varname:node_1168,prsc:2|emission-4203-OUT;n:type:ShaderForge.SFN_Tex2d,id:9588,x:31760,y:32727,ptovrint:False,ptlb:Texture,ptin:_Texture,varname:node_9588,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-8912-OUT;n:type:ShaderForge.SFN_TexCoord,id:7960,x:31181,y:32606,varname:node_7960,prsc:2,uv:0;n:type:ShaderForge.SFN_Time,id:3610,x:30966,y:32816,varname:node_3610,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3255,x:31274,y:32814,varname:node_3255,prsc:2|A-3610-T,B-6647-OUT;n:type:ShaderForge.SFN_Append,id:6647,x:31075,y:32962,varname:node_6647,prsc:2|A-3960-OUT,B-412-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3960,x:30875,y:33022,ptovrint:False,ptlb:Speed_U,ptin:_Speed_U,varname:node_3960,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:412,x:30891,y:33141,ptovrint:False,ptlb:Speed_V,ptin:_Speed_V,varname:node_412,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Add,id:8912,x:31559,y:32707,varname:node_8912,prsc:2|A-7960-UVOUT,B-3255-OUT,C-1327-OUT;n:type:ShaderForge.SFN_Color,id:1140,x:31780,y:33003,ptovrint:False,ptlb:color,ptin:_color,varname:node_1140,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:9339,x:32233,y:32999,varname:node_9339,prsc:2|A-9185-OUT,B-1140-RGB,C-1140-A,D-5235-OUT;n:type:ShaderForge.SFN_Slider,id:5235,x:31662,y:33197,ptovrint:False,ptlb:Intensity,ptin:_Intensity,varname:node_5235,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;n:type:ShaderForge.SFN_Tex2d,id:9878,x:32109,y:33235,ptovrint:False,ptlb:fuwen,ptin:_fuwen,varname:node_9878,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:4203,x:32895,y:33199,varname:node_4203,prsc:2|A-9339-OUT,B-9749-OUT;n:type:ShaderForge.SFN_Slider,id:4340,x:32049,y:33488,ptovrint:False,ptlb:fw_Intensity,ptin:_fw_Intensity,varname:node_4340,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-5,cur:-0.1282048,max:5;n:type:ShaderForge.SFN_Multiply,id:9185,x:32248,y:32604,varname:node_9185,prsc:2|A-65-RGB,B-2536-OUT;n:type:ShaderForge.SFN_Tex2d,id:65,x:31749,y:32492,ptovrint:False,ptlb:mask,ptin:_mask,varname:node_65,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:9749,x:32576,y:33365,varname:node_9749,prsc:2|A-4622-OUT,B-4340-OUT,C-6494-RGB,D-6494-A;n:type:ShaderForge.SFN_Color,id:6494,x:32264,y:33591,ptovrint:False,ptlb:fw,ptin:_fw,varname:node_6494,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2514,x:31278,y:33099,ptovrint:False,ptlb:node_2514,ptin:_node_2514,varname:node_2514,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:1327,x:31559,y:32946,varname:node_1327,prsc:2|A-2514-RGB,B-8787-OUT;n:type:ShaderForge.SFN_Slider,id:8787,x:31228,y:33308,ptovrint:False,ptlb:niuqu,ptin:_niuqu,varname:node_8787,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:2536,x:32010,y:32744,varname:node_2536,prsc:2|A-9588-RGB,B-9588-A;n:type:ShaderForge.SFN_Multiply,id:4622,x:32395,y:33308,varname:node_4622,prsc:2|A-9878-RGB,B-9878-A;proporder:1140-9588-412-3960-5235-6494-9878-4340-8787-65-2514;pass:END;sub:END;*/

Shader "LD/LD_hidner" {
    Properties {
        _color ("color", Color) = (0.5,0.5,0.5,1)
        _Texture ("Texture", 2D) = "white" {}
        _Speed_V ("Speed_V", Float ) = 0
        _Speed_U ("Speed_U", Float ) = 1
        _Intensity ("Intensity", Range(0, 5)) = 0
        _fw ("fw", Color) = (0.5,0.5,0.5,1)
        _fuwen ("fuwen", 2D) = "white" {}
        _fw_Intensity ("fw_Intensity", Range(-5, 5)) = -0.1282048
        _niuqu ("niuqu", Range(0, 1)) = 0
        _mask ("mask", 2D) = "white" {}
        _node_2514 ("node_2514", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform float _Speed_U;
            uniform float _Speed_V;
            uniform float4 _color;
            uniform float _Intensity;
            uniform sampler2D _fuwen; uniform float4 _fuwen_ST;
            uniform float _fw_Intensity;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            uniform float4 _fw;
            uniform sampler2D _node_2514; uniform float4 _node_2514_ST;
            uniform float _niuqu;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
////// Lighting:
////// Emissive:
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                float4 node_3610 = _Time + _TimeEditor;
                float4 _node_2514_var = tex2D(_node_2514,TRANSFORM_TEX(i.uv0, _node_2514));
                float3 node_8912 = (float3(i.uv0,0.0)+float3((node_3610.g*float2(_Speed_U,_Speed_V)),0.0)+(_node_2514_var.rgb*_niuqu));
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(node_8912, _Texture));
                float4 _fuwen_var = tex2D(_fuwen,TRANSFORM_TEX(i.uv0, _fuwen));
                float3 emissive = (((_mask_var.rgb*(_Texture_var.rgb*_Texture_var.a))*_color.rgb*_color.a*_Intensity)+((_fuwen_var.rgb*_fuwen_var.a)*_fw_Intensity*_fw.rgb*_fw.a));
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
