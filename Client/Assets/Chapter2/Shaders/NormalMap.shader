Shader "Custom/NormalMap" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_NormalMap ("_NormalMap", 2D) = "white" {}
		_NormalMapIntensity ("_NormalMapIntensity", Range(0, 5)) = 1

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		#pragma target 3.0

		sampler2D _NormalMap;

		struct Input {
			float2 uv_NormalMap;

		};

		fixed4 _Color;
		float _NormalMapIntensity;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed3 normalData = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			normalData.r *= _NormalMapIntensity;
			normalData.g *= _NormalMapIntensity;
			o.Normal = normalData.rgb;
			o.Albedo = _Color;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
