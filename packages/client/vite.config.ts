import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { mud } from "vite-plugin-mud";
import tailwindcss from "tailwindcss";
import path from "path";

export default defineConfig({
  plugins: [react(), mud({ worldsFile: "../contracts/worlds.json" })],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  css: {
    postcss: {
      plugins: [tailwindcss()],
    },
  },
  server: {
    port: 3000,
  },
  build: {
    target: "es2022",
    minify: true,
    sourcemap: true,
  },
});
