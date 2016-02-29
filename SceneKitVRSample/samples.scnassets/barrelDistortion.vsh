attribute vec4 a_position;
varying vec2 uv;

void main() {
    uv = (a_position.xy + 1.0) * 0.5;
    gl_Position = a_position;
    
}
