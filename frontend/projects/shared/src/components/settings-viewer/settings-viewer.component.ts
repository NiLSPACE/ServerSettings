import { Component, Input } from '@angular/core';
// import { ApiManagerService } from '../api-manager.service';
import { Category, Settings, SubOption, Option, CanHaveCondition } from '../../models/available-settings';
import { ChangesManagerService } from '../../services/changes-manager.service';
// import { Option } from '';

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

  conditionsMet(option: CanHaveCondition)
  {
    if (option.Condition == null)
    {
      return true;
    }
    let condition = option.Condition;
    let category = this.settings.Categories.find(x => x.CategoryName == condition.Target.CategoryName)
    let targetOption = category?.Options.find(x => x.Type != "header" && x.Name == condition.Target.OptionName);
    if (targetOption?.Condition && !this.conditionsMet(targetOption))
    {
      return false;
    }
    let optionValue = targetOption?.CurrentValue;
    let expectedValues = (typeof condition.ExpectedValue == 'string' ? [condition.ExpectedValue] : condition.ExpectedValue)
    .map(x => x.trim().toLowerCase());
    if (option.Condition.Method == "equals") 
    {
      return expectedValues.some(x => x == String(optionValue).toLowerCase())
    }
    else
    {
      return expectedValues.some(x => String(optionValue).toLowerCase().includes(x))
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

  removeMultiCategoryOption(category: Category, option: Option)
  {
    let index = category.Options.findIndex(x => x == option);
    category.Options.splice(index, 1);
    option.CurrentValue = "";
    this.changeManager.addChange(this.settings, category, option, "")
  }
}
