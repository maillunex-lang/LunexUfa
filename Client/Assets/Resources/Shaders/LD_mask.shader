// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.30 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.30;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:14,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3138,x:33185,y:32666,varname:node_3138,prsc:2|custl-5179-OUT,alpha-6938-OUT;n:type:ShaderForge.SFN_TexCoord,id:4223,x:29891,y:32482,varname:node_4223,prsc:2,uv:0;n:type:ShaderForge.SFN_Panner,id:9077,x:30279,y:32525,varname:node_9077,prsc:2,spu:-0.2,spv:-0.1|UVIN-4223-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:6486,x:31093,y:33504,ptovrint:False,ptlb:FlowMap,ptin:_FlowMap,varname:_FlowMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-277-OUT;n:type:ShaderForge.SFN_TexCoord,id:8316,x:30060,y:33976,varname:node_8316,prsc:2,uv:0;n:type:ShaderForge.SFN_Panner,id:5199,x:30273,y:33975,varname:node_5199,prsc:2,spu:-0.1,spv:0.05|UVIN-8316-UVOUT;n:type:ShaderForge.SFN_Multiply,id:8208,x:32116,y:32841,varname:node_8208,prsc:2|A-1500-RGB,B-7999-OUT;n:type:ShaderForge.SFN_Multiply,id:6938,x:32908,y:33080,varname:node_6938,prsc:2|A-8431-OUT,B-4439-OUT;n:type:ShaderForge.SFN_Color,id:4065,x:32217,y:33478,ptovrint:False,ptlb:Color,ptin:_Color,varname:_Color,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:9680,x:32433,y:32883,varname:node_9680,prsc:2|A-8208-OUT,B-4439-OUT,C-4065-RGB;n:type:ShaderForge.SFN_ComponentMask,id:8431,x:32875,y:32822,varname:node_8431,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-5179-OUT;n:type:ShaderForge.SFN_OneMinus,id:4912,x:32129,y:32512,varname:node_4912,prsc:2|IN-1889-OUT;n:type:ShaderForge.SFN_Add,id:5179,x:32630,y:32695,varname:node_5179,prsc:2|A-7814-OUT,B-9680-OUT,C-6335-RGB;n:type:ShaderForge.SFN_Multiply,id:7814,x:32413,y:32583,varname:node_7814,prsc:2|A-4912-OUT,B-7999-OUT,C-4439-OUT,D-9567-RGB;n:type:ShaderForge.SFN_Tex2d,id:6335,x:32430,y:33176,ptovrint:False,ptlb:Specularmap,ptin:_Specularmap,varname:_Specularmap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:d4498fac62ac7d84c872413c3aa22fca,ntxv:0,isnm:False;n:type:ShaderForge.SFN_TexCoord,id:3424,x:29397,y:32560,varname:node_3424,prsc:2,uv:0;n:type:ShaderForge.SFN_Distance,id:1656,x:29727,y:32614,varname:node_1656,prsc:2|A-3424-UVOUT,B-9936-OUT;n:type:ShaderForge.SFN_Vector2,id:9936,x:29468,y:32819,varname:node_9936,prsc:2,v1:0.5,v2:0.4;n:type:ShaderForge.SFN_RemapRange,id:5870,x:29959,y:32614,varname:node_5870,prsc:2,frmn:0,frmx:2,tomn:1,tomx:-1|IN-1656-OUT;n:type:ShaderForge.SFN_TexCoord,id:2961,x:29489,y:32899,varname:node_2961,prsc:2,uv:0;n:type:ShaderForge.SFN_Vector1,id:8345,x:29403,y:33069,varname:node_8345,prsc:2,v1:-0.5;n:type:ShaderForge.SFN_Add,id:6646,x:29691,y:32975,varname:node_6646,prsc:2|A-2961-UVOUT,B-8345-OUT;n:type:ShaderForge.SFN_Multiply,id:8883,x:30372,y:32851,varname:node_8883,prsc:2|A-346-OUT,B-6646-OUT;n:type:ShaderForge.SFN_Multiply,id:8391,x:30633,y:32941,varname:node_8391,prsc:2|A-8883-OUT,B-2000-OUT;n:type:ShaderForge.SFN_Slider,id:2000,x:29530,y:33246,ptovrint:False,ptlb:Sphere,ptin:_Sphere,varname:_Sphere,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-5,cur:-0.6838816,max:1;n:type:ShaderForge.SFN_Tex2d,id:515,x:31551,y:33104,ptovrint:False,ptlb:Flow,ptin:_Flow,varname:_Flow,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:899c4c37f67e59e43afe776d4f607840,ntxv:0,isnm:False|UVIN-2910-OUT;n:type:ShaderForge.SFN_Clamp01,id:346,x:30137,y:32617,varname:node_346,prsc:2|IN-5870-OUT;n:type:ShaderForge.SFN_Add,id:2910,x:30879,y:32895,varname:node_2910,prsc:2|A-9077-UVOUT,B-8391-OUT;n:type:ShaderForge.SFN_Add,id:7999,x:31786,y:33300,varname:node_7999,prsc:2|A-515-RGB,B-6486-RGB;n:type:ShaderForge.SFN_Color,id:9567,x:31784,y:33558,ptovrint:False,ptlb:Edge_color,ptin:_Edge_color,varname:_Edge_color,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:1500,x:31185,y:32611,varname:node_1500,prsc:2,tex:1e38c1cf45fb79540ac58030ff06cc61,ntxv:0,isnm:False|UVIN-7885-OUT,TEX-1841-TEX;n:type:ShaderForge.SFN_Slider,id:1607,x:29712,y:31874,ptovrint:False,ptlb:offect,ptin:_offect,varname:_offect,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0.1,cur:0.1,max:0.9;n:type:ShaderForge.SFN_TexCoord,id:6598,x:30095,y:31623,varname:node_6598,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:7885,x:30299,y:31690,varname:node_7885,prsc:2|A-6598-UVOUT,B-4572-OUT;n:type:ShaderForge.SFN_Tex2d,id:6021,x:31060,y:32157,varname:_node_1500_copy,prsc:2,tex:1e38c1cf45fb79540ac58030ff06cc61,ntxv:0,isnm:False|UVIN-3014-OUT,TEX-1841-TEX;n:type:ShaderForge.SFN_Add,id:1889,x:31800,y:32408,varname:node_1889,prsc:2|A-8193-OUT,B-1500-RGB;n:type:ShaderForge.SFN_OneMinus,id:8193,x:31381,y:32142,varname:node_8193,prsc:2|IN-6021-RGB;n:type:ShaderForge.SFN_RemapRange,id:4572,x:30223,y:31903,varname:node_4572,prsc:2,frmn:0,frmx:1,tomn:0.5,tomx:-0.5|IN-1607-OUT;n:type:ShaderForge.SFN_Add,id:3014,x:30800,y:31850,varname:node_3014,prsc:2|A-4058-OUT,B-7885-OUT;n:type:ShaderForge.SFN_Vector1,id:4058,x:30463,y:31935,varname:node_4058,prsc:2,v1:-0.05;n:type:ShaderForge.SFN_Tex2dAsset,id:1841,x:29469,y:31957,ptovrint:False,ptlb:node_1841,ptin:_node_1841,varname:_node_1841,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:1e38c1cf45fb79540ac58030ff06cc61,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:277,x:30855,y:33390,varname:node_277,prsc:2|A-3506-OUT,B-5199-UVOUT;n:type:ShaderForge.SFN_Multiply,id:3506,x:30124,y:33652,varname:node_3506,prsc:2|A-3281-OUT,B-917-OUT,C-6646-OUT;n:type:ShaderForge.SFN_RemapRange,id:3281,x:29722,y:33539,varname:node_3281,prsc:2,frmn:5,frmx:0,tomn:0,tomx:-1|IN-2000-OUT;n:type:ShaderForge.SFN_OneMinus,id:917,x:30242,y:33287,varname:node_917,prsc:2|IN-346-OUT;n:type:ShaderForge.SFN_TexCoord,id:100,x:30697,y:33629,varname:node_100,prsc:2,uv:0;n:type:ShaderForge.SFN_Distance,id:3913,x:31027,y:33683,varname:node_3913,prsc:2|A-100-UVOUT,B-3509-OUT;n:type:ShaderForge.SFN_RemapRange,id:4214,x:31487,y:33792,varname:node_4214,prsc:2,frmn:0,frmx:1,tomn:50,tomx:-50|IN-2204-OUT;n:type:ShaderForge.SFN_Clamp01,id:6524,x:31665,y:33795,varname:node_6524,prsc:2|IN-4214-OUT;n:type:ShaderForge.SFN_Vector2,id:3509,x:30655,y:33856,varname:node_3509,prsc:2,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_ComponentMask,id:4439,x:31902,y:33805,varname:node_4439,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-6524-OUT;n:type:ShaderForge.SFN_Multiply,id:2204,x:31281,y:33825,varname:node_2204,prsc:2|A-3913-OUT,B-3231-OUT;n:type:ShaderForge.SFN_Slider,id:7873,x:30681,y:34019,ptovrint:False,ptlb:Ramp,ptin:_Ramp,varname:_Ramp,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:3231,x:31090,y:33928,varname:node_3231,prsc:2,frmn:-0.55,frmx:1,tomn:-1,tomx:5|IN-7873-OUT;proporder:4065-7873-2000-6335-6486-515-9567-1607-1841;pass:END;sub:END;*/

