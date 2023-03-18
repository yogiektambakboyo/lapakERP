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
          font-size: 14px;
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
          <tr>
            <td colspan="3">
            </td>
          </tr>
        </tbody>
      </table>


      <table class="table table-striped" id="service_table">
        <thead>
        <tr style="background-color:#FFA726;color:white;">
          <th scope="col" width="4%">No</th>
          <th width="12%" >Ruangan</th>
          <th width="12%" >Nama Tamu</th>
          <th  scope="col" width="18%">Jam Kerja</th>
          <th width="20%" >MU</th>
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
              <th>Produk</th>
              <th>Nilai</th>
              <th>Keterangan</th>
          @endforeach

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
          @endphp

            @foreach($dtt_detail as $detail)
                  <tr>
                      <td style="text-align: left;">{{ $counter+1 }}</td>
                      <td width="12%" style="text-align: left;">{{ $detail->branch_room }}</td>
                      <td style="text-align: left;">{{ $detail->customers_name }}</td>
                      <td style="text-align: left;">
                        @php
                            $c = 1;
                            $sumconversion = 0;
                            $lastsch = "";
                        @endphp
                        @foreach($dtt_item_only as $dio)
                            @if($dio->type_id==2 && $dio->customers_id == $detail->id)
                                @php
                                  $sumconversion = $sumconversion+$dio->conversion;
                                  if ($lastsch=="") {
                                    $lastsch = $detail->scheduled_at;
                                  }
                                @endphp
                                
                                  {{ \Carbon\Carbon::parse($lastsch)->isoFormat('H:mm') }} - {{ \Carbon\Carbon::parse($detail->scheduled_at)->add($sumconversion.' minutes')->isoFormat('H:mm') }} <br>
                                  @php
                                    $c++;
                                    $lastsch = \Carbon\Carbon::parse($detail->scheduled_at)->add($sumconversion.' minutes')->isoFormat('H:mm');
                                  @endphp
                            @endif
                        @endforeach
                      </td>
                      <td style="text-align: left;">{{ $detail->name }}</td>    
                      @foreach($dtt_raw_oneline as $header)
                          @if((int)$header->total_280>0)
                          @php if((int)$dtt_raw[$counter]->total_280>0){ $c_280++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_280,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_281>0)
                          @php if((int)$dtt_raw[$counter]->total_281>0){ $c_281++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_281,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_282>0)
                            @php if((int)$dtt_raw[$counter]->total_282>0){ $c_282++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_282,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_283>0)
                              @php if((int)$dtt_raw[$counter]->total_283>0){ $c_283++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_283,0,',','.') }}</td>
                          @endif                  
                          @if((int)$header->total_284>0)
                          @php if((int)$dtt_raw[$counter]->total_284>0){ $c_284++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_284,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_285>0)
                          @php if((int)$dtt_raw[$counter]->total_285>0){ $c_285++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_285,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_286>0)
                          @php if((int)$dtt_raw[$counter]->total_286>0){ $c_286++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_286,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_287>0)
                          @php if((int)$dtt_raw[$counter]->total_287>0){ $c_287++; } @endphp
                              <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_287,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_288>0)
                          @php if((int)$dtt_raw[$counter]->total_288>0){ $c_288++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_288,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_289>0)
                          @php if((int)$dtt_raw[$counter]->total_289>0){ $c_289++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_289,0,',','.') }}</td>
                          @endif

                            @if((int)$header->total_290>0)
                            @php if((int)$dtt_raw[$counter]->total_290>0){ $c_290++; } @endphp
                              <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_290,0,',','.') }}</td>
                            @endif
          
                            @if((int)$header->total_291>0)
                            @php if((int)$dtt_raw[$counter]->total_291>0){ $c_291++; } @endphp
                              <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_291,0,',','.') }}</td>
                            @endif
                        
                            @if((int)$header->total_292>0)
                            @php if((int)$dtt_raw[$counter]->total_292>0){ $c_292++; } @endphp
                              <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_292,0,',','.') }}</td>
                            @endif
                        
                            @if((int)$header->total_293>0)
                            @php if((int)$dtt_raw[$counter]->total_293>0){ $c_293++; } @endphp
                              <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_293,0,',','.') }}</td>
                            @endif
                        
                          @if((int)$header->total_294>0)
                          @php if((int)$dtt_raw[$counter]->total_294>0){ $c_294++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_294,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_295>0)
                          @php if((int)$dtt_raw[$counter]->total_295>0){ $c_295++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_295,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_296>0)
                          @php if((int)$dtt_raw[$counter]->total_296>0){ $c_296++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_296,0,',','.') }}</td>
                          @endif
                    
                          @if((int)$header->total_297>0)
                          @php if((int)$dtt_raw[$counter]->total_297>0){ $c_297++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_297,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_298>0)
                          @php if((int)$dtt_raw[$counter]->total_298>0){ $c_298++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_298,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_299>0)
                          @php if((int)$dtt_raw[$counter]->total_299>0){ $c_299++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_299,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_300>0)
                          @php if((int)$dtt_raw[$counter]->total_300>0){ $c_300++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_300,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_301>0)
                          @php if((int)$dtt_raw[$counter]->total_301>0){ $c_301++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_301,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_302>0)
                          @php if((int)$dtt_raw[$counter]->total_302>0){ $c_302++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_302,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_304>0)
                          @php if((int)$dtt_raw[$counter]->total_304>0){ $c_304++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_304,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_305>0)
                          @php if((int)$dtt_raw[$counter]->total_305>0){ $c_305++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_305,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_306>0)
                          @php if((int)$dtt_raw[$counter]->total_306>0){ $c_306++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_306,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_307>0)
                          @php if((int)$dtt_raw[$counter]->total_307>0){ $c_307++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_307,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_308>0)
                          @php if((int)$dtt_raw[$counter]->total_308>0){ $c_308++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_308,0,',','.') }}</td>
                            @endif
                          @if((int)$header->total_310>0)
                          @php if((int)$dtt_raw[$counter]->total_310>0){ $c_310++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_310,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_312>0)
                          @php if((int)$dtt_raw[$counter]->total_312>0){ $c_312++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_312,0,',','.') }}</td>
                          @endif
                        
                          @if((int)$header->total_313>0)
                          @php if((int)$dtt_raw[$counter]->total_313>0){ $c_313++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_313,0,',','.') }}</td>
                            @endif
                          @if((int)$header->total_315>0)
                          @php if((int)$dtt_raw[$counter]->total_315>0){ $c_315++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_315,0,',','.') }}</td>
                          @endif
                        
                          @if((int)$header->total_317>0)
                          @php if((int)$dtt_raw[$counter]->total_317>0){ $c_317++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_317,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_321>0)
                          @php if((int)$dtt_raw[$counter]->total_321>0){ $c_321++; } @endphp
                            <td scope="col" width="5%">{{ number_format($dtt_raw[$counter]->total_321,0,',','.') }}</td>
                          @endif
                      @endforeach
                    <td>{{ $detail->payment_type }}</td>
                    <td style="text-align: left;">

                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id && $diox->refbuy == 0)
                                {{ $diox->product_name }} <br>
                                @php $c_p++; @endphp
                          @endif
                      @endforeach
                    </td>
                    <td style="text-align: left;">
                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id && $diox->refbuy == 0)
                                {{ number_format($diox->total,0,',','.') }} <br>
                                @php 
                                $t_p=$t_p+$diox->total; 
                                @endphp
                          @endif
                      @endforeach
                    </td>
                    <td style="text-align: left;">
                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id && $diox->refbuy > 0)
                                {{ $diox->product_name }} / {{ $diox->qty }}<br>
                                @php $c_pn=$c_pn+$diox->qty; @endphp
                          @endif
                      @endforeach
                    </td>
                </tr>
                @php
                 $counter++;
                 $counterall++;
                @endphp
           @endforeach
                <tr>
                  <th colspan="5">JUMLAH</th>
                  @foreach($dtt_raw_oneline as $header)
                    @if((int)$header->total_280>0)
                      <th scope="col" width="5%">{{ number_format($header->total_280,0,',','.') }} / {{ $c_280 }} </th>
                    @endif
                    @if((int)$header->total_281>0)
                      <th scope="col" width="5%">{{ number_format($header->total_281,0,',','.') }} / {{ $c_281 }}  </th>
                    @endif
                    @if((int)$header->total_282>0)
                      <th scope="col" width="5%">{{ number_format($header->total_282,0,',','.') }}  / {{ $c_282 }} </th>
                    @endif
                    @if((int)$header->total_283>0)
                      <th scope="col" width="5%">{{ number_format($header->total_283,0,',','.') }}  / {{ $c_283 }} </th>
                    @endif                  
                    @if((int)$header->total_284>0)
                      <th scope="col" width="5%">{{ number_format($header->total_284,0,',','.') }}  / {{ $c_284 }} </th>
                    @endif
                    @if((int)$header->total_285>0)
                      <th scope="col" width="5%">{{ number_format($header->total_285,0,',','.') }}  / {{ $c_285 }} </th>
                    @endif
                    @if((int)$header->total_286>0)
                      <th scope="col" width="5%">{{ number_format($header->total_286,0,',','.') }}  / {{ $c_286 }} </th>
                    @endif
                    @if((int)$header->total_287>0)
                        <th scope="col" width="5%">{{ number_format($header->total_287,0,',','.') }}  / {{ $c_287 }} </th>
                    @endif
                    @if((int)$header->total_288>0)
                      <th scope="col" width="5%">{{ number_format($header->total_288,0,',','.') }}  / {{ $c_288 }} </th>
                    @endif
                    @if((int)$header->total_289>0)
                      <th scope="col" width="5%">{{ number_format($header->total_289,0,',','.') }}  / {{ $c_289 }} </th>
                    @endif
                      @if((int)$header->total_290>0)
                        <th scope="col" width="5%">{{ number_format($header->total_290,0,',','.') }}  / {{ $c_290 }} </th>
                      @endif
      
                      @if((int)$header->total_291>0)
                        <th scope="col" width="5%">{{ number_format($header->total_291,0,',','.') }}  / {{ $c_291 }} </th>
                      @endif
                  
                      @if((int)$header->total_292>0)
                        <th scope="col" width="5%">{{ number_format($header->total_292,0,',','.') }}  / {{ $c_292 }} </th>
                      @endif
                  
                      @if((int)$header->total_293>0)
                        <th scope="col" width="5%">{{ number_format($header->total_293,0,',','.') }}  / {{ $c_293 }} </th>
                      @endif
                  
                    @if((int)$header->total_294>0)
                      <th scope="col" width="5%">{{ number_format($header->total_294,0,',','.') }}  / {{ $c_294 }} </th>
                    @endif
                
                    @if((int)$header->total_295>0)
                      <th scope="col" width="5%">{{ number_format($header->total_295,0,',','.') }}  / {{ $c_295 }} </th>
                    @endif
                
                    @if((int)$header->total_296>0)
                      <th scope="col" width="5%">{{ number_format($header->total_296,0,',','.') }}  / {{ $c_296 }} </th>
                    @endif
              
                    @if((int)$header->total_297>0)
                      <th scope="col" width="5%">{{ number_format($header->total_297,0,',','.') }}  / {{ $c_297 }} </th>
                    @endif
                    @if((int)$header->total_298>0)
                      <th scope="col" width="5%">{{ number_format($header->total_298,0,',','.') }}  / {{ $c_298 }} </th>
                    @endif
                
                    @if((int)$header->total_299>0)
                      <th scope="col" width="5%">{{ number_format($header->total_299,0,',','.') }}  / {{ $c_299 }} </th>
                    @endif
                
                    @if((int)$header->total_300>0)
                      <th scope="col" width="5%">{{ number_format($header->total_300,0,',','.') }}  / {{ $c_300 }} </th>
                    @endif
                
                    @if((int)$header->total_301>0)
                      <th scope="col" width="5%">{{ number_format($header->total_301,0,',','.') }}  / {{ $c_301 }} </th>
                    @endif
                
                    @if((int)$header->total_302>0)
                      <th scope="col" width="5%">{{ number_format($header->total_302,0,',','.') }}  / {{ $c_302 }} </th>
                    @endif
                
                    @if((int)$header->total_304>0)
                      <th scope="col" width="5%">{{ number_format($header->total_304,0,',','.') }}  / {{ $c_304 }} </th>
                    @endif
                
                    @if((int)$header->total_305>0)
                      <th scope="col" width="5%">{{ number_format($header->total_305,0,',','.') }}  / {{ $c_305 }} </th>
                    @endif
                
                    @if((int)$header->total_306>0)
                      <th scope="col" width="5%">{{ number_format($header->total_306,0,',','.') }}  / {{ $c_306 }} </th>
                    @endif
                
                    @if((int)$header->total_307>0)
                      <th scope="col" width="5%">{{ number_format($header->total_307,0,',','.') }}  / {{ $c_307 }} </th>
                    @endif
                    @if((int)$header->total_308>0)
                      <th scope="col" width="5%">{{ number_format($header->total_308,0,',','.') }}  / {{ $c_308 }} </th>
                      @endif
                    @if((int)$header->total_310>0)
                      <th scope="col" width="5%">{{ number_format($header->total_310,0,',','.') }}  / {{ $c_310 }} </th>
                    @endif
                
                    @if((int)$header->total_312>0)
                      <th scope="col" width="5%">{{ number_format($header->total_312,0,',','.') }}  / {{ $c_312 }} </th>
                    @endif
                  
                    @if((int)$header->total_313>0)
                      <th scope="col" width="5%">{{ number_format($header->total_313,0,',','.') }}  / {{ $c_313 }} </th>
                      @endif
                    @if((int)$header->total_315>0)
                      <th scope="col" width="5%">{{ number_format($header->total_315,0,',','.') }}  / {{ $c_315 }} </th>
                    @endif
                  
                    @if((int)$header->total_317>0)
                      <th scope="col" width="5%">{{ number_format($header->total_317,0,',','.') }}  / {{ $c_317 }} </th>
                    @endif
                    @if((int)$header->total_321>0)
                      <th scope="col" width="5%">{{ number_format($header->total_321,0,',','.') }}  / {{ $c_321 }} </th>
                    @endif
                    <th></th>
                    <th>{{ number_format($c_p,0,',','.') }}</th>
                    <th>{{ number_format($t_p,0,',','.') }}</th>
                    <th style="text-align: left;">
                      @foreach($out_datas_total as $out_data_total) 
                          @php
                              echo $out_data_total->abbr."/".$out_data_total->qty."<br>";
                          @endphp
                      @endforeach
                    </th>
                @endforeach
                </tr>
        </tbody>
      </table>

      <br>

   </body> 
</html> 