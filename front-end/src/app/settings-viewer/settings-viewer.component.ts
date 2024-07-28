import { Component, Input } from '@angular/core';
import { ApiManagerService } from '../api-manager.service';
import { Category, Settings, SubOption } from '../models/available-settings';
import { ChangesManagerService } from '../changes-manager.service';
import { Option } from '../models/available-settings';

@Component({
  selector: 'app-settings-viewer',
  templateUrl: './settings-viewer.component.html',
  styleUrl: './settings-viewer.component.scss'
})
export class SettingsViewerComponent {
  @Input() public settings!: Settings;

  constructor(public changeManager: ChangesManagerService)
  {}

  getValue(event: Event)
  {
    let elem = event.target as HTMLInputElement
    if (elem.type == "checkbox")
    {
      return elem.checked ? "1" : "0"
    }
    else{
      return elem.value
    }
  }

  conditionsMet(option: Option)
  {
    if (option.Condition == null)
    {
      return true;
    }
    let category = this.settings.Categories.find(x => x.CategoryName == option.Condition.Target.CategoryName)
    let targetOption = category?.Options.find(x => x.Name == option.Condition.Target.OptionName);
    if (targetOption?.Condition && !this.conditionsMet(targetOption))
    {
      return false;
    }
    let optionValue = targetOption?.CurrentValue;
    if (option.Condition.Method == "equals") 
    {
      return String(optionValue).toLowerCase() == option.Condition.ExpectedValue.toString().toLowerCase()
    }
    else
    {
      return String(optionValue).toLowerCase().includes(option.Condition.ExpectedValue.toString().toLowerCase())
    }
  }

  formatSubOptionValue(subOption: string | SubOption) : string
  {
    if (typeof subOption === 'string'){
      return subOption as string;
    }
    else {
      return (subOption as SubOption).Value
    }
  }

  formatSubOptionTitle(subOption: string | SubOption) : string
  {
    if (typeof subOption === 'string'){
      return subOption as string;
    }
    else {
      return (subOption as SubOption).Title
    }
  }

  addKey(category:Category)
  {
    let option: Option = {
      Title: category.KeyName,
      Name: category.KeyName + "&NEW",
      OriginalValue: '',
      Type: 'string',
    } as any
    category.Options.push(
      option
    )
  }
}
