Shader "Custom/Ludum/SimpleGemShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		[NoScaleOffset] _ReflectTex ("Reflect", 2D) = "" {}
		_ReflectAmount ("Reflection Amount", Range(0.0, 2.0)) = 1.0
		_Emission ("Emission", Range(0.0,2.0)) = 0.0
	}

	SubShader 
	{
		// back pass
		Pass 
		{
			Cull Front
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert (float4 v : POSITION, float3 n : NORMAL)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v);

				// TexGen SphereMap
				float3 viewDir = normalize(ObjSpaceViewDir(v));
				float3 r = reflect(-viewDir, n);
				r = UnityObjectToViewPos(r);
				r.z += 1;
				float m = 2 * length(r);
				o.uv = r.xy / m + 0.5;

				return o;
			}

			fixed4 _Color;
			sampler2D _ReflectTex;

			half4 frag (v2f i) : SV_Target
			{
				return tex2D(_ReflectTex, i.uv);
			}
			ENDCG
		}

		// front pass		
		Pass 
		{
			ZWrite On
			Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				half fresnel : TEXCOORD1;
			};

			v2f vert (float4 v : POSITION, float3 n : NORMAL)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v);

				// TexGen SphereMap
				float3 viewDir = normalize(ObjSpaceViewDir(v));
				float3 r = reflect(-viewDir, n);
				r = UnityObjectToViewPos(r);
				r.z += 1;
				float m = 2 * length(r);
				o.uv = r.xy / m + 0.5;
				o.fresnel = 1.0 - saturate(dot(n, viewDir));

				return o;
			}

			fixed4 _Color;
			sampler2D _ReflectTex;
			half _ReflectAmount;
			half _Emission;

			half4 frag (v2f i) : SV_Target
			{
				half3 base = _Color.rgb;
				half4 reflection = tex2D(_ReflectTex, i.uv);
				half3 reflectAmt = reflection * _ReflectAmount * i.fresnel;
				return fixed4(base + reflectAmt * _Emission, 1.0f);
			}
			ENDCG
		}

	}
	Fallback "Legacy Shaders/Self-Illumin/Diffuse"
}