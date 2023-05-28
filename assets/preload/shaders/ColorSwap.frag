#pragma header

// WiggleEffect
uniform float uTime;
const int EFFECT_TYPE_DREAMY = 0;
const int EFFECT_TYPE_WAVY = 1;
const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
const int EFFECT_TYPE_FLAG = 4;
uniform int effectType;
uniform vec3 uSettings; //uSpeed, uFrequency, uWaveAmplitude

// ColorSwap
uniform vec3 vColors;
uniform bool awesomeOutline;
const float offset = 1.0 / 128.0;

// ColorSwap
vec3 normalizeColor(vec3 color)
{
	return vec3(
		color[0] / 255.0,
		color[1] / 255.0,
		color[2] / 255.0
	);
}

// ColorSwap
vec3 rgb2hsv(vec3 c)
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// WiggleEffect
vec2 sineWave(vec2 pt)
{
	float x = 0.0;
	float y = 0.0;
	
	if (effectType == EFFECT_TYPE_DREAMY) 
	{
		float offsetX = sin(pt.y * uSettings[1] + uTime * uSettings[0]) * uSettings[2];
        pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
	}
	else if (effectType == EFFECT_TYPE_WAVY) 
	{
		float offsetY = sin(pt.x * uSettings[1] + uTime * uSettings[0]) * uSettings[2];
		pt.y += offsetY; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
	}
	else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
	{
		x = sin(pt.x * uSettings[1] + uTime * uSettings[0]) * uSettings[2];
	}
	else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
	{
		y = sin(pt.y * uSettings[1] + uTime * uSettings[0]) * uSettings[2];
	}
	else if (effectType == EFFECT_TYPE_FLAG)
	{
		y = sin(pt.y * uSettings[1] + 10.0 * pt.x + uTime * uSettings[0]) * uSettings[2];
		x = sin(pt.x * uSettings[1] + 5.0 * pt.y + uTime * uSettings[0]) * uSettings[2];
	}
	
	return vec2(pt.x + x, pt.y + y);
}

vec4 colorSwap(vec2 pt)
{
	vec4 color = flixel_texture2D(bitmap, pt);

	vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);

	swagColor[0] = swagColor[0] + vColors[0];
	swagColor[1] = swagColor[1] + vColors[1];
	swagColor[2] = swagColor[2] * (1.0 + vColors[2]);
	
	if(swagColor[1] < 0.0)
	{
		swagColor[1] = 0.0;
	}
	else if(swagColor[1] > 1.0)
	{
		swagColor[1] = 1.0;
	}

	color = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);

	if (awesomeOutline)
	{
		 // Outline bullshit?
		vec2 size = vec2(3, 3);
	
		if (color.a <= 0.5) {
			float w = size.x / openfl_TextureSize.x;
			float h = size.y / openfl_TextureSize.y;
			
			if (flixel_texture2D(bitmap, vec2(pt.x + w, pt.y)).a != 0.
			|| flixel_texture2D(bitmap, vec2(pt.x - w, pt.y)).a != 0.
			|| flixel_texture2D(bitmap, vec2(pt.x, pt.y + h)).a != 0.
			|| flixel_texture2D(bitmap, vec2(pt.x, pt.y - h)).a != 0.)
				color = vec4(1.0, 1.0, 1.0, 1.0);
		}
	}
	return color;
}

void main()
{
	vec2 uv = sineWave(openfl_TextureCoordv);
	gl_FragColor = colorSwap(uv);
}