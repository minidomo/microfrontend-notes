import { ApplicationConfig, provideBrowserGlobalErrorListeners } from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';

// angular 21 is zoneless by default
// getSingleSpaExtraProviders() should NOT be used with zoneless
// https://single-spa.js.org/docs/ecosystem-angular.html#routing-in-zone-less-applications

// https://single-spa.js.org/docs/ecosystem-angular#configure-routes
// unsure if APP_BASE_HREF is necessary
export const appConfig: ApplicationConfig = {
  providers: [provideBrowserGlobalErrorListeners(), provideRouter(routes)],
};
