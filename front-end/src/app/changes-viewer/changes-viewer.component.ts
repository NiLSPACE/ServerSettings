import { Component } from '@angular/core';
import { ChangesManagerService } from '../changes-manager.service';
import { Option } from '../models/available-settings';
import {diffWords} from "diff"
@Component({
  selector: 'app-changes-viewer',
  templateUrl: './changes-viewer.component.html',
  styleUrl: './changes-viewer.component.scss'
})
export class ChangesViewerComponent {
  public diff = diffWords;
  public isExpanded: boolean = false
  constructor(public changeManager: ChangesManagerService)
  {}

  switchIsExpanded()
  {
    this.isExpanded = !this.isExpanded
  }

  formatValue(option: Option, value: string): string
  {
    switch (option.Type)
    {
      case "bool":
        return value == "1" ? "On" : "Off"
      default:
        return value
    }
  }
}
