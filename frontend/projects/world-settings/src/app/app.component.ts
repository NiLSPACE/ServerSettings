import { Component, OnInit } from '@angular/core';
import { ApiManagerService } from 'shared';
import { ChangesManagerService } from 'shared';
import { Settings } from 'shared';



@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit {
  title = 'front-end';
  isInitializing: boolean = true;
  
  constructor(public apiManager: ApiManagerService)
  {
    apiManager.init("world");
  }
  async ngOnInit(): Promise<void> {
    await this.apiManager.wait
    this.isInitializing = false;
  }
}
