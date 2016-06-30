Shader "Custom/Role"
{
    Properties
    {
    	_Color("Color", Color) = (0, 0, 0, 1)
        _MainTex("Texture (RGB)", 2D) = "black" {}
        _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
        _RimColor("Rim Color", Color) = (0.5, 0.5, 1.0, 1)
        _RimPower ("Rim Power", Range(3, 20.0)) = 7
        _RimRanger ("Rim Ranger", Range(0,2.0)) = 1.0
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline ("Outline width", Range (.0001, 0.003)) = .0005
		_Light ("Light", Range(0.5, 1.5)) = 1 
    }
   
 	SubShader
    {   
    	Alphatest Greater [_Cutoff]
    		
        Pass
        {
            Tags {"LightMode" = "Always"}
            Cull Back
           
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag               
                #include "UnityCG.cginc"
               
                sampler2D _MainTex;
                float4 _MainTex_ST;
                float4 _Color;
                float4 _RimColor;
                float _RimPower;
                float _RimRanger;
                float3 viewDir;
                float _Light;
               
                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float3 normal : TEXCOORD0;
                    float3 viewDir : TEXCOORD1;
                    float2 texcoord : TEXCOORD2;                    
                };

                v2f vert(appdata_base v)
                {
                    v2f o;                   	
                    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
                    o.normal = v.normal;
                    o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                    o.viewDir = ObjSpaceViewDir(v.vertex);
                    return o;
                }
              
                float4 frag(v2f i) : COLOR
                {
                    i.normal = normalize(i.normal);
                    float3 viewdir = normalize(i.viewDir);                   
                    float rim = pow(1.0-saturate(dot(viewdir, i.normal)), _RimPower) * _RimRanger;
                    
                    float4 color = tex2D(_MainTex, i.texcoord) * _Color * _Light;
                    color.rgb = lerp(color.rgb, _RimColor.rgb, rim);

                    return color;
                }
            ENDCG
        }
   		Pass {
			Name "OUTLINE"
			Tags { "LightMode" = "Always" }
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
		
			struct v2f {
				float4 pos : POSITION;
				float4 color : COLOR;
			};
			
			uniform float _Outline;
			uniform float4 _OutlineColor;
			
			v2f vert(appdata v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		
				float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				float2 offset = TransformViewToProjection(norm.xy);
		
				o.pos.xy += offset * o.pos.z * _Outline;
				o.color = _OutlineColor;
				return o;
			}
	
			half4 frag(v2f i) :COLOR { return i.color; }
			ENDCG
		}
		
		Pass 
	    {	  
	    	Cull Front     
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			sampler2D _MainTex;
						
			struct appdata {
			    float4 vertex : POSITION;
			    float4 texcoord : TEXCOORD0;

			};
			
			struct v2f {
			    float4 pos : POSITION;
			    float2 uv : TEXCOORD0;
			};
			v2f vert (appdata v) {
			    v2f o;
			    o.pos = mul( UNITY_MATRIX_MVP, v.vertex );
			    o.uv = v.texcoord;
			    return o;
			}
			fixed4 frag (v2f i) : COLOR 
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
	    }
    }
   
    FallBack "Diffuse"
}
