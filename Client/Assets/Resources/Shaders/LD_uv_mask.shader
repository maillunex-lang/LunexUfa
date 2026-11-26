// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:True,rprd:False,enco:True,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:14,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1168,x:34658,y:32472,varname:node_1168,prsc:2|emission-8424-OUT,custl-9026-OUT,alpha-4084-OUT;n:type:ShaderForge.SFN_Tex2d,id:9588,x:32231,y:32706,ptovrint:False,ptlb:Texture,ptin:_Texture,varname:node_9588,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3255b5981c1ac844d9907aec386c2c8c,ntxv:0,isnm:False|UVIN-6161-OUT;n:type:ShaderForge.SFN_TexCoord,id:7960,x:31084,y:32645,varname:node_7960,prsc:2,uv:1;n:type:ShaderForge.SFN_Time,id:3610,x:31217,y:33110,varname:node_3610,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3255,x:31559,y:33214,varname:node_3255,prsc:2|A-3610-T,B-6647-OUT;n:type:ShaderForge.SFN_Append,id:6647,x:31401,y:33330,varname:node_6647,prsc:2|A-3960-OUT,B-412-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3960,x:31172,y:33309,ptovrint:False,ptlb:Speed_U,ptin:_Speed_U,varname:node_3960,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_ValueProperty,id:412,x:31161,y:33421,ptovrint:False,ptlb:Speed_V,ptin:_Speed_V,varname:node_412,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Add,id:8912,x:31788,y:32917,varname:node_8912,prsc:2|A-3014-OUT,B-3255-OUT;n:type:ShaderForge.SFN_Color,id:1140,x:32022,y:32973,ptovrint:False,ptlb:color,ptin:_color,varname:node_1140,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:9339,x:32858,y:33033,varname:node_9339,prsc:2|A-4084-OUT,B-1140-RGB,C-1140-A,D-5235-OUT,E-9060-A;n:type:ShaderForge.SFN_Slider,id:5235,x:31976,y:33183,ptovrint:False,ptlb:Intensity,ptin:_Intensity,varname:node_5235,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2.556063,max:5;n:type:ShaderForge.SFN_VertexColor,id:9060,x:31992,y:33272,varname:node_9060,prsc:2;n:type:ShaderForge.SFN_Multiply,id:9026,x:33892,y:33094,varname:node_9026,prsc:2|A-9339-OUT,B-9878-RGB,C-8287-OUT;n:type:ShaderForge.SFN_Tex2d,id:9878,x:32676,y:33518,ptovrint:False,ptlb:mask,ptin:_mask,varname:node_9878,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-7899-OUT;n:type:ShaderForge.SFN_Multiply,id:4084,x:32692,y:32598,varname:node_4084,prsc:2|A-9618-R,B-9588-A;n:type:ShaderForge.SFN_SwitchProperty,id:3014,x:31436,y:32787,ptovrint:False,ptlb:UV,ptin:_UV,varname:node_3014,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7960-UVOUT,B-2221-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:2221,x:31080,y:32821,varname:node_2221,prsc:2,uv:0;n:type:ShaderForge.SFN_TexCoord,id:5897,x:32050,y:33466,varname:node_5897,prsc:2,uv:0;n:type:ShaderForge.SFN_SwitchProperty,id:7899,x:32308,y:33562,ptovrint:False,ptlb:mask_UV,ptin:_mask_UV,varname:_UV_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-5897-UVOUT,B-555-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:555,x:32036,y:33638,varname:node_555,prsc:2,uv:1;n:type:ShaderForge.SFN_Rotator,id:2698,x:31650,y:32491,varname:node_2698,prsc:2|UVIN-3014-OUT,SPD-3328-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:6161,x:31969,y:32650,ptovrint:False,ptlb:Rotation,ptin:_Rotation,varname:node_6161,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-8912-OUT,B-2698-UVOUT;n:type:ShaderForge.SFN_Slider,id:3328,x:31257,y:32419,ptovrint:False,ptlb:Speed,ptin:_Speed,varname:node_3328,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.1,max:5;n:type:ShaderForge.SFN_TexCoord,id:1888,x:32093,y:33912,varname:node_1888,prsc:2,uv:0;n:type:ShaderForge.SFN_RemapRange,id:4839,x:32385,y:33864,varname:node_4839,prsc:2,frmn:0,frmx:1,tomn:0,tomx:3.14|IN-1888-U;n:type:ShaderForge.SFN_RemapRange,id:8819,x:32385,y:34072,varname:node_8819,prsc:2,frmn:0,frmx:1,tomn:0,tomx:3.14|IN-1888-V;n:type:ShaderForge.SFN_Sin,id:4950,x:32612,y:33864,varname:node_4950,prsc:2|IN-4839-OUT;n:type:ShaderForge.SFN_Sin,id:6676,x:32612,y:34090,varname:node_6676,prsc:2|IN-8819-OUT;n:type:ShaderForge.SFN_Step,id:3459,x:33164,y:33870,varname:node_3459,prsc:2|A-907-OUT,B-4950-OUT;n:type:ShaderForge.SFN_Step,id:5615,x:33164,y:34033,varname:node_5615,prsc:2|A-907-OUT,B-6676-OUT;n:type:ShaderForge.SFN_Slider,id:907,x:32348,y:33747,ptovrint:False,ptlb:mask_S,ptin:_mask_S,varname:node_907,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-0.1,cur:0.6436539,max:1;n:type:ShaderForge.SFN_Multiply,id:2537,x:33451,y:33913,varname:node_2537,prsc:2|A-3459-OUT,B-5615-OUT;n:type:ShaderForge.SFN_OneMinus,id:8287,x:33904,y:33876,varname:node_8287,prsc:2|IN-2537-OUT;n:type:ShaderForge.SFN_Step,id:3748,x:33180,y:34230,varname:node_3748,prsc:2|A-9560-OUT,B-4950-OUT;n:type:ShaderForge.SFN_Step,id:6804,x:33206,y:34415,varname:node_6804,prsc:2|A-9560-OUT,B-6676-OUT;n:type:ShaderForge.SFN_Multiply,id:8306,x:33439,y:34314,varname:node_8306,prsc:2|A-3748-OUT,B-6804-OUT;n:type:ShaderForge.SFN_Subtract,id:3804,x:32878,y:34692,varname:node_3804,prsc:2|A-9633-OUT,B-4735-OUT;n:type:ShaderForge.SFN_Vector1,id:9633,x:32396,y:34503,varname:node_9633,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Vector1,id:4735,x:32400,y:34783,varname:node_4735,prsc:2,v1:0.09;n:type:ShaderForge.SFN_Add,id:9560,x:33193,y:34707,varname:node_9560,prsc:2|A-907-OUT,B-3804-OUT;n:type:ShaderForge.SFN_Subtract,id:7435,x:33971,y:34283,varname:node_7435,prsc:2|A-2537-OUT,B-8306-OUT;n:type:ShaderForge.SFN_Color,id:3300,x:33821,y:34600,ptovrint:False,ptlb:Edge_color,ptin:_Edge_color,varname:node_3300,prsc:2,glob:False,taghide:True,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:8424,x:34231,y:34414,varname:node_8424,prsc:2|A-7435-OUT,B-3300-RGB;n:type:ShaderForge.SFN_TexCoord,id:6381,x:31444,y:32182,varname:node_6381,prsc:2,uv:0;n:type:ShaderForge.SFN_Tex2d,id:9618,x:32311,y:32079,ptovrint:False,ptlb:niuqu,ptin:_niuqu,varname:node_9618,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3255b5981c1ac844d9907aec386c2c8c,ntxv:0,isnm:False|UVIN-7588-OUT;n:type:ShaderForge.SFN_Panner,id:4651,x:31650,y:32247,varname:node_4651,prsc:2,spu:-0.08,spv:0.02|UVIN-6381-UVOUT;n:type:ShaderForge.SFN_Add,id:7588,x:32022,y:32179,varname:node_7588,prsc:2|A-4651-UVOUT,B-9588-R;proporder:1140-9588-9618-412-3960-5235-9878-3014-7899-6161-3328-907-3300;pass:END;sub:END;*/

