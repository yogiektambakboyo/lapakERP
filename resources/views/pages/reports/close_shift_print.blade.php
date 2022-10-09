<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Serah Terima</title>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          border: 0px inset black;
          padding: 2px;
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
            <td colspan="2" style="width: 50%;">Laporan Serah Terima</td>
          </tr>
          <tr style="background-color: chocolate;">
            <td>Tanggal : {{ $report_datas[0]->dated }}</td>
            <td>Cabang  : {{ $report_datas[0]->branch_name }}</td>
            <td>Shift   : {{ $report_datas[0]->shift_name }}</td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr>
            <td style="width: 30%;vertical-align:top;">

              <table class="table table-striped" id="service_table">
                <thead>
                <tr style="background-color:#FFA726;color:white;">
                    <th>Perawatan</th>
                    <th scope="col" width="10%">Price</th>
                    <th scope="col" width="5%">Qty</th>
                    <th scope="col" width="10%">Total</th>
                </tr>
                </thead>
                <tbody>
                  @php
                    $total_qty = 0;
                    $total_service = 0; 
                    $counter = 0;   
                  @endphp
                  @foreach($report_datas as $report_data)
                      @if($report_data->type_id==2)
                        <tr>
                            <td style="text-align: left;">{{ $report_data->abbr }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                            <td style="text-align: right;">{{ number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_service = $total_service + $report_data->total; 
                          $counter++;   
                          $total_qty = $total_qty + $report_data->qty;
                        @endphp
                      @endif
                  @endforeach
        
                  @if ($counter<15)
                      @for($i=0;$i<(15-$counter);$i++)
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
                    <th>{{ $total_qty }}</th>
                    <th style="text-align: right;">{{ number_format($total_service,0,',','.') }} </th>
                  </tr>
                  <tr>
                    <th colspan="3" style="text-align: left">Tamu</th>
                    <th  style="text-align: right">{{ $report_datas[0]->qty_customer }}</th>
                  </tr>
                </tbody>
              </table>
              

            </td>
            <td style="width: 30%; vertical-align:top;">
              <table class="table table-striped" id="service_table">
                <thead>
                <tr style="background-color:#FFA726;color:white;">
                    <th>Produk</th>
                    <th scope="col" width="10%">Price</th>
                    <th scope="col" width="5%">Qty</th>
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
                      @if($report_data->type_id==1)
                        <tr>
                            <td style="text-align: left;">{{ $report_data->abbr }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                            <td style="text-align: right;">{{ number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_product = $total_product+$report_data->total; 
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
                    <th style="text-align: right;">{{ number_format($total_qty,0,',','.') }} </th>
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
                      @if($report_data->type_id==7)
                        <tr>
                            <td style="text-align: left;">{{ $report_data->abbr }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                            <td style="text-align: right;">{{ number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_misc = $total_misc+$report_data->total; 
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
                    <th style="text-align: right;">{{ number_format($total_qty,0,',','.') }} </th>
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
                            <td style="text-align: right;">{{ number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_extra = $total_extra+$report_data->total; 
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
                    <th style="text-align: right;">{{ number_format($total_qty,0,',','.') }} </th>
                    <th style="text-align: right;">{{ number_format($total_extra,0,',','.') }} </th>
                  </tr>

                  <tr>
                    <th colspan="4" style="text-align: center;width:20%;background-color:#FFA726;">TOTAL PENDAPATAN</th>
                  </tr>
                  
                  <tr>
                    <td colspan="2" style="text-align: left;">Perawatan</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_service,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">Produk</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_product,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">Extra</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_extra,0,',','.') }}</td>
                  </tr>

                  <tr>
                    <th colspan="2" style="text-align: left;width:20%;">Total</th>
                    <th colspan="2" style="text-align: right;">{{ number_format($total_product+$total_service+$total_extra,0,',','.') }} </th>
                  </tr>
                </tbody>
              </table>

            </td>

            <td style="width: 30%; vertical-align:top;">
              <table class="table table-striped" id="service_table">
                <thead>
                <tr>
                  <th colspan="4" style="text-align: center;width:20%;background-color:#FFA726;">Transaksi</th>
                </tr>
                <tr>
                  <th colspan="2" style="text-align: center;width:20%;background-color:#FFA726;">BCA</th>
                  <th colspan="2" style="text-align: center;width:20%;background-color:#FFA726;">MANDIRI</th>
                </tr>
                <tr style="background-color:#FFA726;color:white;">
                    <th scope="col" width="25%">Debit</th>
                    <th scope="col" width="25%">Kredit</th>
                    <th scope="col" width="25%">Debit</th>
                    <th scope="col" width="25%">Kredit</th>
                </tr>
                </thead>
                <tbody>
                  @php
                    $total_payment = 0;
                    $counter = 0;  
                  @endphp
                  @foreach($payment_datas as $payment_data)
                        <tr>
                            <td style="text-align: left;">{{ $payment_data->payment_type=='BCA - Debit'?number_format($payment_data->total_payment,0,',','.'):0 }}</td>
                            <td style="text-align: center;">{{ $payment_data->payment_type=='BCA - Kredit'?number_format($payment_data->total_payment,0,',','.'):0 }}</td>
                            <td style="text-align: left;">{{ $payment_data->payment_type=='Mandiri - Debit'?number_format($payment_data->total_payment,0,',','.'):0 }}</td>
                            <td style="text-align: center;">{{ $payment_data->payment_type=='Mandiri - Kredit'?number_format($payment_data->total_payment,0,',','.'):0 }}</td>
                        </tr>
                        @php
                          $total_payment = $total_payment+$payment_data->total_payment; 
                          $counter++;
                        @endphp
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
                    <td colspan="2" style="text-align: left;">Cash</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_service,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">BCA - Debit</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_product,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">BCA - Kredit</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_extra,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">Mandiri - Debit</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_product,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">Mandiri - Kredit</td>
                    <td colspan="2" style="text-align: right;">{{ number_format($total_extra,0,',','.') }}</td>
                  </tr>

                  <tr>
                    <th colspan="2" style="text-align: left;width:20%;">Total</th>
                    <th colspan="2" style="text-align: right;">{{ number_format($total_payment,0,',','.') }} </th>
                  </tr>
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