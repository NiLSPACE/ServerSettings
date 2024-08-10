export interface Settings
{
    WorldName: string | null,
    Categories: Category[]
}

export interface CanHaveCondition
{
    Condition: Condition,
}

export interface Category extends CanHaveCondition
{
    CategoryName: string,
    IsMultiKeyCategory: boolean,
    RequiredKey: string,
    KeyName: string,
    Options: Option[]
}

export interface SubOption
{
    Title: string,
    Value: string,
    PossibleArguments: string[]
}

export interface Option extends CanHaveCondition
{
    Name: string,
    Title: string | null,
    Type: string,
    Description: string,
    CurrentValue: string,
    UploadUrl: string,
    OriginalValue: string,
    SubOptions: (string | SubOption)[]
}

export interface Condition
{
    Target: OptionTarget
    ExpectedValue: string | string[]
    Method: string
}

export interface OptionTarget
{
    CategoryName: string
    OptionName: string
}