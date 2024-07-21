import {Option} from "./available-settings"

export interface SettingChange
{
  worldName: string | null,
  categoryName: string,
  option: Option,
  newValue: string,
}