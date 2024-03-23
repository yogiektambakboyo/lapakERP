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

      <div class="row">
        <div class="col-3">
          <button type="button" class="btn btn-primary" id="btn-export">Export Excel</button>
        </div>
      </div>

  
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
              $total_qty_produk = 0;
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
                    <td style="text-align: right;">{{ number_format(($rdata->total_service-$rdata->total_tambahan),0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_salon,0,',','.') }}</td>
                    <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_salon+($rdata->total_service-$rdata->total_tambahan),0,',','.') }}</td>
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

                        @php $counter_itg = 0;$qty_produk=0; @endphp
                        @foreach($report_detail as $rdet)
                          @if($rdet->branch_id==$rdata->branch_id && $rdet->dated==$rdata->dated )
                              @php $total_qty_produk = $total_qty_produk + $rdet->qty;$qty_produk = $qty_produk + $rdet->qty; @endphp
                              @if($counter_itg==0)
                                <tr>
                                  <td>{{ Carbon\Carbon::parse($rdata->dated)->format('d-m-Y')  }}</td>
                                  <td style="text-align: right;">{{ number_format(($rdata->total_service-$rdata->total_tambahan),0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_salon,0,',','.') }}</td>
                                  <td class="<?= $report_total[0]->total_salon==0?'d-none':''; ?>"  style="text-align: right;">{{ number_format($rdata->total_salon+($rdata->total_service-$rdata->total_tambahan),0,',','.') }}</td>

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
                            <strong>{{ number_format($qty_produk,0,',','.') }}</strong>
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
                    $total_service = $total_service + ($rdata->total_service-$rdata->total_tambahan);
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
              <th style="text-align: right;">{{ number_format($total_qty_produk,0,',','.') }}</th>               
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
        targets: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23], 
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
            
        ]
    });



    </script>

