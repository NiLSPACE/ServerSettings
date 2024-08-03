export interface StructuredZipFile
{
  [key: string]: StructuredZipFile | string
}

export interface File
{
    path: string;
    content: string
}