Shader "Custom/SpriteSheet" {
	Properties {
		_MainTex("_MainTex",2D) = ""{}
		_Speed("_Speed", Range(0,5)) = 3
		_SpriteCount("_SpriteCount", float)= 9
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		fixed _Speed;
		float _SpriteCount;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed2 origionUV = IN.uv_MainTex;
			fixed2 scaledUV = fixed2(origionUV.x * 1/_SpriteCount, origionUV.y);

			float timeSpeed = _Speed * _Time.y;
			timeSpeed = ceil(timeSpeed);
		    timeSpeed = fmod(timeSpeed, _SpriteCount);

			scaledUV.x += timeSpeed *  1/_SpriteCount;
			fixed4 c = tex2D (_MainTex, scaledUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
