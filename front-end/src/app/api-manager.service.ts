import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { lastValueFrom } from 'rxjs';
// import {Key } from "./models/settings";
import { Category, Settings } from './models/available-settings';

@Injectable({
  providedIn: 'root'
})
export class ApiManagerService {
  
  public serverSettings!: Settings; 
  public worlds!: Settings[];
  public wait!: Promise<void>;
  constructor(public http: HttpClient) {
    this.init();
  }

  init()
  {
    this.wait = new Promise(resolve => {

      let validate = () => {
        if ([this.serverSettings, this.worlds].some(x => x == null))
        {
          return;
        }
        resolve();
      }
      this.http.get<Category[]>("./?endpoint=server_settings").subscribe({next: value => {this.serverSettings = ({WorldName: null, Categories: value}); validate()}})
      this.http.get<Settings[]>("./?endpoint=world_list").subscribe({next: value => {this.worlds = value; validate()}})
    })
  }
}
