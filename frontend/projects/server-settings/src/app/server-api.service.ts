import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ApiManagerService, StructuredZipFile, Option } from 'shared';

@Injectable({
  providedIn: 'root'
})
export class ServerApiService extends ApiManagerService {
  constructor(http: HttpClient) {
    super(http)
   }


}
