Shader "Custom/BasicDifuse" {
	Properties {
		_AmbientColor("_AmbientColor", Color) = (1,1,1,1)
		_EmissiveColor("_EmissiveColor", Color) = (1,1,1,1)
		_MySliderValue("_MySliderValue", Range(0,10)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard lambert
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _AmbientColor;
		fixed4 _EmissiveColor;
		fixed _MySliderValue;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			half4 c;
			c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
