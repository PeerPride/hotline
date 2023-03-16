import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import vue from '@vitejs/plugin-vue';
import vuetify from "@vuetify/vite-plugin"
import rollupNodePolyFill from 'rollup-plugin-node-polyfills'
import path from 'path';

export default defineConfig({
  resolve: {
    alias: [
      {
        find: 'util',
        replacement: 'rollup-plugin-node-polyfills/polyfills/util',
      },
      {
        find: 'events',
        replacement: 'rollup-plugin-node-polyfills/polyfills/events'
      },
      {
        find: '@',
        replacement: path.resolve(__dirname, 'app', 'javascript'),
      },
    ],
    extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue'],
  },
  plugins: [vue(), RubyPlugin()/*, vuetify()*/],
  build: {
    rollupOptions: {
      plugins: [
        //rollupNodePolyFill()
      ]
    }
  },
  css: {
    preprocessorOptions: {
      scss: {
        sourceMap: false,
        additionalData(source: any, fp: any) {
          if (fp.endsWith('variables.scss')) return source;

          return `@import "@/assets/css/_variables.scss"; ${source}`;
        },
      },
    },
  },
});
