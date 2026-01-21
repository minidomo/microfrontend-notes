import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { navigateToUrl } from 'single-spa';

@Component({
  selector: 'app-base',
  imports: [RouterLink],
  templateUrl: './base.html',
})
export class Base {
  navigate(arg: string | Event) {
    if (typeof arg === 'string') {
      navigateToUrl(arg);
      return;
    }

    const target = arg.currentTarget;

    if (target instanceof HTMLAnchorElement) {
      arg.preventDefault();
      navigateToUrl(target.href);
      return;
    }
  }
}
