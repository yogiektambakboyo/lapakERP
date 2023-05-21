<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Summary Perawatan</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          padding: 2px;
          font-size: 12px;
        }
        td, th {
            border: .01px solid black;
        }
        div{
          padding:2px;
        }
        button.btn.print::before {
          font-family: fontAwesome;
          content: "\f02f\00a0";
        }
        @page { margin:0px; }
        @media print {
          .printPageButton {
            display: none;
          }
        }
      </style>
   </head> 
   <body> 

    <button id="printPageButton" onClick="window.print();"  class="btn print">Cetak Laporan</button>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;">Cabang  : {{ count($report_datas)>0?$report_datas[0]->branch_name:"" }}</td>
            <td colspan="2" style="width: 50%;">Laporan Summary Perawatan</td>
          </tr>
          <tr style="background-color: chocolate;">
          </tr>
          <tr>
            <td colspan="3">
            </td>
          </tr>
        </tbody>
      </table>


      <table class="table table-striped" id="service_table">
        <thead>
        <tr style="background-color:#FFA726;color:white;">
          <th scope="col" width="10%">Tgl</th>
          <th scope="col" width="4%">Qty W</th>
          <th scope="col" width="4%">Qty P</th>
          <th scope="col" width="4%">Qty</th>
            @foreach($dtt_raw_oneline as $header)
              @if((int)$header->total_324>0)
                <th scope="col" width="5%">VTT</th>
              @endif
              @if((int)$header->total_325>0)
                <th scope="col" width="5%">VFBT</th>
              @endif
              @if((int)$header->total_326>0)
                <th scope="col" width="5%">VFBR</th>
              @endif
              @if((int)$header->total_327>0)
                <th scope="col" width="5%">VEBBSL</th>
              @endif
              @if((int)$header->total_328>0)
                <th scope="col" width="5%">VEBBSSGT</th>
              @endif
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
                <th scope="col" width="5%">DRY</th>
              @endif
              @if((int)$header->total_289>0)
                <th scope="col" width="5%">FBT</th>
              @endif
                @if((int)$header->total_290>0)
                  <th scope="col" width="5%">AA</th>
                @endif

                @if((int)$header->total_291>0)
                  <th scope="col" width="5%">FBR</th>
                @endif
             
                @if((int)$header->total_292>0)
                  <th scope="col" width="5%">VSPA</th>
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
                <th scope="col" width="5%">SLIMM & BREAST</th>
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
                <th scope="col" width="5%">BODY BLCH.</th>
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
                <th scope="col" width="5%">FOOT EXPR.</th>
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
              @if((int)$header->total_316>0)
                <th scope="col" width="5%">ET</th>
              @endif
              @if((int)$header->total_309>0)
                <th scope="col" width="5%">ETHC</th>
              @endif
              @if((int)$header->total_318>0)
                <th scope="col" width="5%">21:00</th>
              @endif
              @if((int)$header->total_319>0)
                <th scope="col" width="5%">22:00</th>
              @endif
          @endforeach
          <th scope="col" width="4%">Cases</th>


        </tr>
        </thead>
        <tbody>
          @php
            $total_qty = 0;
            $total_service = 0; 
            $counter = 0;   
            $counterall = 0;   
            $counter_spk = 0;
            $divider_page = 17;
            $c_p=0; 
            $t_p=0; 
            $c_pn=0;

            $c_280 = 0;
            $c_281 = 0;
            $c_282 = 0;
            $c_283 = 0;
            $c_284 = 0;
            $c_285 = 0;
            $c_286 = 0;
            $c_287 = 0;
            $c_288 = 0;
            $c_289 = 0;
            $c_290 = 0;
            $c_291 = 0;
            $c_292 = 0;
            $c_293 = 0;
            $c_294 = 0;
            $c_295 = 0;
            $c_296 = 0;
            $c_297 = 0;
            $c_298 = 0;
            $c_299 = 0;
            $c_300 = 0;
            $c_301 = 0;
            $c_302 = 0;
            $c_304 = 0;
            $c_305 = 0;
            $c_306 = 0;
            $c_307 = 0;
            $c_308 = 0;
            $c_310 = 0;
            $c_312 = 0;
            $c_313 = 0;
            $c_315 = 0;
            $c_317 = 0;
            $c_321 = 0;
            $c_319 = 0;
            $c_316 = 0;
            $c_309 = 0;
            $c_318 = 0;
            $c_324 = 0;
            $c_325 = 0;
            $c_326 = 0;
            $c_327 = 0;
            $c_328 = 0;
          @endphp

            @foreach($dtt_detail as $detail)
                  <tr>
                      <td style="text-align: left;">{{ $detail->dated }}</td>
                      <td style="text-align: left;">{{ $detail->qty_w }}</td>
                      <td style="text-align: left;">{{ $detail->qty_p }}</td>
                      <td style="text-align: left;">{{ ($detail->qty_p+$detail->qty_w) }}</td>
                          @if((int)$header->total_324>0)
                          @php if((int)$detail->total_324>0){ $c_324++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_324,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_325>0)
                          @php if((int)$detail->total_325>0){ $c_325++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_325,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_326>0)
                          @php if((int)$detail->total_326>0){ $c_326++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_326,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_327>0)
                          @php if((int)$detail->total_327>0){ $c_327++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_327,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_328>0)
                          @php if((int)$detail->total_328>0){ $c_328++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_328,0,',','.') }}</td>
                          @endif


                          @if((int)$header->total_280>0)
                          @php if((int)$detail->total_280>0){ $c_280++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_280,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_281>0)
                          @php if((int)$detail->total_281>0){ $c_281++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_281,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_282>0)
                            @php if((int)$detail->total_282>0){ $c_282++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_282,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_283>0)
                              @php if((int)$detail->total_283>0){ $c_283++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_283,0,',','.') }}</td>
                          @endif                  
                          @if((int)$header->total_284>0)
                              @php if((int)$detail->total_284>0){ $c_284++; } @endphp 
                              <td scope="col" width="5%"> {{ number_format($detail->total_284,0,',','.') }} </td>
                          @endif
                          @if((int)$header->total_285>0)
                          @php if((int)$detail->total_285>0){ $c_285++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_285,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_286>0)
                          @php if((int)$detail->total_286>0){ $c_286++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_286,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_287>0)
                          @php if((int)$detail->total_287>0){ $c_287++; } @endphp
                              <td scope="col" width="5%">{{ number_format($detail->total_287,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_288>0)
                          @php if((int)$detail->total_288>0){ $c_288++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_288,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_289>0)
                          @php if((int)$detail->total_289>0){ $c_289++; } @endphp 
                              <td scope="col" width="5%"> {{ number_format($detail->total_289,0,',','.') }} </td>
                          @endif

                            @if((int)$header->total_290>0)
                            @php if((int)$detail->total_290>0){ $c_290++; } @endphp
                              <td scope="col" width="5%">{{ number_format($detail->total_290,0,',','.') }}</td>
                            @endif
        
                            @if((int)$header->total_291>0)
                            @php if((int)$detail->total_291>0){ $c_291++; } @endphp 
                                <td scope="col" width="5%"> {{ number_format($detail->total_291,0,',','.') }} </td>
                            @endif

                            
                        
                            @if((int)$header->total_292>0)
                            @php if((int)$detail->total_292>0){ $c_292++; } @endphp
                              <td scope="col" width="5%">{{ number_format($detail->total_292,0,',','.') }}</td>
                            @endif
                        
                            @if((int)$header->total_293>0)
                            @php if((int)$detail->total_293>0){ $c_293++; } @endphp
                              <td scope="col" width="5%">{{ number_format($detail->total_293,0,',','.') }}</td>
                            @endif
                        
                          @if((int)$header->total_294>0)
                          @php if((int)$detail->total_294>0){ $c_294++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_294,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_295>0)
                          @php if((int)$detail->total_295>0){ $c_295++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_295,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_296>0)
                          @php if((int)$detail->total_296>0){ $c_296++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_296,0,',','.') }}</td>
                          @endif
                    
                          @if((int)$header->total_297>0)
                          @php if((int)$detail->total_297>0){ $c_297++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_297,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_298>0)
                          @php if((int)$detail->total_298>0){ $c_298++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_298,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_299>0)
                          @php if((int)$detail->total_299>0){ $c_299++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_299,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_300>0)
                          @php if((int)$detail->total_300>0){ $c_300++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_300,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_301>0)
                          @php if((int)$detail->total_301>0){ $c_301++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_301,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_302>0)
                          @php if((int)$detail->total_302>0){ $c_302++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_302,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_304>0)
                          @php if((int)$detail->total_304>0){ $c_304++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_304,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_305>0)
                          @php if((int)$detail->total_305>0){ $c_305++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_305,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_306>0)
                          @php if((int)$detail->total_306>0){ $c_306++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_306,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_307>0)
                          @php if((int)$detail->total_307>0){ $c_307++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_307,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_308>0)
                          @php if((int)$detail->total_308>0){ $c_308++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_308,0,',','.') }}</td>
                            @endif
                          @if((int)$header->total_310>0)
                          @php if((int)$detail->total_310>0){ $c_310++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_310,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_312>0)
                          @php if((int)$detail->total_312>0){ $c_312++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_312,0,',','.') }}</td>
                          @endif
                        
                          @if((int)$header->total_313>0)
                          @php if((int)$detail->total_313>0){ $c_313++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_313,0,',','.') }}</td>
                            @endif
                          @if((int)$header->total_315>0)
                          @php if((int)$detail->total_315>0){ $c_315++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_315,0,',','.') }}</td>
                          @endif
                        
                          @if((int)$header->total_317>0)
                          @php if((int)$detail->total_317>0){ $c_317++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_317,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_321>0)
                          @php if((int)$detail->total_321>0){ $c_321++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_321,0,',','.') }}</td>
                          @endif
                           
                          @if((int)$header->total_316>0)
                          @php if((int)$detail->total_316>0){ $c_316++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_316,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_309>0)
                          @php if((int)$detail->total_309>0){ $c_309++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_309,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_318>0)
                          @php if((int)$detail->total_318>0){ $c_318++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_318,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_319>0)
                          @php if((int)$detail->total_319>0){ $c_319++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_319,0,',','.') }}</td>
                          @endif     
                          <td style="text-align: left;">{{ $detail->qty_total }}</td>

                </tr>
                @php
                 $counter++;
                 $counterall++;
                @endphp
           @endforeach
                <tr>
                  <th>JUMLAH</th>
                  <th scope="col" width="5%">{{ number_format($header->qty_w,0,',','.') }}</th>
                  <th scope="col" width="5%">{{ number_format($header->qty_p,0,',','.') }}</th>
                  <th scope="col" width="5%">{{ number_format(($header->qty_p+$header->qty_w),0,',','.') }}</th>
                  @foreach($dtt_raw_oneline as $header)
                    @if((int)$header->total_324>0)
                      <th scope="col" width="5%">{{ number_format($header->total_324,0,',','.') }} </th>
                    @endif
                    @if((int)$header->total_325>0)
                      <th scope="col" width="5%">{{ number_format($header->total_325,0,',','.') }} </th>
                    @endif
                    @if((int)$header->total_326>0)
                      <th scope="col" width="5%">{{ number_format($header->total_326,0,',','.') }} </th>
                    @endif
                    @if((int)$header->total_327>0)
                      <th scope="col" width="5%">{{ number_format($header->total_327,0,',','.') }}  </th>
                    @endif
                    @if((int)$header->total_328>0)
                      <th scope="col" width="5%">{{ number_format($header->total_328,0,',','.') }} </th>
                    @endif


                    @if((int)$header->total_280>0)
                      <th scope="col" width="5%">{{ number_format($header->total_280,0,',','.') }} </th>
                    @endif
                    @if((int)$header->total_281>0)
                      <th scope="col" width="5%">{{ number_format($header->total_281,0,',','.') }}   </th>
                    @endif
                    @if((int)$header->total_282>0)
                      <th scope="col" width="5%">{{ number_format($header->total_282,0,',','.') }}</th>
                    @endif
                    @if((int)$header->total_283>0)
                      <th scope="col" width="5%">{{ number_format($header->total_283,0,',','.') }} </th>
                    @endif                  
                    @if((int)$header->total_284>0)
                      <th scope="col" width="5%">{{ number_format($header->total_284,0,',','.') }}</th>
                    @endif
                    @if((int)$header->total_285>0)
                      <th scope="col" width="5%">{{ number_format($header->total_285,0,',','.') }}</th>
                    @endif
                    @if((int)$header->total_286>0)
                      <th scope="col" width="5%">{{ number_format($header->total_286,0,',','.') }} </th>
                    @endif
                    @if((int)$header->total_287>0)
                        <th scope="col" width="5%">{{ number_format($header->total_287,0,',','.') }} </th>
                    @endif
                    @if((int)$header->total_288>0)
                      <th scope="col" width="5%">{{ number_format($header->total_288,0,',','.') }}</th>
                    @endif
                    @if((int)$header->total_289>0)
                      <th scope="col" width="5%">{{ number_format($header->total_289,0,',','.') }}</th>
                    @endif
                      @if((int)$header->total_290>0)
                        <th scope="col" width="5%">{{ number_format($header->total_290,0,',','.') }}</th>
                      @endif
      
                      @if((int)$header->total_291>0)
                        <th scope="col" width="5%">{{ number_format($header->total_291,0,',','.') }}  </th>
                      @endif
                  
                      @if((int)$header->total_292>0)
                        <th scope="col" width="5%">{{ number_format($header->total_292,0,',','.') }} </th>
                      @endif
                  
                      @if((int)$header->total_293>0)
                        <th scope="col" width="5%">{{ number_format($header->total_293,0,',','.') }} </th>
                      @endif
                  
                    @if((int)$header->total_294>0)
                      <th scope="col" width="5%">{{ number_format($header->total_294,0,',','.') }}  </th>
                    @endif
                
                    @if((int)$header->total_295>0)
                      <th scope="col" width="5%">{{ number_format($header->total_295,0,',','.') }}</th>
                    @endif
                
                    @if((int)$header->total_296>0)
                      <th scope="col" width="5%">{{ number_format($header->total_296,0,',','.') }} </th>
                    @endif
              
                    @if((int)$header->total_297>0)
                      <th scope="col" width="5%">{{ number_format($header->total_297,0,',','.') }}  </th>
                    @endif
                    @if((int)$header->total_298>0)
                      <th scope="col" width="5%">{{ number_format($header->total_298,0,',','.') }}  </th>
                    @endif
                
                    @if((int)$header->total_299>0)
                      <th scope="col" width="5%">{{ number_format($header->total_299,0,',','.') }} </th>
                    @endif
                
                    @if((int)$header->total_300>0)
                      <th scope="col" width="5%">{{ number_format($header->total_300,0,',','.') }}  </th>
                    @endif
                
                    @if((int)$header->total_301>0)
                      <th scope="col" width="5%">{{ number_format($header->total_301,0,',','.') }} </th>
                    @endif
                
                    @if((int)$header->total_302>0)
                      <th scope="col" width="5%">{{ number_format($header->total_302,0,',','.') }}  </th>
                    @endif
                
                    @if((int)$header->total_304>0)
                      <th scope="col" width="5%">{{ number_format($header->total_304,0,',','.') }} </th>
                    @endif
                
                    @if((int)$header->total_305>0)
                      <th scope="col" width="5%">{{ number_format($header->total_305,0,',','.') }} </th>
                    @endif
                
                    @if((int)$header->total_306>0)
                      <th scope="col" width="5%">{{ number_format($header->total_306,0,',','.') }}</th>
                    @endif
                
                    @if((int)$header->total_307>0)
                      <th scope="col" width="5%">{{ number_format($header->total_307,0,',','.') }}</th>
                    @endif
                    @if((int)$header->total_308>0)
                      <th scope="col" width="5%">{{ number_format($header->total_308,0,',','.') }}</th>
                      @endif
                    @if((int)$header->total_310>0)
                      <th scope="col" width="5%">{{ number_format($header->total_310,0,',','.') }} </th>
                    @endif
                
                    @if((int)$header->total_312>0)
                      <th scope="col" width="5%">{{ number_format($header->total_312,0,',','.') }} </th>
                    @endif
                  
                    @if((int)$header->total_313>0)
                      <th scope="col" width="5%">{{ number_format($header->total_313,0,',','.') }} </th>
                      @endif
                    @if((int)$header->total_315>0)
                      <th scope="col" width="5%">{{ number_format($header->total_315,0,',','.') }} </th>
                    @endif
                  
                    @if((int)$header->total_317>0)
                      <th scope="col" width="5%">{{ number_format($header->total_317,0,',','.') }} </th>
                    @endif
                    @if((int)$header->total_321>0)
                      <th scope="col" width="5%">{{ number_format($header->total_321,0,',','.') }}</th>
                    @endif

                    @if((int)$header->total_316>0)
                      <th scope="col" width="5%">{{ number_format($header->total_316,0,',','.') }}</th>
                    @endif
                    @if((int)$header->total_309>0)
                      <th scope="col" width="5%">{{ number_format($header->total_309,0,',','.') }}</th>
                    @endif
                    @if((int)$header->total_318>0)
                      <th scope="col" width="5%">{{ number_format($header->total_318,0,',','.') }}</th>
                    @endif
                    @if((int)$header->total_319>0)
                      <th scope="col" width="5%">{{ number_format($header->total_319,0,',','.') }}</th>
                    @endif
                @endforeach
                <th scope="col" width="5%">{{ number_format($header->qty_total,0,',','.') }}</th>
                </tr>
        </tbody>
      </table>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: left;background-color:#white;">
            <td style="width: 100%;font-size:10px;font-style: italic;">
              <label>Printed at : {{ \Carbon\Carbon::now() }}</label>
            </td>
          </tr>
        </tbody>
      </table>

   </body> 
</html> 