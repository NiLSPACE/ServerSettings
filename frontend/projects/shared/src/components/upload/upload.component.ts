import { Component, Input } from '@angular/core';
import { Category, Option } from '../../models/available-settings';
import JSZip from 'jszip';
import {StructuredZipFile, File} from "../../models/zip"
import { ApiManagerService } from '../../services/api-manager.service';


@Component({
  selector: 'app-upload',
  templateUrl: './upload.component.html',
  styleUrl: './upload.component.scss'
})
export class UploadComponent {
  @Input() public option!: Option
  @Input() public category!: Category;
  public errorMessage!: string | null;
  public successMessage!: string | null;


  constructor(private apiService: ApiManagerService)
  {}
  
  async bufferToBase64(buffer: Uint8Array) {
    // use a FileReader to generate a base64 data URI:
    const base64url: string = await new Promise(r => {
      const reader = new FileReader()
      reader.onload = () => r(reader.result as string)
      reader.readAsDataURL(new Blob([buffer]))
    });
    // remove the `data:...;base64,` part from the start
    return base64url.slice(base64url.indexOf(',') + 1);
  }
  

  async onZipSelected(event: any)
  {
    this.errorMessage = null;
    this.successMessage = null;
    let file = await JSZip.loadAsync(event.target.files[0])

    let promises: Promise<File>[] = []
    file.forEach(async (path, file) => {
      if (file.dir)
        return;
      promises.push(file.async("uint8array")
      .then(x => this.bufferToBase64(x))
      .then(x => ({content: x, path: path})))
    })
    let allFiles = await Promise.all(promises);
    let output: StructuredZipFile = {};
    for (let file of allFiles)
    {
      var path = file.path.split('/');
      let lastPathPiece = output;
      for (let i = 0; i < path.length - 1; i++)
      {
        lastPathPiece[path[i]] = lastPathPiece[path[i]] || {};
        lastPathPiece = lastPathPiece[path[i]] as StructuredZipFile
      }
      lastPathPiece[path[path.length - 1]] = file.content;
    }
    try {
      let option = await this.apiService.uploadPlugin(this.option.UploadUrl, event.target.files[0].name, output);
      this.category.Options.push(option)
      this.category.Options = this.category.Options.sort((x, y) => x.Type == "upload" ? -1 : x.Name.localeCompare(y.Name))
      this.successMessage = `The plugin "${option.Name}" has been uploaded`
    } catch(e: any)
    {
      this.errorMessage = e.message;
    }

    event.target.value = null;
  }
}
