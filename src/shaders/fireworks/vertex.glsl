uniform vec2 uResolution;
uniform float uPixelRatio;
uniform float uSize;
uniform float uProgress;

attribute float aDelay;

float remap(float value, float originMin, float originMax, float destinationMin, float destinationMax)
{
    return destinationMin + (value - originMin) * (destinationMax - destinationMin) / (originMax - originMin);
}

void main() {
    vec3 newPosition = position;

    // Falling 下落
    float progressFalling = remap(uProgress, 0.1, 1.0, 0.0, 1.0);
    progressFalling = clamp(progressFalling, 0.0, 1.0);
    progressFalling = 1.0 - pow(1.0 - progressFalling, 3.0);
    newPosition.y -= progressFalling * 0.2 * (1.0 - pow(aDelay * 4.0, 0.5));

    float progress = clamp(uProgress - aDelay, 0.0, 1.0);
    newPosition = mix(vec3(0.0), newPosition, progress);

    vec4 modelPosition = modelMatrix * vec4(newPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;


    float size = 1.0 - pow(aDelay * 4.0, 2.0);
    gl_PointSize = uSize * uResolution.y * uPixelRatio * size;
    gl_PointSize *= 1.0 / -viewPosition.z;
    // Final position
    gl_Position = projectedPosition;

    if(gl_PointSize < 1.0) {
        gl_Position = vec4(9999.9);
    }
}