Shader "LD/LD_uv_mask" {
    Properties {
        [HDR]_color ("color", Color) = (0.5,0.5,0.5,1)
        _Texture ("Texture", 2D) = "white" {}
        _niuqu ("niuqu", 2D) = "white" {}
        _Speed_V ("Speed_V", Float ) = 0
        _Speed_U ("Speed_U", Float ) = 0.2
        _Intensity ("Intensity", Range(0, 5)) = 2.556063
        _mask ("mask", 2D) = "white" {}
        [MaterialToggle] _UV ("UV", Float ) = 0
        [MaterialToggle] _mask_UV ("mask_UV", Float ) = 0
        [MaterialToggle] _Rotation ("Rotation", Float ) = 0
        _Speed ("Speed", Range(0, 5)) = 0.1
        _mask_S ("mask_S", Range(-0.1, 1)) = 0.6436539
        [HideInInspector]_Edge_color ("Edge_color", Color) = (0.5,0.5,0.5,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
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
            ColorMask RGB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform float _Speed_U;
            uniform float _Speed_V;
            uniform float4 _color;
            uniform float _Intensity;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            uniform fixed _UV;
            uniform fixed _mask_UV;
            uniform fixed _Rotation;
            uniform float _Speed;
            uniform float _mask_S;
            uniform float4 _Edge_color;
            uniform sampler2D _niuqu; uniform float4 _niuqu_ST;
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
                float node_4950 = sin((i.uv0.r*3.14+0.0));
                float node_6676 = sin((i.uv0.g*3.14+0.0));
                float node_2537 = (step(_mask_S,node_4950)*step(_mask_S,node_6676));
                float node_9560 = (_mask_S+(0.1-0.09));
                float3 emissive = ((node_2537-(step(node_9560,node_4950)*step(node_9560,node_6676)))*_Edge_color.rgb);
                float4 node_2718 = _Time + _TimeEditor;
                float2 _UV_var = lerp( i.uv1, i.uv0, _UV );
                float4 node_3610 = _Time + _TimeEditor;
                float node_2698_ang = node_2718.g;
                float node_2698_spd = _Speed;
                float node_2698_cos = cos(node_2698_spd*node_2698_ang);
                float node_2698_sin = sin(node_2698_spd*node_2698_ang);
                float2 node_2698_piv = float2(0.5,0.5);
                float2 node_2698 = (mul(_UV_var-node_2698_piv,float2x2( node_2698_cos, -node_2698_sin, node_2698_sin, node_2698_cos))+node_2698_piv);
                float2 _Rotation_var = lerp( (_UV_var+(node_3610.g*float2(_Speed_U,_Speed_V))), node_2698, _Rotation );
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(_Rotation_var, _Texture));
                float2 node_7588 = ((i.uv0+node_2718.g*float2(-0.08,0.02))+_Texture_var.r);
                float4 _niuqu_var = tex2D(_niuqu,TRANSFORM_TEX(node_7588, _niuqu));
                float node_4084 = (_niuqu_var.r*_Texture_var.a);
                float2 _mask_UV_var = lerp( i.uv0, i.uv1, _mask_UV );
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(_mask_UV_var, _mask));
                float3 finalColor = emissive + ((node_4084*_color.rgb*_color.a*_Intensity*i.vertexColor.a)*_mask_var.rgb*(1.0 - node_2537));
                return fixed4(finalColor,node_4084);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
