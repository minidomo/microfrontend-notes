import { Router, NavigationStart } from '@angular/router';

import { singleSpaAngular } from 'single-spa-angular';

import { bootstrapApplication } from '@angular/platform-browser';
import { App } from './app/app';
import { appConfig } from './app/app.config';

// https://github.com/kfrederix/single-spa-angular-esm/blob/main/apps/dogs/src/main.ts
// https://single-spa.js.org/docs/ecosystem-angular.html#routing-in-zone-less-applications

const lifecycles = singleSpaAngular({
  bootstrapFunction: async () => {
    const appRef = await bootstrapApplication(App, appConfig);

    const listener = () => appRef.tick();
    window.addEventListener('popstate', listener);

    appRef.onDestroy(() => {
      window.removeEventListener('popstate', listener);
    });

    return appRef;
  },
  template: '<app-root />',
  Router,
  NavigationStart,
  NgZone: 'noop',
});

export const bootstrap = lifecycles.bootstrap;
export const mount = lifecycles.mount;
export const unmount = lifecycles.unmount;
