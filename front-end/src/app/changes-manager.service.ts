import { Injectable } from '@angular/core';
import { Option, Settings } from './models/available-settings';
import { SettingChange } from "./models/setting-change"
import { ApiManagerService } from './api-manager.service';
import { Status } from './models/current-status';





@Injectable({
  providedIn: 'root'
})
export class ChangesManagerService {
  private _currentStatus: Status = Status.Editing;
  public get currentStatus() {return this._currentStatus;}
  public changes: SettingChange[] = []
  public isSaving: boolean = false;
  constructor(private apiManager: ApiManagerService) { }

  addChange(source: Settings, categoryName: string, option: Option, newValue: string)
  {
    let existingChange = this.changes.find(x => x.worldName == source.WorldName && x.option.Name == option.Name && x.categoryName == categoryName)
    if (existingChange)
    {
      if (existingChange.option.OriginalValue == newValue)
      {
        this.removeChange(existingChange);
      }
      else
      {
        existingChange.newValue = newValue
      }
    }
    else
    {
      this.changes.push({worldName: source.WorldName, categoryName, option, newValue})
    }
    this._currentStatus = Status.Editing;
  }

  removeChange(change: SettingChange)
  {
    let index = this.changes.findIndex(x => x == change);
    if (index < 0) {
      return;
    }
    this.changes.splice(index, 1);
  }

  async applyChanges() {
    try {
      this.isSaving = true;
      await this.apiManager.sendChanges(this.changes);
      this._currentStatus = Status.Saved
      this.changes = []
    }
    finally
    {
      this.isSaving = false;
    }
  }
  
  async restart() {
    await this.apiManager.restart();
    this._currentStatus = Status.Editing;
  }
}
