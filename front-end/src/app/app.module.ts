import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { AppComponent } from './app.component';
import { provideHttpClient, withFetch } from '@angular/common/http';
import { SettingsViewerComponent } from './settings-viewer/settings-viewer.component';
import { GroupByPipe } from './group-by.pipe';
import { ChangesViewerComponent } from './changes-viewer/changes-viewer.component';
import { IfNullPipe } from './if-null.pipe';
import { OptionMultiComponent } from './option-multi/option-multi.component';
import {
  CdkDragDrop,
  CdkDrag,
  CdkDropList,
  CdkDropListGroup,
  moveItemInArray,
  transferArrayItem,
} from '@angular/cdk/drag-drop';
import {DragDropModule} from '@angular/cdk/drag-drop';
import { SpinnerComponent } from './spinner/spinner.component';
import { PageSettingsComponent } from './page-settings/page-settings.component';
import { UploadComponent } from './upload/upload.component'; 

@NgModule({
  declarations: [
    AppComponent,
    SettingsViewerComponent,
    GroupByPipe,
    ChangesViewerComponent,
    IfNullPipe,
    OptionMultiComponent,
    SpinnerComponent,
    PageSettingsComponent,
    UploadComponent,
  ],
  imports: [
    BrowserModule,
    FormsModule,
    DragDropModule,
    CdkDropListGroup, CdkDropList, CdkDrag
  ],
  exports:[
    GroupByPipe
  ],
  providers: [provideHttpClient(withFetch())],
  bootstrap: [AppComponent]
})
export class AppModule { }
