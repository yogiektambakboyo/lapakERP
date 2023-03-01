<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Harian</title>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          padding: 2px;
        }
        td, th {
            border: .01px solid black;
        }
        div{
          padding:2px;
        }
        @page { margin:0px; }
      </style>
   </head> 
   <body> 

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
            <td colspan="2" style="width: 50%;">Laporan Harian</td>
          </tr>
          <tr style="background-color: chocolate;">
            <td>Tanggal : {{ Carbon\Carbon::parse(count($report_datas)>0?$report_datas[0]->dated:"")->format('d-m-Y')  }}</td>
            <td>Cabang  : {{ count($report_datas)>0?$report_datas[0]->branch_name:"" }}</td>
            <td>Shift   : All </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr>
            <td style="width: 80%;vertical-align:top;">

              <table class="table table-striped" id="service_table">
                <thead>

   

                <tr style="background-color:#FFA726;color:white;">
                    <th scope="col" width="4%">No</th>
                    <th>Nama Tamu</th>
                    <th  scope="col" width="18%">Jam Kerja</th>
                    <th>MU</th>
                    @foreach($dtt_raw_oneline as $header)
                      @if((int)$header->total_280>0)
                        <th scope="col" width="5%">TH</th>
                      @endif
                      @if((int)$header->total_281>0)
                        <th scope="col" width="5%">FAC</th>
                      @endif
                      @if((int)$header->total_282>0)
                        <th scope="col" width="5%">BHC</th>
                      @endif
                      @if((int)$header->total_283>0)
                        <th scope="col" width="5%">ST</th>
                      @endif                  
                      @if((int)$header->total_284>0)
                        <th scope="col" width="5%">TT</th>
                      @endif
                      @if((int)$header->total_285>0)
                        <th scope="col" width="5%">FR</th>
                      @endif
                      @if((int)$header->total_286>0)
                        <th scope="col" width="5%">HS</th>
                      @endif
                      @if((int)$header->total_287>0)
                          <th scope="col" width="5%">EC</th>
                      @endif
                      @if((int)$header->total_288>0)
                        <th scope="col" width="5%">FBT</th>
                      @endif
                        @if((int)$header->total_290>0)
                          <th scope="col" width="5%">AA</th>
                        @endif
      
                        @if((int)$header->total_291>0)
                          <th scope="col" width="5%">FBR</th>
                        @endif
                     
                        @if((int)$header->total_292>0)
                          <th scope="col" width="5%">V SPA</th>
                        @endif
                     
                        @if((int)$header->total_293>0)
                          <th scope="col" width="5%">BACK DRY</th>
                        @endif
                     
                      @if((int)$header->total_294>0)
                        <th scope="col" width="5%">BACK</th>
                      @endif
                   
                      @if((int)$header->total_295>0)
                        <th scope="col" width="5%">BCM</th>
                      @endif
                   
                      @if((int)$header->total_296>0)
                        <th scope="col" width="5%">SLIMMING & BREAST</th>
                      @endif
                
                      @if((int)$header->total_297>0)
                        <th scope="col" width="5%">SLIM</th>
                      @endif
                      @if((int)$header->total_298>0)
                        <th scope="col" width="5%">BREAST</th>
                      @endif
                   
                      @if((int)$header->total_299>0)
                        <th scope="col" width="5%">RATUS</th>
                      @endif
                   
                      @if((int)$header->total_300>0)
                        <th scope="col" width="5%">EBBSL</th>
                      @endif
                   
                      @if((int)$header->total_301>0)
                        <th scope="col" width="5%">EBBS</th>
                      @endif
                  
                      @if((int)$header->total_302>0)
                        <th scope="col" width="5%">BODY BLEACHING</th>
                      @endif
                   
                      @if((int)$header->total_304>0)
                        <th scope="col" width="5%">BABSL</th>
                      @endif
                   
                      @if((int)$header->total_305>0)
                        <th scope="col" width="5%">BABS</th>
                      @endif
                   
                      @if((int)$header->total_306>0)
                        <th scope="col" width="5%">JFS</th>
                      @endif
                   
                      @if((int)$header->total_307>0)
                        <th scope="col" width="5%">FOOT</th>
                      @endif
                      @if((int)$header->total_308>0)
                        <th scope="col" width="5%">FOOT EXSPRESS</th>
                        @endif
                      @if((int)$header->total_310>0)
                        <th scope="col" width="5%">BCP</th>
                      @endif
                  
                      @if((int)$header->total_312>0)
                        <th scope="col" width="5%">LA</th>
                      @endif
                    
                      @if((int)$header->total_313>0)
                        <th scope="col" width="5%">MSU</th>
                        @endif
                      @if((int)$header->total_315>0)
                        <th scope="col" width="5%">MB</th>
                      @endif
                    
                      @if((int)$header->total_317>0)
                        <th scope="col" width="5%">STEAM B</th>
                      @endif
                      @if((int)$header->total_321>0)
                        <th scope="col" width="5%">TP</th>
                      @endif
                      <th>Pembayaran</th>
                  @endforeach

                </tr>
                </thead>
                <tbody>
                  @php
                    $total_qty = 0;
                    $total_service = 0; 
                    $counter = 0;   
                    $counter_spk = 0;
                  @endphp
                  @foreach($dtt_detail as $detail)
                        <tr>
                            <td style="text-align: left;">{{ $counter+1 }}</td>
                            <td style="text-align: left;">{{ $detail->customers_name }}</td>
                            <td style="text-align: left;">{{ $detail->scheduled_at }}</td>
                            <td style="text-align: left;">{{ $detail->name }}</td>          
                            @foreach($dtt_raw_oneline as $header)
                                @if((int)$header->total_280>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_280,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_281>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_281,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_282>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_282,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_283>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_283,0,',','.') }}</td>
                                @endif                  
                                @if((int)$header->total_284>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_284,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_285>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_285,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_286>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_286,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_287>0)
                                    <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_287,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_288>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_288,0,',','.') }}</td>
                                @endif
                                  @if((int)$header->total_290>0)
                                    <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_290,0,',','.') }}</td>
                                  @endif
                
                                  @if((int)$header->total_291>0)
                                    <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_291,0,',','.') }}</td>
                                  @endif
                              
                                  @if((int)$header->total_292>0)
                                    <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_292,0,',','.') }}</td>
                                  @endif
                              
                                  @if((int)$header->total_293>0)
                                    <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_293,0,',','.') }}</td>
                                  @endif
                              
                                @if((int)$header->total_294>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_294,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_295>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_295,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_296>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_296,0,',','.') }}</td>
                                @endif
                          
                                @if((int)$header->total_297>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_297,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_298>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_298,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_299>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_299,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_300>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_300,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_301>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_301,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_302>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_302,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_304>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_304,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_305>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_305,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_306>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_306,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_307>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_307,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_308>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_308,0,',','.') }}</td>
                                  @endif
                                @if((int)$header->total_310>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_310,0,',','.') }}</td>
                                @endif
                            
                                @if((int)$header->total_312>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_312,0,',','.') }}</td>
                                @endif
                              
                                @if((int)$header->total_313>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_313,0,',','.') }}</td>
                                  @endif
                                @if((int)$header->total_315>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_315,0,',','.') }}</td>
                                @endif
                              
                                @if((int)$header->total_317>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_317,0,',','.') }}</td>
                                @endif
                                @if((int)$header->total_321>0)
                                  <td scope="col" widtd="5%">{{ number_format($dtt_raw[$counter]->total_321,0,',','.') }}</td>
                                @endif
                            @endforeach
                            <td>{{ $detail->payment_type }}</td>
                        </tr>
                        @php
                         $counter++;
                        @endphp
                   @endforeach

                  @foreach($payment_datas as $payment_data)
                        @php
                          $counter_spk = $counter_spk + $payment_data->qty_payment;
                        @endphp
                  @endforeach
            
                </tbody>
              </table>
              

            </td>
        

          </tr>
          <tr>
            <th colspan="2" style="text-align: center;">TTD Kasir<br><br><br>( . . . . . . . . . )</th>
            <th colspan="2" style="text-align: center;">TTD Penerima<br><br><br>( . . . . . . . . . )</th>
          </tr>
        </tbody>
      </table>

       
   </body> 
</html> 