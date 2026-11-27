import { JSDOM } from 'jsdom';
const dom = new JSDOM('<!DOCTYPE html><html><body></body></html>', { pretendToBeVisual: true });
globalThis.window = dom.window;
globalThis.document = dom.window.document;
Object.defineProperty(globalThis, 'navigator', { value: dom.window.navigator, configurable: true });
globalThis.screen = dom.window.screen;
globalThis.requestAnimationFrame = (cb) => setTimeout(cb, 16);
try {
  const m = await import('p5');
  console.log('p5 import with jsdom: OK, default is', typeof m.default);
} catch (e) {
  console.log('p5 import with jsdom: FAIL —', e.message.split('\n')[0]);
}
