<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Harian</title>
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


      <table class="table table-striped" id="service_table" width="100%">
        <thead>
        <tr style="background-color:#FFA726;color:white;">
          <th scope="col" width="2%">No</th>
          <th scope="col" width="7%" >Ruangan</th>
          <th width="7%" >Nama Tamu</th>
          <th scope="col" width="7%">Jam Kerja</th>
          <th width="5%" >MU</th>
            @foreach($dtt_raw_oneline as $header)
              @if((int)$header->total_324>0)
                <th scope="col" width="3%">VTT</th>
              @endif
              @if((int)$header->total_325>0)
                <th scope="col" width="3%">VFBT</th>
              @endif
              @if((int)$header->total_326>0)
                <th scope="col" width="3%">VFBR</th>
              @endif
              @if((int)$header->total_327>0)
                <th scope="col" width="3%">VEBBSL</th>
              @endif
              @if((int)$header->total_328>0)
                <th scope="col" width="3%">VEBBSSGT</th>
              @endif
              @if((int)$header->total_280>0)
                <th scope="col" width="3%">TH</th>
              @endif
              @if((int)$header->total_281>0)
                <th scope="col" width="3%">FAC</th>
              @endif
              @if((int)$header->total_282>0)
                <th scope="col" width="3%">BHC</th>
              @endif
              @if((int)$header->total_283>0)
                <th scope="col" width="3%">ST</th>
              @endif                  
              @if((int)$header->total_284>0)
                <th scope="col" width="3%">TT</th>
              @endif
              @if((int)$header->total_285>0)
                <th scope="col" width="3%">FR</th>
              @endif
              @if((int)$header->total_286>0)
                <th scope="col" width="3%">HS</th>
              @endif
              @if((int)$header->total_287>0)
                  <th scope="col" width="3%">EC</th>
              @endif
              @if((int)$header->total_288>0)
                <th scope="col" width="3%">DRY</th>
              @endif
              @if((int)$header->total_289>0)
                <th scope="col" width="3%">FBT</th>
              @endif
                @if((int)$header->total_290>0)
                  <th scope="col" width="3%">AA</th>
                @endif

                @if((int)$header->total_291>0)
                  <th scope="col" width="3%">FBR</th>
                @endif
             
                @if((int)$header->total_292>0)
                  <th scope="col" width="3%">V SPA</th>
                @endif
             
                @if((int)$header->total_293>0)
                  <th scope="col" width="3%">BACK DRY</th>
                @endif
             
              @if((int)$header->total_294>0)
                <th scope="col" width="3%">BACK</th>
              @endif
           
              @if((int)$header->total_295>0)
                <th scope="col" width="3%">BCM</th>
              @endif
           
              @if((int)$header->total_296>0)
                <th scope="col" width="3%">SLIM & BREAST</th>
              @endif
        
              @if((int)$header->total_297>0)
                <th scope="col" width="3%">SLIM</th>
              @endif
              @if((int)$header->total_298>0)
                <th scope="col" width="3%">BREAST</th>
              @endif
           
              @if((int)$header->total_299>0)
                <th scope="col" width="3%">RATUS</th>
              @endif
           
              @if((int)$header->total_300>0)
                <th scope="col" width="3%">EBBSL</th>
              @endif
           
              @if((int)$header->total_301>0)
                <th scope="col" width="3%">EBBS</th>
              @endif
          
              @if((int)$header->total_302>0)
                <th scope="col" width="3%">BODY BLEACH</th>
              @endif
           
              @if((int)$header->total_304>0)
                <th scope="col" width="3%">BABSL</th>
              @endif
           
              @if((int)$header->total_305>0)
                <th scope="col" width="3%">BABS</th>
              @endif
           
              @if((int)$header->total_306>0)
                <th scope="col" width="3%">JFS</th>
              @endif
           
              @if((int)$header->total_307>0)
                <th scope="col" width="3%">FOOT</th>
              @endif
              @if((int)$header->total_308>0)
                <th scope="col" width="3%">FOOT EXSPR</th>
                @endif
              @if((int)$header->total_310>0)
                <th scope="col" width="3%">BCP</th> 
              @endif
          
              @if((int)$header->total_312>0)
                <th scope="col" width="3%">LA</th>
              @endif
            
              @if((int)$header->total_313>0)
                <th scope="col" width="3%">MSU</th>
                @endif
              @if((int)$header->total_315>0)
                <th scope="col" width="3%">MB</th>
              @endif
            
              @if((int)$header->total_317>0)
                <th scope="col" width="3%">STEAM B</th>
              @endif
              @if((int)$header->total_321>0)
                <th scope="col" width="3%">TP</th>
              @endif
              @if((int)$header->total_316>0)
                <th scope="col" width="3%">ET</th>
              @endif
              @if((int)$header->total_309>0)
                <th scope="col" width="3%">ETHC</th>
              @endif
              @if((int)$header->total_318>0)
                <th scope="col" width="3%">21:00</th>
              @endif
              @if((int)$header->total_319>0)
                <th scope="col" width="3%">22:00</th>
              @endif
              <th>Pembayaran</th>
              <th>Produk</th>
              <th>Nilai</th>
              <th width="12%">Keterangan</th>
          @endforeach

        </tr>
        </thead>
        <tbody>
          @php
            $total_qty = 0;
            $total_service = 0; 
            $qty_service = 0; 
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
                      <td style="text-align: left;">{{ $counter+1 }}</td>
                      <td style="text-align: left;@php if($detail->remark =='SHIFT 1 PAGI') {  echo 'background-color:#fea8ff;'; } @endphp">{{ $detail->branch_room }}<br>{{ $detail->invoice_no }}</td>
                      <td style="text-align: left;">{{ $detail->customers_name }}</td>
                      <td style="text-align: left;">
                        @php
                            $c = 1;
                            $sumconversion = 0;
                            $lastsch = "";
                        @endphp
                        @foreach($dtt_item_only as $dio)
                            @if($dio->type_id==2 && $dio->customers_id == $detail->id && $dio->executed_at!='' && $dio->invoice_no==$detail->invoice_no)
                                {{ \Carbon\Carbon::parse($dio->executed_at)->format('H:i') }} - {{ \Carbon\Carbon::parse($dio->executed_at)->add($dio->conversion.' minutes')->format('H:i') }} <br>
                            @endif
                        @endforeach
                      </td>
                      <td style="text-align: left;">{{ $detail->name }}</td>    
                      @foreach($dtt_raw_oneline as $header)
                          @if((int)$header->total_324>0)
                              @php if((int)$dtt_raw[$counter]->total_324>0){ $c_324++; } @endphp
                                <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_324,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_325>0)
                          @php if((int)$dtt_raw[$counter]->total_325>0){ $c_325++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_325,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_326>0)
                          @php if((int)$dtt_raw[$counter]->total_326>0){ $c_326++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_326,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_327>0)
                          @php if((int)$dtt_raw[$counter]->total_327>0){ $c_327++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_327,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_328>0)
                          @php if((int)$dtt_raw[$counter]->total_328>0){ $c_328++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_328,0,',','.') }}</td>
                          @endif


                          @if((int)$header->total_280>0)
                          @php if((int)$dtt_raw[$counter]->total_280>0){ $c_280++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_280,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_281>0)
                          @php if((int)$dtt_raw[$counter]->total_281>0){ $c_281++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_281,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_282>0)
                            @php if((int)$dtt_raw[$counter]->total_282>0){ $c_282++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_282,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_283>0)
                              @php if((int)$dtt_raw[$counter]->total_283>0){ $c_283++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_283,0,',','.') }}</td>
                          @endif                  
                          @if((int)$header->total_284>0)
                              @php if((int)$dtt_raw[$counter]->total_284>0 || (int)$dtt_raw_disc[$counter]->total_284>0){ $c_284++; } @endphp 
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_284<=0 && (int)$dtt_raw_disc[$counter]->total_284>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_284,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_285>0)
                          @php if((int)$dtt_raw[$counter]->total_285>0){ $c_285++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_285,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_286>0)
                          @php if((int)$dtt_raw[$counter]->total_286>0){ $c_286++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_286,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_287>0)
                          @php if((int)$dtt_raw[$counter]->total_287>0){ $c_287++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_287,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_288>0)
                          @php if((int)$dtt_raw[$counter]->total_288>0){ $c_288++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_288,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_289>0)
                          @php if((int)$dtt_raw[$counter]->total_289>0 || (int)$dtt_raw_disc[$counter]->total_289>0){ $c_289++; } @endphp 
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_289<=0 && (int)$dtt_raw_disc[$counter]->total_289>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_289,0,',','.'); } @endphp </td>
                          @endif

                            @if((int)$header->total_290>0)
                            @php if((int)$dtt_raw[$counter]->total_290>0){ $c_290++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_290,0,',','.') }}</td>
                            @endif
        
                            @if((int)$header->total_291>0)
                            @php if((int)$dtt_raw[$counter]->total_291>0 || (int)$dtt_raw_disc[$counter]->total_291>0){ $c_291++; } @endphp 
                                <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_291<=0 && (int)$dtt_raw_disc[$counter]->total_291>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_291,0,',','.'); } @endphp </td>
                            @endif

                            
                        
                            @if((int)$header->total_292>0)
                            @php if((int)$dtt_raw[$counter]->total_292>0){ $c_292++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_292,0,',','.') }}</td>
                            @endif
                        
                            @if((int)$header->total_293>0)
                            @php if((int)$dtt_raw[$counter]->total_293>0){ $c_293++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_293,0,',','.') }}</td>
                            @endif
                        
                          @if((int)$header->total_294>0)
                          @php if((int)$dtt_raw[$counter]->total_294>0){ $c_294++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_294,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_295>0)
                          @php if((int)$dtt_raw[$counter]->total_295>0){ $c_295++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_295,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_296>0)
                          @php if((int)$dtt_raw[$counter]->total_296>0){ $c_296++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_296,0,',','.') }}</td>
                          @endif
                    
                          @if((int)$header->total_297>0)
                          @php if((int)$dtt_raw[$counter]->total_297>0){ $c_297++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_297,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_298>0)
                          @php if((int)$dtt_raw[$counter]->total_298>0){ $c_298++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_298,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_299>0)
                          @php if((int)$dtt_raw[$counter]->total_299>0){ $c_299++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_299,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_300>0)
                          @php if((int)$dtt_raw[$counter]->total_300>0){ $c_300++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_300,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_301>0)
                          @php if((int)$dtt_raw[$counter]->total_301>0){ $c_301++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_301,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_302>0)
                          @php if((int)$dtt_raw[$counter]->total_302>0){ $c_302++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_302,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_304>0)
                          @php if((int)$dtt_raw[$counter]->total_304>0){ $c_304++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_304,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_305>0)
                          @php if((int)$dtt_raw[$counter]->total_305>0){ $c_305++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_305,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_306>0)
                          @php if((int)$dtt_raw[$counter]->total_306>0){ $c_306++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_306,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_307>0)
                          @php if((int)$dtt_raw[$counter]->total_307>0){ $c_307++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_307,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_308>0)
                          @php if((int)$dtt_raw[$counter]->total_308>0){ $c_308++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_308,0,',','.') }}</td>
                            @endif
                          @if((int)$header->total_310>0)
                          @php if((int)$dtt_raw[$counter]->total_310>0){ $c_310++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_310,0,',','.') }}</td>
                          @endif
                      
                          @if((int)$header->total_312>0)
                          @php if((int)$dtt_raw[$counter]->total_312>0){ $c_312++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_312,0,',','.') }}</td>
                          @endif
                        
                          @if((int)$header->total_313>0)
                          @php if((int)$dtt_raw[$counter]->total_313>0){ $c_313++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_313,0,',','.') }}</td>
                            @endif
                          @if((int)$header->total_315>0)
                          @php if((int)$dtt_raw[$counter]->total_315>0){ $c_315++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_315,0,',','.') }}</td>
                          @endif
                        
                          @if((int)$header->total_317>0)
                          @php if((int)$dtt_raw[$counter]->total_317>0){ $c_317++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_317,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_321>0)
                          @php if((int)$dtt_raw[$counter]->total_321>0){ $c_321++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_321,0,',','.') }}</td>
                          @endif
                           
                          @if((int)$header->total_316>0)
                          @php if((int)$dtt_raw[$counter]->total_316>0){ $c_316++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_316,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_309>0)
                          @php if((int)$dtt_raw[$counter]->total_309>0){ $c_309++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_309,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_318>0)
                          @php if((int)$dtt_raw[$counter]->total_318>0){ $c_318++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_318,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_319>0)
                          @php if((int)$dtt_raw[$counter]->total_319>0){ $c_319++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_319,0,',','.') }}</td>
                          @endif
                      @endforeach
                    <td>{{ $detail->payment_type }}</td>
                    <td style="text-align: left;">

                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id && $diox->refbuy == 0 && $diox->category_id<>"26"  && $diox->invoice_no== $detail->invoice_no)
                                {{ $diox->product_name }}  / {{ $diox->qty }} <br>
                                @php $c_p=$c_p+$diox->qty; @endphp
                          @endif
                      @endforeach
                    </td>

                    <td style="text-align: left;">
                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id && $diox->refbuy == 0  && $diox->category_id<>"26"   && $diox->invoice_no== $detail->invoice_no )
                                {{ number_format($diox->total,0,',','.') }}<br>
                                @php 
                                $t_p=$t_p+$diox->total; 
                                @endphp
                          @endif
                      @endforeach
                    </td>
                    <td style="text-align: left;">
                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id && ($diox->refbuy > 0 || $diox->category_id=="26")   && $diox->invoice_no== $detail->invoice_no )
                                {{ $diox->product_name }} / {{ $diox->qty }}  / {{ $diox->total }}<br>
                                @php $c_pn=$c_pn+$diox->qty; @endphp<br>
                          @endif
                      @endforeach
                      <?php $last_vc = ""; ?>
                      @foreach($dtt_item_only as $diox)
                          <?php 
                            if($diox->customers_id == $detail->id && $diox->invoice_no== $detail->invoice_no && $last_vc!=$diox->voucher_code ){
                                $last_vc = $diox->voucher_code;
                                echo $diox->voucher_code;
                            }
                          ?>
                      @endforeach
                    </td>
                </tr>
                @php
                 $counter++;
                 $counterall++;
                @endphp
           @endforeach
                <tr>
                  @php
                    $count_column_service = 0;
                    $qty_service = 0;
                  @endphp
                  <th colspan="5">JUMLAH</th>
                  @foreach($dtt_raw_oneline as $header)
                    @if((int)$header->total_324>0)
                      @php
                        $count_column_service++;
                        $total_service = $total_service + $header->total_324;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_324;
                      @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_324,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_324 }} </th>
                    @endif
                    @if((int)$header->total_325>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_325;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_325;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_325,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_325 }} </th>
                    @endif
                    @if((int)$header->total_326>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_326;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_326;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_326,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_326 }} </th>
                    @endif
                    @if((int)$header->total_327>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_327;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_327;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_327,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_327 }} </th>
                    @endif
                    @if((int)$header->total_328>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_328;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_328;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_328,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_328 }} </th>
                    @endif


                    @if((int)$header->total_280>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_280;
                        $qty_service = $qty_service + $c_280;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_280,0,',','.') }} / {{ $c_280 }} </th>
                    @endif
                    @if((int)$header->total_281>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_281;
                        $qty_service = $qty_service + $c_281;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_281,0,',','.') }} / {{ $c_281 }}  </th>
                    @endif
                    @if((int)$header->total_282>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_282;
                        $qty_service = $qty_service + $c_282;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_282,0,',','.') }}  / {{ $c_282 }} </th>
                    @endif
                    @if((int)$header->total_283>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_283;
                        $qty_service = $qty_service + $c_283;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_283,0,',','.') }}  / {{ $c_283 }} </th>
                    @endif                  
                    @if((int)$header->total_284>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_284;
                        $qty_service = $qty_service + $c_284;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_284,0,',','.') }}  / {{ $c_284 }} </th>
                    @endif
                    @if((int)$header->total_285>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_285;
                        $qty_service = $qty_service + $c_285;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_285,0,',','.') }}  / {{ $c_285 }} </th>
                    @endif
                    @if((int)$header->total_286>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_286;
                        $qty_service = $qty_service + $c_286;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_286,0,',','.') }}  / {{ $c_286 }} </th>
                    @endif
                    @if((int)$header->total_287>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_287;
                        $qty_service = $qty_service + $c_287;
                    @endphp
                        <th scope="col" width="3%">{{ number_format($header->total_287,0,',','.') }}  / {{ $c_287 }} </th>
                    @endif
                    @if((int)$header->total_288>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_288;
                        $qty_service = $qty_service + $c_288;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_288,0,',','.') }}  / {{ $c_288 }} </th>
                    @endif
                    @if((int)$header->total_289>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_289;
                        $qty_service = $qty_service + $c_289;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_289,0,',','.') }}  / {{ $c_289 }} </th>
                    @endif
                      @if((int)$header->total_290>0)
                      @php
                        $count_column_service++;
                        $total_service = $total_service + $header->total_290;
                        $qty_service = $qty_service + $c_290;
                      @endphp
                        <th scope="col" width="3%">{{ number_format($header->total_290,0,',','.') }}  / {{ $c_290 }} </th>
                      @endif
      
                      @if((int)$header->total_291>0)
                      @php
                        $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_291;
                        $qty_service = $qty_service + $c_291;
                      @endphp
                        <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_291,0,',','.') }}  / {{ $c_291 }} </th>
                      @endif
                  
                      @if((int)$header->total_292>0)
                      @php
                        $count_column_service++;
                        $total_service = $total_service + $header->total_292;
                        $qty_service = $qty_service + $c_292;
                      @endphp
                        <th scope="col" width="3%">{{ number_format($header->total_292,0,',','.') }}  / {{ $c_292 }} </th>
                      @endif
                  
                      @if((int)$header->total_293>0)
                      @php
                        $count_column_service++;
                        $total_service = $total_service + $header->total_293;
                        $qty_service = $qty_service + $c_293;
                      @endphp
                        <th scope="col" width="3%">{{ number_format($header->total_293,0,',','.') }}  / {{ $c_293 }} </th>
                      @endif
                  
                    @if((int)$header->total_294>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_294;
                        $qty_service = $qty_service + $c_294;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_294,0,',','.') }}  / {{ $c_294 }} </th>
                    @endif
                
                    @if((int)$header->total_295>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_295;
                        $qty_service = $qty_service + $c_295;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_295,0,',','.') }}  / {{ $c_295 }} </th>
                    @endif
                
                    @if((int)$header->total_296>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_296;
                        $qty_service = $qty_service + $c_296;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_296,0,',','.') }}  / {{ $c_296 }} </th>
                    @endif
              
                    @if((int)$header->total_297>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_297;
                        $qty_service = $qty_service + $c_297;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_297,0,',','.') }}  / {{ $c_297 }} </th>
                    @endif
                    @if((int)$header->total_298>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_298;
                        $qty_service = $qty_service + $c_298;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_298,0,',','.') }}  / {{ $c_298 }} </th>
                    @endif
                
                    @if((int)$header->total_299>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_299;
                        $qty_service = $qty_service + $c_299;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_299,0,',','.') }}  / {{ $c_299 }} </th>
                    @endif
                
                    @if((int)$header->total_300>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_300;
                        $qty_service = $qty_service + $c_300;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_300,0,',','.') }}  / {{ $c_300 }} </th>
                    @endif
                
                    @if((int)$header->total_301>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_301;
                        $qty_service = $qty_service + $c_301;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_301,0,',','.') }}  / {{ $c_301 }}</th>
                    @endif
                
                    @if((int)$header->total_302>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_302;
                        $qty_service = $qty_service + $c_302;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_302,0,',','.') }}  / {{ $c_302 }} </th>
                    @endif
                
                    @if((int)$header->total_304>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_304;
                        $qty_service = $qty_service + $c_304;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_304,0,',','.') }}  / {{ $c_304 }} </th>
                    @endif
                
                    @if((int)$header->total_305>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_305;
                        $qty_service = $qty_service + $c_305;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_305,0,',','.') }}  / {{ $c_305 }} </th>
                    @endif
                
                    @if((int)$header->total_306>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_306;
                        $qty_service = $qty_service + $c_306;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_306,0,',','.') }}  / {{ $c_306 }} </th>
                    @endif
                
                    @if((int)$header->total_307>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_307;
                        $qty_service = $qty_service + $c_307;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_307,0,',','.') }}  / {{ $c_307 }} </th>
                    @endif
                    @if((int)$header->total_308>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_308;
                        $qty_service = $qty_service + $c_308;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_308,0,',','.') }}  / {{ $c_308 }} </th>
                      @endif
                    @if((int)$header->total_310>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_310;
                        $qty_service = $qty_service + $c_310;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_310,0,',','.') }}  / {{ $c_310 }} </th>
                    @endif
                
                    @if((int)$header->total_312>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_312;
                        $qty_service = $qty_service + $c_312;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_312,0,',','.') }}  / {{ $c_312 }} </th>
                    @endif
                  
                    @if((int)$header->total_313>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_313;
                        $qty_service = $qty_service + $c_313;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_313,0,',','.') }}  / {{ $c_313 }} </th>
                      @endif
                    @if((int)$header->total_315>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_315;
                        $qty_service = $qty_service + $c_315;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_315,0,',','.') }}  / {{ $c_315 }} </th>
                    @endif
                  
                    @if((int)$header->total_317>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_317;
                        $qty_service = $qty_service + $c_317;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_317,0,',','.') }}  / {{ $c_317 }} </th>
                    @endif
                    @if((int)$header->total_321>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_321;
                        $qty_service = $qty_service + $c_321;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_321,0,',','.') }}  / {{ $c_321 }} </th>
                    @endif

                    @if((int)$header->total_316>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_316;
                        $qty_service = $qty_service + $c_316;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_316,0,',','.') }}  / {{ $c_316 }} </th>
                    @endif
                    @if((int)$header->total_309>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_309;
                        $qty_service = $qty_service + $c_309;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_309,0,',','.') }}  / {{ $c_309 }} </th>
                    @endif
                    @if((int)$header->total_318>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_318;
                        $qty_service = $qty_service + $c_318;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_318,0,',','.') }}  / {{ $c_318 }} </th>
                    @endif
                    @if((int)$header->total_319>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $header->total_319;
                        $qty_service = $qty_service + $c_319;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($header->total_319,0,',','.') }}  / {{ $c_319 }} </th>
                    @endif
                    <th></th>
                    <th>{{ number_format($c_p,0,',','.') }}</th>
                    <th>{{ number_format($t_p,0,',','.') }}</th>
                    <th style="text-align: left;">
                      @foreach($out_datas_total_drink as $out_datas_total_drink) 
                          @php
                              echo $out_datas_total_drink->abbr."/".$out_datas_total_drink->qty."/".$out_datas_total_drink->total."<br>";
                          @endphp
                      @endforeach
                      @foreach($out_datas_total_other as $out_datas_total_other) 
                          @php
                              echo $out_datas_total_other->abbr."/".$out_datas_total_other->qty."/".$out_datas_total_other->total."<br>";
                          @endphp
                      @endforeach
                      @foreach($out_datas_total as $out_data_total) 
                          @php
                              echo $out_data_total->abbr."/".$out_data_total->qty."<br>";
                          @endphp
                      @endforeach
                      
                      @php echo "Keluar :<br>"; @endphp 
                      @foreach($petty_datas as $petty_data)
                          @if($petty_data->type == 'Produk - Keluar')
                            {{ $petty_data->abbr }} / ({{ $petty_data->qty }})  @php echo "<br>"; @endphp                       
                          @endif    
                      @endforeach
                      @php echo "Masuk :<br>"; @endphp     
                      @foreach($petty_datas as $petty_data)
                          @if($petty_data->type == 'Produk - Masuk')
                            {{ $petty_data->abbr }} / ({{ $petty_data->qty }})  @php echo "<br>"; @endphp                      
                          @endif    
                      @endforeach
                    </th>
                @endforeach
                </tr>
                <tr>
                  <td colspan="5"></td>
                  <th colspan="{{ $count_column_service }}">{{ number_format($total_service,0,',','.') }} / {{ number_format($qty_service,0,',','.')  }}</th>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
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