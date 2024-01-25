<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Close  Day Summary - {{ count((array)$report_data)>0?$report_data[0]->branch_name:"" }} Tgl : {{ Carbon\Carbon::parse($begindate)->format('d-m-Y') }} s/d {{ Carbon\Carbon::parse($enddate)->format('d-m-Y') }}</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
      <link href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css" rel="stylesheet"/>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          padding: 1px;
          font-size: 12px;
        }
        td, th {
            border: .01px solid black;
        }
        div{
          padding:1px;
        }
        button.btn.print::before {
          font-family: fontAwesome;
          content: "\f02f\00a0";
        }
        @page { margin:0px; }
        @media print {
          #printPageButton {
            display: none;
          }
        }
      </style>
   </head> 
   <body> 

      <button id="printPageButton" onClick="window.print();"  class="btn btn-secondary btn-sm mt-1 print mb-2">Cetak Laporan</button>
      <br>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <td style="width: 20%;">Tgl : {{ Carbon\Carbon::parse($begindate)->format('d-m-Y') }} s/d {{ Carbon\Carbon::parse($enddate)->format('d-m-Y') }}</td>
              <td style="width: 30%;">Laporan Close Day Summary</td>
              <td style="width: 20%;">Cabang  : {{ count((array)$report_data)>0?$report_data[0]->branch_name:"" }}</td>
          </tr>
        </tbody>
      </table>
      <br>

  
      {{-- Area Looping --}}
  
      <table class="table table-striped" id="example"  style="width: 100%">
        <thead>
            <tr>
                <th style="text-align: center;background-color:#FFA726;" rowspan="2" scope="col" width="8%">@lang('general.lbl_dated')</th>
                <th style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">@lang('general.service')</th>  
                <th class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">Salon</th>     
                <th class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">Total Perawatan & Salon</th>     
                <th style="text-align: center;background-color:#FFA726;" colspan="<?= $report_total[0]->total_ojek==0?'4':'5'; ?>" scope="col">@lang('general.product')</th>    
                <th class="<?= $report_total[0]->total_tambahan==0?'d-none':''; ?>"  style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">Tambahan Terapis</th> 
                <th style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">Extra</th>    
                <th style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">@lang('general.lbl_drink')</th>     
                <th class="<?= $report_total[0]->total_lebaran==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">Charge Lebaran</th>       
                <th class="<?= $report_total[0]->total_b1d==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2" scope="col">B1 - D</th>    
                <th  class="<?= $report_total[0]->total_b1c==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">B1 - K</th>    
                <th  class="<?= $report_total[0]->total_b2d==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">B2 - D</th>    
                <th  class="<?= $report_total[0]->total_b2c==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">B2 - K</th> 
                <th  class="<?= $report_total[0]->total_b1q==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">B1 - QRIS</th> 
                <th  class="<?= $report_total[0]->total_b2q==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">B2 - QRIS</th> 
                <th  class="<?= $report_total[0]->total_b1t==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">B1 - Tnsfr</th> 
                <th  class="<?= $report_total[0]->total_b2t==0?'d-none':''; ?>" style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">B2 - Tnsfr</th> 
                <th style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">Cases</th> 
                <th style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">Total Yang Disetor</th>  
                <th  style="text-align: center;background-color:#FFA726;" rowspan="2"  scope="col">Total Pendapatan</th>    
            </tr>
            <tr>
              <th style="text-align: center;background-color:#FFA726;"  scope="col">Jenis</th>    
              <th style="text-align: center;background-color:#FFA726;"  scope="col">Qty</th>    
              <th style="text-align: center;background-color:#FFA726;"  scope="col">Harga</th>    
              <th style="text-align: center;background-color:#FFA726;"  scope="col">Total</th>   
              <th class="<?= $report_total[0]->total_ojek==0?'d-none':''; ?>"  style="text-align: center;background-color:#FFA726;"  scope="col">Ojek</th> 
          </tr>
        </thead>
          <?php 
              $total_service = 0;
              $total_salon = 0;
              $total_ojek = 0;
              $total_tambahan = 0;
              $total_product = 0;
              $total_drink = 0;
              $total_extra = 0;
              $total_lebaran = 0;
              $total_cash = 0;
              $total_b1d = 0;
              $total_b1c = 0;
              $total_b2d = 0;
              $total_b2c = 0;
              $total_b1q = 0;
              $total_b2q = 0;
              $total_b1t = 0;
              $total_b2t = 0;
              $qty_service = 0;
              $total_all = 0;
          ?>
        <tbody>
            @foreach($report_data as $rdata)
              @php $counter_it=0; @endphp
                        @foreach($report_detail as $rdet)
                          @if($rdet->branch_id==$rdata->branch_id && $rdet->dated==$rdata->dated )
                              @php  $counter_it++; @endphp
                          @endif
                        @endforeach
                @if($counter_it<=0)
                  <tr>
                    <td>{{ Carbon\Carbon::parse($rdata->dated)->format('d-m-Y')  }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_service,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_salon,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_salon+$rdata->total_service,0,',','.') }}</td>
                    <td style="text-align: right;"></td>
                    <td style="text-align: right;"></td>
                    <td style="text-align: right;"></td>
                    <td style="text-align: right;"></td>
                    <td class="<?= $report_total[0]->total_ojek==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_ojek,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_tambahan==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_tambahan,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_extra,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_drink,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_lebaran==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_lebaran,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_b1d==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b1d,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_b1c==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b1c,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_b2d==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b2d,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_b2c==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b2c,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_b1q==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b1q,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_b2q==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b2q,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_b1t==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b1t,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_b2t==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b2t,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->qty_service,0,',','.') }}</td>
                    <td style="text-align: right;"><strong>{{ number_format($rdata->total_cash,0,',','.') }}</strong></td>
                    <td style="text-align: right;"><strong>{{ number_format($rdata->total_all,0,',','.') }}</strong></td>                      
                  </tr>
                
                @else

                        @php $counter_itg = 0; @endphp
                        @foreach($report_detail as $rdet)
                          @if($rdet->branch_id==$rdata->branch_id && $rdet->dated==$rdata->dated )
                              @if($counter_itg==0)
                                <tr>
                                  <td>{{ Carbon\Carbon::parse($rdata->dated)->format('d-m-Y')  }}</td>
                                  <td style="text-align: right;">{{ number_format($rdata->total_service,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_salon,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_salon+$rdata->total_service,0,',','.') }}</td>

                                  <td style="text-align: left;">
                                    {{ $rdet->abbr."" }}
                                  </td>
                                  <td style="text-align: right;">
                                    {{ number_format($rdet->qty,0,',','.')."" }}
                                  </td>
                                  <td style="text-align: right;">
                                    {{ number_format($rdet->price,0,',','.')."" }}
                                  </td>
                                  <td style="text-align: right;">
                                    {{ number_format($rdet->total,0,',','.')."" }}
                                  </td>
                                  <td  class="<?= $report_total[0]->total_ojek==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_ojek,0,',','.') }}</td>
                                  <td  class="<?= $report_total[0]->total_tambahan==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_tambahan,0,',','.') }}</td>
                                  <td style="text-align: right;">{{ number_format($rdata->total_extra,0,',','.') }}</td>
                                  <td style="text-align: right;">{{ number_format($rdata->total_drink,0,',','.') }}</td>
                                  <td  class="<?= $report_total[0]->total_lebaran==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_lebaran,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_b1d==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b1d,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_b1c==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b1c,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_b2d==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b2d,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_b2c==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b2c,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_b1q==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b1q,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_b2q==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b2q,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_b1t==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b1t,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_b2t==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($rdata->total_b2t,0,',','.') }}</td>
                                  <td style="text-align: right;">{{ number_format($rdata->qty_service,0,',','.') }}</td>
                                  <td style="text-align: right;"></td>  
                                  <td style="text-align: right;" rowspan=""></td>                   
                                </tr>
                              @else
                                <tr>
                                  <td></td>
                                  <td style="text-align: right;"></td>
                                  
                                  <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;"></td>
                                  <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;"></td>
                                  
            
                                  <td style="text-align: left;">
                                    {{ $rdet->abbr."" }}
                                  </td>
                                  <td style="text-align: right;">
                                    {{ number_format($rdet->qty,0,',','.')."" }}
                                  </td>
                                  <td style="text-align: right;">
                                    {{ number_format($rdet->price,0,',','.')."" }}
                                  </td>
                                  <td style="text-align: right;">
                                    {{ number_format($rdet->total,0,',','.')."" }}
                                  </td>
                                  <td  class="<?= $report_total[0]->total_ojek==0?'d-none':''; ?>" style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_tambahan==0?'d-none':''; ?>" style="text-align: right;"></td>
                                  <td style="text-align: right;"></td>
                                  <td style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_lebaran==0?'d-none':''; ?>" style="text-align: right;"></td>
                                  <td class="<?= $report_total[0]->total_b1d==0?'d-none':''; ?>" style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_b1c==0?'d-none':''; ?>" style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_b2d==0?'d-none':''; ?>"style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_b2c==0?'d-none':''; ?>"style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_b1q==0?'d-none':''; ?>"style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_b2q==0?'d-none':''; ?>"style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_b1t==0?'d-none':''; ?>"style="text-align: right;"></td>
                                  <td  class="<?= $report_total[0]->total_b2t==0?'d-none':''; ?>"style="text-align: right;"></td>
                                  <td style="text-align: right;"></td>
                                  <td style="text-align: right;"></td>
                                  <td style="text-align: right;"></td>
                                  
                                                       
                                </tr>
                              @endif
                              @php  $counter_itg++; @endphp
                          @endif
                        @endforeach  

                        <?php
                          $colspan_c = 14;
                          if($report_total[0]->total_lebaran==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_ojek==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_tambahan==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_b1d==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_b2d==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_b1c==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_b2c==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_b1t==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_b2t==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_b1q==0){
                            $colspan_c--;
                          }
                          if($report_total[0]->total_b2q==0){
                            $colspan_c--;
                          }
                        ?>

                        <tr>
                          <td></td>
                          <td style="text-align: right;"></td>
                          
                          <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;"></td>
                          <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;"></td>
                          
    
                          <td style="text-align: left;">
                            
                          </td>
                          <td style="text-align: right;">
                            
                          </td>
                          <td style="text-align: right;">
                            
                          </td>
                          <td style="text-align: right;">
                            <strong>{{ number_format($rdata->total_product,0,',','.') }}</strong>
                          </td>
                          <td  class="<?= $report_total[0]->total_ojek==0?'d-none':''; ?>" style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_tambahan==0?'d-none':''; ?>" style="text-align: right;"></td>
                          <td style="text-align: right;"></td>
                          <td style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_lebaran==0?'d-none':''; ?>" style="text-align: right;"></td>
                          <td class="<?= $report_total[0]->total_b1d==0?'d-none':''; ?>" style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_b1c==0?'d-none':''; ?>" style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_b2d==0?'d-none':''; ?>"style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_b2c==0?'d-none':''; ?>"style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_b1q==0?'d-none':''; ?>"style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_b2q==0?'d-none':''; ?>"style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_b1t==0?'d-none':''; ?>"style="text-align: right;"></td>
                          <td  class="<?= $report_total[0]->total_b2t==0?'d-none':''; ?>"style="text-align: right;"></td>
                          <td style="text-align: right;"></td>
                          <td style="text-align: right;"><strong>{{ number_format($rdata->total_cash,0,',','.') }}</strong></td>     
                          <td style="text-align: right;"><strong>{{ number_format($rdata->total_all,0,',','.') }}</strong></td>

                       
                        </tr>
      
                @endif

                
                <?php 
                    $total_service = $total_service + $rdata->total_service;
                    $total_salon = $total_salon + $rdata->total_salon;
                    $total_ojek = $total_ojek + $rdata->total_ojek;
                    $total_tambahan = $total_tambahan+ $rdata->total_tambahan;
                    $total_product = $total_product + $rdata->total_product;
                    $total_drink = $total_drink + $rdata->total_drink;
                    $total_extra = $total_extra + $rdata->total_extra;
                    $total_lebaran = $total_lebaran + $rdata->total_lebaran;
                    $total_cash = $total_cash + $rdata->total_cash;
                    $total_b1d = $total_b1d + $rdata->total_b1d;
                    $total_b1c = $total_b1c + $rdata->total_b1c;
                    $total_b2d = $total_b2d + $rdata->total_b2d;
                    $total_b2c = $total_b2c + $rdata->total_b2c;
                    $total_b1q = $total_b1q + $rdata->total_b1q;
                    $total_b2q = $total_b2q + $rdata->total_b2q;
                    $total_b1t = $total_b1t + $rdata->total_b1t;
                    $total_b2t = $total_b2t + $rdata->total_b2t;
                    $qty_service = $qty_service + $rdata->qty_service;
                    $total_all = $total_all + $rdata->total_all;
                ?>
            @endforeach

            <tr>
              <th>Grand Total</th>
              <th style="text-align: right;">{{ number_format($total_service,0,',','.') }}</th> 
              <th  class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($total_salon,0,',','.') }}</th>  
              <th  class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($total_salon+$total_service,0,',','.') }}</th>  
              <th style="text-align: right;"></th>               
              <th style="text-align: right;"></th>               
              <th style="text-align: right;"></th>               
              <th style="text-align: right;">{{ number_format($total_product,0,',','.') }}</th>   
              <th class="<?= $report_total[0]->total_ojek==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($total_ojek,0,',','.') }}</th>              
              <th class="<?= $report_total[0]->total_tambahan==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($total_tambahan,0,',','.') }}</th>              
              <th style="text-align: right;">{{ number_format($total_extra,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_drink,0,',','.') }}</th>                
              <th class="<?= $report_total[0]->total_lebaran==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($total_lebaran,0,',','.') }}</th>                
                            
              <th  class="<?= $report_total[0]->total_b1d==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($total_b1d,0,',','.') }}</th>                
              <th  class="<?= $report_total[0]->total_b1c==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($total_b1c,0,',','.') }}</th>                
              <th  class="<?= $report_total[0]->total_b2d==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($total_b2d,0,',','.') }}</th>                
              <th  class="<?= $report_total[0]->total_b2d==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($total_b2c,0,',','.') }}</th>                
              <th  class="<?= $report_total[0]->total_b1q==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($total_b1q,0,',','.') }}</th>                
              <th  class="<?= $report_total[0]->total_b2q==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($total_b2q,0,',','.') }}</th>                
              <th  class="<?= $report_total[0]->total_b1t==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($total_b1t,0,',','.') }}</th>                
              <th  class="<?= $report_total[0]->total_b2t==0?'d-none':''; ?>" style="text-align: right;">{{ number_format($total_b2t,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($qty_service,0,',','.') }}</th>
              <th style="text-align: right;">{{ number_format($total_cash,0,',','.') }}</th>                  
              <th style="text-align: right;">{{ number_format($total_all,0,',','.') }}</th>                
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
   
    <!-- use version 0.19.3 -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>  
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script> 
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>   
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap.min.js"></script>   
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>   
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/accounting.js/0.4.1/accounting.min.js" integrity="sha512-LW+1GKW2tt4kK180qby6ADJE0txk5/92P70Oh5YbtD7heFlC0qFFtacvSnHG4bNXmLnZq5hNb2V70r5DzS/U+g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <script type="text/javascript">
    //window.print();
    //const workbook = XLSX.utils.book_new();

    new DataTable('#example',{
      "ordering": false,
      "paging" : false,
      info: false,
      columnDefs: [
      { 
        targets: [1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23], 
        render: function ( data, type, row, meta ) {
          return type === 'export' ?
                    data.replaceAll('.','') :
                    data;
        }
      }
    ],
      searching: false,
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'copyHtml5',
                exportOptions: { 
                  orthogonal: 'export',
                  columns: ':visible'
                }
            },
            {
                extend: 'excelHtml5',
                exportOptions: { 
                  orthogonal: 'export',
                  columns: ':visible'
                }
            },
        ]
    });



    </script>
</html> 