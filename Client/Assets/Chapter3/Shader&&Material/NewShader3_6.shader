Shader "Custom/NewShader3_6" {
	Properties {
		_MainTint("_MainTint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_RoughnessTex("_RoughnessTex", 2D) = "white"{}
		_Roughness("_Roughness", Range(0,1)) = 0.5
		_SpecularColor("_SpecularColor", Color) = (1,1,1,1)
		_SpecularPower("_SpecularPower", Range(0,30)) = 2
		_Fresnel("_Fresnel", Range(0,1)) = 0.05
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MetallicSoft

		sampler2D _MainTex;
		float4 _MainTint;
		sampler2D _RoughnessTex;
		float _Roughness;
		float4 _SpecularColor;
		float _SpecularPower;
		float _Fresnel;

		struct Input {
			float2 uv_MainTex;
		};

		inline fixed4 LightingMetallicSoft(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir,fixed atten)
		{
			float3 halfVector = normalize(lightDir + viewDir);
			float NdotL = saturate(dot(s.Normal, normalize(lightDir)));
			float NdotH_raw = dot(s.Normal, halfVector);
			float NdotH = saturate(NdotH_raw);
			float NdotV = saturate(dot(s.Normal, normalize(viewDir)));
			float VdotH = saturate(dot(normalize(viewDir), halfVector));

			float geoEnum = 2.0 * NdotH;
			float3 G1 = (geoEnum * NdotV) / NdotH;
			float3 G2 = (geoEnum * NdotL) / NdotH;
			float3 G = min(1.0f, min(G1, G2));

			float roughness = tex2D(_RoughnessTex, float2(NdotH_raw * 0.5 + 0.5, _Roughness)).r;

			float fresnel = pow(1 - VdotH, 5);
			fresnel *= (1 - _Fresnel);
			fresnel += _Fresnel;

			float3 spec = float3(fresnel * G * roughness * roughness) * _SpecularPower;

			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (spec * _SpecularColor.rgb) * (atten * 2);
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
