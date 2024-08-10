import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, lastValueFrom } from 'rxjs';
import { Category, Settings, Option } from '../models/available-settings';
import { SettingChange } from '../models/setting-change';
import { StructuredZipFile } from '../models/zip';

@Injectable({
  providedIn: 'root'
})
export class ApiManagerService {
  public isRestarting: boolean = false;
  public serverSettings!: Settings; 
  public worlds!: Settings[];
  public wait!: Promise<any>;
  _toLoad: string | null = null;
  constructor(public http: HttpClient) {
    // this.init();
  }

  init(toLoad: string | null = null)
  {
    this._toLoad = toLoad || this._toLoad;
    console.log(this._toLoad)
    if (this._toLoad == "server")
    {
      this.wait = this.sendRequest<Category[]>("./?endpoint=server_settings", "get").then(value => this.serverSettings = ({WorldName: null, Categories: value}))
    }
    else
    {
      this.wait = this.sendRequest<Settings[]>("./?endpoint=world_list", "get").then(value => this.worlds = value)
    }
    // this.wait = Promise.all([
    //   this.sendRequest<Category[]>("./?endpoint=server_settings", "get").then(value => this.serverSettings = ({WorldName: null, Categories: value})),
    //   this.sendRequest<Settings[]>("./?endpoint=world_list", "get").then(value => this.worlds = value)
    // ])
  }

  async sendChanges(changes: SettingChange[]): Promise<void>
  {
    let mapped = changes.map(x => ({target: x.worldName, category: x.category.CategoryName, option: x.option.Name, value: x.newValue}))
    let result = await this.sendRequest("./?endpoint=apply_changes", "post","changes=" + encodeURIComponent(JSON.stringify(mapped)), {'Content-Type': 'application/x-www-form-urlencoded'})
    if (result != "OK")
    {
      throw result;
    }
  }

  sendRequest<TExpected>(url: string, method: string, body?: any, headers?: HttpHeaders | {[header: string]: string | string[]})
  {
    return new Promise<TExpected>((resolve, reject) => {
      this.http.request<TExpected>(method, url, {body, headers}).subscribe({next: value => resolve(value), error: error => reject(error)})
    })
  }

  sleep(ms: number)
  {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  async restart()
  {
    this.isRestarting = true;
    try {
      await this.sendRequest("./?endpoint=restart_server", "post", null, {'Content-Type': 'application/x-www-form-urlencoded'})
    }catch(e) {
      // The server could have restarted before it finished sending a response
      // which can cause an error.
    }
    for (let i = 1; i < 100; i++)
    {
      let result;
      try {
        result = await this.sendRequest("./?endpoint=ping", "get");
      }
      catch (e) {
        // Let errors silently fail.
        // Errors can occur if Cuberite has not yet restarted the webserver.
      }
      if (result == "Pong")
      {
        break;
      }
      await this.sleep(Math.min(i * 100, 500));
    }
    // Reload all the setting objects.
    this.init();
    await this.wait;
    this.isRestarting = false;
  }
  
     
  async uploadPlugin(url: string, filename: string, zip: StructuredZipFile): Promise<Option> {
    let option = await this.sendRequest<Option | any>(url, "post", "zipname=" + encodeURIComponent(filename) + "&files=" + encodeURIComponent(JSON.stringify(zip)), {'Content-Type': 'application/x-www-form-urlencoded'} )
    if (option.ErrorCode)
    {
      throw option;
    }
    return option;
  }

  async resumeUpload(url: string, id: string, newname: string): Promise<Option>
  {
    let response = await this.sendRequest<any>(url, "post", "resume=" + id + "&newname=" + newname, {'Content-Type': 'application/x-www-form-urlencoded'})
    if (response.ErrorCode)
    {
      throw response
    }
    return response
  }
}
