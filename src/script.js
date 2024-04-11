import * as THREE from 'three'
import { OrbitControls } from 'three/addons/controls/OrbitControls.js'
import GUI from 'lil-gui'
import fireworksVertexShader from './shaders/fireworks/vertex.glsl'
import fireworksFragmentShader from './shaders/fireworks/fragment.glsl'
import { gsap } from 'gsap'
import getSpherePosition from './utils/getSpherePosition.js'

/**
 * Base
 */
// Debug
const gui = new GUI({ width: 340 })

// Canvas
const canvas = document.querySelector('canvas.webgl')

// Scene
const scene = new THREE.Scene()

// Loaders
const textureLoader = new THREE.TextureLoader()

/**
 * Sizes
 */
const sizes = {
  width: window.innerWidth,
  height: window.innerHeight,
  pixelRatio: Math.min(window.devicePixelRatio, 2),
}
sizes.resolution = new THREE.Vector2(sizes.width, sizes.height)

window.addEventListener('resize', () => {
  // Update sizes
  sizes.width = window.innerWidth
  sizes.height = window.innerHeight
  sizes.pixelRatio = Math.min(window.devicePixelRatio, 2)
  sizes.resolution.set(sizes.width, sizes.height)

  // Update camera
  camera.aspect = sizes.width / sizes.height
  camera.updateProjectionMatrix()

  // Update renderer
  renderer.setSize(sizes.width, sizes.height)
  renderer.setPixelRatio(sizes.pixelRatio)
})

/**
 * Camera
 */
// Base camera
const camera = new THREE.PerspectiveCamera(25, sizes.width / sizes.height, 0.1, 100)
camera.position.set(1.5, 0, 6)
scene.add(camera)

// Controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true

/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
  canvas: canvas,
  antialias: true,
})
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

/**
 * Fireworks
 */

const createFirework = (count, size, delayStep, tailCount) => {
  const positions = new Float32Array(count * 3 * tailCount)
  const delays = new Float32Array(count * tailCount)

  for (let i = 0; i < count; i++) {
    const i3 = i * 3
    const { x, y, z } = getSpherePosition(i, count)
    positions[i3 + 0] = x
    positions[i3 + 1] = y
    positions[i3 + 2] = z

    for (let j = 1; j < tailCount; j++) {
      positions[i3 + j * count * 3 + 0] = positions[i3 + 0]
      positions[i3 + j * count * 3 + 1] = positions[i3 + 1]
      positions[i3 + j * count * 3 + 2] = positions[i3 + 2]
    }
  }

  for (let i = 0; i < count; i++) {
    for (let j = 0; j < tailCount; j++) {
      delays[i + j * count] = j * delayStep
    }
  }

  console.log(positions, delays)

  const geometry = new THREE.BufferGeometry()
  geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
  geometry.setAttribute('aDelay', new THREE.BufferAttribute(delays, 1))

  const material = new THREE.ShaderMaterial({
    vertexShader: fireworksVertexShader,
    fragmentShader: fireworksFragmentShader,
    uniforms: {
      uResolution: new THREE.Uniform(sizes.resolution),
      uPixelRatio: new THREE.Uniform(sizes.pixelRatio),
      uSize: new THREE.Uniform(size),
      uProgress: new THREE.Uniform(0),
    },
    transparent: true,
    depthWrite: false,
    blending: THREE.AdditiveBlending,
  })
  const firework = new THREE.Points(geometry, material)
  scene.add(firework)

  // Animation
  const destroy = () => {
    scene.remove(firework)
    geometry.dispose()
    material.dispose()
  }
  gsap.to(material.uniforms.uProgress, {
    value: 2,
    duration: 6,
    ease: 'linear',
    // onComplete: destroy,
  })
}

createFirework(100, 0.05, 0.01, 20)

/**
 * Animate
 */
const tick = () => {
  // Update controls
  controls.update()

  // Render
  renderer.render(scene, camera)

  // Call tick again on the next frame
  window.requestAnimationFrame(tick)
}

tick()
