uniform vec2 uResolution;
uniform float uPixelRatio;
uniform float uSize;
uniform float uProgress;

attribute float aDelay;

void main() {
    vec3 newPosition = position;

    float progress = clamp(uProgress - aDelay, 0.0, 1.0);

    newPosition = mix(vec3(0.0), newPosition, progress);

    float size = 1.0 - pow(aDelay * 4.0, 2.0);

    vec4 modelPosition = modelMatrix * vec4(newPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;


    gl_PointSize = uSize * uResolution.y * uPixelRatio * size;
    gl_PointSize *= 1.0 / -viewPosition.z;
    // Final position
    gl_Position = projectedPosition;

    if(gl_PointSize < 1.0) {
        gl_Position = vec4(9999.9);
    }
}
