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

    <button id="printPageButton" onClick="window.print();"  class="btn print printPageButton">Cetak Laporan</button>
    <button id="btn_export_xls"  class="btn print printPageButton">Cetak XLS</button>
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
              @if((int)$header->total_oth>0)
                <th scope="col" width="5%">OTHER</th>
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
            $c_oth = 0;
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
                          @php if((int)$detail->total_318>0){ $c_318=$c_318+$detail->total_318; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_318,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_319>0)
                          @php if((int)$detail->total_319>0){ $c_319++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_319,0,',','.') }}</td>
                          @endif     
                          @if((int)$header->total_oth>0)
                          @php if((int)$detail->total_oth>0){ $c_oth++; } @endphp
                            <td scope="col" width="5%">{{ number_format($detail->total_oth,0,',','.') }}</td>
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
                    @if((int)$header->total_oth>0)
                      <th scope="col" width="5%">{{ number_format($header->total_oth,0,',','.') }}</th>
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


          <input type="hidden" name="filter_begin_date" id="filter_begin_date" value="{{ $filter_begin_date }}">
          <input type="hidden" name="filter_begin_end" id="filter_begin_end" value="{{ $filter_begin_end }}">
          <input type="hidden" name="filter_branch_id" id="filter_branch_id" value="{{ $filter_branch_id }}">

   </body> 

   <!-- use version 0.19.3 -->
   <script src="/assets/js/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
   <script src="/assets/js/axios.min.js"></script>   
   <script src="/assets/js/exceljs.min.js"></script>
   <script src="/assets/js/FileSaver.min.js"></script>
   <script type="text/javascript">
    //window.print();
    //const workbook = XLSX.utils.book_new();

    const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Kakiku System Apps';
    workbook.created = new Date();
    //workbook.modified = new Date();

    function nextChar(c) {
        return String.fromCharCode(c.charCodeAt(0) + 1);
    }
  
    $(document).ready(function() {
      var url = "{{ route('reports.invoicedetail.search') }}";
      const params = {
        filter_begin_date_in : "{{ $filter_begin_date }}",
        filter_end_date_in : "{{ $filter_begin_end }}",
        filter_branch_id_in: "{{ $filter_branch_id }}",
        export : 'Export Total API',
      };

      $('#btn_export_xls').on('click',function(){
        const res = axios.get(url,{ params }, {
                    headers: {}
                  }).then(resp => {
                    report_datas = resp.data.report_datas;
                    dtt_raw_oneline = resp.data.dtt_raw_oneline;
                    report_data_terapist = resp.data.report_data_terapist;

                    var beginnewformat = resp.data.filter_begin_date;
                    var endnewformat = resp.data.filter_begin_end;

                    let worksheet = workbook.addWorksheet("Worksheet");

                        worksheet.mergeCells('A1', 'E1');
                        worksheet.getCell('A1').value = 'Cabang : '+report_datas[0].branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('K1', 'O1');
                        worksheet.getCell('K1').value = 'Tgl : '+beginnewformat+' sd '+endnewformat;
                        worksheet.getCell('K1').alignment = { vertical: 'middle', horizontal: 'center' };



                        worksheet.getCell('A3').value = 'Tgl';
                        worksheet.getCell('A3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('B3').value = 'Qty Wanita';
                        worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('C3').value = 'Qty Pria';
                        worksheet.getCell('C3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('D3').value = 'Qty';
                        worksheet.getCell('D3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getRow(1).font = { bold: true };
                        worksheet.getRow(2).font = { bold: true };
                        worksheet.getRow(3).font = { bold: true };
                        worksheet.getCell('A1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('B1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('C1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('D1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('E1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('G1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('H1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('I1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('J1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('K1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('L1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('M1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('N1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('O1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                        worksheet.getCell('A3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('B3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('C3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('D3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('E3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('G3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('H3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('I3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('J3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('K3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('L3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('M3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('N3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('O3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                        var columnx  = 'E';
                        var columnadd  = '';
                    // Loop Terapist
                    dtt_raw_oneline.forEach(element => {
                        if(parseInt(element.total_324)>0){
                          worksheet.getCell(columnx+'3').value = 'VTT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);

                        }
                        if(parseInt(element.total_325)>0){
                          worksheet.getCell(columnx+'3').value = 'VFBT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_326)>0){
                          worksheet.getCell(columnx+'3').value = 'VFBR';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_327)>0){
                          worksheet.getCell(columnx+'3').value = 'VEBBSL';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_328)>0){
                          worksheet.getCell(columnx+'3').value = 'VEBBSSGT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_280)>0){
                          worksheet.getCell(columnx+'3').value = 'TH';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_281)>0){
                          worksheet.getCell(columnx+'3').value = 'FAC';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_282)>0){
                          worksheet.getCell(columnx+'3').value = 'BHC';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_283)>0){
                          worksheet.getCell(columnx+'3').value = 'ST';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_284)>0){
                          worksheet.getCell(columnx+'3').value = 'TT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_285)>0){
                          worksheet.getCell(columnx+'3').value = 'FR';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_286)>0){
                          worksheet.getCell(columnx+'3').value = 'HS';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_287)>0){
                          worksheet.getCell(columnx+'3').value = 'EC';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_289)>0){
                          worksheet.getCell(columnx+'3').value = 'FBT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_290)>0){
                          worksheet.getCell(columnx+'3').value = 'AA';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_291)>0){
                          worksheet.getCell(columnx+'3').value = 'FBR';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_292)>0){
                          worksheet.getCell(columnx+'3').value = 'VSPA';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_293)>0){
                          worksheet.getCell(columnx+'3').value = 'BACK DRY';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_294)>0){
                          worksheet.getCell(columnx+'3').value = 'BACK';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_295)>0){
                          worksheet.getCell(columnx+'3').value = 'BCM';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_296)>0){
                          worksheet.getCell(columnx+'3').value = 'SLIMM & BREAST';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_297)>0){
                          worksheet.getCell(columnx+'3').value = 'SLIM';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_298)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }
                          worksheet.getCell(columnadd+columnx+'3').value = 'BREAST';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_300)>0){

                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }
                          worksheet.getCell(columnadd+columnx+'3').value = 'EBBSL';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_301)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnadd+columnx+'3').value = 'EBBS';
                          worksheet.getCell(columnadd+columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_302)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'BODY BLCH.';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_304)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'BABSL';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_305)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'BABS';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_306)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'JFS';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_307)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'FOOT';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_308)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'FOOT EXPR.';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_310)>0){


                          worksheet.getCell(columnadd+columnx+'3').value = 'BCP';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_312)>0){


                          worksheet.getCell(columnadd+columnx+'3').value = 'LA';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };


                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_313)>0){


                          worksheet.getCell(columnadd+columnx+'3').value = 'MSU';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }


                        }
                        if(parseInt(element.total_315)>0){


                          worksheet.getCell(columnadd+columnx+'3').value = 'MB';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }


                        }
                        if(parseInt(element.total_317)>0){

                          worksheet.getCell(columnadd+columnx+'3').value = 'STEAM B';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_321)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'TP';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_316)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'ET';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_309)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'ETHC';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_318)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = '21:00';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_319)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = '22:00';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_oth)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'OTHER';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }


                    });
                    // End loop header

                    worksheet.getCell(columnadd+columnx+'3').value = 'Case';
                    worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                
                    var countery = 4;
                    columnx = 'E';
                    columnadd = '';
                    report_datas.forEach(element => {
                         worksheet.getCell('A'+countery).value = element.dated;
                         worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                         worksheet.getCell('B'+countery).value = element.qty_w;
                         worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                         worksheet.getCell('C'+countery).value = element.qty_p;
                         worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                         worksheet.getCell('D'+countery).value = (element.qty_w+element.qty_p);
                         worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                        columnx = 'E';
                        columnadd = '';
                        dtt_raw_oneline.forEach(elementx => {
                          if(parseInt(elementx.total_324)>0){
                              if(parseInt(element.total_324)>0){
                                worksheet.getCell(columnx+countery).value = elementx.total_324;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }
                            nextChar(columnx);
                            columnx = nextChar(columnx);

                          }
                          if(parseInt(elementx.total_325)>0){
                            if(parseInt(element.total_325)>0){
                                worksheet.getCell(columnx+countery).value = element.total_325;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_326)>0){
                            if(parseInt(element.total_326)>0){
                                worksheet.getCell(columnx+countery).value = element.total_326;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }              

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_327)>0){
                            if(parseInt(element.total_327)>0){
                                worksheet.getCell(columnx+countery).value = element.total_327;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }   
                      
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_328)>0){
                            if(parseInt(element.total_328)>0){
                                worksheet.getCell(columnx+countery).value = element.total_328;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_280)>0){
                            if(parseInt(element.total_280)>0){
                                worksheet.getCell(columnx+countery).value = element.total_280;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_281)>0){
                            if(parseInt(element.total_281)>0){
                                worksheet.getCell(columnx+countery).value = element.total_281;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_282)>0){
                            if(parseInt(element.total_282)>0){
                                worksheet.getCell(columnx+countery).value = element.total_282;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_283)>0){
                            if(parseInt(element.total_283)>0){
                                worksheet.getCell(columnx+countery).value = element.total_283;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                          
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_284)>0){
                            if(parseInt(element.total_284)>0){
                                worksheet.getCell(columnx+countery).value = element.total_284;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }

                          if(parseInt(elementx.total_285)>0){
                            if(parseInt(element.total_285)>0){
                                worksheet.getCell(columnx+countery).value = element.total_285;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_286)>0){
                            if(parseInt(element.total_286)>0){
                                worksheet.getCell(columnx+countery).value = element.total_286;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_287)>0){
                            if(parseInt(element.total_287)>0){
                                worksheet.getCell(columnx+countery).value = element.total_287;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_289)>0){
                            if(parseInt(element.total_289)>0){
                                worksheet.getCell(columnx+countery).value = element.total_289;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_290)>0){
                            if(parseInt(element.total_290)>0){
                                worksheet.getCell(columnx+countery).value = element.total_290;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_291)>0){
                            if(parseInt(element.total_291)>0){
                                worksheet.getCell(columnx+countery).value = element.total_291;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_292)>0){
                            if(parseInt(element.total_292)>0){
                                worksheet.getCell(columnx+countery).value = element.total_292;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_293)>0){
                            if(parseInt(element.total_293)>0){
                                worksheet.getCell(columnx+countery).value = element.total_293;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_294)>0){
                            if(parseInt(element.total_294)>0){
                                worksheet.getCell(columnx+countery).value = element.total_294;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_295)>0){
                            if(parseInt(element.total_295)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_295;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_296)>0){
                            if(parseInt(element.total_296)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_296;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_297)>0){
                            if(parseInt(element.total_297)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_297;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_298)>0){
                            
                            if(parseInt(element.total_298)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_298;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  

                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                           
                          }
                          if(parseInt(elementx.total_300)>0){

                            if(parseInt(element.total_300)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_300;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_301)>0){
                            

                            if(parseInt(element.total_301)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_301;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_302)>0){
  

                            if(parseInt(element.total_302)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_302;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                          if(parseInt(elementx.total_304)>0){
    

                            if(parseInt(element.total_304)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_304;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_305)>0){
  

                            if(parseInt(element.total_305)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_305;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_306)>0){
 

                            if(parseInt(element.total_306)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_306;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_307)>0){
  

                            if(parseInt(element.total_307)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_307;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_308)>0){
   

                            if(parseInt(element.total_308)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_308;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_310)>0){
  

                            if(parseInt(element.total_310)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_310;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_312)>0){
 

                            if(parseInt(element.total_312)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_312;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_313)>0){
   
                            if(parseInt(element.total_313)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_313;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_315)>0){
      

                            if(parseInt(element.total_315)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_315;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_317)>0){
         

                            if(parseInt(element.total_317)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_317;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_321)>0){
      

                            if(parseInt(element.total_321)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_321;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                          if(parseInt(elementx.total_316)>0){
   

                            if(parseInt(element.total_316)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_316;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                          if(parseInt(elementx.total_309)>0){
      

                            if(parseInt(element.total_309)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_309;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_318)>0){
    

                            if(parseInt(element.total_318)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_318;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_319)>0){


                            if(parseInt(element.total_319)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_319;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                          if(parseInt(elementx.total_oth)>0){
                            if(parseInt(element.total_oth)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_oth;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                        });

                        worksheet.getCell(columnadd+columnx+countery).value = (element.qty_total);
                        worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                        countery++;

                    });
                    // End loop header


                    worksheet.getCell('A'+countery).value = 'JUMLAH';
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('B'+countery).value = dtt_raw_oneline[0].qty_w;
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('C'+countery).value = dtt_raw_oneline[0].qty_p;
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('D'+countery).value = (dtt_raw_oneline[0].qty_w+dtt_raw_oneline[0].qty_p);
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell(columnadd+columnx+countery).value = dtt_raw_oneline[0].qty_total;
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    columnadd = "";
                    columnx = "E";
                    dtt_raw_oneline.forEach(element => {
                        if(parseInt(element.total_324)>0){
                          worksheet.getCell(columnx+countery).value = element.total_324;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);

                        }
                        if(parseInt(element.total_325)>0){
                          worksheet.getCell(columnx+countery).value = element.total_325;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_326)>0){
                          worksheet.getCell(columnx+countery).value = element.total_326;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_327)>0){
                          worksheet.getCell(columnx+countery).value = element.total_327;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_328)>0){
                          worksheet.getCell(columnx+countery).value = element.total_328;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_280)>0){
                          worksheet.getCell(columnx+countery).value = element.total_280;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_281)>0){
                          worksheet.getCell(columnx+countery).value = element.total_281;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_282)>0){
                          worksheet.getCell(columnx+countery).value = element.total_282;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_283)>0){
                          worksheet.getCell(columnx+countery).value = element.total_283;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_284)>0){
                          worksheet.getCell(columnx+countery).value = element.total_284;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_285)>0){
                          worksheet.getCell(columnx+countery).value = element.total_285;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_286)>0){
                          worksheet.getCell(columnx+countery).value = element.total_286;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_287)>0){
                          worksheet.getCell(columnx+countery).value = element.total_287;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_289)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_289;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_290)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_290;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_291)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_291;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_292)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_292;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_293)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_293;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_294)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_294;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_295)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_295;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_296)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_296;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_297)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_297;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_298)>0){

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_298;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_300)>0){

   
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_300;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_301)>0){


                          worksheet.getCell(columnadd+columnadd+columnx+countery).value = element.total_301;
                          worksheet.getCell(columnadd+columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_302)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_302;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }

                        if(parseInt(element.total_304)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_304;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_305)>0){

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_305;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_306)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_306;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_307)>0){

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_307;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_308)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_308;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_310)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_310;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_312)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_312;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_313)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_313;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }


                        }
                        if(parseInt(element.total_315)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_315;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }


                        }
                        if(parseInt(element.total_317)>0){

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_317;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_321)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_321;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_316)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_316;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_309)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_309;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_318)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_318;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_319)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_319;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_oth)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_oth;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        worksheet.getRow(countery).font = { bold: true };



                    });


                    
                    // End loop header

                    let filename = "Report_Summary_Faktur_"+(Math.floor(Date.now() / 1000)+".xlsx");
                    workbook.xlsx.writeBuffer()
                    .then(function(buffer) {
                      saveAs(
                        new Blob([buffer], { type: "application/octet-stream" }),
                        filename
                      );
                  });

                  });
      });
 
    });


    
 </script>
</html> 