#ifndef EMITER_INCLUDED
#define EMITER_INCLUDED

#include "UnityCG.cginc"

float4		_g_cl;
float3		_g_dir;
float		_g_scl;
float		_g_sat;

float		_e_scl;
float		_e_max;
			
float		_global_scale;
float		_emiter_scale;


struct vcol
{
	float4 	vertex 				: POSITION;
	float2 	color 				: COLOR;
};

struct vtex
{
	float4 	vertex 				: POSITION;
	float2 	texcoord 			: TEXCOORD;
};

struct vnorm
{
	float4 	vertex 				: POSITION;
	float4	color 				: COLOR;
	float2 	texcoord 			: TEXCOORD;
	float3 	normal 				: NORMAL;
};
			
struct vrefl 
{
    float4 	vertex 				: POSITION;
	float4	color 				: COLOR;
	float2 	texcoord 			: TEXCOORD;
    float3 	normal 				: NORMAL;
    float4 	tangent 			: TANGENT;
};
        
struct itex
{
	float4 	pos 				: POSITION;
	float2 	uv 					: TEXCOORD0;
	float3 	light				: TEXCOORD2;
};
        
struct inorm
{
	float4 	pos 				: POSITION;
	float2 	uv 					: TEXCOORD0;
	float3 	normal 				: TEXCOORD1;
	float3 	light				: TEXCOORD2;
};
				
struct irefl
{
    float4  pos 				: SV_POSITION;
	float4	color 				: COLOR;
    float2  uv 					: TEXCOORD0;
	float2  uv1 				: TEXCOORD1;
    float3  normal 				: TEXCOORD2;
    float3  tangent 			: TEXCOORD3;
    float3  binormal 			: TEXCOORD4;
    float3  view_dir 			: TEXCOORD5;
	float3 	light				: TEXCOORD6;
};

float3 LightSun(float3 WorldNormal)
{
	return max(dot(WorldNormal, _g_dir), _g_sat) * _g_cl * _g_scl * _global_scale;
}

float3 Light(float3 WorldNormal)
{
	//float4 	wn1 			= WorldNormal.xyzz * WorldNormal.yzzx;
	//float		dxy				= WorldNormal.x*WorldNormal.x - WorldNormal.y*WorldNormal.y;

	float3		sun_light		= max(dot(WorldNormal, _g_dir), _g_sat *0.7) * _g_cl * _g_scl;
	//float3	sun_light		= dot(WorldNormal, _g_dir) * _g_cl * _g_scl;
						
	return sun_light * (_global_scale);
}

float3 Reflect(irefl i, sampler2D NormalMap, samplerCUBE CubeMap, float Scale)
{
	float3  	refl 			= float3 (0,0,0);
					
	if (Scale > 0)
	{
		float3 	nrml 			= UnpackNormal(tex2D(NormalMap, i.uv1));
    	float3 	normalW 		= (i.tangent * nrml.x) + (i.binormal * nrml.y) + (i.normal * nrml.z);
    			refl 			= texCUBE(CubeMap, reflect(i.view_dir, normalW)).rgb * Scale;
	}
	
	return refl;
}

float3 Reflect(irefl i, float2 iuv, sampler2D NormalMap, samplerCUBE CubeMap, float Scale)
{
	float3  	refl 			= float3 (0,0,0);
					
	if (Scale > 0)
	{
		float3 	nrml 			= UnpackNormal(tex2D(NormalMap, iuv));
    	float3 	normalW 		= (i.tangent * nrml.x) + (i.binormal * nrml.y) + (i.normal * nrml.z);

    	refl 					= texCUBE(CubeMap, reflect(i.view_dir, normalW)).rgb * Scale;
	}
	
	return refl;
}

float3 Tint(float3 V0, float3 V1, float3 V2, float3 V3, float3 Scale)
{			 
	V1  						= (V0 + V1) * Scale.x;
	V2  						= (V0 + V2) * Scale.y;
	V3  						= (V0 + V3) * Scale.z;
	
	return V1+V2+V3;
}


#endif
