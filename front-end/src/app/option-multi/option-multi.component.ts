import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Option, SubOption } from '../models/available-settings';

class SelectedOption
{
  public optionName: string;
  public optionArguments: string[];
  constructor(rawValue: string)
  {
    let [optionName, args] = rawValue.split(':')
    this.optionName = optionName.trim();
    this.optionArguments = (args?.split("|") || []).map(x => x.trim())
  }

  toString()
  {
    return this.optionName
  }
}

@Component({
  selector: 'app-option-multi',
  templateUrl: './option-multi.component.html',
  styleUrl: './option-multi.component.scss'
})
export class OptionMultiComponent {
  private _option!: Option;
  public selectedValues!: SelectedOption[];
  @Input() public set option(option: Option)
  {
    this._option = option;
    this.selectedValues = this._option.CurrentValue.split(',').map(x => new SelectedOption(x))
    console.log(this.selectedValues)
  }

  @Output() change = new EventEmitter<string>();
  public isExpanded: boolean = false;


  public get possibleValues(): string[]
  {
    return this._option.SubOptions.map(x => this.formatSubOption(x))
  }
  get preview()
  {
    return this.selectedValues.slice(0, 2);
  }

  formatTitle(option: SelectedOption)
  {
    // let [finisherName, args] = name.split(':')
    return option.optionName
  }

  formatPreviewText()
  {
    let numOtherOptions = this.selectedValues.length - this.preview.length
    return numOtherOptions > 0 ? ` and ${numOtherOptions} other options` : ''
  }

  formatSubOption(subOption: string | SubOption)
  {
    if (typeof subOption == 'string')
      return subOption;
    else
      return (subOption as SubOption).Title
  }

  optionEquals(value: string, option: string | SubOption)
  {
    let optionVal = typeof option ==  'string' ? option : (option as SubOption).Value
    return optionVal.toLowerCase() == value.toLowerCase();
  }

  hasArguments(selectedOption: SelectedOption)
  {
    // let [finisherName, args] = name.split(':').map(x => x.trim())
    let subOption = this._option.SubOptions.find(x => this.optionEquals(selectedOption.optionName, x));
    if (typeof subOption == 'string')
    {
      return false
    }
    subOption = subOption as SubOption
    return (subOption.PossibleArguments?.length || 0) > 0
  }

  formatOutputOption(selectedOption: SelectedOption)
  {
    let outp = selectedOption.optionName
    if (selectedOption.optionArguments.length > 0){
      outp += ": " + selectedOption.optionArguments.join("|")
    }
    return outp;
  }
  formatOutput(): string
  {
    return this.selectedValues
    .map(x => this.formatOutputOption(x))
    .join(", ")
  }
  drop(event: any, remove: boolean = false) {
    if (remove) {
      this.selectedValues.splice(event.previousIndex, 1);
      return
    }
    if (event.previousContainer === event.container) {
      this.array_move(this.selectedValues, event.previousIndex, event.currentIndex);
    } else {
      // this event only gets called when dropped on the selectedValues list.
      let item = this.possibleValues[event.previousIndex];
      this.selectedValues.splice(event.currentIndex, 0, new SelectedOption(this.formatSubOption(item)));
    }
    this.change.emit(this.formatOutput())
  }

  array_move(arr: any[], old_index: number, new_index: number) {
    if (new_index >= arr.length) {
        var k = new_index - arr.length + 1;
        while (k--) {
            arr.push(undefined);
        }
    }
    arr.splice(new_index, 0, arr.splice(old_index, 1)[0]);
    return arr; // for testing
};
}
