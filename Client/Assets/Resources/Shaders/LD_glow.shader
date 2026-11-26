// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:0,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:33320,y:32611,varname:node_4013,prsc:2|diff-9885-OUT,emission-9244-OUT,clip-3221-OUT;n:type:ShaderForge.SFN_Tex2d,id:7765,x:32383,y:32473,ptovrint:False,ptlb:wenli,ptin:_wenli,varname:node_7765,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ea5540d460241b14c8caa3a0b2e3ae3f,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Fresnel,id:3890,x:32064,y:32608,varname:node_3890,prsc:2|NRM-8093-OUT,EXP-6830-OUT;n:type:ShaderForge.SFN_Add,id:9244,x:32679,y:32647,varname:node_9244,prsc:2|A-103-OUT,B-5426-OUT;n:type:ShaderForge.SFN_Color,id:1995,x:31933,y:32959,ptovrint:False,ptlb:bianyuanyanse,ptin:_bianyuanyanse,varname:node_1995,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_NormalVector,id:8093,x:31851,y:32548,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:2349,x:32385,y:32825,varname:node_2349,prsc:2|A-8137-OUT,B-1995-RGB;n:type:ShaderForge.SFN_Panner,id:6461,x:31447,y:31985,varname:node_6461,prsc:2,spu:0.1,spv:0.1|UVIN-6854-UVOUT,DIST-2366-OUT;n:type:ShaderForge.SFN_Tex2d,id:8133,x:31946,y:32093,ptovrint:False,ptlb:node_8133,ptin:_node_8133,varname:node_8133,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a626536343d6db44bb06c06b87857dd3,ntxv:0,isnm:False|UVIN-1163-OUT;n:type:ShaderForge.SFN_TexCoord,id:6854,x:31239,y:31989,varname:node_6854,prsc:2,uv:0;n:type:ShaderForge.SFN_Tex2d,id:8569,x:31549,y:32217,ptovrint:False,ptlb:node_8569,ptin:_node_8569,varname:node_8569,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b82836ae3a73fd84c9d5b2a24c319895,ntxv:0,isnm:False|UVIN-7796-UVOUT;n:type:ShaderForge.SFN_ToggleProperty,id:2075,x:32486,y:33031,ptovrint:False,ptlb:bianyuankaiguan,ptin:_bianyuankaiguan,varname:node_2075,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True;n:type:ShaderForge.SFN_Multiply,id:5426,x:32613,y:32835,varname:node_5426,prsc:2|A-2349-OUT,B-2075-OUT;n:type:ShaderForge.SFN_Slider,id:6830,x:31639,y:32704,ptovrint:False,ptlb:bianyuanhoudu,ptin:_bianyuanhoudu,varname:node_6830,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:3.585012,max:5;n:type:ShaderForge.SFN_Multiply,id:8137,x:32151,y:32749,varname:node_8137,prsc:2|A-3890-OUT,B-3484-OUT;n:type:ShaderForge.SFN_Slider,id:3484,x:31764,y:32825,ptovrint:False,ptlb:bianyuanqiangdu,ptin:_bianyuanqiangdu,varname:node_3484,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:5,max:5;n:type:ShaderForge.SFN_Multiply,id:8982,x:32405,y:32260,varname:node_8982,prsc:2|A-8133-RGB,B-8569-RGB;n:type:ShaderForge.SFN_Color,id:1527,x:32178,y:31936,ptovrint:False,ptlb:liuguangyanse,ptin:_liuguangyanse,varname:node_1527,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:8067,x:32457,y:32087,varname:node_8067,prsc:2|A-1527-RGB,B-8982-OUT;n:type:ShaderForge.SFN_Tex2d,id:3144,x:32518,y:31846,ptovrint:False,ptlb:mask,ptin:_mask,varname:node_3144,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:9885,x:32788,y:31951,varname:node_9885,prsc:2|A-3144-RGB,B-8067-OUT,C-5130-OUT,D-2157-OUT;n:type:ShaderForge.SFN_Slider,id:5130,x:32607,y:32259,ptovrint:False,ptlb:liuguangqiangdu,ptin:_liuguangqiangdu,varname:node_5130,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:10;n:type:ShaderForge.SFN_ToggleProperty,id:2157,x:32727,y:32099,ptovrint:False,ptlb:liuguangkaiguan,ptin:_liuguangkaiguan,varname:node_2157,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True;n:type:ShaderForge.SFN_Add,id:1163,x:31728,y:32000,varname:node_1163,prsc:2|A-6461-UVOUT,B-8569-R;n:type:ShaderForge.SFN_Panner,id:7796,x:31292,y:32171,varname:node_7796,prsc:2,spu:-0.05,spv:0|UVIN-1934-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:1934,x:31083,y:32150,varname:node_1934,prsc:2,uv:0;n:type:ShaderForge.SFN_Color,id:7731,x:32568,y:32398,ptovrint:False,ptlb:wenliyanse,ptin:_wenliyanse,varname:node_7731,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:103,x:32856,y:32444,varname:node_103,prsc:2|A-7731-RGB,B-7765-RGB;n:type:ShaderForge.SFN_Panner,id:594,x:31961,y:33340,varname:node_594,prsc:2,spu:-0.01,spv:0.02|UVIN-6472-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:5794,x:32290,y:33322,ptovrint:False,ptlb:rongjiewenli,ptin:_rongjiewenli,varname:_node_8133_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a626536343d6db44bb06c06b87857dd3,ntxv:0,isnm:False|UVIN-594-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:6472,x:31753,y:33344,varname:node_6472,prsc:2,uv:0;n:type:ShaderForge.SFN_Multiply,id:8630,x:32563,y:33404,varname:node_8630,prsc:2|A-5794-R,B-3391-OUT;n:type:ShaderForge.SFN_Slider,id:3391,x:32106,y:33625,ptovrint:False,ptlb:rongjie,ptin:_rongjie,varname:node_3391,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:5,max:5;n:type:ShaderForge.SFN_Color,id:6514,x:32448,y:33180,ptovrint:False,ptlb:rongjieyanse,ptin:_rongjieyanse,varname:node_6514,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:3221,x:32722,y:33203,varname:node_3221,prsc:2|A-6514-R,B-8630-OUT;n:type:ShaderForge.SFN_Vector1,id:2366,x:31382,y:31801,varname:node_2366,prsc:2,v1:5;proporder:1995-7731-7765-1527-8133-8569-2075-2157-6830-3484-5130-3144-5794-3391-6514;pass:END;sub:END;*/

