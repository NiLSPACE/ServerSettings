import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'groupBy',
  pure: false
})
export class GroupByPipe implements PipeTransform {
  transform(value: Array<any>, ...fields: string[]): Array<any> {
    const groupedObj = value.reduce((prev, cur)=> {
      let key: any = cur;
      fields.forEach(x => key = key[x]);
      (prev[key] = prev[key] || []).push(cur);
      return prev;
    }, {});
    return Object.keys(groupedObj).map(key => ({ key, value: groupedObj[key] }));
  }
}
