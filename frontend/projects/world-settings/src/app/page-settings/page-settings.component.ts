import { Component } from '@angular/core';
import { Settings } from 'shared';
import { ApiManagerService } from 'shared';

@Component({
  selector: 'app-page-settings',
  templateUrl: './page-settings.component.html',
  styleUrl: './page-settings.component.scss'
})
export class PageSettingsComponent {
  public selectedSettings!: Settings;
  constructor(public apiManager: ApiManagerService)
  {
    this.selectedSettings = apiManager.worlds[0]
  }
}
