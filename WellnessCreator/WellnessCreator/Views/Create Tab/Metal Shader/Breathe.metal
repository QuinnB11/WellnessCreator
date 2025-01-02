//
//  Breathe.metal
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/27/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 checkerboard(float2 position, half4 currentColor, float time, float speed, float size, float enabled) {
    if (enabled == 1.0) {
        float2 offset = float2(time * speed, time * speed);
        uint2 posInChecks = uint2(1000 + (position.x + offset.x) / size, 1000 + (position.y + offset.y) / size);
        bool isColor = (posInChecks.x ^ posInChecks.y) & 1;
        return isColor ? currentColor : half4(0.0, 0.0, 0.0, 0.0);
    }
    return currentColor;
}



float smooth(float t, float strength) {
    return t * t * strength;
}


float perlinNoise(float2 p, float strength) {
    float2 i = floor(p);
    float2 f = fract(p);
    
    float2 g = float2(sin(i.x + i.y), cos(i.x - i.y));
    
    float n00 = dot(g, f);
    float n01 = dot(g + float2(1.0, 0.0), f - float2(1.0, 0.0));
    float n10 = dot(g + float2(0.0, 1.0), f - float2(0.0, 1.0));
    float n11 = dot(g + float2(1.0, 1.0), f - float2(1.0, 1.0));

    float x = smooth(f.x, strength);
    float y = smooth(f.y, strength);

    float nx0 = mix(n00, n10, x);
    float nx1 = mix(n01, n11, x);
    return mix(nx0, nx1, y);
}


[[ stitchable ]] half4 noise(float2 position, half4 currentColor, float time, float strength, float enabled) {
   
    if (enabled == 1.0) {
            float noiseValue = perlinNoise(position * 0.3 + time, strength * 10);
            float noiseFactor = (noiseValue + 1.0) * 0.5;
            half3 noisyColor = currentColor.rgb * (noiseFactor) + currentColor.rgb;
            return half4(noisyColor, currentColor.a);
        }
        return currentColor;
}

[[ stitchable ]] half4 pixellate(float2 position, SwiftUI::Layer layer, float strength) {
    float min_strength = max(strength, 0.0001);
    float coord_x = min_strength * round(position.x / min_strength);
    float coord_y = min_strength * round(position.y / min_strength);
    return layer.sample(float2(coord_x, coord_y));
}


[[ stitchable ]] float2 complexWave(float2 position, float time, float2 size, float speed, float strength, float frequency, float enabled) {
    
    if (enabled == 1.0) {
        float2 normalizedPosition = position / size;
        float moveAmount = time * speed;
        
        position.x += sin((normalizedPosition.x + moveAmount) * frequency) * strength;
        position.y += cos((normalizedPosition.y + moveAmount) * frequency) * strength;
        
        return position;
    }
    return position;
   

}

half3 rgbToHsv(half3 rgb) {
    half cmax = max(rgb.r, max(rgb.g, rgb.b));
    half cmin = min(rgb.r, min(rgb.g, rgb.b));
    half delta = cmax - cmin;

    half h = 0.0;
    if (delta != 0.0) {
        if (cmax == rgb.r) {
            h = (rgb.g - rgb.b) / delta;
        } else if (cmax == rgb.g) {
            h = (rgb.b - rgb.r) / delta + 2.0;
        } else {
            h = (rgb.r - rgb.g) / delta + 4.0;
        }
    }

    h = h / 6.0;
    h = h - floor(h);
    
    half s = (cmax == 0.0) ? 0.0 : delta / cmax;
    half v = cmax;

    return half3(h, s, v);
}

half3 hsvToRgb(half3 hsv) {
    half h = hsv.x;
    half s = hsv.y;
    half v = hsv.z;

    half c = v * s;
    half x = c * (1.0 - abs(fract(h * 6.0) * 2.0 - 1.0));
    half m = v - c;

    half3 rgb;
    if (h < 1.0 / 6.0) {
        rgb = half3(c, x, 0.0);
    } else if (h < 2.0 / 6.0) {
        rgb = half3(x, c, 0.0);
    } else if (h < 3.0 / 6.0) {
        rgb = half3(0.0, c, x);
    } else if (h < 4.0 / 6.0) {
        rgb = half3(0.0, x, c);
    } else if (h < 5.0 / 6.0) {
        rgb = half3(x, 0.0, c);
    } else {
        rgb = half3(c, 0.0, x);
    }

    return rgb + half3(m, m, m);
}

[[ stitchable ]] half4 flipHue(float2 position, half4 currentColor, float time, float enabled) {
    if (enabled == 1.0) {
        float hueShift = 0.5 * sin(time / 8) ;
        half3 hsv = rgbToHsv(currentColor.rgb);
        hsv.x = fract(hsv.x + hueShift);
        half3 flippedColor = hsvToRgb(hsv);
        return half4(flippedColor, currentColor.a);
    }
    return currentColor;
}

// TODO ??? HAVE TO STILL ADD
[[stitchable]] float3 rotate(float3 position, float time, float3 size, float speed) {
    float angle = time * speed;
    float cosAngle = cos(angle);
    float sinAngle = sin(angle);
    
    float3x3 rotationMatrix = float3x3(
        float3(cosAngle, 0.0, sinAngle),
        float3(0.0, 1.0, 0.0),
        float3(-sinAngle, 0.0, cosAngle)
    );
    
    float3 rotatedPosition = position * rotationMatrix;
    rotatedPosition *= size;
    
    return rotatedPosition;
}

