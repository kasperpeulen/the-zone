
(function(global) {
    'use strict';

    importScripts('js/sw-toolbox.js');

    toolbox.options.debug = false;

    global.toolbox.router.default = global.toolbox.fastest;

    global.addEventListener('install', function(event) {
        event.waitUntil(global.skipWaiting())
    });

    global.addEventListener('activate', function(event){
        event.waitUntil(global.clients.claim())
    });

})(self);
