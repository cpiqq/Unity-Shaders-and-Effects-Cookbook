Shader "Custom/NewShader3_4" {
	Properties {
		//_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("_MainTint", Color) = (1,1,1,1)
		_SpecularColor("_SpecularColor", Color) = (1,1,1,1)
		_SpecPower("_SpecPower", Range(0,30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong

		sampler2D _MainTex;
		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecPower;

		struct Input {
			float2 uv_MainTex;
		};

		inline fixed4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			fixed3 halfVector = normalize(lightDir + viewDir);
			half diff = max(dot(s.Normal, lightDir), 0);
			half nh = max(dot(s.Normal, halfVector), 0);
			float spec = pow(nh,_SpecPower);

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * _SpecularColor.rgb * spec) * (atten * 2);
			c.a = s.Alpha;
			return c;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			//half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = _MainTint.rgb;
			o.Alpha = _MainTint.a;
		}
	
		ENDCG
	} 
	FallBack "Diffuse"
}
