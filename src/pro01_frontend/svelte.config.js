import adapter from '@sveltejs/adapter-static';
/* import preprocess from 'svelte-preprocess'; */
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';


/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: vitePreprocess(),
  kit: {
    adapter: adapter({
      pages: 'dist',
      assets: 'dist',
      fallback: undefined,
      precompress: false,
      strict: true,
    }),
  },
};

export default config;