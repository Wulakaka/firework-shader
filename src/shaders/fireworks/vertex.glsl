uniform vec2 uResolution;
uniform float uPixelRatio;
uniform float uSize;
uniform float uProgress;

attribute float aDelay;

float remap(float value, float originMin, float originMax, float destinationMin, float destinationMax)
{
    return destinationMin + (value - originMin) * (destinationMax - destinationMin) / (originMax - originMin);
}

float getS (float v0, float a, float t) {
    return (v0 + v0 + a * t) * t * 0.5;
}

void main() {
    vec3 newPosition = position;

    // Falling 下落
    float progress = clamp(uProgress - aDelay, 0.0, 1.0);
    // 目标是没有重力作用下预期的位置
    newPosition = mix(vec3(0.0), newPosition, progress);
    newPosition.y += getS(position.y * 0.1, -1.0, progress);
    newPosition.x += getS(position.x * 0.1, -0.5, progress);
    newPosition.z += getS(position.z * 0.1, -0.2, progress);

    // Scaling 缩放
    float progressScalingClose = remap(progress, 0.8 - aDelay * 2.0, 1.0, 1.0, 0.0);
    float progressScaling = clamp(progressScalingClose, 0.0, 1.0);

    // Twinkling 闪烁
    float progressTwinkling = remap(progress, 0.2, 0.8, 0.0, 1.0);
    progressTwinkling = clamp(progressTwinkling, 0.0, 1.0);
    float twinklingSize = sin(progressTwinkling * 30.0) * 0.5 + 0.5;
    // 0 - 0.2 时 progress 为 0，为了不让size变化，需要将 twinklingSize 保持为 1
    twinklingSize = 1.0 - twinklingSize * progressTwinkling;


    vec4 modelPosition = modelMatrix * vec4(newPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;


    float sizeDecay = 1.0 - pow(aDelay * 2.0, 1.2);
    gl_PointSize = uSize * uResolution.y * uPixelRatio * sizeDecay * progressScaling;
    gl_PointSize *= 1.0 / -viewPosition.z;
    // Final position
    gl_Position = projectedPosition;

    if (gl_PointSize < 1.0) {
        gl_Position = vec4(9999.9);
    }
}
