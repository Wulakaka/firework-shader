uniform vec3 uColor;
uniform sampler2D uTexture;

void main() {
    vec4 texture = texture(uTexture, gl_PointCoord);

    gl_FragColor = vec4(uColor, texture.r);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}
