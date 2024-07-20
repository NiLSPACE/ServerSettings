import { Injectable } from '@angular/core';
import { Option, Settings } from './models/available-settings';

interface SettingChange
{
  worldName: string | null,
  categoryName: string,
  option: Option,
  newValue: string,
  // oldValue: string,

}


@Injectable({
  providedIn: 'root'
})
export class ChangesManagerService {
  changes: SettingChange[] = []
  constructor() { }

  addChange(source: Settings, categoryName: string, option: Option, newValue: string)
  {
    source.WorldName
    console.log(newValue)
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
  }

  removeChange(change: SettingChange)
  {
    let index = this.changes.findIndex(x => x == change);
    if (index < 0) {
      return;
    }
    this.changes.splice(index, 1);
  }
}