Shader "LD/LD_glow" {
    Properties {
        _bianyuanyanse ("bianyuanyanse", Color) = (0.5,0.5,0.5,1)
        _wenliyanse ("wenliyanse", Color) = (0.5,0.5,0.5,1)
        _wenli ("wenli", 2D) = "white" {}
        _liuguangyanse ("liuguangyanse", Color) = (0.5,0.5,0.5,1)
        _node_8133 ("node_8133", 2D) = "white" {}
        _node_8569 ("node_8569", 2D) = "white" {}
        [MaterialToggle] _bianyuankaiguan ("bianyuankaiguan", Float ) = 1
        [MaterialToggle] _liuguangkaiguan ("liuguangkaiguan", Float ) = 1
        _bianyuanhoudu ("bianyuanhoudu", Range(0, 5)) = 3.585012
        _bianyuanqiangdu ("bianyuanqiangdu", Range(0, 5)) = 5
        _liuguangqiangdu ("liuguangqiangdu", Range(0, 10)) = 1
        _mask ("mask", 2D) = "white" {}
        _rongjiewenli ("rongjiewenli", 2D) = "white" {}
        _rongjie ("rongjie", Range(0, 5)) = 5
        _rongjieyanse ("rongjieyanse", Color) = (0.5,0.5,0.5,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform sampler2D _wenli; uniform float4 _wenli_ST;
            uniform float4 _bianyuanyanse;
            uniform sampler2D _node_8133; uniform float4 _node_8133_ST;
            uniform sampler2D _node_8569; uniform float4 _node_8569_ST;
            uniform fixed _bianyuankaiguan;
            uniform float _bianyuanhoudu;
            uniform float _bianyuanqiangdu;
            uniform float4 _liuguangyanse;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            uniform float _liuguangqiangdu;
            uniform fixed _liuguangkaiguan;
            uniform float4 _wenliyanse;
            uniform sampler2D _rongjiewenli; uniform float4 _rongjiewenli_ST;
            uniform float _rongjie;
            uniform float4 _rongjieyanse;
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
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float4 node_4200 = _Time + _TimeEditor;
                float2 node_594 = (i.uv0+node_4200.g*float2(-0.01,0.02));
                float4 _rongjiewenli_var = tex2D(_rongjiewenli,TRANSFORM_TEX(node_594, _rongjiewenli));
                clip((_rongjieyanse.r*(_rongjiewenli_var.r*_rongjie)) - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                float2 node_7796 = (i.uv0+node_4200.g*float2(-0.05,0));
                float4 _node_8569_var = tex2D(_node_8569,TRANSFORM_TEX(node_7796, _node_8569));
                float2 node_1163 = ((i.uv0+5.0*float2(0.1,0.1))+_node_8569_var.r);
                float4 _node_8133_var = tex2D(_node_8133,TRANSFORM_TEX(node_1163, _node_8133));
                float3 diffuseColor = (_mask_var.rgb*(_liuguangyanse.rgb*(_node_8133_var.rgb*_node_8569_var.rgb))*_liuguangqiangdu*_liuguangkaiguan);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float4 _wenli_var = tex2D(_wenli,TRANSFORM_TEX(i.uv0, _wenli));
                float3 emissive = ((_wenliyanse.rgb*_wenli_var.rgb)+(((pow(1.0-max(0,dot(i.normalDir, viewDirection)),_bianyuanhoudu)*_bianyuanqiangdu)*_bianyuanyanse.rgb)*_bianyuankaiguan));
/// Final Color:
                float3 finalColor = diffuse + emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers gles3 d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform sampler2D _wenli; uniform float4 _wenli_ST;
            uniform float4 _bianyuanyanse;
            uniform sampler2D _node_8133; uniform float4 _node_8133_ST;
            uniform sampler2D _node_8569; uniform float4 _node_8569_ST;
            uniform fixed _bianyuankaiguan;
            uniform float _bianyuanhoudu;
            uniform float _bianyuanqiangdu;
            uniform float4 _liuguangyanse;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            uniform float _liuguangqiangdu;
            uniform fixed _liuguangkaiguan;
            uniform float4 _wenliyanse;
            uniform sampler2D _rongjiewenli; uniform float4 _rongjiewenli_ST;
            uniform float _rongjie;
            uniform float4 _rongjieyanse;
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
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float4 node_3585 = _Time + _TimeEditor;
                float2 node_594 = (i.uv0+node_3585.g*float2(-0.01,0.02));
                float4 _rongjiewenli_var = tex2D(_rongjiewenli,TRANSFORM_TEX(node_594, _rongjiewenli));
                clip((_rongjieyanse.r*(_rongjiewenli_var.r*_rongjie)) - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                float2 node_7796 = (i.uv0+node_3585.g*float2(-0.05,0));
                float4 _node_8569_var = tex2D(_node_8569,TRANSFORM_TEX(node_7796, _node_8569));
                float2 node_1163 = ((i.uv0+5.0*float2(0.1,0.1))+_node_8569_var.r);
                float4 _node_8133_var = tex2D(_node_8133,TRANSFORM_TEX(node_1163, _node_8133));
                float3 diffuseColor = (_mask_var.rgb*(_liuguangyanse.rgb*(_node_8133_var.rgb*_node_8569_var.rgb))*_liuguangqiangdu*_liuguangkaiguan);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                return fixed4(finalColor * 1,0);
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
            uniform sampler2D _rongjiewenli; uniform float4 _rongjiewenli_ST;
            uniform float _rongjie;
            uniform float4 _rongjieyanse;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 node_6994 = _Time + _TimeEditor;
                float2 node_594 = (i.uv0+node_6994.g*float2(-0.01,0.02));
                float4 _rongjiewenli_var = tex2D(_rongjiewenli,TRANSFORM_TEX(node_594, _rongjiewenli));
                clip((_rongjieyanse.r*(_rongjiewenli_var.r*_rongjie)) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
