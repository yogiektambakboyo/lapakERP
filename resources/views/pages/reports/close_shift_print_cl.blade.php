<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Serah Terima</title>
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
          #printPageButton {
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
            <td colspan="2" style="width: 50%;">Laporan Serah Terima - CL</td>
          </tr>
          <tr style="background-color: chocolate;">
            <td>Tanggal : {{ Carbon\Carbon::parse(count($report_datas)>0?$report_datas[0]->dated:"")->format('d-m-Y') }}</td>
            <td>Cabang  : {{ count($report_datas)>0?$report_datas[0]->branch_name:"" }}</td>
            <td>Shift   : {{ count($report_datas)>0?$report_datas[0]->shift_name:"" }}</td>
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
                $counter_cl35 = 0;
                $val_cl35 = 0;
              @endphp
              
              <table class="table table-striped" id="service_table">
                <thead>
                <tr style="background-color:#FFA726;color:white;">
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
                  <table class="table table-striped" id="service_table">
                    <thead>
                    <tr style="background-color:#FFA726;color:white;">
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
                <tr style="background-color:#FFA726;color:white;">
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
                            <td style="text-align: right;"> {{ $report_data->total=="Free"?"Free":number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_misc = $total_misc+($report_data->total=="Free"?0:$report_data->total); 
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

                  @if($val_cl25>0)
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

                    @if($val_cl35>0)
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

          
            <td  style="width: 22%; vertical-align:top;">
              <table class="table table-striped" id="w_t"  width="100%">
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
            <th colspan="2" style="text-align: center;">TTD Kasir<br><br><br>( {{ $creator[0]->created_by }}  )</th>
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
</html> 