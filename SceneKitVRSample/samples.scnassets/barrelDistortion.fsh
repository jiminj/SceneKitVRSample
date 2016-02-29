
//reference
// http://rifty-business.blogspot.kr/2013/08/understanding-oculus-rift-distortion.html
// https://forums.oculus.com/viewtopic.php?t=3413

uniform sampler2D colorSampler;
varying vec2 uv;
const vec4 hmdWarpParam = vec4(1.0,0.22,0.24,0.0);

void main() {
    vec2 p = 2.0 * uv.xy - 1.0;
    float theta  = atan(p.y, p.x);
    float radius = length(p);

    float rSq = pow(radius, 2.0);
    
    float distortionScale = hmdWarpParam.x + hmdWarpParam.y * rSq
                        + hmdWarpParam.z * rSq * rSq
                        + hmdWarpParam.w * rSq * rSq * rSq;
    
    float newRadius = radius * distortionScale;
    p.x = newRadius * cos(theta);
    p.y = newRadius * sin(theta);
    vec2 uv2 = (p + 1.0) * 0.5;
    
    if(abs(p.x) > 1.0 || abs(p.y) > 1.0) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
    else {
        gl_FragColor = texture2D(colorSampler, uv2);
    }
}
