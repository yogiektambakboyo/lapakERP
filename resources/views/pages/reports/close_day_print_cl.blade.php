<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Closing Harian</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
      <style>
        body {
          background-color: whitesmoke;
          font-family: "Roboto", serif;
        }
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
      <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">-->
   </head> 
   <body> 

    <button id="printPageButton" onClick="window.print();"  class="btn print">Cetak Laporan</button>
    <!-- <button id="btn_export_xls" class="btn print printPageButton">Cetak XLS</button> -->
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
            <td colspan="2" style="width: 50%;">Laporan Closing Harian - CL</td>
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
            <td style="width: 20%;vertical-align:top;">
              @php
                $total_qty = 0;
                $total_service = 0; 
                $total_qty_salon = 0; 
                $total_salon = 0; 
                $counter = 0;   
                $counter_spk = 0;
                $counter_salon = 0;
                $counter_cl25 = 0;
                $val_cl25 = 0;
                $counter_cl15 = 0;
                $val_cl15 = 0;
                $counter_cl35 = 0;
                $val_cl35 = 0;
              @endphp
              
              <table class="table table-striped" id="service_table">
                <thead>
                <tr style="background-color:#FFA726;color:black;">
                    <th scope="col" width="55%">Perawatan</th>
                    <th scope="col" width="15%">@lang('general.lbl_price')</th>
                    <th scope="col" width="15%">@lang('general.lbl_qty')</th>
                    <th scope="col" width="15%">Total</th>
                </tr>
                </thead>
                <tbody>
                  
                  @foreach($report_datas as $report_data)
                      @if($report_data->type_id==2 && $report_data->category_id!=53 )
                        <tr>
                            <td style="text-align: left;">{{ $report_data->abbr }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                            <td style="text-align: right;">{{ $report_data->total=='Free'?'Free':number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                         if($report_data->is_cl==1 && $report_data->charge_lebaran==25000){
                            $counter_cl25 = $counter_cl25 + $report_data->qty;
                            $val_cl25 = $val_cl25 + ($report_data->total=='Free'?0:($report_data->charge_lebaran*$report_data->qty));
                         }
                         if($report_data->is_cl==1 && $report_data->charge_lebaran==15000){
                            $counter_cl15 = $counter_cl15 + $report_data->qty;
                            $val_cl15 = $val_cl15 + ($report_data->total=='Free'?0:($report_data->charge_lebaran*$report_data->qty));
                         }
                         if($report_data->is_cl==1 && $report_data->charge_lebaran==35000){
                          $counter_cl35 = $counter_cl35 + $report_data->qty;
                            $val_cl35 = $val_cl35 + ($report_data->total=='Free'?0:($report_data->charge_lebaran*$report_data->qty));
                         }
                          $total_service = $total_service + ($report_data->total=='Free'?0:$report_data->total); 
                          $counter++;   
                          $total_qty = $total_qty + $report_data->qty;
                        @endphp
                      @endif

                      @if($report_data->type_id==2 && $report_data->category_id==53 )
                        @php
                          $counter_salon++;   
                        @endphp
                      @endif
                  @endforeach
                </tbody>
              </table>

              <table class="table table-striped" id="" width="100%">
                <thead>
                </thead>
                <tbody>
                  <tr>
                    <th colspan="2" style="text-align: left;width:50%;">Total</th>
                    <th>{{ $total_qty }}</th>
                    <th style="text-align: right;">{{ number_format($total_service,0,',','.') }} </th>
                  </tr>
                </tbody>
              </table>

              @if($counter_salon>0 )
                  <table class="table table-striped" id="service_table"   width="100%">
                    <thead>
                    <tr style="background-color:#FFA726;color:black;">
                        <th scope="col" width="55%">Salon</th>
                        <th scope="col" width="15%">@lang('general.lbl_price')</th>
                        <th scope="col" width="15%">@lang('general.lbl_qty')</th>
                        <th scope="col" width="15%">Total</th>
                    </tr>
                    </thead>
                    <tbody>
                      
                      @foreach($report_datas as $report_data)
                          @if($report_data->type_id==2 && $report_data->category_id==53 )
                            <tr>
                                <td style="text-align: left;">{{ $report_data->abbr }}</td>
                                <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                                <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                                <td style="text-align: right;">{{ $report_data->total=='Free'?'Free':number_format($report_data->total,0,',','.') }}</td>
                            </tr>
                            @php
                              if($report_data->is_cl==1 && $report_data->charge_lebaran==25000){
                                  $counter_cl25 = $counter_cl25 + $report_data->qty;
                                  $val_cl25 = $val_cl25 + ($report_data->total=='Free'?0:($report_data->charge_lebaran*$report_data->qty));
                              }
                              if($report_data->is_cl==1 && $report_data->charge_lebaran==15000){
                                  $counter_cl15 = $counter_cl15 + $report_data->qty;
                                  $val_cl15 = $val_cl15 + ($report_data->total=='Free'?0:($report_data->charge_lebaran*$report_data->qty));
                              }
                              if($report_data->is_cl==1 && $report_data->charge_lebaran==35000){
                                $counter_cl35 = $counter_cl35 + $report_data->qty;
                                  $val_cl35 = $val_cl35 + ($report_data->total=='Free'?0:($report_data->charge_lebaran*$report_data->qty));
                              }
                              $total_salon = $total_salon + ($report_data->total=='Free'?0:$report_data->total); 
                              $counter++;   
                              $total_qty_salon = $total_qty_salon + $report_data->qty;
                            @endphp

                          @endif
                      @endforeach
                    </tbody>
                  </table>
              @endif

              <table class="table table-striped" id=""  width="100%">
                <thead>
                </thead>
                <tbody>
                
                  @foreach($payment_datas as $payment_data)
                        @php
                          $counter_spk = $counter_spk + $payment_data->qty_payment;
                        @endphp
                  @endforeach

                  @if($counter_salon>0)
                    <tr>
                      <th style="text-align: left;width:50%;">Total</th>
                      <th>{{ $total_qty_salon }}</th>
                      <th style="text-align: right;">{{ number_format($total_salon,0,',','.') }} </th>
                    </tr>
                  @endif
                  <tr>
                    <th colspan="2" style="text-align: left;width:20%;">Tamu</th>
                    <th  style="text-align: right">{{ count($cust)>0?$cust[0]->c_cus:"" }}</th>
                  </tr>
                  <tr>
                    <th colspan="2" style="text-align: left">SPK</th>
                    <th  style="text-align: right">{{ $counter_spk }}</th>
                  </tr>
                </tbody>
              </table>

              
              

            </td>
            <td style="width: 22%; vertical-align:top;">
              <table class="table table-striped" id="service_table">
                <thead>
                <tr style="background-color:#FFA726;color:black;">
                    <th>Produk</th>
                    <th scope="col" width="10%">@lang('general.lbl_price')</th>
                    <th scope="col" width="5%">Jml</th>
                    <th scope="col" width="10%">Total</th>
                </tr>
                </thead>
                <tbody>
                  @php
                    $total_product = 0;
                    $counter = 0;    
                    $total_qty = 0;
                  @endphp
                  @foreach($report_datas as $report_data)
                      @if($report_data->type_id==1&&$report_data->category_id!=26)
                        <tr>
                            <td style="text-align: left;">{{ $report_data->abbr }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                            <td style="text-align: right;">{{ $report_data->total=='Free'?'Free':number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          if($report_data->total=='Free'){

                          }else{
                            $total_product = $total_product+$report_data->total; 
                          } 
                          $counter++;
                          $total_qty = $total_qty + $report_data->qty;
                        @endphp
                      @endif
                  @endforeach
        
                  @if ($counter<5)
                      @for($i=0;$i<(5-$counter);$i++)
                        <tr>
                            <td style="text-align: left;"><br></th>
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                        </tr>
                      @endfor
                  @endif
        
                  <tr>
                    <th colspan="2" style="text-align: left;width:20%;">Total</th>
                    <th style="text-align: center;">{{ number_format($total_qty,0,',','.') }} </th>
                    <th style="text-align: right;">{{ number_format($total_product,0,',','.') }} </th>
                  </tr>

                  <tr>
                    <th colspan="4" style="text-align: center;width:20%;background-color:#FFA726;">Minuman</th>
                  </tr>
                  @php
                    $total_misc = 0;
                    $total_qty = 0;
                    $counter = 0;    
                  @endphp
                  @foreach($report_datas as $report_data)
                      @if($report_data->category_id==26)
                        <tr>
                            <td style="text-align: left;">{{ $report_data->abbr }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                            <td style="text-align: right;">{{ $report_data->total=='Free'?'Free':number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_misc = $total_misc+($report_data->total=='Free'?0:$report_data->total); 
                          $counter++;   
                          $total_qty = $total_qty + $report_data->qty;
                        @endphp
                      @endif
                  @endforeach
        
                  @if ($counter<4)
                      @for($i=0;$i<(4-$counter);$i++)
                        <tr>
                            <td style="text-align: left;"><br></th>
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                        </tr>
                      @endfor
                  @endif

                  <tr>
                    <th colspan="2" style="text-align: left;width:20%;">Total</th>
                    <th style="text-align: center;">{{ number_format($total_qty,0,',','.') }} </th>
                    <th style="text-align: right;">{{ number_format($total_misc,0,',','.') }} </th>
                  </tr>


                  <tr>
                    <th colspan="4" style="text-align: center;width:20%;background-color:#FFA726;">Extra Charge</th>
                  </tr>
                  @php
                    $total_extra = 0;
                    $total_qty = 0;
                    $counter = 0;    
                  @endphp
                  @foreach($report_datas as $report_data)
                    @if($report_data->type_id==8)
                        <tr>
                            <td style="text-align: left;">{{ $report_data->abbr }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                            <td style="text-align: right;">{{ $report_data->total=='Free'?'Free':number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_extra = $total_extra+($report_data->total=='Free'?0:$report_data->total); 
                          $counter++;   
                          $total_qty = $total_qty + $report_data->qty;
                        @endphp
                    @endif
                  @endforeach


                  @if($counter_cl15>0)
                        <tr>
                            <td style="text-align: left;">CHARGE LEBARAN 15K</td>
                            <td style="text-align: center;">{{ number_format(15000,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($counter_cl15,0,',','.') }}</td>
                            <td style="text-align: right;">{{  number_format($val_cl15,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_extra = $total_extra+$val_cl15; 
                          $counter++;   
                          $total_qty = $total_qty + $counter_cl15;
                        @endphp
                    @endif

                    @if($counter_cl25>0)
                        <tr>
                            <td style="text-align: left;">CHARGE LEBARAN 25K</td>
                            <td style="text-align: center;">{{ number_format(25000,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($counter_cl25,0,',','.') }}</td>
                            <td style="text-align: right;">{{  number_format($val_cl25,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_extra = $total_extra+$val_cl25; 
                          $counter++;   
                          $total_qty = $total_qty + $counter_cl25;
                        @endphp
                    @endif

                    

                    @if($counter_cl35>0)
                        <tr>
                            <td style="text-align: left;">CHARGE LEBARAN 35K</td>
                            <td style="text-align: center;">{{ number_format(35000,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($counter_cl35,0,',','.') }}</td>
                            <td style="text-align: right;">{{  number_format($val_cl35,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_extra = $total_extra+$val_cl35; 
                          $counter++;   
                          $total_qty = $total_qty + $counter_cl35;
                        @endphp
                    @endif
        
                  @if ($counter<4)
                      @for($i=0;$i<(4-$counter);$i++)
                        <tr>
                            <td style="text-align: left;"><br></th>
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                        </tr>
                      @endfor
                  @endif

                  <tr>
                    <th colspan="2" style="text-align: left;width:20%;">Total</th>
                    <th style="text-align: center;">{{ number_format($total_qty,0,',','.') }} </th>
                    <th style="text-align: right;">{{ number_format($total_extra,0,',','.') }} </th>
                  </tr>

                  <tr>
                    <th colspan="4" style="text-align: center;width:20%;background-color:#FFA726;">TOTAL PENDAPATAN</th>
                  </tr>
                  
                  <tr>
                    <td colspan="2" style="text-align: left;">Perawatan</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_service,0,',','.') }}</td>
                  </tr>
                  @if($counter_salon>0)
                    <tr>
                      <td colspan="2" style="text-align: left;">Salon</td>
                      <td colspan="2" style="text-align: right;">{{ number_format($total_salon,0,',','.') }}</td>
                    </tr>
                  @endif
                  <tr>
                    <td colspan="2" style="text-align: left;">Produk</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_product,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">Minuman</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_misc,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">Extra</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_extra,0,',','.') }}</td>
                  </tr>

                  <tr>
                    <th colspan="2" style="text-align: left;width:20%;">Total</th>
                    <th colspan="2" style="text-align: right;">{{ number_format($total_product+$total_salon+$total_misc+$total_service+$total_extra,0,',','.') }} </th>
                  </tr>
                </tbody>
              </table>

            </td>

            <td style="width: 25%; vertical-align:top;">
              <table class="table table-striped" id="p_t" width="100%">
                @php
                  $total_payment = 0;
                  $counter = 0;
                  
                  $payment_cash = 0;
                  $payment_bca_debit = 0;
                  $payment_bca_kredit = 0;
                  $payment_mandiri_debit = 0;
                  $payment_mandiri_kredit = 0;
                  $payment_qr_b1 = 0;
                  $payment_qr_b2 = 0;
                  $payment_tr_b1 = 0;
                  $payment_tr_b2 = 0;

                @endphp

                @foreach($payment_datas as $payment_data)
                      @php
                        $total_payment = $total_payment+$payment_data->total_payment; 
                        if($payment_data->payment_type=='Cash'){
                          $payment_cash = $payment_cash + $payment_data->total_payment;
                        }else if($payment_data->payment_type=='BCA - Debit'||$payment_data->payment_type=='BANK 1 - Debit'){
                          $payment_bca_debit = $payment_bca_debit + $payment_data->total_payment;
                        }else if($payment_data->payment_type=='BCA - Kredit'||$payment_data->payment_type=='BANK 1 - Kredit'){
                          $payment_bca_kredit = $payment_bca_kredit + $payment_data->total_payment;
                        }else if($payment_data->payment_type=='Mandiri - Debit'||$payment_data->payment_type=='BANK 2 - Debit'){
                          $payment_mandiri_debit = $payment_mandiri_debit + $payment_data->total_payment;
                        }else if($payment_data->payment_type=='Mandiri - Kredit'||$payment_data->payment_type=='BANK 2 - Kredit'){
                          $payment_mandiri_kredit = $payment_mandiri_kredit + $payment_data->total_payment;
                        }else if($payment_data->payment_type=='QRIS'||$payment_data->payment_type=='BANK 1 - QRIS'){
                          $payment_qr_b1 = $payment_qr_b1 + $payment_data->total_payment;
                        }else if($payment_data->payment_type=='BANK 2 - QRIS'){
                          $payment_qr_b2 = $payment_qr_b2 + $payment_data->total_payment;
                        }else if($payment_data->payment_type=='Transfer'||$payment_data->payment_type=='BANK 1 - Transfer'){
                          $payment_tr_b1 = $payment_tr_b1 + $payment_data->total_payment;
                        }else if($payment_data->payment_type=='BANK 2 - Transfer'){
                          $payment_tr_b2 = $payment_tr_b2 + $payment_data->total_payment;
                        }
                        $counter++;
                      @endphp
                @endforeach

                <?php
                  $colspan_header = 0;
                  $colspan_bank_1 = 0;
                  $colspan_bank_2 = 0;
                  $colspan_transfer = 0;
                  $colspan_qr = 0;
                  if($payment_bca_debit>0){
                    $colspan_header = $colspan_header + 1;
                    $colspan_bank_1 = $colspan_bank_1 + 1;
                  }
                  if($payment_bca_kredit>0){
                    $colspan_header = $colspan_header + 1;
                    $colspan_bank_1 = $colspan_bank_1 + 1;
                  }
                  if($payment_mandiri_debit>0){
                    $colspan_header = $colspan_header + 1;
                    $colspan_bank_2 = $colspan_bank_2 + 1;
                  }
                  if($payment_mandiri_kredit>0){
                    $colspan_header = $colspan_header + 1;
                    $colspan_bank_2 = $colspan_bank_2 + 1;
                  }
                  if($payment_qr_b1>0){
                    $colspan_header = $colspan_header + 1;
                    $colspan_qr = $colspan_qr + 1;
                  }
                  if($payment_qr_b2>0){
                    $colspan_header = $colspan_header + 1;
                    $colspan_qr = $colspan_qr + 1;
                  }
                  if($payment_tr_b1>0){
                    $colspan_header = $colspan_header + 1;
                    $colspan_transfer = $colspan_transfer + 1;
                  }
                  if($payment_tr_b2>0){
                    $colspan_header = $colspan_header + 1;
                    $colspan_transfer = $colspan_transfer + 1;
                  }
                ?>
                
                <thead>
                <tr>
                  <th colspan="<?= $colspan_header; ?>" style="text-align: center;width:20%;background-color:#FFA726;">Transaksi</th>
                </tr>
                <tr>
                  @if($colspan_bank_1>0)
                      <th colspan="<?= $colspan_bank_1; ?>" style="text-align: center;width:20%;background-color:#FFA726;">BANK 1</th>
                  @endif
                  @if($colspan_bank_2>0)
                      <th colspan="<?= $colspan_bank_2; ?>" style="text-align: center;width:20%;background-color:#FFA726;">BANK 2</th>
                  @endif
                  @if($colspan_qr>0)
                    <th colspan="<?= $colspan_qr; ?>" style="text-align: center;width:20%;background-color:#FFA726;">QRIS</th>
                  @endif
                  @if($colspan_transfer>0)
                    <th colspan="<?= $colspan_transfer; ?>" style="text-align: center;width:20%;background-color:#FFA726;">TRF</th>
                  @endif
                </tr>
                <tr style="background-color:#FFA726;color:white;">
                    @if($payment_bca_debit>0)
                      <th scope="col" width="13%">Debit</th>
                    @endif
                    @if($payment_bca_kredit>0)
                      <th scope="col" width="13%">Kredit</th>
                    @endif
                    @if($payment_mandiri_debit>0)
                      <th scope="col" width="13%">Debit</th>
                    @endif
                    @if($payment_mandiri_kredit>0)
                      <th scope="col" width="13%">Kredit</th>
                    @endif
                    @if($payment_qr_b1>0)
                      <th scope="col" width="13%">Bank 1</th>
                    @endif
                    @if($payment_qr_b2>0)
                      <th scope="col" width="13%">Bank 2</th>
                    @endif
                    @if($payment_tr_b1>0)
                      <th scope="col" width="13%">Bank 1</th>
                    @endif
                    @if($payment_tr_b2>0)
                      <th scope="col" width="13%">Bank 2</th>
                    @endif
                    
                </tr>
                </thead>
                <tbody>

                 
        
                  @if ($counter<5)
                      @for($i=0;$i<(5-$counter);$i++)
                        <tr>
                          
                          @if($payment_bca_debit>0)
                            <td style="text-align: center;"> </td>
                          @endif
                          @if($payment_bca_kredit>0)
                            <td style="text-align: center;"> </td>
                          @endif
                          @if($payment_mandiri_debit>0)
                            <td style="text-align: center;"> </td>
                          @endif
                          @if($payment_mandiri_kredit>0)
                            <td style="text-align: center;"> </td>
                          @endif
                          @if($payment_qr_b1>0)
                            <td style="text-align: center;"> </td>
                          @endif
                          @if($payment_qr_b2>0)
                            <td style="text-align: center;"> </td>
                          @endif
                          @if($payment_tr_b1>0)
                            <td style="text-align: center;"> </td>

                          @endif
                          @if($payment_tr_b2>0)
                            <td style="text-align: center;"> </td>
                          @endif
                        </tr>
                      @endfor
                  @endif


                  @php
                    $arr_bca_d = array();
                    $arr_bca_k = array();
                    $arr_man_d = array();
                    $arr_man_k = array();
                    $arr_qr_b1 = array();
                    $arr_qr_b2 = array();
                    $arr_tr_b1 = array();
                    $arr_tr_b2 = array();

                  @endphp

                  @foreach($payment_datas as $payment_d)
                  @if($payment_d->payment_type!='Cash')
                    @php
                    if($payment_d->payment_type=='BCA - Debit'||$payment_d->payment_type=='BANK 1 - Debit'){
                        array_push($arr_bca_d,$payment_d->total_payment);
                    }else{
                        array_push($arr_bca_d,"0");
                    }
                    if($payment_d->payment_type=='BCA - Kredit'||$payment_d->payment_type=='BANK 1 - Kredit'){
                        array_push($arr_bca_k,$payment_d->total_payment);
                    }else{
                        array_push($arr_bca_k,"0");
                    }
                    if($payment_d->payment_type=='Mandiri - Debit'||$payment_d->payment_type=='BANK 2 - Debit'){
                        array_push($arr_man_d,$payment_d->total_payment);
                    } else{
                        array_push($arr_man_d,"0");
                    }  

                    if($payment_d->payment_type=='Mandiri - Kredit'||$payment_d->payment_type=='BANK 2 - Kredit'){
                        array_push($arr_man_k,$payment_d->total_payment);
                    }else{
                        array_push($arr_man_k,"0");
                    }

                    if($payment_d->payment_type=='QRIS'||$payment_d->payment_type=='BANK 1 - QRIS'){
                      array_push($arr_qr_b1,$payment_d->total_payment);
                    }else{
                      array_push($arr_qr_b1,"0");
                    }

                    if($payment_d->payment_type=='BANK 2 - QRIS'){
                      array_push($arr_qr_b2,$payment_d->total_payment);
                    }else{
                      array_push($arr_qr_b2,"0");
                    }

                    
                    if($payment_d->payment_type=='Transfer'||$payment_d->payment_type=='BANK 1 - Transfer'){
                      array_push($arr_tr_b1,$payment_d->total_payment);
                    }else{
                      array_push($arr_tr_b1,"0");
                    }

                    if($payment_d->payment_type=='BANK 2 - Transfer'){
                      array_push($arr_tr_b2,$payment_d->total_payment);
                    }else{
                      array_push($arr_tr_b2,"0");
                    }

                    rsort($arr_bca_d,1);
                    rsort($arr_bca_k,1);
                    rsort($arr_man_d,1);
                    rsort($arr_man_k,1);
                    rsort($arr_qr_b1,1);
                    rsort($arr_qr_b2,1);
                    rsort($arr_tr_b1,1);
                    rsort($arr_tr_b2,1);

                    @endphp   
                  @endif
                  @endforeach


                  @php
                     $cp = 0; 
                  @endphp
                  @foreach($arr_bca_d as $dat)
                        @if(($arr_bca_d[$cp]+$arr_bca_k[$cp]+$arr_man_d[$cp]+$arr_man_k[$cp]+$arr_qr_b1[$cp]+$arr_qr_b2[$cp]+$arr_tr_b1[$cp]+$arr_tr_b2[$cp])>0)
                            <tr>
                              @if($payment_bca_debit>0)
                                <td style="text-align: center;">{{ number_format($arr_bca_d[$cp],0,',','.') }}</td>
                              @endif
                              @if($payment_bca_kredit>0)
                                <td style="text-align: center;">{{ number_format($arr_bca_k[$cp],0,',','.') }}</td>
                              @endif
                              @if($payment_mandiri_debit>0)
                                <td style="text-align: center;">{{ number_format($arr_man_d[$cp],0,',','.') }}</td>
                              @endif
                              @if($payment_mandiri_kredit>0)
                                <td style="text-align: center;">{{ number_format($arr_man_k[$cp],0,',','.') }}</td>
                              @endif
                              @if($payment_qr_b1>0)
                                <td style="text-align: center;">{{ number_format($arr_qr_b1[$cp],0,',','.') }}</td>
                              @endif
                              @if($payment_qr_b2>0)
                                <td style="text-align: center;">{{ number_format($arr_qr_b2[$cp],0,',','.') }}</td>
                              @endif
                              @if($payment_tr_b1>0)
                                <td style="text-align: center;">{{ number_format($arr_tr_b1[$cp],0,',','.') }}</td>
                              @endif
                              @if($payment_tr_b2>0)
                                <td style="text-align: center;">{{ number_format($arr_tr_b2[$cp],0,',','.') }}</td>
                              @endif
                          </tr> 
                        @endif
                        @php
                          $cp++; 
                      @endphp  
                  @endforeach
                </tbody>
              </table>  
              
              <table class="table table-striped" id="p_sum"  width="100%">
                <thead>
                <tr>
                  <th colspan="2" style="text-align: center;width:30%;background-color:#FFA726;">Ringkasan Transaksi</th>
                </tr>
                </thead>
                <tbody>
                  @php
                    $total_payment = 0;
                    $counter = 0;
                    
                    $payment_cash = 0;
                    $payment_bca_debit = 0;
                    $payment_bca_kredit = 0;
                    $payment_mandiri_debit = 0;
                    $payment_mandiri_kredit = 0;
                    $payment_qr_b1 = 0;
                    $payment_qr_b2 = 0;
                    $payment_tr_b1 = 0;
                    $payment_tr_b2 = 0;

                  @endphp

                  @foreach($payment_datas as $payment_data)
                        @php
                          $total_payment = $total_payment+$payment_data->total_payment; 
                          if($payment_data->payment_type=='Cash'){
                            $payment_cash = $payment_cash + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='BCA - Debit'||$payment_data->payment_type=='BANK 1 - Debit'){
                            $payment_bca_debit = $payment_bca_debit + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='BCA - Kredit'||$payment_data->payment_type=='BANK 1 - Kredit'){
                            $payment_bca_kredit = $payment_bca_kredit + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='Mandiri - Debit'||$payment_data->payment_type=='BANK 2 - Debit'){
                            $payment_mandiri_debit = $payment_mandiri_debit + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='Mandiri - Kredit'||$payment_data->payment_type=='BANK 2 - Kredit'){
                            $payment_mandiri_kredit = $payment_mandiri_kredit + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='QRIS'||$payment_data->payment_type=='BANK 1 - QRIS'){
                            $payment_qr_b1 = $payment_qr_b1 + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='BANK 2 - QRIS'){
                            $payment_qr_b2 = $payment_qr_b2 + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='Transfer'||$payment_data->payment_type=='BANK 1 - Transfer'){
                            $payment_tr_b1 = $payment_tr_b1 + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='BANK 2 - Transfer'){
                            $payment_tr_b2 = $payment_tr_b2 + $payment_data->total_payment;
                          }
                          $counter++;
                        @endphp
                  @endforeach
      
                  @if($payment_cash>0)
                  @endif
                  <tr>
                    <td style="text-align: left;">Cash</td>
                    <td style="text-align: right;">{{ number_format($payment_cash,0,',','.') }}</td>
                  </tr>
                  @if($payment_bca_debit>0)
                  <tr>
                    <td style="text-align: left;">Bank 1 - Debit</td>
                    <td style="text-align: right;">{{ number_format($payment_bca_debit,0,',','.') }}</td>
                  </tr>
                  @endif
                 
                  @if($payment_bca_kredit>0)
                  <tr>
                    <td style="text-align: left;">Bank 1 - Kredit</td>
                    <td style="text-align: right;">{{ number_format($payment_bca_kredit,0,',','.') }}</td>
                  </tr>
                  @endif
                  
                  @if($payment_mandiri_debit>0)
                  <tr>
                    <td style="text-align: left;">Bank 2 - Debit</td>
                    <td style="text-align: right;">{{ number_format($payment_mandiri_debit,0,',','.') }}</td>
                  </tr>
                  @endif
                 
                  @if($payment_mandiri_kredit>0)
                  <tr>
                    <td style="text-align: left;">Bank 2 - Kredit</td>
                    <td style="text-align: right;">{{ number_format($payment_mandiri_kredit,0,',','.') }}</td>
                  </tr>
                  @endif
                  

                  
                  @if($payment_qr_b1>0)
                  <tr>
                    <td style="text-align: left;">Bank 1 - QRIS</td>
                    <td style="text-align: right;">{{ number_format($payment_qr_b1,0,',','.') }}</td>
                  </tr>
                  @endif
                  

                  @if($payment_qr_b2>0)
                  <tr>
                    <td style="text-align: left;">Bank 2 - QRIS</td>
                    <td style="text-align: right;">{{ number_format($payment_qr_b2,0,',','.') }}</td>
                  </tr>
                  @endif
                  

                  @if($payment_tr_b1>0)
                    <tr>
                      <td style="text-align: left;">Bank 1 - Transfer</td>
                      <td style="text-align: right;">{{ number_format($payment_tr_b1,0,',','.') }}</td>
                    </tr>
                  @endif
                  

                  @if($payment_tr_b2>0)
                    <tr>
                      <td style="text-align: left;">Bank 2 - Transfer</td>
                      <td style="text-align: right;">{{ number_format($payment_tr_b2,0,',','.') }}</td>
                    </tr>
                  @endif
                  

                  <tr>
                    <th style="text-align: left;width:20%;">Total</th>
                    <th style="text-align: right;">{{ number_format($total_payment,0,',','.') }} </th>
                  </tr>
                </tbody>
              </table> 
            </td>

            <td style="vertical-align:top;">
              <table class="table table-striped" id="sr"  width="100%">
                <thead>
                <tr>
                  <th colspan="1" style="text-align: center;background-color:#FFA726;">Ket. Produk Terpakai</th>
                </tr>
                </thead>
                <tbody>   
                      <tr>
                        <td style="text-align: left;">Keluar : </th>
                      </tr>     
                      @foreach($petty_datas as $petty_data)
                          @if($petty_data->type == 'Produk - Keluar')
                          @php
                          @endphp    
                          <tr>
                              <td style="text-align: left;">{{ $petty_data->abbr }} ({{ $petty_data->qty }})</th>                            
                          </tr>
                          @endif    
                        @endforeach
                        @foreach($out_datas as $out_data) 
                          <tr>
                              <td style="text-align: left;">{{ $out_data->abbr }} ({{ $out_data->qty }})</th>                            
                          </tr>   
                        @endforeach
                      <tr>
                        <td style="text-align: left;">Masuk : </th>
                      </tr>     
                      @foreach($petty_datas as $petty_data)
                        @if($petty_data->type == 'Produk - Masuk')
                        @php
                        @endphp    
                        <tr>
                            <td style="text-align: left;">{{ $petty_data->abbr }} ({{ $petty_data->qty }})</th>                            
                        </tr>
                        @endif    
                      @endforeach
                </tbody>
              </table>           
            </td>

          </tr>
          <tr>
            <th colspan="2" style="text-align: center;">TTD Kasir<br><br><br>( {{ $creator[0]->created_by }} )</th>
            <th colspan="3" style="text-align: center;">TTD Penerima<br><br><br>( . . . . . . . . . )</th>
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

   <script src="/assets/js/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
 <script src="/assets/js/axios.min.js"></script>   
 <script src="/assets/js/exceljs.min.js"></script>
 <script src="/assets/js/FileSaver.min.js"></script>
 <!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>-->
   
<script type="text/javascript">
   //window.print();
   const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Kakiku System Apps';
    workbook.created = new Date();

    let report_data_detail_t = [];
    let report_data_com_from1 = [];
    let report_data_terapist = [];
    let report_datas = [];
    let payment_datas = [];
    let petty_datas = [];

    let arr_bca_d = [];
    let arr_bca_k = [];
    let arr_man_d = [];
    let arr_man_k = [];
    let arr_qr = [];
    let arr_tr = [];

    $(document).ready(function() {
      var url = "{{ route('reports.closeday.getdata') }}";
      const params = {
        filter_begin_date : "{{ $filter_begin_date }}",
        filter_begin_date : "{{ $filter_begin_end }}",
        filter_branch_id : "{{ $filter_branch_id }}",
        filter_type : 'api',
      };

      $('#btn_export_xls').on('click',function(){
        const res = axios.get(url,{ params }, {
                    headers: {}
                  }).then(resp => {
                    report_datas = resp.data.report_datas;
                    payment_datas = resp.data.payment_datas;
                    petty_datas = resp.data.petty_datas;

                    data_filtered = [];

                        let worksheet = workbook.addWorksheet("Laporan Closing Harian");

                        worksheet.mergeCells('A1', 'L1');
                        worksheet.getCell('A1').value = 'Cabang : '+report_datas[0].branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('M1', 'U1');
                        worksheet.getCell('M1').value = 'Tgl : '+resp.data.filter_begin_date;
                        worksheet.getCell('M1').alignment = { vertical: 'middle', horizontal: 'center' };
                        
                        worksheet.getRow(1).font = { bold: true };
                        worksheet.getRow(2).font = { bold: true };
                        worksheet.getCell('A1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('B1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('C1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('D1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('G1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('H1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('I1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('M1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.getCell('A2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('B2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('C2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('D2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('G2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('H2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('I2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.getCell('A2').value = 'Perawatan';
                        worksheet.getCell('B2').value = 'Harga';
                        worksheet.getCell('C2').value = 'Jml';
                        worksheet.getCell('D2').value = 'Total';

                        worksheet.getCell('F2').value = 'Produk';
                        worksheet.getCell('G2').value = 'Harga';
                        worksheet.getCell('H2').value = 'Jml';
                        worksheet.getCell('I2').value = 'Total';

                        worksheet.mergeCells('F9', 'I9');
                        worksheet.getCell('F9').value = 'Minuman';
                        worksheet.getCell('F9').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('F15', 'I15');
                        worksheet.getCell('F15').value = 'Extra Charge';
                        worksheet.getCell('F15').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('F23', 'I23');
                        worksheet.getCell('F23').value = 'Pendapatan';
                        worksheet.getCell('F23').alignment = { vertical: 'middle', horizontal: 'center' };


                        worksheet.mergeCells('K2', 'P2');
                        worksheet.getCell('K2').value = 'Transaksi';
                        worksheet.getCell('K2').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('K2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.mergeCells('K3', 'L3');
                        worksheet.getCell('K3').value = 'BCA';
                        worksheet.getCell('K3').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('K3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                        worksheet.mergeCells('M3', 'N3');
                        worksheet.getCell('M3').value = 'Mandiri';
                        worksheet.getCell('M3').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('M3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                        worksheet.getCell('K4').value = 'Debit';
                        worksheet.getCell('K4').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('K4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                        worksheet.getCell('L4').value = 'Kredit';
                        worksheet.getCell('L4').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('L4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.getCell('M4').value = 'Debit';
                        worksheet.getCell('M4').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('M4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.getCell('N4').value = 'Kredit';
                        worksheet.getCell('N4').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('N4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.mergeCells('O3', 'O4');
                        worksheet.getCell('O3').value = 'QRIS';
                        worksheet.getCell('O3').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('O3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.mergeCells('P3', 'P4');
                        worksheet.getCell('P3').value = 'Transfer';
                        worksheet.getCell('P3').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('P3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.mergeCells('R3', 'S3');
                        worksheet.getCell('R3').value = 'Pengeluaran';
                        worksheet.getCell('R3').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('R3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.mergeCells('R4', 'S4');
                        worksheet.getCell('R4').value = 'Kas Masuk';
                        worksheet.getCell('R4').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('R4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.getCell('R5').value = 'Jenis';
                        worksheet.getCell('R5').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('R5').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.getCell('S5').value = 'Harga';
                        worksheet.getCell('S5').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('S5').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.getCell('U3').value = 'Ket. Produk Terpakai';
                        worksheet.getCell('U3').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('U3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        var counter_service = 3;
                        var counter_product = 3;
                        var counter_drink = 10;
                        var counter_extra = 16;
                        var total_qty=0, total_qty_product = 0, total_qty_drink = 0, total_qty_extra = 0;
                        var total_service = 0,total_drink = 0, total_product = 0, total_extra = 0;
                        var counter_spk = 0;
                        for (let index = 0; index < report_datas.length; index++) {
                          const rowElement = report_datas[index];
                          let value_sd = 0;
                            
                            if(rowElement.type_id==2){
                                 worksheet.getCell('A'+counter_service).value = rowElement.abbr;
                                 worksheet.getCell('B'+counter_service).value = rowElement.price;
                                 worksheet.getCell('C'+counter_service).value = rowElement.qty;
                                 worksheet.getCell('D'+counter_service).value = rowElement.total;
                                counter_service++;
                                total_service = total_service + parseFloat(rowElement.total);
                                total_qty = total_qty + parseFloat(rowElement.qty);
                            }

                            if(rowElement.type_id==1&&rowElement.category_id!=26){
                                 worksheet.getCell('F'+counter_product).value = rowElement.abbr;
                                 worksheet.getCell('G'+counter_product).value = rowElement.price;
                                 worksheet.getCell('H'+counter_product).value = rowElement.qty;
                                 worksheet.getCell('I'+counter_product).value = rowElement.total;
                                 counter_product++;
                                 total_product = total_product + parseFloat(rowElement.total);
                                 total_qty_product = total_qty_product + parseFloat(rowElement.qty);
                            }        
                            
                            if(rowElement.category_id==26){
                                 worksheet.getCell('F'+counter_drink).value = rowElement.abbr;
                                 worksheet.getCell('G'+counter_drink).value = rowElement.price;
                                 worksheet.getCell('H'+counter_drink).value = rowElement.qty;
                                 worksheet.getCell('I'+counter_drink).value = rowElement.total;
                                 counter_drink++;
                                 total_drink = total_drink + parseFloat(rowElement.total);
                                 total_qty_drink = total_qty_drink + parseFloat(rowElement.qty);
                            }    

                            if(rowElement.type_id==8){
                                 worksheet.getCell('F'+counter_extra).value = rowElement.abbr;
                                 worksheet.getCell('G'+counter_extra).value = rowElement.price;
                                 worksheet.getCell('H'+counter_extra).value = rowElement.qty;
                                 worksheet.getCell('I'+counter_extra).value = rowElement.total;
                                 counter_extra++;
                                 total_extra = total_extra + parseFloat(rowElement.total);
                                 total_qty_extra = total_qty_extra + parseFloat(rowElement.qty);
                            }    

                            var borderStyles = {
                              top: { style: "thin" },
                              left: { style: "thin" },
                              bottom: { style: "thin" },
                              right: { style: "thin" }
                            };

                            worksheet.eachRow({ includeEmpty: true }, function(row, rowNumber) {
                              row.eachCell({ includeEmpty: true }, function(cell, colNumber) {
                                cell.border = borderStyles;
                              });
                            });
                         
                        }

                        for (let index = 0; index < payment_datas.length; index++) {
                          const rowElement = payment_datas[index];
                          counter_spk = counter_spk + parseFloat(rowElement.qty_payment);
                        }

                        worksheet.mergeCells('A20','B20');
                        worksheet.getCell('A20').value = 'Total';
                        worksheet.getCell('C20').value = total_qty;
                        worksheet.getCell('D20').value = total_service;

                        worksheet.getCell('A20').font = { bold: true };
                        worksheet.getCell('C20').font = { bold: true };
                        worksheet.getCell('D20').font = { bold: true };
                        worksheet.getCell('A21').font = { bold: true };
                        worksheet.getCell('D21').font = { bold: true };
                        worksheet.getCell('A22').font = { bold: true };
                        worksheet.getCell('D22').font = { bold: true };

                        worksheet.mergeCells('F8','G8');
                        worksheet.getCell('F8').value = 'Total';
                        worksheet.getCell('H8').value = total_qty_product;
                        worksheet.getCell('I8').value = total_product;

                        worksheet.getCell('F8').font = { bold: true };
                        worksheet.getCell('H8').font = { bold: true };
                        worksheet.getCell('I8').font = { bold: true };
                        worksheet.getCell('F9').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F15').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F23').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        worksheet.getCell('F9').font = { bold: true };
                        worksheet.getCell('F15').font = { bold: true };
                        worksheet.getCell('F23').font = { bold: true };


                        worksheet.mergeCells('F14','G14');
                        worksheet.getCell('F14').value = 'Total';
                        worksheet.getCell('H14').value = total_qty_drink;
                        worksheet.getCell('I14').value = total_drink;
                        worksheet.getCell('F14').font = { bold: true };
                        worksheet.getCell('H14').font = { bold: true };
                        worksheet.getCell('I14').font = { bold: true };

                        worksheet.mergeCells('F22','G22');
                        worksheet.getCell('F22').value = 'Total';
                        worksheet.getCell('H22').value = total_qty_extra;
                        worksheet.getCell('I22').value = total_extra;
                        worksheet.getCell('F22').font = { bold: true };
                        worksheet.getCell('H22').font = { bold: true };
                        worksheet.getCell('I22').font = { bold: true };

                        worksheet.mergeCells('F24','G24');
                        worksheet.getCell('F24').value = 'Perawatan';
                        worksheet.mergeCells('H24','I24');
                        worksheet.getCell('H24').value = total_service;
         

                        worksheet.mergeCells('F25','G25');
                        worksheet.getCell('F25').value = 'Produk';
                        worksheet.mergeCells('H25','I25');
                        worksheet.getCell('H25').value = total_product;
   

                        worksheet.mergeCells('F26','G26');
                        worksheet.getCell('F26').value = 'Minuman';
                        worksheet.mergeCells('H26','I26');
                        worksheet.getCell('H26').value = total_drink;
   

                        worksheet.mergeCells('F27','G27');
                        worksheet.getCell('F27').value = 'Extra';
                        worksheet.mergeCells('H27','I27');
                        worksheet.getCell('H27').value = total_extra;


                        worksheet.mergeCells('F28','G28');
                        worksheet.getCell('F28').value = 'Total';
                        worksheet.mergeCells('H28','I28');
                        worksheet.getCell('H28').value = total_service+total_product+total_drink+total_extra;
                        worksheet.getCell('F28').font = { bold: true };
                        worksheet.getCell('H28').font = { bold: true };

                        worksheet.mergeCells('A21','C21');
                        worksheet.getCell('A21').value = 'Tamu';
                        worksheet.getCell('D21').value = resp.data.cust[0].c_cus;

                        worksheet.mergeCells('A22','C22');
                        worksheet.getCell('A22').value = 'SPK';
                        worksheet.getCell('D22').value = counter_spk;

                        // Payment Section

                        total_payment = 0;
                        counter = 0;
                        
                        payment_cash = 0;
                        payment_bca_debit = 0;
                        payment_bca_kredit = 0;
                        payment_mandiri_debit = 0;
                        payment_mandiri_kredit = 0;
                        payment_qr = 0;
                        payment_tr = 0;

                        arr_bca_d = [];
                        arr_bca_k = [];
                        arr_man_d = [];
                        arr_man_k = [];
                        arr_qr = [];
                        arr_tr = [];

                        for (let index = 0; index < payment_datas.length; index++) {
                          const rowElement = payment_datas[index];
                          if(rowElement.payment_type=='BCA - Debit'){
                              arr_bca_d.push(rowElement.total_payment);
                              payment_bca_debit = payment_bca_debit + parseFloat(rowElement.total_payment);
                          }else{
                              arr_bca_d.push("0");
                          }
                          if(rowElement.payment_type=='BCA - Kredit'){
                              arr_bca_k.push(rowElement.total_payment);
                              payment_bca_kredit = payment_bca_kredit + parseFloat(rowElement.total_payment);
                          }else{
                              arr_bca_k.push("0");
                          }
                          if(rowElement.payment_type=='Mandiri - Debit'){
                              arr_man_d.push(rowElement.total_payment);
                              payment_mandiri_debit = payment_mandiri_debit + parseFloat(rowElement.total_payment);
                          }else{
                              arr_man_d.push("0");
                          }
                          if(rowElement.payment_type=='Mandiri - Kredit'){
                              arr_man_k.push(rowElement.total_payment);
                              payment_mandiri_kredit = payment_mandiri_kredit + parseFloat(rowElement.total_payment);
                          }else{
                              arr_man_k.push("0");
                          }
                          if(rowElement.payment_type=='QRIS'){
                            arr_qr.push(rowElement.total_payment);
                            payment_qr = payment_qr + parseFloat(rowElement.total_payment);
                          }else{
                            arr_qr.push("0");
                          }
                          if(rowElement.payment_type=='Transfer'){
                            arr_tr.push(rowElement.total_payment);
                            payment_tr = payment_tr + parseFloat(rowElement.total_payment);
                          }else{
                            arr_tr.push("0");
                          }
                          if(rowElement.payment_type=='Cash'){
                            payment_cash = payment_cash + parseFloat(rowElement.total_payment);
                          }
                        }

                        arr_bca_d.sort();
                        arr_bca_k.sort();
                        arr_man_d.sort();
                        arr_man_k.sort();
                        arr_qr.sort();
                        arr_tr.sort();

                        arr_bca_d.reverse();
                        arr_bca_k.reverse();
                        arr_man_d.reverse();
                        arr_man_k.reverse();
                        arr_qr.reverse();
                        arr_tr.reverse();

                        var counter_transaction = 5;
                        var counter_transaction_ex = 5;

                        for (let index = 0; index < arr_bca_d.length; index++) {
                          if( (parseFloat(arr_bca_d[index])+parseFloat(arr_bca_k[index])+parseFloat(arr_man_d[index])+parseFloat(arr_man_k[index])+parseFloat(arr_tr[index])+parseFloat(arr_qr[index])) >0){
                            worksheet.getCell('K'+counter_transaction_ex).value = arr_bca_d[index];
                            worksheet.getCell('L'+counter_transaction_ex).value = arr_bca_k[index];
                            worksheet.getCell('M'+counter_transaction_ex).value = arr_man_d[index];
                            worksheet.getCell('N'+counter_transaction_ex).value = arr_man_k[index];
                            worksheet.getCell('O'+counter_transaction_ex).value = arr_qr[index];
                            worksheet.getCell('P'+counter_transaction_ex).value = arr_tr[index];
                            counter_transaction++;
                            worksheet.getCell('K'+counter_transaction_ex).border = borderStyles;
                            worksheet.getCell('L'+counter_transaction_ex).border = borderStyles;
                            worksheet.getCell('M'+counter_transaction_ex).border = borderStyles;
                            worksheet.getCell('N'+counter_transaction_ex).border = borderStyles;
                            worksheet.getCell('O'+counter_transaction_ex).border = borderStyles;
                            worksheet.getCell('P'+counter_transaction_ex).border = borderStyles;
                          }
                          counter_transaction_ex++;
                        }

                        worksheet.mergeCells('K'+counter_transaction,'L'+counter_transaction);
                        worksheet.getCell('K'+counter_transaction).value = 'Cash';
                        worksheet.mergeCells('M'+counter_transaction,'P'+counter_transaction);
                        worksheet.getCell('M'+counter_transaction).value = payment_cash;
                        counter_transaction++;

                        worksheet.mergeCells('K'+counter_transaction,'L'+counter_transaction);
                        worksheet.getCell('K'+counter_transaction).value = 'BCA - Debit';
                        worksheet.mergeCells('M'+counter_transaction,'P'+counter_transaction);
                        worksheet.getCell('M'+counter_transaction).value = payment_bca_debit;
                        counter_transaction++;

                        worksheet.mergeCells('K'+counter_transaction,'L'+counter_transaction);
                        worksheet.getCell('K'+counter_transaction).value = 'BCA - Kredit';
                        worksheet.mergeCells('M'+counter_transaction,'P'+counter_transaction);
                        worksheet.getCell('M'+counter_transaction).value = payment_bca_kredit;
                        counter_transaction++;

                        worksheet.mergeCells('K'+counter_transaction,'L'+counter_transaction);
                        worksheet.getCell('K'+counter_transaction).value = 'Mandiri - Debit';
                        worksheet.mergeCells('M'+counter_transaction,'P'+counter_transaction);
                        worksheet.getCell('M'+counter_transaction).value = payment_mandiri_debit;
                        counter_transaction++;

                        worksheet.mergeCells('K'+counter_transaction,'L'+counter_transaction);
                        worksheet.getCell('K'+counter_transaction).value = 'Mandiri - Kredit';
                        worksheet.mergeCells('M'+counter_transaction,'P'+counter_transaction);
                        worksheet.getCell('M'+counter_transaction).value = payment_mandiri_kredit;
                        counter_transaction++;

                        worksheet.mergeCells('K'+counter_transaction,'L'+counter_transaction);
                        worksheet.getCell('K'+counter_transaction).value = 'QRIS';
                        worksheet.mergeCells('M'+counter_transaction,'P'+counter_transaction);
                        worksheet.getCell('M'+counter_transaction).value = payment_qr;
                        counter_transaction++;

                        worksheet.mergeCells('K'+counter_transaction,'L'+counter_transaction);
                        worksheet.getCell('K'+counter_transaction).value = 'Transfer';
                        worksheet.mergeCells('M'+counter_transaction,'P'+counter_transaction);
                        worksheet.getCell('M'+counter_transaction).value = payment_tr;
                        counter_transaction++;

                        worksheet.mergeCells('K'+counter_transaction,'L'+counter_transaction);
                        worksheet.getCell('K'+counter_transaction).value = 'Total';
                        worksheet.mergeCells('M'+counter_transaction,'P'+counter_transaction);
                        worksheet.getCell('M'+counter_transaction).value = payment_cash+payment_bca_debit+payment_bca_kredit+payment_tr+payment_qr+payment_mandiri_kredit+payment_mandiri_debit;

                        worksheet.getCell('K'+counter_transaction).font = { bold: true };
                        worksheet.getCell('M'+counter_transaction).font = { bold: true };

                        counter_kas = 6;
                        total_kas_out = 0;
                        for (let index = 0; index < petty_datas.length; index++) {
                          if(petty_datas[index].type == 'Kas - Keluar'){
                            worksheet.getCell('R'+counter_kas).value = petty_datas[index].abbr;
                            worksheet.getCell('S'+counter_kas).value = petty_datas[index].total;
                            total_kas_out = total_kas_out + parseFloat(petty_datas[index].total);
                            worksheet.getCell('R'+counter_kas).border = borderStyles;
                            worksheet.getCell('S'+counter_kas).border = borderStyles;

                            counter_kas++;
                          }
                        }

                        counter_kas++;
                        worksheet.getCell('R'+counter_kas).value = "Total";
                        worksheet.getCell('S'+counter_kas).value = total_kas_out;


                        worksheet.getCell('U4').value = "Keluar :";
                        counter_p = 5;

                        for (let index = 0; index < petty_datas.length; index++) {
                          if(petty_datas[index].type == 'Produk - Keluar'){
                            worksheet.getCell('U'+counter_p).value = petty_datas[index].abbr + " ("+petty_datas[index].qty+")";
                            worksheet.getCell('U'+counter_p).border = borderStyles;

                            counter_p++;
                          }
                        }

                        worksheet.getCell('U'+counter_p).value = "Masuk :";
                        counter_p++;

                        for (let index = 0; index < petty_datas.length; index++) {
                          if(petty_datas[index].type == 'Produk - Masuk'){
                            worksheet.getCell('U'+counter_p).value = petty_datas[index].abbr + " ("+petty_datas[index].qty+")";
                            worksheet.getCell('U'+counter_p).border = borderStyles;
                            counter_p++;
                          }
                        }
                        // End Payment Section 


                    // Loop Terapist

                    //XLSX.writeFile(workbook, "Presidents.xlsx", { compression: true });


                  
                    let filename = "Report_Clesa_Day_"+(Math.floor(Date.now() / 1000)+".xlsx");
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