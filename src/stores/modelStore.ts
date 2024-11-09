import { writable } from 'svelte/store';
import type { Application } from 'pixi.js';

export const appStore = writable<Application | null>(null);
export const speakStore = writable<((audioLink: string) => void) | null>(null);