Shader "LD/LD_mask" {
    Properties {
        [HDR]_Color ("Color", Color) = (0.5,0.5,0.5,1)
        _Ramp ("Ramp", Range(0, 1)) = 0
        _Sphere ("Sphere", Range(-5, 1)) = -0.6838816
        _Specularmap ("Specularmap", 2D) = "white" {}
        _FlowMap ("FlowMap", 2D) = "white" {}
        _Flow ("Flow", 2D) = "white" {}
        [HDR]_Edge_color ("Edge_color", Color) = (0.5,0.5,0.5,1)
        _offect ("offect", Range(0.1, 0.9)) = 0.1
        _node_1841 ("node_1841", 2D) = "white" {}
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
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float4 _Color;
            uniform sampler2D _Specularmap; uniform float4 _Specularmap_ST;
            uniform float _Sphere;
            uniform sampler2D _Flow; uniform float4 _Flow_ST;
            uniform float4 _Edge_color;
            uniform float _offect;
            uniform sampler2D _node_1841; uniform float4 _node_1841_ST;
            uniform float _Ramp;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
                float2 node_7885 = (i.uv0+(_offect*-1.0+0.5));
                float2 node_3014 = ((-0.05)+node_7885);
                float4 _node_1500_copy = tex2D(_node_1841,TRANSFORM_TEX(node_3014, _node_1841));
                float4 node_1500 = tex2D(_node_1841,TRANSFORM_TEX(node_7885, _node_1841));
                float4 node_1000 = _Time + _TimeEditor;
                float node_346 = saturate((distance(i.uv0,float2(0.5,0.4))*-1.0+1.0));
                float2 node_6646 = (i.uv0+(-0.5));
                float2 node_2910 = ((i.uv0+node_1000.g*float2(-0.2,-0.1))+((node_346*node_6646)*_Sphere));
                float4 _Flow_var = tex2D(_Flow,TRANSFORM_TEX(node_2910, _Flow));
                float2 node_277 = (((_Sphere*0.2+-1.0)*(1.0 - node_346)*node_6646)+(i.uv0+node_1000.g*float2(-0.1,0.05)));
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_277, _FlowMap));
                float3 node_7999 = (_Flow_var.rgb+_FlowMap_var.rgb);
                float node_4439 = saturate(((distance(i.uv0,float2(0.5,0.5))*(_Ramp*3.870968+1.129032))*-100.0+50.0)).r;
                float4 _Specularmap_var = tex2D(_Specularmap,TRANSFORM_TEX(i.uv0, _Specularmap));
                float3 node_5179 = (((1.0 - ((1.0 - _node_1500_copy.rgb)+node_1500.rgb))*node_7999*node_4439*_Edge_color.rgb)+((node_1500.rgb*node_7999)*node_4439*_Color.rgb)+_Specularmap_var.rgb);
                float3 finalColor = node_5179;
                return fixed4(finalColor,(node_5179.g*node_4439));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
