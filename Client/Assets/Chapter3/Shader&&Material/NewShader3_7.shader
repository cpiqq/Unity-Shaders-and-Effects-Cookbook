Shader "Custom/NewShader3_7" {
	Properties {
		_MainTint ("_MainTint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecularColor("_SpecularColor", Color) = (1,1,1,1)
		_SpecularPower("_SpecularPower", Range(0,1)) = 0.5
		_Specular("_Specular", Range(0,1)) = 0.5
		_AnisoDir("_AnisoDir", 2D) = ""{}
		_AnisoOffset("_AnisoOffset", Range(-1,1)) = -0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Aniso
		#pragma target 3.0

		sampler2D _MainTex;
		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecularPower;
		float _Specular;
		sampler2D _AnisoDir;
		float _AnisoOffset;

		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisoDir;
		};
		struct SurfaceAnisoOutput{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			half Specular;
			fixed3 AnisoDirection;
			fixed Gloss;
			fixed Alpha;
		};


		inline fixed4 LightingAniso(SurfaceAnisoOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			fixed3 halfVector = normalize(normalize(lightDir)  + normalize(viewDir));
			float NdotL = saturate(dot(s.Normal, lightDir));
			fixed HdotA = dot(halfVector, normalize(s.Normal + s.AnisoDirection));
			float aniso =  max(sin(radians((HdotA + _AnisoOffset) * 180)),0);
			float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);

			float4 c;
			c.rgb = ((s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec)) * (atten * 2);
			c.a = 1.0f;
			return c;
		}

		void surf(Input IN, inout SurfaceAnisoOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));

			o.AnisoDirection = anisoTex;
			o.Specular = _Specular;
			o.Gloss = _SpecularPower;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
