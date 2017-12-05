Shader "Custom/NewShader4_3" {
	Properties {
		_MainTint("_MainTint",Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ReflAmount("_ReflAmount",Range(0,1)) = 1
		_Cubemap("_Cubemap", CUBE) = ""{}
		_ReflMask("_ReflMask",2D) = ""{}
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
		sampler2D _ReflMask;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			half3 reflection = texCUBE(_Cubemap, IN.worldRefl).rgb;
			float4 reflMask = tex2D(_ReflMask, IN.uv_MainTex);
			o.Albedo = reflection * _ReflAmount * reflMask.r;//c.rgb;
			//o.Emission = reflection * _ReflAmount * reflMask.r;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
