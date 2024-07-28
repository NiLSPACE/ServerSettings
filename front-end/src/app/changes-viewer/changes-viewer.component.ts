import { Component } from '@angular/core';
import { ChangesManagerService } from '../changes-manager.service';
import { Option } from '../models/available-settings';
import {diffWords} from "diff"
import { Status } from '../models/current-status';
import { ApiManagerService } from '../api-manager.service';

@Component({
  selector: 'app-changes-viewer',
  templateUrl: './changes-viewer.component.html',
  styleUrl: './changes-viewer.component.scss'
})
export class ChangesViewerComponent {
  JSON = JSON
  public Status = Status;
  public diff = diffWords;
  public isExpanded: boolean = false
  constructor(public changeManager: ChangesManagerService, public apiManager: ApiManagerService)
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
