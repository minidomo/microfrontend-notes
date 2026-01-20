# Microfrontend Notes

My notes and examples on creating microfrontends with [single-spa](https://single-spa.js.org/) because the [create-single-spa CLI](https://single-spa.js.org/docs/create-single-spa) is not always working, has out-of-date packages, and requires a decent amount of manual changes to switch to [SystemJS](https://single-spa.js.org/docs/recommended-setup/#systemjs) due to ESM being the default.

## Why SystemJS

With the [migration to ESM](https://github.com/single-spa/single-spa.js.org/blob/systemjs-to-esm-migration/blog/2025-01-25-systemjs-to-esm-migration.md) already existing, the official support for Angular has been a [slow process](https://github.com/single-spa/single-spa-angular/issues/534).
