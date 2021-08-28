import { Injectable,Inject } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {Observable,of} from 'rxjs';
import { JsonData  } from '../Models/home.model';



@Injectable({
  providedIn: 'root'
})
export class HomeService {
 servername: string = "";
 
  // constructor(private http: HttpClient/*, @Inject('BASE_URL') baseurl: string*/) {
  //   //this.servername = baseurl;
  //     this.servername = 'https://localhost:5001/';
  //  }
   constructor(){}
   
      DataOnSave(DataFile : any){//:Observable<any>{
        console.log(DataFile);
        // return this.http.post(this.servername + 'CreateXLTable/api/dataload' , DataFile);
      }
      getRuleList(): string[] {//Observable<any>{
        //return this.http.get<any[]>(this.servername + 'api/RuleSet');
       let rule=["Column Level Mapping","Column Name Comparision","Record Count","Column Sequencing","Data Format Difference","Flag Mismatch Indicator",
      "Symbol Mismatch","Duplicate Check"]
       return rule;
      }
      // sendJasonData(data:JsonData){
      //   console.log(JSON.stringify(data))
      // }
}
