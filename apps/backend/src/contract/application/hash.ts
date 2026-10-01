/**
 * SHA-256 de los bytes finales del PDF (HAB-31).
 *
 * Hex minúsculas. Se guarda junto al documento, no dentro del dominio.
 */

export async function sha256Hex(bytes: Uint8Array): Promise<string> {
  const digest = await crypto.subtle.digest('SHA-256', bytes);
  return [...new Uint8Array(digest)]
    .map((byte) => byte.toString(16).padStart(2, '0'))
    .join('');
}
