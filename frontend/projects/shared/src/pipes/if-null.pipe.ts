import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'ifNull'
})
export class IfNullPipe implements PipeTransform {

  transform(value: any, ...args: string[]): string {
    if (value == null || value == 'null')
    {
      return args[0];
    }
    return value;
  }

}
