Shader "Custom/NewShader3_5" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("_MainTint", Color) = (1,1,1,1)
		_SpecularColor("_SpecularColor", Color) = (1,1,1,1)
		_SpecularMask("_SpecularMask", 2D) = "white" {}
		_SpecularPower("_SpecularPower", Range(0.2,10)) = 3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomPhong

		sampler2D _MainTex;
		float4 _MainTint;
		float4 _SpecularColor;
		sampler2D _SpecularMask;
		float _SpecularPower;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SpecularMask;
		};
		struct SurfaceCustomOutput{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 SpecularColor;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};

		inline fixed4 LightingCustomPhong(SurfaceCustomOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float diff = dot(s.Normal, lightDir);
			float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);
			float spec = pow(max(dot(reflectionVector, viewDir), 0),_SpecularPower) * s.Specular;

			float3 finalSpec = s.SpecularColor * spec ;

			fixed4 c;
			c.rgb = (s.Albedo * diff * _LightColor0.rgb) + (_LightColor0.rgb * finalSpec) * (atten * 2);
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceCustomOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			float4 specMask = tex2D(_SpecularMask, IN.uv_SpecularMask) * _SpecularColor;

			o.Albedo = c.rgb;
			o.SpecularColor = specMask.rgb;
			o.Specular = specMask.r;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
