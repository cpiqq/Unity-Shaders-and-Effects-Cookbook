Shader "Custom/NewShader4_4" {
	Properties {
		_MainTint("_MainTint",Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ReflAmount("_ReflAmount",Range(0,1)) = 1
		_Cubemap("_Cubemap", CUBE) = ""{}
		_NormalMap("_NormalMap", 2D) = ""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _MainTint;
		sampler2D _MainTex;
		float _ReflAmount;
		samplerCUBE _Cubemap;
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			float3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)).rgb;
			o.Normal = normal;
			half3 reflection = texCUBE(_Cubemap, WorldReflectionVector(IN,o.Normal)).rgb * _ReflAmount;
			o.Albedo = c.rgb;
			o.Emission = reflection;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
