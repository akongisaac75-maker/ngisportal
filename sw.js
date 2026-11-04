// v2 - NGIS Live App logo update. Minimal service worker: always loads fresh from network (no stale cache).
self.addEventListener('install',e=>self.skipWaiting());
self.addEventListener('activate',e=>e.waitUntil(self.clients.claim()));
self.addEventListener('fetch',e=>{ e.respondWith(fetch(e.request)); });
