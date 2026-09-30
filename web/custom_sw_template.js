'use strict';

// Flutter's own generated `flutter_service_worker.js` (as of this Flutter
// SDK version) immediately unregisters itself in its `activate` handler —
// intentional upstream, since Flutter web moved away from SW-based asset
// caching in favor of normal HTTP caching. That's fine for asset freshness,
// but it means the site never has an *active* service worker for Chrome to
// see, which breaks PWA installability: `beforeinstallprompt` never fires,
// so a custom in-page "Install app" banner has nothing to show.
//
// This file replaces the generated `flutter_service_worker.js` (same
// filename Flutter's own `flutter_bootstrap.js` already registers — no
// index.html changes needed) after every `flutter build web`, deliberately
// staying registered and adding a trivial fetch handler, purely to satisfy
// that installability check. It intentionally does NOT cache Flutter's
// build assets itself — that's what caused the stale-deploy confusion this
// replaced; real caching stays governed by the Cache-Control headers in
// firebase.json instead.
self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', (event) => {
  event.respondWith(fetch(event.request));
});
