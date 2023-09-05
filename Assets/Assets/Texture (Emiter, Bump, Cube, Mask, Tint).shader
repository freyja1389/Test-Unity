// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CG/Emiter/Texture (Bump, Refl, Mask, Tint)" 
{	
	Properties 
	{
		_tex 				("Texture", 					2D) 	= "grey" 	{}
		_normal 			("Normal", 						2D) 	= "bump" 	{}
		
		_refl 				("Reflection", 					CUBE) 	= "black" 	{}
		_color_0			("_color_0", 					color)	= (1,1,1,1)
		_color_1			("_color_1", 					color)	= (1,1,1,1)
		_color_2			("_color_2", 					color)	= (1,1,1,1)

		_refl_tint_mask		("Scale: Refl 'r', Tint 'gba'", 2D)		= "black" 	{}
		_ao					("_ao",							2D)		= "white" 	{}
		_refl_tint_scale	("",							Vector) = (1,1,1,1)
		
		_global_scale 		("Scale: Global light", 		float) 	= 1.0
		_emiter_scale		("Scale: Emiters light",		float) 	= 1.0

		_g_cl               ("Global color",                Color) = (1, 1, 1, 1)
		_g_dir              ("Global light direction",      Vector) = (0, 1, 0)
		_g_scl              ("Global light scale",          Range(0, 2)) = 1.0
		_g_sat              ("Global light saturation",     Range(0, 1)) = 1.0

	}
     
    Category 
    {
		Cull 								Back 
		ZWrite 								On 
		Lighting 							Off 
		
		Fog 								{Mode Off}
		
		Tags 		
		{
			"RenderType"					= "Opaque"
			"Queue"							= "Geometry" 
			"LightMode" 					= "ForwardBase" 
			"IgnoreProjector"				= "True"
		}
		
		SubShader 
		{	
			CGINCLUDE
			#include "Emiter.cginc"
					

			sampler2D 						_ao;
			sampler2D 						_tex;
			sampler2D						_normal;
			sampler2D						_refl_tint_mask;
			
			float4 							_tex_ST;

			samplerCUBE 					_refl;
			float4 							_color_0;
			float4 							_color_1;
			float4 							_color_2;
			
			float4							_refl_tint_scale;
			
			struct vdata
			{
				float4 	vertex 				: POSITION;
				float2 	texcoord 			: TEXCOORD;
				float3 	normal 				: NORMAL;
				float4 	tangent 			: TANGENT;
				float3 	color 				: COLOR;
			};

			struct fdata
			{
				float4  pos 				: SV_POSITION;
				float2  uv 					: TEXCOORD0;
				float3  normal 				: TEXCOORD1;
				float3  tangent 			: TEXCOORD2;
				float3  binormal 			: TEXCOORD3;
				float3  view_dir 			: TEXCOORD4;
				float3 	light				: TEXCOORD5;
			};
		

			fdata vert (vdata v)
			{
				fdata 		o;

							o.pos 			= UnityObjectToClipPos(v.vertex);
							o.uv			= v.texcoord * _tex_ST.xy + _tex_ST.zw;
							o.normal 		= mul((float3x3)unity_ObjectToWorld, v.normal.xyz);
							o.tangent		= v.tangent;
							o.binormal 		= cross(o.normal, o.tangent) * v.tangent.w;
							o.view_dir 		= normalize(o.normal - _WorldSpaceCameraPos.xyz);
							//o.view_dir 	= ObjSpaceViewDir(o.pos);
							o.light			= Light(normalize(o.normal))*v.color.rgb;

				return 		o; 
			}

			float4 frag (fdata i) : COLOR
			{					
				float4 t 					= tex2D		(_tex, 				i.uv);
				float4 ao 					= tex2D		(_ao, 				i.uv);
				float4 mask					= tex2D		(_refl_tint_mask,	i.uv);
				
				//float3 refl 				= Reflect	(i, i.uv, i.tangent, i.binormal, i.normal, i.view_dir, _normal, _refl, mask.r * _refl_tint_scale.x);

				float3 nrml 				= UnpackNormal(tex2D(_normal, i.uv));
    			float3 normalW 				= (i.tangent * nrml.x) + (i.binormal * nrml.y) + (i.normal * nrml.z);
    			float3 refl 				= texCUBE(_refl, reflect(i.view_dir, normalW)).rgb * mask.r * _refl_tint_scale.x;

				float3 tint					= Tint		(t.rgb, _color_0.rgb, _color_1.rgb, _color_2.rgb, mask.gba * _refl_tint_scale.yzw);
				
					   t.rgb 				= t.rgb * i.light * ao + refl + tint;

				return t;
			}
			ENDCG
			
			Pass 
			{
				CGPROGRAM
				#pragma vertex 				vert
				#pragma fragment 			frag
				#pragma fragmentoption 		ARB_precision_hint_fastest 
				ENDCG
			}
		}
	}
}