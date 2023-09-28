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
          <th scope="col" width="6%" >Ruangan</th>
          <th width="7%" >Nama Tamu</th>
          <th scope="col" width="6%">Jam Kerja</th>
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
                  <th scope="col" width="3%">VSPA</th>
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
                <th scope="col" width="3%">SLIM BRS</th>
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
                <th scope="col" width="3%">BODY BLC</th>
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
                <th scope="col" width="3%">FOOT EXS</th>
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
                <th scope="col" width="3%">STEAMB</th>
              @endif
              @if((int)$header->total_321>0)
                <th scope="col" width="3%">TP</th>
              @endif


              @if((int)$header->total_468>0)
                <th scope="col" width="3%">FBT JR1</th>
              @endif
              @if((int)$header->total_469>0)
                <th scope="col" width="3%">FBR JR1</th>
              @endif
              @if((int)$header->total_470>0)
                <th scope="col" width="3%">TT JR1</th>
              @endif
              @if((int)$header->total_472>0)
                <th scope="col" width="3%">BACK JR1</th>
              @endif
              @if((int)$header->total_474>0)
                <th scope="col" width="3%">BCM JR1</th>
              @endif
              @if((int)$header->total_476>0)
                <th scope="col" width="3%">FRB JR1</th>
              @endif
              @if((int)$header->total_477>0)
                <th scope="col" width="3%">FOOT JR1</th>
              @endif
              @if((int)$header->total_479>0)
                <th scope="col" width="3%">TT JR2</th>
              @endif
              @if((int)$header->total_480>0)
                <th scope="col" width="3%">FBT JR2</th>
              @endif
              @if((int)$header->total_481>0)
                <th scope="col" width="3%">FBR JR2</th>
              @endif
              @if((int)$header->total_482>0)
                <th scope="col" width="3%">BACK JR2</th>
              @endif
              @if((int)$header->total_485>0)
                <th scope="col" width="3%">BCM JR2</th>
              @endif
              @if((int)$header->total_486>0)
                <th scope="col" width="3%">FRB2</th>
              @endif
              @if((int)$header->total_487>0)
                <th scope="col" width="3%">FOOT JR2</th>
              @endif
              @if((int)$header->total_449>0)
                <th scope="col" width="3%">EBBSLG</th>
              @endif
              @if((int)$header->total_453>0)
                <th scope="col" width="3%">EBBSGT</th>
              @endif
              @if((int)$header->total_455>0)
                <th scope="col" width="3%">EBBSGT3</th>
              @endif
              @if((int)$header->total_341>0)
                <th scope="col" width="3%">MCL</th>
              @endif

              @if((int)$header->total_445>0)
                <th scope="col" width="3%">TTW1</th>
              @endif
              @if((int)$header->total_446>0)
                <th scope="col" width="3%">FR</th>
              @endif
              @if((int)$header->total_452>0)
                <th scope="col" width="3%">LSTAND</th>
              @endif
              @if((int)$header->total_444>0)
                <th scope="col" width="3%">FBT1J</th>
              @endif
              @if((int)$header->total_340>0)
                <th scope="col" width="3%">HBM</th>
              @endif
              @if((int)$header->total_342>0)
                <th scope="col" width="3%">FBM</th>
              @endif
              @if((int)$header->total_448>0)
                <th scope="col" width="3%">BRS1J</th>
              @endif
              @if((int)$header->total_510>0)
                <th scope="col" width="3%">GTBR</th>
              @endif

              @if((int)$header->total_496>0)
                <th scope="col" width="3%">LEX</th>
              @endif
              @if((int)$header->total_518>0)
                <th scope="col" width="3%">CATWPN</th>
              @endif
              @if((int)$header->total_544>0)
                <th scope="col" width="3%">CRB</th>
              @endif
              @if((int)$header->total_546>0)
                <th scope="col" width="3%">CRBBL</th>
              @endif
              @if((int)$header->total_567>0)
                <th scope="col" width="3%">HMMKZ</th>
              @endif
              @if((int)$header->total_537>0)
                <th scope="col" width="3%">MP</th>
              @endif
              @if((int)$header->total_538>0)
                <th scope="col" width="3%">PD</th>
              @endif

              @if((int)$header->total_oth_sln>0)
                <th scope="col" width="3%">OTHER</th>
              @endif
              
              @if((int)$header->total_498>0)
                <th scope="col" width="3%">KERIK</th>
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
              @if((int)$header->total_467>0)
                <th scope="col" width="3%">CGEN</th>
              @endif
              @if((int)$header->total_488>0)
                <th scope="col" width="3%">CROOM</th>
              @endif
              @if((int)$header->total_494>0)
                <th scope="col" width="3%">CMNYK</th>
              @endif
              @if((int)$header->total_329>0)
                <th scope="col" width="3%">CLBRN</th>
              @endif
              @if((int)$header->total_635>0)
                <th scope="col" width="3%">OTH-XTRA</th>
              @endif
              <th scope="col" width="4%">Bayar</th>
              <th scope="col" width="7%">Produk</th>
              <th scope="col" width="3%">Rp.</th>
              <th scope="col" width="7%">Minuman</th>
              <th width="15%">Keterangan</th>
          @endforeach

        </tr>
        </thead>
        <tbody>
          @php
            $total_qty = 0;
            $total_payment = 0;
            $total_service = 0; 
            $qty_service = 0; 
            $total_extra = 0; 
            $qty_extra = 0; 
            $t_drink = 0;
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
            $c_444 = 0;
            $c_340 = 0;
            $c_342 = 0;
            $c_448 = 0;
            $c_341 = 0;
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
            $c_467 = 0;
            $c_488 = 0;
            $c_494 = 0;
            $c_329 = 0;

            $c_316 = 0;
            $c_510 = 0;

            $c_496 = 0;
            $c_518 = 0;
            $c_544 = 0;
            $c_546 = 0;
            $c_567 = 0;
            $c_537 = 0;
            $c_538 = 0;
            $c_635 = 0;
            $c_oth_sln = 0;
            

            $c_498 = 0;
            $c_309 = 0;
            $c_318 = 0;
            $c_324 = 0;
            $c_325 = 0;
            $c_326 = 0;
            $c_327 = 0;
            $c_328 = 0;
            $c_449 = 0;
            $c_453 = 0;
            $c_455 = 0;

            $c_468 = 0;
            $c_469 = 0;
            $c_470 = 0;
            $c_472 = 0;
            $c_474 = 0;
            $c_476 = 0;
            $c_477 = 0;
            $c_479 = 0;
            $c_480 = 0;
            $c_481 = 0;
            $c_482 = 0;
            $c_485 = 0;
            $c_486 = 0;
            $c_487 = 0;
            $c_445 = 0;
            $c_446 = 0;
            $c_452 = 0;
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
                              @php if((int)$dtt_raw[$counter]->total_324>0 || (int)$dtt_raw_disc[$counter]->total_324>0){ $c_324=$c_324+$dtt_raw_qty[$counter]->total_324; } @endphp 
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_324<=0 && (int)$dtt_raw_disc[$counter]->total_324>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_324,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_325>0)
                              @php if((int)$dtt_raw[$counter]->total_325>0 || (int)$dtt_raw_disc[$counter]->total_325>0){ $c_325=$c_325+$dtt_raw_qty[$counter]->total_325; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_325<=0 && (int)$dtt_raw_disc[$counter]->total_325>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_325,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_326>0)
                            @php if((int)$dtt_raw[$counter]->total_326>0 || (int)$dtt_raw_disc[$counter]->total_326>0){ $c_326=$c_326+$dtt_raw_qty[$counter]->total_326; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_326<=0 && (int)$dtt_raw_disc[$counter]->total_326>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_326,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_327>0)
                            @php if((int)$dtt_raw[$counter]->total_327>0 || (int)$dtt_raw_disc[$counter]->total_327>0){ $c_327=$c_327+$dtt_raw_qty[$counter]->total_327; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_327<=0 && (int)$dtt_raw_disc[$counter]->total_327>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_327,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_328>0)
                            @php if((int)$dtt_raw[$counter]->total_328>0 || (int)$dtt_raw_disc[$counter]->total_328>0){ $c_328=$c_328+$dtt_raw_qty[$counter]->total_328; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_328<=0 && (int)$dtt_raw_disc[$counter]->total_328>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_328,0,',','.'); } @endphp </td>
                          @endif


                          @if((int)$header->total_280>0)
                            @php if((int)$dtt_raw[$counter]->total_280>0 || (int)$dtt_raw_disc[$counter]->total_280>0){ $c_280=$c_280+$dtt_raw_qty[$counter]->total_280; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_280<=0 && (int)$dtt_raw_disc[$counter]->total_280>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_280,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_281>0)
                            @php if((int)$dtt_raw[$counter]->total_281>0 || (int)$dtt_raw_disc[$counter]->total_281>0){ $c_281=$c_281+$dtt_raw_qty[$counter]->total_281; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_281<=0 && (int)$dtt_raw_disc[$counter]->total_281>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_281,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_282>0)
                            @php if((int)$dtt_raw[$counter]->total_282>0 || (int)$dtt_raw_disc[$counter]->total_282>0){ $c_282=$c_282+$dtt_raw_qty[$counter]->total_282; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_282<=0 && (int)$dtt_raw_disc[$counter]->total_282>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_282,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_283>0)
                            @php if((int)$dtt_raw[$counter]->total_283>0 || (int)$dtt_raw_disc[$counter]->total_283>0){ $c_283=$c_283+$dtt_raw_qty[$counter]->total_283; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_283<=0 && (int)$dtt_raw_disc[$counter]->total_283>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_283,0,',','.'); } @endphp </td>
                          @endif                  
                          @if((int)$header->total_284>0)
                              @php if((int)$dtt_raw[$counter]->total_284>0 || (int)$dtt_raw_disc[$counter]->total_284>0){ $c_284++; } @endphp 
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_284<=0 && (int)$dtt_raw_disc[$counter]->total_284>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_284,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_285>0)
                            @php if((int)$dtt_raw[$counter]->total_285>0 || (int)$dtt_raw_disc[$counter]->total_285>0){ $c_285=$c_285+$dtt_raw_qty[$counter]->total_285; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_285<=0 && (int)$dtt_raw_disc[$counter]->total_285>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_285,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_286>0)
                            @php if((int)$dtt_raw[$counter]->total_286>0 || (int)$dtt_raw_disc[$counter]->total_286>0){ $c_286=$c_286+$dtt_raw_qty[$counter]->total_286; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_286<=0 && (int)$dtt_raw_disc[$counter]->total_286>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_286,0,',','.'); } @endphp </td>
                          @endif

                          @if((int)$header->total_287>0)
                              @php if((int)$dtt_raw[$counter]->total_287>0 || (int)$dtt_raw_disc[$counter]->total_287>0){ $c_287=$c_287+$dtt_raw_qty[$counter]->total_287; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_287<=0 && (int)$dtt_raw_disc[$counter]->total_287>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_287,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_288>0)
                              @php if((int)$dtt_raw[$counter]->total_288>0 || (int)$dtt_raw_disc[$counter]->total_288>0){ $c_288=$c_288+$dtt_raw_qty[$counter]->total_288; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_288<=0 && (int)$dtt_raw_disc[$counter]->total_288>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_288,0,',','.'); } @endphp </td>
                          @endif

                          @if((int)$header->total_289>0)
                              @php if((int)$dtt_raw[$counter]->total_289>0 || (int)$dtt_raw_disc[$counter]->total_289>0){ $c_289=$c_289+$dtt_raw_qty[$counter]->total_289; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_289<=0 && (int)$dtt_raw_disc[$counter]->total_289>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_289,0,',','.'); } @endphp </td>
                          @endif

                            @if((int)$header->total_290>0)
                            @php if((int)$dtt_raw[$counter]->total_290>0 || (int)$dtt_raw_disc[$counter]->total_290>0){ $c_290++; } @endphp 
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_290<=0 && (int)$dtt_raw_disc[$counter]->total_290>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_290,0,',','.'); } @endphp </td>
                            @endif
        
                            @if((int)$header->total_291>0)
                            @php if((int)$dtt_raw[$counter]->total_291>0 || (int)$dtt_raw_disc[$counter]->total_291>0){ $c_291++; } @endphp 
                                <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_291<=0 && (int)$dtt_raw_disc[$counter]->total_291>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_291,0,',','.'); } @endphp </td>
                            @endif

                            
                        
                            @if((int)$header->total_292>0)
                              @php if((int)$dtt_raw[$counter]->total_292>0 || (int)$dtt_raw_disc[$counter]->total_292>0){ $c_292=$c_292+$dtt_raw_qty[$counter]->total_292; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_292<=0 && (int)$dtt_raw_disc[$counter]->total_292>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_292,0,',','.'); } @endphp </td>
                            @endif
                        
                            @if((int)$header->total_293>0)
                              @php if((int)$dtt_raw[$counter]->total_293>0 || (int)$dtt_raw_disc[$counter]->total_293>0){ $c_293=$c_293+$dtt_raw_qty[$counter]->total_293; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_293<=0 && (int)$dtt_raw_disc[$counter]->total_293>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_293,0,',','.'); } @endphp </td>
                            @endif
                        
                          @if((int)$header->total_294>0)
                              @php if((int)$dtt_raw[$counter]->total_294>0 || (int)$dtt_raw_disc[$counter]->total_294>0){ $c_294=$c_294+$dtt_raw_qty[$counter]->total_294; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_294<=0 && (int)$dtt_raw_disc[$counter]->total_294>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_294,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_295>0)
                              @php if((int)$dtt_raw[$counter]->total_295>0 || (int)$dtt_raw_disc[$counter]->total_295>0){ $c_295++; } @endphp 
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_295<=0 && (int)$dtt_raw_disc[$counter]->total_295>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_295,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_296>0)
                              @php if((int)$dtt_raw[$counter]->total_296>0 || (int)$dtt_raw_disc[$counter]->total_296>0){ $c_296=$c_296+$dtt_raw_qty[$counter]->total_296; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_296<=0 && (int)$dtt_raw_disc[$counter]->total_296>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_296,0,',','.'); } @endphp </td>
                          @endif
                    
                          @if((int)$header->total_297>0)
                              @php if((int)$dtt_raw[$counter]->total_297>0 || (int)$dtt_raw_disc[$counter]->total_297>0){ $c_297=$c_297+$dtt_raw_qty[$counter]->total_297; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_297<=0 && (int)$dtt_raw_disc[$counter]->total_297>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_297,0,',','.'); } @endphp </td>
                          @endif
                          @if((int)$header->total_298>0)
                              @php if((int)$dtt_raw[$counter]->total_298>0 || (int)$dtt_raw_disc[$counter]->total_298>0){ $c_298=$c_298+$dtt_raw_qty[$counter]->total_298; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_298<=0 && (int)$dtt_raw_disc[$counter]->total_298>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_298,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_299>0)
                              @php if((int)$dtt_raw[$counter]->total_299>0 || (int)$dtt_raw_disc[$counter]->total_299>0){ $c_299=$c_299+$dtt_raw_qty[$counter]->total_299; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_299<=0 && (int)$dtt_raw_disc[$counter]->total_299>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_299,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_300>0)
                              @php if((int)$dtt_raw[$counter]->total_300>0 || (int)$dtt_raw_disc[$counter]->total_300>0){ $c_300=$c_300+$dtt_raw_qty[$counter]->total_300; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_300<=0 && (int)$dtt_raw_disc[$counter]->total_300>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_300,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_301>0)
                              @php if((int)$dtt_raw[$counter]->total_301>0 || (int)$dtt_raw_disc[$counter]->total_301>0){ $c_301=$c_301+$dtt_raw_qty[$counter]->total_301; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_301<=0 && (int)$dtt_raw_disc[$counter]->total_301>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_301,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_302>0)
                             @php if((int)$dtt_raw[$counter]->total_302>0 || (int)$dtt_raw_disc[$counter]->total_302>0){ $c_302=$c_302+$dtt_raw_qty[$counter]->total_302; } @endphp
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_302<=0 && (int)$dtt_raw_disc[$counter]->total_302>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_302,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_304>0)
                            @php if((int)$dtt_raw[$counter]->total_304>0 || (int)$dtt_raw_disc[$counter]->total_304>0){ $c_304=$c_304+$dtt_raw_qty[$counter]->total_304; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_304<=0 && (int)$dtt_raw_disc[$counter]->total_304>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_304,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_305>0)
                            @php if((int)$dtt_raw[$counter]->total_305>0 || (int)$dtt_raw_disc[$counter]->total_305>0){ $c_305=$c_305+$dtt_raw_qty[$counter]->total_305; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_305<=0 && (int)$dtt_raw_disc[$counter]->total_305>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_305,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_306>0)
                            @php if((int)$dtt_raw[$counter]->total_306>0 || (int)$dtt_raw_disc[$counter]->total_306>0){ $c_306=$c_306+$dtt_raw_qty[$counter]->total_306; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_306<=0 && (int)$dtt_raw_disc[$counter]->total_306>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_306,0,',','.'); } @endphp </td>
                          @endif
                      
                          @if((int)$header->total_307>0)
                          @php if((int)$dtt_raw[$counter]->total_307>0 || (int)$dtt_raw_disc[$counter]->total_307>0){ $c_307++; } @endphp 
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_307<=0 && (int)$dtt_raw_disc[$counter]->total_307>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_307,0,',','.'); } @endphp </td>
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
                         


                          @if((int)$header->total_468>0)
                            @php if((int)$dtt_raw[$counter]->total_468>0){ $c_468++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_468,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_469>0)
                            @php if((int)$dtt_raw[$counter]->total_469>0){ $c_469++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_469,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_470>0)
                            @php if((int)$dtt_raw[$counter]->total_470>0){ $c_470++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_470,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_472>0)
                            @php if((int)$dtt_raw[$counter]->total_472>0){ $c_472++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_472,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_474>0)
                            @php if((int)$dtt_raw[$counter]->total_474>0){ $c_474++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_474,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_476>0)
                            @php if((int)$dtt_raw[$counter]->total_476>0){ $c_476++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_476,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_477>0)
                            @php if((int)$dtt_raw[$counter]->total_477>0){ $c_477++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_477,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_479>0)
                            @php if((int)$dtt_raw[$counter]->total_479>0){ $c_479++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_479,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_480>0)
                            @php if((int)$dtt_raw[$counter]->total_480>0){ $c_480++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_480,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_481>0)
                          @php if((int)$dtt_raw[$counter]->total_481>0 || (int)$dtt_raw_disc[$counter]->total_481>0){ $c_481++; } @endphp 
                              <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_481<=0 && (int)$dtt_raw_disc[$counter]->total_481>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_481,0,',','.'); } @endphp </td>
                          @endif


                          @if((int)$header->total_482>0)
                            @php if((int)$dtt_raw[$counter]->total_482>0){ $c_482++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_482,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_485>0)
                            @php if((int)$dtt_raw[$counter]->total_485>0){ $c_485++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_485,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_486>0)
                            @php if((int)$dtt_raw[$counter]->total_486>0){ $c_486++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_486,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_487>0)
                            @php if((int)$dtt_raw[$counter]->total_487>0){ $c_487++; } @endphp
                              <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_487,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_449>0)
                          @php if((int)$dtt_raw[$counter]->total_449>0){ $c_449++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_449,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_453>0)
                          @php if((int)$dtt_raw[$counter]->total_453>0){ $c_453++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_453,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_455>0)
                          @php if((int)$dtt_raw[$counter]->total_455>0){ $c_455++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_455,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_341>0)
                          @php if((int)$dtt_raw[$counter]->total_341>0){ $c_341++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_341,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_445>0)
                          @php if((int)$dtt_raw[$counter]->total_445>0){ $c_445++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_445,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_446>0)
                          @php if((int)$dtt_raw[$counter]->total_446>0){ $c_446++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_446,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_452>0)
                          @php if((int)$dtt_raw[$counter]->total_452>0){ $c_452++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_452,0,',','.') }}</td>
                          @endif

                          @if((int)$header->total_444>0)
                          @php if((int)$dtt_raw[$counter]->total_444>0){ $c_444++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_444,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_340>0)
                          @php if((int)$dtt_raw[$counter]->total_340>0){ $c_340++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_340,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_342>0)
                          @php if((int)$dtt_raw[$counter]->total_342>0){ $c_342++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_342,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_448>0)
                          @php if((int)$dtt_raw[$counter]->total_448>0){ $c_448++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_448,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_510>0)
                            @php if((int)$dtt_raw[$counter]->total_510>0 || (int)$dtt_raw_disc[$counter]->total_510>0){ $c_510=$c_510+$dtt_raw_qty[$counter]->total_510; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_510<=0 && (int)$dtt_raw_disc[$counter]->total_510>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_510,0,',','.'); } @endphp </td>
                          @endif
                          
                          @if((int)$header->total_496>0)
                          @php if((int)$dtt_raw[$counter]->total_496>0){ $c_496++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_496,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_518>0)
                          @php if((int)$dtt_raw[$counter]->total_518>0){ $c_518++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_518,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_544>0)
                          @php if((int)$dtt_raw[$counter]->total_544>0){ $c_544++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_544,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_546>0)
                          @php if((int)$dtt_raw[$counter]->total_546>0){ $c_546++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_546,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_567>0)
                          @php if((int)$dtt_raw[$counter]->total_567>0){ $c_567++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_567,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_537>0)
                          @php if((int)$dtt_raw[$counter]->total_537>0){ $c_537++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_537,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_538>0)
                          @php if((int)$dtt_raw[$counter]->total_538>0){ $c_538++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_538,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_oth_sln>0)
                            @php if((int)$dtt_raw[$counter]->total_oth_sln>0 || (int)$dtt_raw_disc[$counter]->total_oth_sln>0){ $c_oth_sln=$c_oth_sln+$dtt_raw_qty[$counter]->total_oth_sln; } @endphp
                            <td scope="col" width="3%"> @php if((int)$dtt_raw[$counter]->total_oth_sln<=0 && (int)$dtt_raw_disc[$counter]->total_oth_sln>0){ echo 'Free'; }else{ echo number_format($dtt_raw[$counter]->total_oth_sln,0,',','.'); } @endphp </td>
                          @endif
                         



                          @if((int)$header->total_498>0)
                          @php if((int)$dtt_raw[$counter]->total_498>0){ $c_498++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_498,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_316>0)
                          @php if((int)$dtt_raw[$counter]->total_316>0){ $c_316=$c_316+$dtt_raw_qty[$counter]->total_316; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_316,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_309>0)
                          @php if((int)$dtt_raw[$counter]->total_309>0){ $c_309=$c_309+$dtt_raw_qty[$counter]->total_309; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_309,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_318>0)
                          @php if((int)$dtt_raw[$counter]->total_318>0){ $c_318=$c_318+$dtt_raw_qty[$counter]->total_318; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_318,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_319>0)
                          @php if((int)$dtt_raw[$counter]->total_319>0){ $c_319=$c_319+$dtt_raw_qty[$counter]->total_319; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_319,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_467>0)
                          @php if((int)$dtt_raw[$counter]->total_467>0){ $c_467++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_467,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_488>0)
                          @php if((int)$dtt_raw[$counter]->total_488>0){ $c_488++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_488,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_494>0)
                          @php if((int)$dtt_raw[$counter]->total_494>0){ $c_494++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_494,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_329>0)
                          @php if((int)$dtt_raw[$counter]->total_329>0){ $c_329++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_329,0,',','.') }}</td>
                          @endif
                          @if((int)$header->total_635>0)
                          @php if((int)$dtt_raw[$counter]->total_635>0){ $c_635++; } @endphp
                            <td scope="col" width="3%">{{ number_format($dtt_raw[$counter]->total_635,0,',','.') }}</td>
                          @endif
                      @endforeach
                    <td>
                      @php
                        $payment = $detail->payment_type;
                        if($payment == 'BCA - Debit'){
                          $payment = 'BCAD';
                        }else if($payment == 'BCA - Kredit'){
                          $payment = 'BCAK';
                        }else if($payment == 'Mandiri - Kredit'){
                          $payment = 'MDRK';
                        }else if($payment == 'Mandiri - Debit'){
                          $payment = 'MDRD';
                        }else if($payment == 'Transfer'){
                          $payment = 'TRF';
                        }
                        $total_payment = $total_payment + $detail->payment_nominal;
                      @endphp
                      {{ $payment }} <br> {{ number_format($detail->payment_nominal,1,',','.') }}
                    </td>
                    <td style="text-align: left;">

                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id && $diox->category_id<>"26"  && $diox->invoice_no== $detail->invoice_no)
                                {{ $diox->product_name }}  / {{ $diox->qty }} <br>
                                @php $c_p=$c_p+$diox->qty; @endphp
                          @endif
                      @endforeach
                    </td>

                    <td style="text-align: left;">
                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id  && $diox->category_id<>"26"   && $diox->invoice_no== $detail->invoice_no )
                                {{ number_format($diox->total,0,',','.') }}<br>
                                @php 
                                $t_p=$t_p+$diox->total; 
                                @endphp
                          @endif
                      @endforeach
                    </td>
                    <td style="text-align: left;">
                      @foreach($dtt_item_only as $diox)
                          @if($diox->type_id==1 && $diox->customers_id == $detail->id && ($diox->category_id=="26")   && $diox->invoice_no== $detail->invoice_no )
                                {{ $diox->product_name }} / {{ $diox->qty }}  / {{ number_format($diox->total,1,',','.') }}<br>
                                @php $c_pn=$c_pn+$diox->qty;$t_drink=$t_drink+$diox->total; @endphp<br>
                          @endif
                      @endforeach
                    </td>
                    <td style="text-align: left;">
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
                    $count_column_extra = 0;
                    $qty_service = 0;
                  @endphp
                  <th colspan="5">JUMLAH</th>
                  @foreach($dtt_raw_oneline as $header)
                    @if((int)$header->total_324>0)
                      @php
                        $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_324;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_324;
                      @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_324,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_324 }} </th>
                    @endif
                    @if((int)$header->total_325>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_325;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_325;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_325,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_325 }} </th>
                    @endif
                    @if((int)$header->total_326>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_326;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_326;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_326,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_326 }} </th>
                    @endif
                    @if((int)$header->total_327>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_327;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_327;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_327,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_327 }} </th>
                    @endif
                    @if((int)$header->total_328>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_328;
                        $qty_service = $qty_service + $dtt_raw_oneline_qty[0]->total_328;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_328,0,',','.') }} / {{ $dtt_raw_oneline_qty[0]->total_328 }} </th>
                    @endif


                    @if((int)$header->total_280>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_280;
                        $qty_service = $qty_service + $c_280;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_280,0,',','.') }} / {{ $c_280 }} </th>
                    @endif
                    @if((int)$header->total_281>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_281;
                        $qty_service = $qty_service + $c_281;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_281,0,',','.') }} / {{ $c_281 }}  </th>
                    @endif
                    @if((int)$header->total_282>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_282;
                        $qty_service = $qty_service + $c_282;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_282,0,',','.') }}  / {{ $c_282 }} </th>
                    @endif
                    @if((int)$header->total_283>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_283;
                        $qty_service = $qty_service + $c_283;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_283,0,',','.') }}  / {{ $c_283 }} </th>
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
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_285;
                        $qty_service = $qty_service + $c_285;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_285,0,',','.') }}  / {{ $c_285 }} </th>
                    @endif
                    @if((int)$header->total_286>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_286;
                        $qty_service = $qty_service + $c_286;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_286,0,',','.') }}  / {{ $c_286 }} </th>
                    @endif
                    @if((int)$header->total_287>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_287;
                        $qty_service = $qty_service + $c_287;
                    @endphp
                        <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_287,0,',','.') }}  / {{ $c_287 }} </th>
                    @endif
                    @if((int)$header->total_288>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_288;
                        $qty_service = $qty_service + $c_288;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_288,0,',','.') }}  / {{ $c_288 }} </th>
                    @endif
                    @if((int)$header->total_289>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_289;
                        $qty_service = $qty_service + $c_289;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_289,0,',','.') }}  / {{ $c_289 }} </th>
                    @endif
                      @if((int)$header->total_290>0)
                      @php
                        $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_290;
                        $qty_service = $qty_service + $c_290;
                      @endphp
                        <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_290,0,',','.') }}  / {{ $c_290 }} </th>
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
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_292;
                        $qty_service = $qty_service + $c_292;
                      @endphp
                        <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_292,0,',','.') }}  / {{ $c_292 }} </th>
                      @endif
                  
                      @if((int)$header->total_293>0)
                      @php
                        $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_293;
                        $qty_service = $qty_service + $c_293;
                      @endphp
                        <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_293,0,',','.') }}  / {{ $c_293 }} </th>
                      @endif
                  
                    @if((int)$header->total_294>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_294;
                        $qty_service = $qty_service + $c_294;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_294,0,',','.') }}  / {{ $c_294 }} </th>
                    @endif
                
                    @if((int)$header->total_295>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_295;
                        $qty_service = $qty_service + $c_295;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_295,0,',','.') }}  / {{ $c_295 }} </th>
                    @endif
                
                    @if((int)$header->total_296>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_296;
                        $qty_service = $qty_service + $c_296;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_296,0,',','.') }}  / {{ $c_296 }} </th>
                    @endif
              
                    @if((int)$header->total_297>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_297;
                        $qty_service = $qty_service + $c_297;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_297,0,',','.') }}  / {{ $c_297 }} </th>
                    @endif
                    @if((int)$header->total_298>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_298;
                        $qty_service = $qty_service + $c_298;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_298,0,',','.') }}  / {{ $c_298 }} </th>
                    @endif
                
                    @if((int)$header->total_299>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_299;
                        $qty_service = $qty_service + $c_299;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_299,0,',','.') }}  / {{ $c_299 }} </th>
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
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_302;
                        $qty_service = $qty_service + $c_302;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_302,0,',','.') }}  / {{ $c_302 }} </th>
                    @endif
                
                    @if((int)$header->total_304>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_304;
                        $qty_service = $qty_service + $c_304;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_304,0,',','.') }}  / {{ $c_304 }} </th>
                    @endif
                
                    @if((int)$header->total_305>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_305;
                        $qty_service = $qty_service + $c_305;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_305,0,',','.') }}  / {{ $c_305 }} </th>
                    @endif
                
                    @if((int)$header->total_306>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_306;
                        $qty_service = $qty_service + $c_306;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_306,0,',','.') }}  / {{ $c_306 }} </th>
                    @endif
                
                    @if((int)$header->total_307>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_307;
                        $qty_service = $qty_service + $c_307;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_307,0,',','.') }}  / {{ $c_307 }} </th>
                    @endif
                    @if((int)$header->total_308>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_308;
                        $qty_service = $qty_service + $c_308;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_308,0,',','.') }}  / {{ $c_308 }} </th>
                      @endif
                    @if((int)$header->total_310>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_310;
                        $qty_service = $qty_service + $c_310;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_310,0,',','.') }}  / {{ $c_310 }} </th>
                    @endif
                
                    @if((int)$header->total_312>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_312;
                        $qty_service = $qty_service + $c_312;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_312,0,',','.') }}  / {{ $c_312 }} </th>
                    @endif
                  
                    @if((int)$header->total_313>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_313;
                        $qty_service = $qty_service + $c_313;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_313,0,',','.') }}  / {{ $c_313 }} </th>
                      @endif
                    @if((int)$header->total_315>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_315;
                        $qty_service = $qty_service + $c_315;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_315,0,',','.') }}  / {{ $c_315 }} </th>
                    @endif
                  
                    @if((int)$header->total_317>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_317;
                        $qty_service = $qty_service + $c_317;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_317,0,',','.') }}  / {{ $c_317 }} </th>
                    @endif

                    @if((int)$header->total_321>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_321;
                        $qty_service = $qty_service + $c_321;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_321,0,',','.') }}  / {{ $c_321 }} </th>
                    @endif

                    
                    
                    
                    @if((int)$header->total_468>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_468;
                        $qty_service = $qty_service + $c_468;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_468,0,',','.') }}  / {{ $c_468 }} </th>
                    @endif

                    @if((int)$header->total_469>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_469;
                        $qty_service = $qty_service + $c_469;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_469,0,',','.') }}  / {{ $c_469 }} </th>
                    @endif
                    
                    @if((int)$header->total_470>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_470;
                        $qty_service = $qty_service + $c_470;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_470,0,',','.') }}  / {{ $c_470 }} </th>
                    @endif
                    
                    @if((int)$header->total_472>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_472;
                        $qty_service = $qty_service + $c_472;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_472,0,',','.') }}  / {{ $c_472 }} </th>
                    @endif
                    
                    @if((int)$header->total_474>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_474;
                        $qty_service = $qty_service + $c_474;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_474,0,',','.') }}  / {{ $c_474 }} </th>
                    @endif
                    
                    @if((int)$header->total_476>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_476;
                        $qty_service = $qty_service + $c_476;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_476,0,',','.') }}  / {{ $c_476 }} </th>
                    @endif
                    
                    @if((int)$header->total_477>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_477;
                        $qty_service = $qty_service + $c_477;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_477,0,',','.') }}  / {{ $c_477 }} </th>
                    @endif
                    
                    @if((int)$header->total_479>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_479;
                        $qty_service = $qty_service + $c_479;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_479,0,',','.') }}  / {{ $c_479 }} </th>
                    @endif
                    
                    @if((int)$header->total_480>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_480;
                        $qty_service = $qty_service + $c_480;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_480,0,',','.') }}  / {{ $c_480 }} </th>
                    @endif
                    
                    @if((int)$header->total_481>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_481;
                        $qty_service = $qty_service + $c_481;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_481,0,',','.') }}  / {{ $c_481 }} </th>
                    @endif
                    
                    @if((int)$header->total_482>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_482;
                        $qty_service = $qty_service + $c_482;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_482,0,',','.') }}  / {{ $c_482 }} </th>
                    @endif
                    
                    @if((int)$header->total_485>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_485;
                        $qty_service = $qty_service + $c_485;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_485,0,',','.') }}  / {{ $c_485 }} </th>
                    @endif
                    
                    @if((int)$header->total_486>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_486;
                        $qty_service = $qty_service + $c_486;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_486,0,',','.') }}  / {{ $c_486 }} </th>
                    @endif
                    
                    @if((int)$header->total_487>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_487;
                        $qty_service = $qty_service + $c_487;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_487,0,',','.') }}  / {{ $c_487 }} </th>
                    @endif

                    @if((int)$header->total_449>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_449;
                        $qty_service = $qty_service + $c_449;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_449,0,',','.') }}  / {{ $c_449 }} </th>
                    @endif

                    @if((int)$header->total_453>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_453;
                        $qty_service = $qty_service + $c_453;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_453,0,',','.') }}  / {{ $c_453 }} </th>
                    @endif

                    @if((int)$header->total_455>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_455;
                        $qty_service = $qty_service + $c_455;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_455,0,',','.') }}  / {{ $c_455 }} </th>
                    @endif

                    @if((int)$header->total_341>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_341;
                        $qty_service = $qty_service + $c_341;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_341,0,',','.') }}  / {{ $c_341 }} </th>
                    @endif



                    @if((int)$header->total_445>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_445;
                        $qty_service = $qty_service + $c_445;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_445,0,',','.') }}  / {{ $c_445 }} </th>
                    @endif
                    @if((int)$header->total_446>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_446;
                        $qty_service = $qty_service + $c_446;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_446,0,',','.') }}  / {{ $c_446 }} </th>
                    @endif
                    @if((int)$header->total_452>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_452;
                        $qty_service = $qty_service + $c_452;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_452,0,',','.') }}  / {{ $c_452 }} </th>
                    @endif
                    @if((int)$header->total_444>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_444;
                        $qty_service = $qty_service + $c_444;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_444,0,',','.') }}  / {{ $c_444 }} </th>
                    @endif
                    @if((int)$header->total_340>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_340;
                        $qty_service = $qty_service + $c_340;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_340,0,',','.') }}  / {{ $c_340 }} </th>
                    @endif
                    @if((int)$header->total_342>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_342;
                        $qty_service = $qty_service + $c_342;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_342,0,',','.') }}  / {{ $c_342 }} </th>
                    @endif
                   
                    @if((int)$header->total_448>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_448;
                        $qty_service = $qty_service + $c_448;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_448,0,',','.') }}  / {{ $c_448 }} </th>
                    @endif
                    @if((int)$header->total_510>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_510;
                        $qty_service = $qty_service + $c_510;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_510,0,',','.') }}  / {{ $c_510 }} </th>
                    @endif



                    @if((int)$header->total_496>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_496;
                        $qty_service = $qty_service + $c_496;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_496,0,',','.') }}  / {{ $c_496 }} </th>
                    @endif
                    @if((int)$header->total_518>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_518;
                        $qty_service = $qty_service + $c_518;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_518,0,',','.') }}  / {{ $c_518 }} </th>
                    @endif
                    @if((int)$header->total_544>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_544;
                        $qty_service = $qty_service + $c_544;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_544,0,',','.') }}  / {{ $c_544 }} </th>
                    @endif
                    @if((int)$header->total_546>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_546;
                        $qty_service = $qty_service + $c_546;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_546,0,',','.') }}  / {{ $c_546 }} </th>
                    @endif
                    @if((int)$header->total_567>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_567;
                        $qty_service = $qty_service + $c_567;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_567,0,',','.') }}  / {{ $c_567 }} </th>
                    @endif
                    @if((int)$header->total_537>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_537;
                        $qty_service = $qty_service + $c_537;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_537,0,',','.') }}  / {{ $c_537 }} </th>
                    @endif
                    @if((int)$header->total_538>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_538;
                        $qty_service = $qty_service + $c_538;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_538,0,',','.') }}  / {{ $c_538 }} </th>
                    @endif
                    @if((int)$header->total_oth_sln>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_oth_sln;
                        $qty_service = $qty_service + $c_oth_sln;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_oth_sln,0,',','.') }}  / {{ $c_oth_sln }} </th>
                    @endif


                    @if((int)$header->total_498>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_498;
                        $qty_service = $qty_service + $c_498;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_498,0,',','.') }}  / {{ $c_498 }} </th>
                    @endif
                    @if((int)$header->total_316>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_316;
                        $qty_service = $qty_service + $c_316;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_316,0,',','.') }}  / {{ $c_316 }} </th>
                    @endif
                    @if((int)$header->total_309>0)
                    @php
                      $count_column_service++;
                        $total_service = $total_service + $dtt_raw_oneline_discs[0]->total_309;
                        $qty_service = $qty_service + $c_309;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_309,0,',','.') }}  / {{ $c_309 }} </th>
                    @endif
                    @if((int)$header->total_318>0)
                    @php
                        $count_column_extra++;
                        $total_extra = $total_extra + $dtt_raw_oneline_discs[0]->total_318;
                        $qty_extra = $qty_extra + $c_318;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_318,0,',','.') }}  / {{ $c_318 }} </th>
                    @endif
                    @if((int)$header->total_319>0)
                    @php
                        $count_column_extra++;
                        $total_extra = $total_extra + $dtt_raw_oneline_discs[0]->total_319;
                        $qty_extra = $qty_extra + $c_319;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_319,0,',','.') }}  / {{ $c_319 }} </th>
                    @endif
                    @if((int)$header->total_467>0)
                    @php
                        $count_column_extra++;
                        $total_extra = $total_extra + $dtt_raw_oneline_discs[0]->total_467;
                        $qty_extra = $qty_extra + $c_467;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_467,0,',','.') }}  / {{ $c_467 }} </th>
                    @endif
                    @if((int)$header->total_488>0)
                    @php
                        $count_column_extra++;
                        $total_extra = $total_extra + $dtt_raw_oneline_discs[0]->total_488;
                        $qty_extra = $qty_extra + $c_488;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_488,0,',','.') }}  / {{ $c_488 }} </th>
                    @endif
                    @if((int)$header->total_494>0)
                    @php
                        $count_column_extra++;
                        $total_extra = $total_extra + $dtt_raw_oneline_discs[0]->total_494;
                        $qty_extra = $qty_extra + $c_494;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_494,0,',','.') }}  / {{ $c_494 }} </th>
                    @endif
                    @if((int)$header->total_329>0)
                    @php
                        $count_column_extra++;
                        $total_extra = $total_extra + $dtt_raw_oneline_discs[0]->total_329;
                        $qty_extra = $qty_extra + $c_329;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_329,0,',','.') }}  / {{ $c_329 }} </th>
                    @endif
                    @if((int)$header->total_635>0)
                    @php
                        $count_column_extra++;
                        $total_extra = $total_extra + $dtt_raw_oneline_discs[0]->total_635;
                        $qty_extra = $qty_extra + $c_635;
                    @endphp
                      <th scope="col" width="3%">{{ number_format($dtt_raw_oneline_discs[0]->total_635,0,',','.') }}  / {{ $c_635 }} </th>
                    @endif
                    <th>{{ number_format($total_payment,1,',','.') }}</th>
                    <th>{{ number_format($c_p,0,',','.') }}</th>
                    <th>{{ number_format($t_p,0,',','.') }}</th>
                    <th>{{ number_format($t_drink,1,',','.') }} / {{ number_format($c_pn,0,',','.') }}</th>
                    <th style="text-align: left;">
                      @foreach($out_datas_total_drink as $out_datas_total_drink) 
                          @php
                              echo $out_datas_total_drink->abbr."/".$out_datas_total_drink->qty."/".number_format($out_datas_total_drink->total,1,',','.')."<br>";
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
                  <th colspan="5"></th>
                  <th colspan="{{ $count_column_service }}">{{ number_format($total_service,0,',','.') }} / {{ number_format($qty_service,0,',','.')  }}</th>
                  <?php
                      if($count_column_extra>0){
                        echo '<th colspan="'.$count_column_extra.'">'.number_format($total_extra,0,',','.').' / '.number_format($qty_extra,0,',','.').'</th>';
                      }
                  ?>
                  <th>{{ number_format($total_payment,1,',','.') }}</th>
                  <th colspan="2">{{ number_format($t_p,0,',','.') }} / {{ number_format($c_p,0,',','.') }}</th>
                  <th>{{ number_format($t_drink,1,',','.') }} / {{ number_format($c_pn,0,',','.') }}</th>
                  <th></th>
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