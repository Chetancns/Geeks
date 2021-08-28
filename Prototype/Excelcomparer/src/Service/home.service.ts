import { Injectable } from '@angular/core';
import { JsonData } from '../Models/home.model';
import{HttpClient, HttpHeaders} from '@angular/common/http';
import {Observable,of} from 'rxjs';
const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type' : 'application/json'
  })
};
@Injectable({
  providedIn: 'root'
})
export class HomeService {

  constructor() { }

  getRuleList():string[]{// Observable<any>{
    // return this.http.get<any[]>(this.url+"getrules");
     let rule=["Column Level Mapping","Column Name Comparision","Record Count","Column Sequencing","Data Format Difference","Flag Mismatch Indicator",
   "Symbol Mismatch","Duplicate Check"]
    return rule;
   }
   sendJsonData(data:JsonData){
     console.log(JSON.stringify(data))
   }
}
