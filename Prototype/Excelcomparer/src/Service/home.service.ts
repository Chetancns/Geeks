import { Injectable,Inject } from '@angular/core';
import {HttpClient, HttpHeaders,HttpResponse} from '@angular/common/http';
import {Observable,of} from 'rxjs';
import { BASE_URL } from 'app.config';
import { JsonData  } from '../Models/home.model';

const headers = new HttpHeaders().set('content-type', 'application/json');
@Injectable({
  providedIn: 'root'
})
export class HomeService {
 servername: string = "";
 
  constructor(private http: HttpClient/*, @Inject('BASE_URL') baseurl: string*/) {
    //this.servername = baseurl;
      this.servername = 'https://localhost:5001/ExcelComparer/';
   }

      DataOnSave(objClass : any){//:Observable<any>{
        console.log(objClass);
        return this.http.post(this.servername + 'api/dataload' , objClass , {headers ,observe: 'response',responseType: "arraybuffer"});
      }
      getRuleList() : Observable<any[]>{
        console.log("Service rule");
        return this.http.get<any[]>(this.servername + 'api/RuleList');
      //  let rule=["Column Level Mapping","Column Name Comparision","Record Count","Column Sequencing","Data Format Difference","Flag Mismatch Indicator",
      // "Symbol Mismatch","Duplicate Check"]
      //  return rule;
      }
      sendJasonData(){
       // console.log(JSON.stringify(data))
       this.http.get(this.servername + 'api/complete');
      }
}
