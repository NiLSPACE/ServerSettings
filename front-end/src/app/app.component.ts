import { Component, OnInit } from '@angular/core';
import { ApiManagerService } from './api-manager.service';
import { ChangesManagerService } from './changes-manager.service';
import { Settings } from './models/available-settings';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit {
  title = 'front-end';
  public selectedSettings!: Settings;
  constructor(public apiManager: ApiManagerService)
  {
  }
  async ngOnInit(): Promise<void> {
    await this.apiManager.wait
    this.selectedSettings = this.apiManager.serverSettings;
  }
}
