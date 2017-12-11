Shader "Custom/NewShader4_5" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CubeMap("_CubeMap",Cube) = "white"{}
		_RimPower("_RimPower",Range(0.1,3)) = 2
		_ReflectAmount ("_ReflectAmount", Range(0,1)) = 1
		_SpecularPower("_SpecularPower",Range(0,1)) = 0.5
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			float3 viewDir;
		};
		
		samplerCUBE _CubeMap;
		float _RimPower;
		float _ReflectAmount;
		float _SpecularPower;


		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			half rim = 1 - saturate( dot(normalize(IN.viewDir), o.Normal) );
			rim = pow(rim, _RimPower);
			o.Emission = texCUBE(_CubeMap, IN.worldRefl) * _ReflectAmount * rim;
			o.Specular = _SpecularPower;
			o.Gloss = 1;
		
		}
		ENDCG
	}
	FallBack "Diffuse"
}
