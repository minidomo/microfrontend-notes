import { Component } from '@angular/core';
import { environment } from '../environments/environment';
import { JsonPipe } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-config',
  imports: [JsonPipe, RouterLink],
  templateUrl: './config.html',
})
export class Config {
  protected readonly data = environment;
}
