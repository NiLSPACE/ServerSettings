import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SpinnerComponent } from '../components/spinner/spinner.component';
import { GroupByPipe, IfNullPipe, SettingsViewerComponent } from '../public-api';
import { OptionMultiComponent } from '../components/option-multi/option-multi.component';
import { UploadComponent } from '../components/upload/upload.component';
import { provideHttpClient, withFetch } from '@angular/common/http';
import {DragDropModule} from '@angular/cdk/drag-drop';
import {
  CdkDragDrop,
  CdkDrag,
  CdkDropList,
  CdkDropListGroup,
  moveItemInArray,
  transferArrayItem,
} from '@angular/cdk/drag-drop';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { ChangesViewerComponent } from '../components/changes-viewer/changes-viewer.component';



@NgModule({
  declarations: [
    IfNullPipe,
    GroupByPipe,
    SpinnerComponent, 
    SettingsViewerComponent,
    OptionMultiComponent,
    ChangesViewerComponent,
    UploadComponent],
  imports: [
    CommonModule,
    BrowserModule,
    // SharedModule,
    FormsModule,
    DragDropModule,

    CdkDropListGroup, CdkDropList, CdkDrag
  ],exports: [
    SpinnerComponent,
    SettingsViewerComponent,
    ChangesViewerComponent,
    OptionMultiComponent,
    UploadComponent,
    IfNullPipe,
    GroupByPipe
  ],
  providers: [provideHttpClient(withFetch())],
})
export class SharedModule { }
