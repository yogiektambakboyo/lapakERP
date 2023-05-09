<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Closing Harian</title>
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
    <!-- <button id="btn_export_xls" class="btn print printPageButton">Cetak XLS</button> -->
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
            <td colspan="2" style="width: 50%;">Laporan Closing Harian</td>
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

              <table class="table table-striped" id="service_table">
                <thead>
                <tr style="background-color:#FFA726;color:white;">
                    <th>Perawatan</th>
                    <th scope="col" width="10%">@lang('general.lbl_price')</th>
                    <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                    <th scope="col" width="10%">Total</th>
                </tr>
                </thead>
                <tbody>
                  @php
                    $total_qty = 0;
                    $total_service = 0; 
                    $counter = 0;   
                    $counter_spk = 0;
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

                  @foreach($payment_datas as $payment_data)
                        @php
                          $counter_spk = $counter_spk + $payment_data->qty_payment;
                        @endphp
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
                    <th  style="text-align: right">{{ count($cust)>0?$cust[0]->c_cus:"" }}</th>
                  </tr>
                  <tr>
                    <th colspan="3" style="text-align: left">SPK</th>
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
                    <th colspan="2" style="text-align: right;">{{ number_format($total_product+$total_misc+$total_service+$total_extra,0,',','.') }} </th>
                  </tr>
                </tbody>
              </table>

            </td>

            <td style="width: 25%; vertical-align:top;">
              <table class="table table-striped" id="service_table">
                <thead>
                <tr>
                  <th colspan="6" style="text-align: center;width:20%;background-color:#FFA726;">Transaksi</th>
                </tr>
                <tr>
                  <th colspan="2" style="text-align: center;width:20%;background-color:#FFA726;">BCA</th>
                  <th colspan="2" style="text-align: center;width:20%;background-color:#FFA726;">MANDIRI</th>
                  <th rowspan="2" style="text-align: center;width:20%;background-color:#FFA726;">QRIS</th>
                  <th rowspan="2" style="text-align: center;width:20%;background-color:#FFA726;">TRF</th>
                </tr>
                <tr style="background-color:#FFA726;color:white;">
                    <th scope="col" width="20%">Debit</th>
                    <th scope="col" width="20%">Kredit</th>
                    <th scope="col" width="20%">Debit</th>
                    <th scope="col" width="20%">Kredit</th>
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
                    $payment_qr = 0;
                    $payment_tr = 0;

                  @endphp
                  @php
                    $arr_bca_d = array();
                    $arr_bca_k = array();
                    $arr_man_d = array();
                    $arr_man_k = array();
                    $arr_qr = array();
                    $arr_tr = array();
                  @endphp
                  @foreach($payment_datas as $payment_d)
                        @if($payment_d->payment_type!='Cash')
                          @php
                           if($payment_d->payment_type=='BCA - Debit'){
                              array_push($arr_bca_d,$payment_d->total_payment);
                           }else{
                              array_push($arr_bca_d,"0");
                           }
                           if($payment_d->payment_type=='BCA - Kredit'){
                              array_push($arr_bca_k,$payment_d->total_payment);
                           }else{
                              array_push($arr_bca_k,"0");
                           }
                           if($payment_d->payment_type=='Mandiri - Debit'){
                              array_push($arr_man_d,$payment_d->total_payment);
                           } else{
                              array_push($arr_man_d,"0");
                           }  
                    
                           if($payment_d->payment_type=='Mandiri - Kredit'){
                              array_push($arr_man_k,$payment_d->total_payment);
                           }else{
                              array_push($arr_man_k,"0");
                           }

                           if($payment_d->payment_type=='QRIS'){
                              array_push($arr_qr,$payment_d->total_payment);
                           }else{
                              array_push($arr_qr,"0");
                           }

                           if($payment_d->payment_type=='Transfer'){
                              array_push($arr_tr,$payment_d->total_payment);
                           }else{
                              array_push($arr_tr,"0");
                           }

                           rsort($arr_bca_d,1);
                           rsort($arr_bca_k,1);
                           rsort($arr_man_d,1);
                           rsort($arr_man_k,1);
                           rsort($arr_qr,1);
                           rsort($arr_tr,1);
                          @endphp   
                        @endif
                  @endforeach
                  
                  @php
                    $cp = 0; 
                  @endphp
                  @foreach($arr_bca_d as $dat)
                           @if(($arr_bca_d[$cp]+$arr_bca_k[$cp]+$arr_man_d[$cp]+$arr_man_k[$cp]+$arr_qr[$cp]+$arr_tr[$cp])>0)
                           <tr>
                              <td style="text-align: left;">{{ number_format($arr_bca_d[$cp],0,',','.') }}</td>
                              <td style="text-align: center;">{{ number_format($arr_bca_k[$cp],0,',','.') }}</td>
                              <td style="text-align: center;">{{number_format($arr_man_d[$cp],0,',','.') }}</td>
                              <td style="text-align: center;">{{ number_format($arr_man_k[$cp],0,',','.') }}</td>
                              <td style="text-align: center;">{{ number_format($arr_qr[$cp],0,',','.') }}</td>
                              <td style="text-align: center;">{{ number_format($arr_tr[$cp],0,',','.') }}</td>
                          </tr> 
                           @endif
                        @php
                          $cp++; 
                       @endphp  
                  @endforeach
                  
                  @foreach($payment_datas as $payment_data)
                        @php
                          $total_payment = $total_payment+$payment_data->total_payment; 
                          if($payment_data->payment_type=='Cash'){
                            $payment_cash = $payment_cash + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='BCA - Debit'){
                            $payment_bca_debit = $payment_bca_debit + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='BCA - Kredit'){
                            $payment_bca_kredit = $payment_bca_kredit + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='Mandiri - Debit'){
                            $payment_mandiri_debit = $payment_mandiri_debit + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='Mandiri - Kredit'){
                            $payment_mandiri_kredit = $payment_mandiri_kredit + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='QRIS'){
                            $payment_qr = $payment_qr + $payment_data->total_payment;
                          }else if($payment_data->payment_type=='Transfer'){
                            $payment_tr = $payment_tr + $payment_data->total_payment;
                          }
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
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                        </tr>
                      @endfor
                  @endif
               
                  
                  <tr>
                    <td colspan="2" style="text-align: left;">Cash</td>
                    <td colspan="4" style="text-align: right;">{{ number_format($payment_cash,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">BCA - Debit</td>
                    <td colspan="4" style="text-align: right;">{{ number_format($payment_bca_debit,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">BCA - Kredit</td>
                    <td colspan="4" style="text-align: right;">{{ number_format($payment_bca_kredit,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">Mandiri - Debit</td>
                    <td colspan="4" style="text-align: right;">{{ number_format($payment_mandiri_debit,0,',','.') }}</td>
                  </tr>
                  <tr>
                    <td colspan="2" style="text-align: left;">Mandiri - Kredit</td>
                    <td colspan="4" style="text-align: right;">{{ number_format($payment_mandiri_kredit,0,',','.') }}</td>
                  </tr>

                  <tr>
                    <td colspan="2" style="text-align: left;">QRIS</td>
                    <td colspan="4" style="text-align: right;">{{ number_format($payment_qr,0,',','.') }}</td>
                  </tr>

                  <tr>
                    <td colspan="2" style="text-align: left;">Transfer</td>
                    <td colspan="4" style="text-align: right;">{{ number_format($payment_tr,0,',','.') }}</td>
                  </tr>

                  <tr>
                    <th colspan="2" style="text-align: left;width:20%;">Total</th>
                    <th colspan="4" style="text-align: right;">{{ number_format($total_payment,0,',','.') }} </th>
                  </tr>
                </tbody>
              </table>           
            </td>

            <td style="width: 16%; vertical-align:top;">
              <table class="table table-striped" id="service_table">
                <thead>
                <tr>
                  <th colspan="2" style="text-align: center;width:20%;background-color:#FFA726;">Pengeluaran</th>
                </tr>
                <tr>
                  <th colspan="1" style="text-align: center;width:20%;background-color:#FFA726;">Kas Masuk</th>
                  <th colspan="1" style="text-align: center;width:20%;background-color:#FFA726;"></th>
                </tr>
                <tr>
                  <th colspan="1" style="width:80px;text-align: center;background-color:#FFA726;">Jenis</th>
                  <th colspan="1" style="width:80px;text-align: center;background-color:#FFA726;">Harga</th>
                </tr>
                </thead>
                <tbody>    
                   @php
                      $total_petty = 0;
                   @endphp    
                       @foreach($petty_datas as $petty_data)
                          @if($petty_data->type == 'Kas - Keluar')
                          @php
                            $total_petty = $total_petty + $petty_data->total;
                          @endphp    
                          <tr>
                              <td style="text-align: left;">{{ $petty_data->abbr }}</th>
                              <td style="text-align: center;">{{ number_format($petty_data->total,0,',','.') }}</td>
                          </tr>
                          @endif
                         
                        @endforeach
               
                  
                  <tr>
                    <th colspan="1" style="text-align: left;width:20%;">Total</th>
                    <th colspan="1" style="text-align: right;">{{ number_format($total_petty,0,',','.') }}</th>
                  </tr>
                  <tr>
                    <th colspan="1" style="text-align: left;width:20%;">Sisa Kas</th>
                    <th colspan="1" style="text-align: right;"> </th>
                  </tr>
                </tbody>
              </table>           
            </td>

            <td style="vertical-align:top;">
              <table class="table table-striped" id="service_table">
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

   <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
 <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>   
 <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
   
<script type="text/javascript">
   //window.print();
   const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Kakiku System Apps';
    workbook.created = new Date();

    let report_data_detail_t = [];
    let report_data_com_from1 = [];
    let report_data_terapist = [];

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
                    report_data_detail_t = resp.data.report_data_detail_t;
                    report_data_com_from1 = resp.data.report_data_com_from1;

                    var beginnewformat = resp.data.beginnewformat;
                    var endnewformat = resp.data.endnewformat;

                    let data_filtered = [];

                    data_filtered = [];

                        let worksheet = workbook.addWorksheet("Commision Cashier");

                        /*Column headers*/
                        worksheet.getRow(3).values = [
                          'Tgl', 
                          'No Faktur', 
                          'Jenis',
                          'Harga',
                          'Komisi',
                          'Jml',
                          'T Komisi',
                          'Extra Charge',
                          'Pendapatan',
                          'Pendapatan (s/d)',
                        ];


                        worksheet.mergeCells('A1', 'E1');
                        worksheet.getCell('A1').value = 'Cabang : '+report_data_detail_t[0].branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('F1', 'J1');
                        worksheet.getCell('F1').value = 'Tgl : '+beginnewformat+' sd '+endnewformat;
                        worksheet.getCell('F1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('A2', 'A3');
                        worksheet.getCell('A2').value = 'Tgl';
                        worksheet.getCell('A2').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('B2', 'B3');
                        worksheet.getCell('B2').value = 'No Faktur';
                        worksheet.getCell('B2').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('C2', 'G2');
                        worksheet.getCell('C2').value = 'Produk';
                        worksheet.getCell('C2').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('H2', 'H3');
                        worksheet.getCell('H2').value = 'Extra Charge';
                        worksheet.getCell('H2').alignment = { vertical: 'middle', horizontal: 'center' };


                        worksheet.mergeCells('I2', 'J2');
                        worksheet.getCell('I2').value = 'Total';
                        worksheet.getCell('I2').alignment = { vertical: 'middle', horizontal: 'center' };                    

                        worksheet.columns = [
                          { key: 'dated', width: 12 },
                          { key: 'invoice_no', width: 15 },
                          { key: 'product_abbr', width: 18 },
                          { key: 'product_price', width: 10 },
                          { key: 'product_base_commision', width: 10 },
                          { key: 'product_qty', width: 10 },
                          { key: 'product_commisions', width: 10 },
                          { key: 'commisions_extra', width: 13 },
                          { key: 'total', width: 12 },
                          { key: 'totalx', width: 20 },
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

                        worksheet.getCell('A2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('B2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('C2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('D2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('E2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('G2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('H2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('I2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('J2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


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


                        let counter = 3;
                        for (let index = 0; index < report_data_detail_t.length; index++) {
                          const rowElement = report_data_detail_t[index];
                          let value_sd = 0;
                            for (let idx = 0; idx < report_data_com_from1.length; idx++) {
                              const elementFrom = report_data_com_from1[idx];
                              dateNow = parseInt(rowElement.dated.replaceAll('-','').replaceAll('-','').replaceAll('-',''));
                              dateFrom = parseInt(elementFrom.dated.replaceAll('-','').replaceAll('-','').replaceAll('-',''));
                              if(elementFrom.id == rowElement.id && dateNow>=dateFrom){
                                value_sd = value_sd + parseFloat(elementFrom.total);
                              }
                            }
                            
                            worksheet.addRow({
                              dated : rowElement.dated, 
                              invoice_no : ((rowElement.invoice_no.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll('####','##').replaceAll('##','\n'), 
                              product_abbr        : ((rowElement.product_abbr.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll('####','##').replaceAll('##','\n'), 
                              product_price       : ((rowElement.product_price.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll('####','##').replaceAll("####","##").replaceAll('##','\n'), 
                              product_base_commision : ((rowElement.product_base_commision.replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####", "##")).replaceAll('##','\n'), 
                              product_qty         : ((rowElement.product_qty.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              product_commisions  : ((rowElement.product_commisions.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              commisions_extra    : ((rowElement.commisions_extra.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              total : rowElement.total, 
                              totalx : value_sd, 
                            });
                            worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                            worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                            worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                            worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                            worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                            worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                            worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                            worksheet.getCell('I'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                            worksheet.getCell('J'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
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

                    // Loop Terapist

                    //XLSX.writeFile(workbook, "Presidents.xlsx", { compression: true });


                  
                    let filename = "Report_Commission_Cashier_"+(Math.floor(Date.now() / 1000)+".xlsx");
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