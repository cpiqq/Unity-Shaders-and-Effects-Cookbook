Shader "Custom/SpriteSheet1" {
	Properties {
		_MainTex("_MainTex",2D) = ""{}
		_Stage("_Stage", float) = 0
		_xScaleCoefficient("_xScaleCoefficient", float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		float _Stage;
		float _xScaleCoefficient;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed2 origionUV = IN.uv_MainTex;
			fixed2 scaledUV = origionUV * fixed2(_xScaleCoefficient,1);

			scaledUV.x += _Stage * _xScaleCoefficient;
			fixed4 c = tex2D (_MainTex, scaledUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
