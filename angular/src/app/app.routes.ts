import { Routes } from '@angular/router';
import { Config } from './config/config';
import { Base } from './base/base';

export const routes: Routes = [
  {
    path: '',
    component: Base,
  },
  {
    path: 'angular/config',
    component: Config,
  },
  {
    path: '**',
    redirectTo: '',
  },
];
