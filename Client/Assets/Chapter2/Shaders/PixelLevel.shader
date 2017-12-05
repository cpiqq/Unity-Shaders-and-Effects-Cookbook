Shader "Custom/PixelLevel" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_inWhite("_inWhite", Range(0,255)) = 255
		_inBlack("_inBlack", Range(0,255)) = 0
		_inGama("_inGama", Range(0,2)) = 1.6

		_outBlack("_outBlack", Range(0,255)) = 0
		_outWhite("_outWhite", Range(0,255)) = 255

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		half _inWhite;
		half _inBlack;
		half _inGama;
		half _outBlack;
		half _outWhite;

		struct Input {
			float2 uv_MainTex;
		};

		inline half GetPixelLevel(float pixelColor)
		{
			half pixelResult;
			pixelResult = pixelColor * 255.0;
			pixelResult = max(0, pixelResult - _inBlack);
			pixelResult = saturate(pow(pixelResult / (_inWhite - _inBlack), _inGama));
			pixelResult = (pixelResult * (_outWhite - _outBlack) + _outBlack ) / 255.0;
			return pixelResult;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = fixed3(GetPixelLevel(c.r), GetPixelLevel(c.g),GetPixelLevel(c.b));
			o.Alpha = c.a;
		}
	   

		ENDCG
	}
	FallBack "Diffuse"
}
