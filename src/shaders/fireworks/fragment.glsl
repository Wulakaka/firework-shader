uniform vec3 uColor;

void main() {
    gl_FragColor = vec4(uColor, 0.5);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}
