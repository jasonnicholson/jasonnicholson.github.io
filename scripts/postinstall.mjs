import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

// Resolve paths relative to this script's location (scripts/postinstall.mjs)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const src = path.resolve(__dirname, '..', 'node_modules', 'highlightjs-vba', 'dist', 'vba.min.js');
const destDir = path.resolve(__dirname, '..', 'libs', 'highlight');
const dest = path.join(destDir, 'vba.min.js');

await fs.mkdir(destDir, { recursive: true });

try {
  await fs.copyFile(src, dest);
  console.log(`Copied: ${src} -> ${dest}`);
} catch (err) {
  console.error('Failed to copy highlightjs-vba file:', err);
  process.exitCode = 1;
}