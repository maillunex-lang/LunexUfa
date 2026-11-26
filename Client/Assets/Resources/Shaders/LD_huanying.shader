// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.2572448,fgcg:0.2986891,fgcb:0.5735294,fgca:1,fgde:0.01,fgrn:30,fgrf:180,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:33964,y:32912,varname:node_4013,prsc:2|diff-6768-OUT,clip-7099-OUT;n:type:ShaderForge.SFN_Fresnel,id:2276,x:32778,y:33029,varname:node_2276,prsc:2|NRM-8404-OUT,EXP-1052-OUT;n:type:ShaderForge.SFN_NormalVector,id:8404,x:32512,y:32789,prsc:2,pt:False;n:type:ShaderForge.SFN_Slider,id:1052,x:32433,y:32979,ptovrint:False,ptlb:Width,ptin:_Width,varname:node_1052,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:4.615385,max:5;n:type:ShaderForge.SFN_Multiply,id:3288,x:32981,y:33180,varname:node_3288,prsc:2|A-2276-OUT,B-8651-OUT,C-2217-RGB,D-2217-A;n:type:ShaderForge.SFN_Slider,id:8651,x:32386,y:33149,ptovrint:False,ptlb:Intensity,ptin:_Intensity,varname:node_8651,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:10;n:type:ShaderForge.SFN_Color,id:2217,x:32654,y:33322,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_2217,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:7363,x:32800,y:32598,ptovrint:False,ptlb:wenli,ptin:_wenli,varname:node_7363,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2918,x:32954,y:32693,varname:node_2918,prsc:2|A-7363-RGB,B-1816-RGB,C-1816-A;n:type:ShaderForge.SFN_Color,id:1816,x:32778,y:32811,ptovrint:False,ptlb:wenli_color,ptin:_wenli_color,varname:node_1816,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Add,id:6768,x:33170,y:32837,varname:node_6768,prsc:2|A-2918-OUT,B-3288-OUT;n:type:ShaderForge.SFN_Tex2d,id:495,x:32945,y:33552,ptovrint:False,ptlb:rongjiewenli,ptin:_rongjiewenli,varname:_node_8133_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a626536343d6db44bb06c06b87857dd3,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3689,x:33214,y:33710,varname:node_3689,prsc:2|A-495-R,B-7862-OUT;n:type:ShaderForge.SFN_Slider,id:7862,x:32676,y:33806,ptovrint:False,ptlb:rongjie,ptin:_rongjie,varname:node_3391,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:10,max:10;n:type:ShaderForge.SFN_Color,id:9980,x:33181,y:33426,ptovrint:False,ptlb:rongjieyanse,ptin:_rongjieyanse,varname:node_6514,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:7099,x:33601,y:33626,varname:node_7099,prsc:2|A-9980-R,B-3689-OUT;proporder:2217-1052-8651-1816-7363-9980-495-7862;pass:END;sub:END;*/

Shader "LD/LD_huanying" {
    Properties {
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _Width ("Width", Range(0, 5)) = 4.615385
        _Intensity ("Intensity", Range(0, 10)) = 1
        _wenli_color ("wenli_color", Color) = (0.5,0.5,0.5,1)
        _wenli ("wenli", 2D) = "white" {}
        _rongjieyanse ("rongjieyanse", Color) = (0.5,0.5,0.5,1)
        _rongjiewenli ("rongjiewenli", 2D) = "white" {}
        _rongjie ("rongjie", Range(0, 10)) = 10
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
            uniform float _Width;
            uniform float _Intensity;
            uniform float4 _Color;
            uniform sampler2D _wenli; uniform float4 _wenli_ST;
            uniform float4 _wenli_color;
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
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float4 _rongjiewenli_var = tex2D(_rongjiewenli,TRANSFORM_TEX(i.uv0, _rongjiewenli));
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
                float4 _wenli_var = tex2D(_wenli,TRANSFORM_TEX(i.uv0, _wenli));
                float3 diffuseColor = ((_wenli_var.rgb*_wenli_color.rgb*_wenli_color.a)+(pow(1.0-max(0,dot(i.normalDir, viewDirection)),_Width)*_Intensity*_Color.rgb*_Color.a));
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
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
            uniform float _Width;
            uniform float _Intensity;
            uniform float4 _Color;
            uniform sampler2D _wenli; uniform float4 _wenli_ST;
            uniform float4 _wenli_color;
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
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float4 _rongjiewenli_var = tex2D(_rongjiewenli,TRANSFORM_TEX(i.uv0, _rongjiewenli));
                clip((_rongjieyanse.r*(_rongjiewenli_var.r*_rongjie)) - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float4 _wenli_var = tex2D(_wenli,TRANSFORM_TEX(i.uv0, _wenli));
                float3 diffuseColor = ((_wenli_var.rgb*_wenli_color.rgb*_wenli_color.a)+(pow(1.0-max(0,dot(i.normalDir, viewDirection)),_Width)*_Intensity*_Color.rgb*_Color.a));
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
            float4 frag(VertexOutput i) : COLOR {
                float4 _rongjiewenli_var = tex2D(_rongjiewenli,TRANSFORM_TEX(i.uv0, _rongjiewenli));
                clip((_rongjieyanse.r*(_rongjiewenli_var.r*_rongjie)) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