<script type="text/javascript">
  //window.print();
  const workbook = new ExcelJS.Workbook();
   workbook.creator = 'Kakiku System Apps';
   workbook.created = new Date();

   let report_data_detail_t = [];
   let report_data_com_from1 = [];
   let report_data_terapist = [];

   $(document).ready(function() {
     var url = "{{ route('reports.closeday.search') }}";
     const params = {
       filter_begin_date_in : "{{ $begindate }}",
       filter_end_date_in : "{{ $enddate }}",
       filter_branch_id_in: "{{ $branchx }}",
       export : 'Export Sum New API',
     };

     $('#btn-export').on('click',function(){
       const res = axios.get(url,{ params }, {
                   headers: {}
                 }).then(resp => {
                  report_data = resp.data.report_data;
                  report_detail = resp.data.report_detail;
                  report_total = resp.data.report_total;
                  
                   let data_filtered = [];

                   data_filtered = [];

                       let worksheet = workbook.addWorksheet("Data");

                       /*Column headers*/
                       


                       worksheet.mergeCells('A1', 'E1');
                       worksheet.getCell('A1').value = 'Cabang : '+report_detail[0].branch_name;
                       worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('F1', 'O1');
                       worksheet.getCell('F1').value = 'Tgl : '+resp.data.beginnewformat+' sd '+resp.data.endnewformat;
                       worksheet.getCell('F1').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('A2', 'A3');
                       worksheet.getCell('A2').value = 'Tanggal';
                       worksheet.getCell('A2').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('B2', 'B3');
                       worksheet.getCell('B2').value = 'Perawatan';
                       worksheet.getCell('B2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.getCell('C3').value = 'Jenis';
                       worksheet.getCell('C3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.getCell('D3').value = 'Qty';
                       worksheet.getCell('D3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.getCell('E3').value = 'Harga';
                       worksheet.getCell('E3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.getCell('F3').value = 'Total';
                       worksheet.getCell('F3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('C2', 'F2');
                       worksheet.getCell('C2').value = 'Produk';
                       worksheet.getCell('C2').alignment = { vertical: 'middle', horizontal: 'center' };  
                       
                       worksheet.mergeCells('G2', 'G3');
                       worksheet.getCell('G2').value = 'Extra';
                       worksheet.getCell('G2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('G3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('H2', 'H3');
                       worksheet.getCell('H2').value = 'Minuman';
                       worksheet.getCell('H2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('H3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('I2', 'I3');
                       worksheet.getCell('I2').value = 'B1 - D';
                       worksheet.getCell('I2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('I3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('J2', 'J3');
                       worksheet.getCell('J2').value = 'B1 - K';
                       worksheet.getCell('J2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('J3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('K2', 'K3');
                       worksheet.getCell('K2').value = 'B1 - QRIS';
                       worksheet.getCell('K2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('K3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('L2', 'L3');
                       worksheet.getCell('L2').value = 'B1 - TRANSFER';
                       worksheet.getCell('L2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('L3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('M2', 'M3');
                       worksheet.getCell('M2').value = 'B2 - D';
                       worksheet.getCell('M2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('M3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('N2', 'N3');
                       worksheet.getCell('N2').value = 'B2 - K';
                       worksheet.getCell('N2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('N3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('O2', 'O3');
                       worksheet.getCell('O2').value = 'B2 - QRIS';
                       worksheet.getCell('O2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('O3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('P2', 'P3');
                       worksheet.getCell('P2').value = 'B2 - TRANSFER';
                       worksheet.getCell('P2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('P3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('Q2', 'Q3');
                       worksheet.getCell('Q2').value = 'CASES';
                       worksheet.getCell('Q2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('Q3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('R2', 'R3');
                       worksheet.getCell('R2').value = 'Total Yang Disetor';
                       worksheet.getCell('R2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('R3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('S2', 'S3');
                       worksheet.getCell('S2').value = 'Total Pendapatan';
                       worksheet.getCell('S2').alignment = { vertical: 'middle', horizontal: 'center' };
                       worksheet.getCell('S3').alignment = { vertical: 'middle', horizontal: 'center' };


                       worksheet.columns = [
                         { key: 'dated', width: 12 },
                         { key: 'abbr', width: 15 },
                       ];

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
                       worksheet.getCell('P1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('Q1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('R1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('S1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                       worksheet.getCell('A2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('B2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('C2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('D2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('E2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('F2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('G2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('H2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('I2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('K2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('L2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('M2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('N2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('O2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('P2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('Q2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('R2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('S2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       
                       


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
                       worksheet.getCell('P3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('Q3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('R3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('S3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                       let counter = 4;
                       var last_dated = "";
                       let t_qty = 0;
                       let t_qty_t = 0;
                       let t_total = 0;
                       let t_total_t = 0;
                       let last_total_cash = 0;
                       let last_total_all = 0;

                       let t_total_all_t = 0;
                       let t_total_service_t = 0;

                       for (let index = 0; index < report_data.length; index++) {
                         const rowElementData = report_data[index];

                         
                         
                         
                         if(last_dated != rowElementData.dated){
                              

                              for (let idx = 0; idx < report_detail.length; idx++) {
                                const rowElementDetail = report_detail[idx];

                                var counterDetail = 1;
                                if(rowElementData.dated == rowElementDetail.dated){
                                  last_total_cash = parseFloat(rowElementData.total_cash);
                                  last_total_all = parseFloat(rowElementData.total_all);

                                  if(counterDetail == 1 ){
                                      /*worksheet.getCell('A'+counter).value = "";
                                      worksheet.getCell('B'+counter).value = "";
                                      worksheet.getCell('C'+counter).value = "";
                                      worksheet.getCell('D'+counter).value = t_qty;
                                      worksheet.getCell('E'+counter).value = "";
                                      worksheet.getCell('F'+counter).value = t_total;
                                      worksheet.getCell('G'+counter).value = "";
                                      worksheet.getCell('H'+counter).value = "";
                                      worksheet.getCell('I'+counter).value = "";
                                      worksheet.getCell('J'+counter).value = "";
                                      worksheet.getCell('K'+counter).value = "";
                                      worksheet.getCell('L'+counter).value = "";
                                      worksheet.getCell('M'+counter).value = "";
                                      worksheet.getCell('N'+counter).value = "";
                                      worksheet.getCell('O'+counter).value = "";
                                      worksheet.getCell('P'+counter).value = "";
                                      worksheet.getCell('Q'+counter).value = "";
                                      worksheet.getCell('R'+counter).value = report_data[idx-1].total_cash;
                                      worksheet.getCell('S'+counter).value = report_data[idx-1].total_all;
                                      worksheet.getRow(counter).font = { bold: true };
                                      */

                                      worksheet.getCell('A'+counter).value = rowElementDetail.datedformat;
                                      worksheet.getCell('B'+counter).value = rowElementData.total_service;
                                      worksheet.getCell('C'+counter).value = rowElementDetail.abbr;
                                      worksheet.getCell('D'+counter).value = rowElementDetail.qty;
                                      worksheet.getCell('E'+counter).value = rowElementDetail.price;
                                      worksheet.getCell('F'+counter).value = rowElementDetail.total;
                                      worksheet.getCell('G'+counter).value = rowElementData.total_extra;
                                      worksheet.getCell('H'+counter).value = rowElementData.total_drink;
                                      worksheet.getCell('I'+counter).value = rowElementData.total_b1d;
                                      worksheet.getCell('J'+counter).value = rowElementData.total_b1c;
                                      worksheet.getCell('K'+counter).value = rowElementData.total_b1q;
                                      worksheet.getCell('L'+counter).value = rowElementData.total_b1t;
                                      worksheet.getCell('M'+counter).value = rowElementData.total_b2d;
                                      worksheet.getCell('N'+counter).value = rowElementData.total_b2c;
                                      worksheet.getCell('O'+counter).value = rowElementData.total_b2q;
                                      worksheet.getCell('P'+counter).value = rowElementData.total_b2t;
                                      worksheet.getCell('Q'+counter).value = rowElementData.qty_service;
                                      worksheet.getCell('R'+counter).value = "";
                                      worksheet.getCell('S'+counter).value = "";

                                      counter++;

                                      t_qty = 0;
                                      t_total = 0;
                                  }else{
                                    worksheet.getCell('A'+counter).value = "";
                                    worksheet.getCell('B'+counter).value = "";
                                    worksheet.getCell('C'+counter).value = rowElementDetail.abbr;
                                    worksheet.getCell('D'+counter).value = rowElementDetail.qty;
                                    worksheet.getCell('E'+counter).value = rowElementDetail.price;
                                    worksheet.getCell('F'+counter).value = rowElementDetail.total;
                                    worksheet.getCell('G'+counter).value = "";
                                    worksheet.getCell('H'+counter).value = "";
                                    worksheet.getCell('I'+counter).value = "";
                                    worksheet.getCell('J'+counter).value = "";
                                    worksheet.getCell('K'+counter).value = "";
                                    worksheet.getCell('L'+counter).value = "";
                                    worksheet.getCell('M'+counter).value = "";
                                    worksheet.getCell('N'+counter).value = "";
                                    worksheet.getCell('O'+counter).value = "";
                                    worksheet.getCell('P'+counter).value = "";
                                    worksheet.getCell('Q'+counter).value = "";
                                    worksheet.getCell('R'+counter).value = "";
                                    worksheet.getCell('S'+counter).value = "";
                                  }

                                  t_total_service_t = t_total_service_t + (parseFloat(rowElementData.total_service)-parseFloat(rowElementData.total_tambahan));
                                  t_total_all_t = t_total_all_t + parseFloat(rowElementData.total_all);

                                 

                                  t_qty = t_qty + parseFloat(rowElementDetail.qty);
                                  t_total = t_total + parseFloat(rowElementDetail.total);

                                  t_qty_t = t_qty_t + parseFloat(rowElementDetail.qty);
                                  t_total_t = t_total_t + parseFloat(rowElementDetail.total);

                                  counterDetail++;
                                  

                                }// End If Dated Detail vs Data

                              } // End For Loop

                              last_dated = rowElementData.dated;
                         
                          
                          }else{
                            
                          }

                      
                           worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('I'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('J'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('K'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('L'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('M'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('N'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('O'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('P'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('Q'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('R'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('S'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           counter++;
                           worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('I'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('J'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('K'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('M'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('N'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('O'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('P'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('Q'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('R'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                           worksheet.getCell('S'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                           var borderStyles = {
                             top: { style: "thin" },
                             left: { style: "thin" },
                             bottom: { style: "thin" },
                             right: { style: "thin" }
                           };

                           


                           if((index+1) == report_detail.length ){
                                worksheet.getCell('A'+counter).value = "";
                                worksheet.getCell('B'+counter).value = "";
                                worksheet.getCell('C'+counter).value = "";
                                worksheet.getCell('D'+counter).value = t_qty;
                                worksheet.getCell('E'+counter).value = "";
                                worksheet.getCell('F'+counter).value = t_total;
                                worksheet.getCell('G'+counter).value = "";
                                worksheet.getCell('H'+counter).value = "";
                                worksheet.getCell('I'+counter).value = "";
                                worksheet.getCell('J'+counter).value = "";
                                worksheet.getCell('K'+counter).value = "";
                                worksheet.getCell('L'+counter).value = "";
                                worksheet.getCell('M'+counter).value = "";
                                worksheet.getCell('N'+counter).value = "";
                                worksheet.getCell('O'+counter).value = "";
                                worksheet.getCell('P'+counter).value = "";
                                worksheet.getCell('Q'+counter).value = "";
                                worksheet.getCell('R'+counter).value = last_total_cash;
                                worksheet.getCell('S'+counter).value = last_total_all;
                                worksheet.getRow(counter).font = { bold: true };

                                counter++;

                                worksheet.getCell('A'+counter).value = "Grand Total";
                                worksheet.getCell('B'+counter).value = t_total_service_t;
                                worksheet.getCell('C'+counter).value = "";
                                worksheet.getCell('D'+counter).value = t_qty_t;
                                worksheet.getCell('E'+counter).value = "";
                                worksheet.getCell('F'+counter).value = t_total_t;
                                worksheet.getCell('G'+counter).value = report_total[0].total_extra;
                                worksheet.getCell('H'+counter).value = report_total[0].total_drink;
                                worksheet.getCell('I'+counter).value = report_total[0].total_b1d;
                                worksheet.getCell('J'+counter).value = report_total[0].total_b1c;
                                worksheet.getCell('K'+counter).value = report_total[0].total_b1q;
                                worksheet.getCell('L'+counter).value = report_total[0].total_b1t;
                                worksheet.getCell('M'+counter).value = report_total[0].total_b2d;
                                worksheet.getCell('N'+counter).value = report_total[0].total_b2c;
                                worksheet.getCell('O'+counter).value = report_total[0].total_b2q;
                                worksheet.getCell('P'+counter).value = report_total[0].total_b2t;
                                worksheet.getCell('Q'+counter).value = report_total[0].qty_service;
                                worksheet.getCell('R'+counter).value = report_total[0].total_cash;
                                worksheet.getCell('S'+counter).value = t_total_all_t;
                                worksheet.getRow(counter).font = { bold: true };
                            }

                            worksheet.eachRow({ includeEmpty: true }, function(row, rowNumber) {
                             row.eachCell({ includeEmpty: true }, function(cell, colNumber) {
                               cell.border = borderStyles;
                             });
                           });
                        
                       }
                 
                   let filename = "Report_Close_Day_Summary_"+(Math.floor(Date.now() / 1000)+".xlsx");
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