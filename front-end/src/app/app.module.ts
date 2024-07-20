import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module';
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
// import {DragDropModule} from '@angular/cdk/drag-drop';
import {DragDropModule} from '@angular/cdk/drag-drop'; 

@NgModule({
  declarations: [
    AppComponent,
    SettingsViewerComponent,
    GroupByPipe,
    ChangesViewerComponent,
    IfNullPipe,
    OptionMultiComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
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
