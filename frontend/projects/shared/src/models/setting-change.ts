import {Category, Option} from "./available-settings"

export interface SettingChange
{
  worldName: string | null,
  category: Category,
  option: Option,
  newValue: string,
}