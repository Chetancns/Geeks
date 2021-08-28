import { Component, OnInit } from '@angular/core';
import * as XLSX from 'xlsx';
import {DualListComponent} from 'angular-dual-listbox';
import {CdkDragDrop,moveItemInArray} from '@angular/cdk/drag-drop';
import {JsonData} from '../../Models/home.model'
import {HomeService} from '../../Service/home.service'

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  frmValid: boolean = false;
  title = 'Solvathon';
  spinnerEnabled = false;
  Sread=false;
  Dread=false;
  SourceSheetlist: string[]=[];
  DistSheetlist:string[]=[];
  isSourceExcelFile:boolean=false;
  isDistExcelFile:boolean=false;
  wbSorce: any;
  wbDist:any;
  UniqueKeys=[];
  DistCol:any;
  errorMessage: any;
  RuleList:any;
  ApiData:JsonData={
    SourceFile:undefined,
    DestFile:undefined,
    SourceSheetName:undefined,
    DestSheetName:undefined,
    SourceCol:[],
    DestCol:[],
    UniqueKeys:[],
    SelectedRules:[],
    FlagVariable:[]
  }
  constructor(private service:HomeService) {
      this.RuleList=service.getRuleList();
      console.log(this.RuleList);
   }

  ngOnInit(): void {
  }

  onSourceChange(evt:any){
    const target: DataTransfer=<DataTransfer>(evt.target);
    this.isSourceExcelFile = !!target.files[0].name.match(/(.xls|.xlsx)/);
    this.ApiData.SourceFile=target.files[0].name;
    if (this.isSourceExcelFile) {
     this.spinnerEnabled = true;
     const reader: FileReader = new FileReader();
     reader.onload = (e: any) => {
       /* read workbook */
       const bstr = e.target.result;
       this.wbSorce = XLSX.read(bstr, { type: 'binary' });
       
       /* grab sheet names */
       this.SourceSheetlist = this.wbSorce.SheetNames;
       this.Sread=true;
      };
     reader.readAsBinaryString(target.files[0]);
 
     reader.onloadend = (e) => {
       this.spinnerEnabled = false;
     }
   }
   }
   onDistChange(evt:any){
     const target: DataTransfer=<DataTransfer>(evt.target);
    this.isDistExcelFile = !!target.files[0].name.match(/(.xls|.xlsx)/);
    this.ApiData.DestFile=target.files[0].name;
    if (this.isDistExcelFile) {
     this.spinnerEnabled = true;
     const reader: FileReader = new FileReader();
     reader.onload = (e: any) => {
       /* read workbook */
       const bstr = e.target.result;
       this.wbDist = XLSX.read(bstr, { type: 'binary' });
 
       /* grab sheet names */
       this.DistSheetlist = this.wbDist.SheetNames;
       this.Dread=true;
      };
 
     reader.readAsBinaryString(target.files[0]);
 
     reader.onloadend = (e) => {
       this.spinnerEnabled = false;
     }
   }
   }
   onSourceSheet(event:any){
     console.log(event.target.value);
     let sheet=event.target.value;
     let data;
     
     if (sheet != '**'){
       this.ApiData.SourceSheetName=sheet;
     const ws: XLSX.WorkSheet=this.wbSorce.Sheets[sheet];
     /*data=XLSX.utils.sheet_to_json(ws); 
     this.Sourcekeys=Object.keys(data[0]);*/
     this.ApiData.SourceCol=this.get_header_row(ws);
     console.log(this.ApiData.SourceCol);
     }
     else{
       alert('Please Select the correct Sheet');
     }
   }
   onDistSheet(event:any){
     console.log(event.target.value);
     let sheet=event.target.value;
     let data;
     
     if (sheet != '**'){
      this.ApiData.DestSheetName=sheet;
     const ws: XLSX.WorkSheet=this.wbDist.Sheets[sheet];
     data=XLSX.utils.sheet_to_json(ws); 
     this.ApiData.DestCol=this.get_header_row(ws);
     console.log(this.ApiData.DestCol);
     }
     else{
       alert('Please Select the correct Sheet');
     }
   }
   drop(event: CdkDragDrop<string[]>) {
     moveItemInArray(this.ApiData.DestCol, event.previousIndex, event.currentIndex);
     console.log(this.ApiData.DestCol);
   }
   get_header_row(sheet:any) {
     var headers = [];
     var range = XLSX.utils.decode_range(sheet['!ref']);
     var C, R = range.s.r; /* start in the first row */
     /* walk every column in the range */
     for (C = range.s.c; C <= range.e.c; ++C) {
       var cell = sheet[XLSX.utils.encode_cell({ c: C, r: R })] /* find the cell in the first row */
        //console.log("cell",cell)
       var hdr = "UNKNOWN " + C; // <-- replace with your desired default 
       if (cell && cell.t) {
         hdr = XLSX.utils.format_cell(cell);
         headers.push(hdr);
       }
     }
     return headers;
   }
   onPush(Ch:String){
     if (Ch === 'S'){
       this.ApiData.SourceCol.push('Null');
     }
     else{
       this.ApiData.DestCol.push('Null');
     }
   }
   
  onStart()
  {
     this.service.DataOnSave(JSON.stringify(this.ApiData));//.subscribe(
    //     res => {
    //       console.log(this.ApiData.SourceFile);
    //       this.ApiData.SourceFile = res.toString();
    //       this.ApiData.DestFile = res.toString();
    //     }
    //   );
      //this.service.sendJasonData(this.ApiData);
  }   
  onCheckboxChange(eve:any){
    if(eve.target.checked){
      this.ApiData.SelectedRules.push(eve.target.value);
    }else{
      let i:number=0;
      this.ApiData.SelectedRules.forEach((item:String)=>{
        if(item ==eve.target.value){
          this.ApiData.SelectedRules=this.ApiData.SelectedRules.filter((value: String)=>value!=item);
        }
      });
    }
  }
  reset(){
    console.log("Refreshed!");
    this.Sread = false;
    this.Dread=false;
    this.ApiData.SourceCol = null;
    this.SourceSheetlist=[];
    this.ApiData.DestCol=null;
    window.location.reload();
  }

}
