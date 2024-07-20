import { TestBed } from '@angular/core/testing';

import { ChangesManagerService } from './changes-manager.service';

describe('ChangesManagerService', () => {
  let service: ChangesManagerService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ChangesManagerService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
