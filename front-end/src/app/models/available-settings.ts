export interface Settings
{
    WorldName: string | null,
    Categories: Category[]
}

export interface Category
{
    CategoryName: string,
    Options: Option[]
}

export interface SubOption
{
    Title: string,
    Value: string,
    PossibleArguments: string[]
}

export interface Option
{
    Name: string,
    Type: string,
    Description: string,
    CurrentValue: string,
    OriginalValue: string,
    Condition: Condition,
    SubOptions: (string | SubOption)[]
}

export interface Condition
{
    Target: OptionTarget
    ExpectedValue: string
    Method: string
}

export interface OptionTarget
{
    CategoryName: string
    OptionName: string
}