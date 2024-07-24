import { Component } from '@angular/core';
import { Settings } from '../models/available-settings';
import { ApiManagerService } from '../api-manager.service';

@Component({
  selector: 'app-page-settings',
  templateUrl: './page-settings.component.html',
  styleUrl: './page-settings.component.scss'
})
export class PageSettingsComponent {
  public selectedSettings!: Settings;
  constructor(public apiManager: ApiManagerService)
  {
    this.selectedSettings = apiManager.serverSettings
  }
}
