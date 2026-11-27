import { JSDOM } from 'jsdom';
const dom = new JSDOM('<!DOCTYPE html><html><body></body></html>', { pretendToBeVisual: true });
globalThis.window = dom.window;
globalThis.document = dom.window.document;
Object.defineProperty(globalThis, 'navigator', { value: dom.window.navigator, configurable: true });
try {
  const m = await import('lottie-web');
  const l = m.default || m;
  console.log('lottie-web with jsdom: loadAnimation =', typeof l.loadAnimation, '| keys:', Object.keys(l).slice(0,6).join(','));
} catch (e) {
  console.log('lottie-web with jsdom: FAIL —', e.message.split('\n')[0]);
}
