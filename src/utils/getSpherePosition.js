// 菲波那契网格
export default function getSpherePosition(n, N) {
  const phi = (Math.sqrt(5) - 1) / 2;
  const z = (2 * n) / N - 1;
  const x = (1 - z ** 2) ** 0.5 * Math.cos(2 * Math.PI * n * phi);
  const y = (1 - z ** 2) ** 0.5 * Math.sin(2 * Math.PI * n * phi);

  return {
    x,
    y,
    z,
  };
}
