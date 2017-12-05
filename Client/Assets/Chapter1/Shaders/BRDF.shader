Shader "Custom/BRDF" {
	Properties {
		_AmbientColor("_AmbientColor", Color) = (1,1,1,1)
		_EmissiveColor("_EmissiveColor", Color) = (1,1,1,1)
		_MySliderValue("_MySliderValue", Range(0,10)) = 03
		_RampTex("_RampTex", 2D) = ""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BasicDiffuse
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _AmbientColor;
		fixed4 _EmissiveColor;
		fixed _MySliderValue;
		sampler2D _RampTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c;
			c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		inline fixed4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			// half difLight = max(0, dot(s.Normal, lightDir));
			half difLight = dot(s.Normal, lightDir);
			difLight = difLight * 0.5 +0.5;

			half viewDif = max(0, dot(s.Normal, viewDir));

			half3 ramp = tex2D(_RampTex, half2(difLight,viewDif)).rgb;

			fixed4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * ramp;
			col.a = s.Alpha;
			return col;
		}

		
		ENDCG
	}
	FallBack "Diffuse"
}
