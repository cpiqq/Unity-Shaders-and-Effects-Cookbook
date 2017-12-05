Shader "Custom/NewShader4_2" {
	Properties {
		_MainTint("_MainTint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cubemap("_Cubemap", CUBE) = ""{}
		_ReflAmount("_ReflAmount", Range(0.1,1)) = 0.5		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed4 _MainTint;
		samplerCUBE _Cubemap;
		float _ReflAmount;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
		 	o.Emission = texCUBE(_Cubemap, IN.worldRefl).rgb * _ReflAmount;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
