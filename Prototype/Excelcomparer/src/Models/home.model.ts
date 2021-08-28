export class JsonData{
    SourceFile:string|undefined;
    DestFile:string|undefined;
    SourceSheetName:string|undefined;
    DestSheetName:string|undefined;
    SourceCol:string[];
    DestCol:string[];
    UniqueKeys:string[];
    SelectedRules:string[];
    FlagVariable:string[]|any;
}