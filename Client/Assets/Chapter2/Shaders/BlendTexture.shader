Shader "Custom/BlendTexture" {
	Properties {
		_ColorA ("ColorA", Color) = (1,1,1,1)
		_ColorB ("ColorB", Color) = (1,1,1,1)

		_BlendTex ("_BlendTex", 2D) = "white" {}
		_RTex("_RTex", 2D) = ""{}
		_GTex("_GTex", 2D) = ""{}
		_BTex("_BTex", 2D) = ""{}
		_ATex("_ATex", 2D) = ""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		#pragma target 4.0

		sampler2D _BlendTex;
		sampler2D _RTex;
		sampler2D _GTex;
		sampler2D _BTex;
		sampler2D _ATex;
		fixed4 _ColorA;
		fixed4 _ColorB;

		struct Input {
			float2 uv_BlendTex;
			float2 uv_RTex;
			float2 uv_GTex;
			float2 uv_BTex;
			float2 uv_ATex;

		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed2 rUV = IN.uv_RTex;
			fixed2 gUV = IN.uv_GTex;
			fixed2 bUV = IN.uv_BTex;
			fixed2 aUV = IN.uv_ATex;
			fixed2 blendUV = IN.uv_BlendTex;
		
			fixed4 rData = tex2D(_RTex, rUV);
			fixed4 gData = tex2D(_GTex, gUV);
			fixed4 bData = tex2D(_BTex, bUV);
			fixed4 aData = tex2D(_ATex, aUV);
			fixed4 blendData = tex2D(_BlendTex, blendUV);

			fixed4 c = lerp(rData, gData, blendData.g);
			c = lerp(c, bData, blendData.b);
			c = lerp(c, aData, blendData.a);
			c *= lerp(_ColorA, _ColorB, blendData.r);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
