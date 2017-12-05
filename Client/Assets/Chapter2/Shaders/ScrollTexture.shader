Shader "Custom/ScrollTexture" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTe ("Albedo (RGB)", 2D) = "white" {}
		_xSpeed ("_xSpeed", Range(0,10)) = 0.5
		_ySpeed ("_ySpeed", Range(0,10)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTe;

		struct Input {
			float2 uv_MainTe;
		};

		fixed4 _Color;
		fixed _xSpeed;
		fixed _ySpeed;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed2 origionUV = IN.uv_MainTe;
			_xSpeed *= _Time;
			_ySpeed *= _Time;
			fixed2 offset = fixed2(_xSpeed, _ySpeed);
			fixed2 offsetUV = offset * origionUV;

			fixed4 c = tex2D (_MainTe, origionUV + offsetUV) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
