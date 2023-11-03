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
          padding: 5px;
          font-size: 12px;
          border: 1px solid #ddd;
          border-collapse: collapse;
        }
        th>.truncate, td>.truncate{
          width: auto;
          min-width: 0;
          max-width: 200px;
          display: inline-block;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
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

    

    <?php
     //43% - 57%
      $width_table = 100;
      if(count($counter_service)>14){
        $width_table = 100 + ((count($counter_service)-14)*5);
      }
    ?>

    <table width="<?= $width_table; ?>%">
      <tbody>
        <tr style="text-align: center;background-color:#FFA726;">
            <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
          <td colspan="2" style="width: 50%;">Laporan Harian</td>
        </tr>
        <tr style="background-color: chocolate;">
          <td>Tanggal : {{ Carbon\Carbon::parse(count($report_data_detail)>0?$report_data_detail[0]->dated:"")->format('d-m-Y')  }}</td>
          <td>Cabang  : {{ count($report_data_detail)>0?$report_data_detail[0]->branch_name:"" }}</td>
          <td>Shift   : All </td>
        </tr>
      </tbody>
    </table>

    <br>

    <table class="table table-striped" id="service_table" width="<?= $width_table; ?>%">
      <thead>
      <tr style="background-color:#FFA726;color:white;">
        <th scope="col"><div class="truncate">No</div></th>
        <th scope="col"><div class="truncate">Ruangan</div></th>
        <th><div class="truncate">Nama</div></th>
        <th scope="col"><div class="truncate">Jam Kerja</div></th>
        <th><div class="truncate">MU</div></th>
        @foreach($counter_service as $serv)
              <th  scope="col">
                <div class="">{{  $serv->product_abbr }}</div>
              </th>
        @endforeach
        @foreach($counter_extra as $serv)
              <th  scope="col">
                <div class="truncate">{{  $serv->product_abbr }}</div>
              </th>
        @endforeach
        <th scope="col"><div class="truncate">Bayar </div></th>
        <th scope="col"><div class="truncate">Produk</div></th>
        <th scope="col"><div class="truncate">Rp.</div></th>
        <th scope="col"><div class="truncate">Minuman</div></th>
        <th><div class="truncate">Keterangan</div></th>
      </tr>
      </thead>
      <tbody>
        
        <?php 
          $counter = 0;
          $total_payment = 0;
          $total_product_rp = 0;
          $total_product_qty = 0;
          $total_drink_rp = 0;
          $total_drink_qty = 0;
          $total_service_rp = 0;
          $total_service_qty = 0;
          $total_extra_rp = 0;
          $total_extra_qty = 0;
          ?>
        @foreach($report_data as $detail)
        <tr>
            <td style="text-align: left;"  width="50px">{{ $counter+1 }}</td>
            <td style="text-align: left;@php if($detail->shift_name =='SHIFT 1 PAGI') {  echo 'background-color:#fea8ff;'; } @endphp"><div class="truncate">{{ $detail->branch_room }}<br>{{ $detail->invoice_no }}</div></td>
            <td style="text-align: left;">{{ $detail->customers_name }}</td>
            <td style="text-align: left;"  width="30px">
              @php
                  $c = 1;
                  $sumconversion = 0;
                  $lastsch = "";
              @endphp
              <?php

              ?>
              <div class="truncate">
              @foreach($report_data_detail as $dio)
                  @if($dio->type_id==2 && $dio->executed_at!='' && $dio->invoice_no==$detail->invoice_no_full)
                  {{ \Carbon\Carbon::parse($dio->executed_at)->format('H:i') }} - {{ \Carbon\Carbon::parse($dio->executed_at)->add($dio->product_conversion.' minutes')->format('H:i') }}<br>
                  @endif
              @endforeach
            </div>
            </td>
            <td style="text-align: left;"><div class="truncate">{{ $detail->assigned_to_name }}</div></td>

            <?php 
              $nominal_service = 0; 
              $nominal_discount = 0; 
            ?>
            @foreach($counter_service as $serv)
            <?php $nominal_service = 0; ?>
            <?php $nominal_discount = 0; ?>
              @foreach($report_data_service as $dio)
                  @if($dio->invoice_no==$detail->invoice_no_full && $dio->type_id==2 && $dio->product_id==$serv->product_id)
                      <?php
                        $nominal_service = $nominal_service + $dio->sub_total;
                        $nominal_discount = $nominal_discount + $dio->discount;
                        $total_service_rp = $total_service_rp + $dio->sub_total;
                        $total_service_qty = $total_service_qty + $dio->product_qty;
                      ?>
                  @endif
              @endforeach
                <td style="text-align: left;">
                  <?php
                    if($nominal_service==0 && $nominal_discount>100){
                       echo "Free";
                    }else{
                      echo number_format(($nominal_service/1000),0,',','.');
                    }
                  ?>
                  
                </td>
            @endforeach

            <?php $nominal_extra = 0; ?>
            @foreach($counter_extra as $serv)
            <?php $nominal_extra = 0; ?>
              @foreach($report_data_service as $dio)
                  @if($dio->invoice_no==$detail->invoice_no_full && $dio->type_id==8 && $dio->product_id==$serv->product_id)
                      <?php
                        $nominal_extra = $nominal_extra + $dio->sub_total;
                        $total_extra_rp = $total_extra_rp + $dio->sub_total;
                        $total_extra_qty = $total_extra_qty + $dio->product_qty;
                      ?>
                  @endif
              @endforeach
                <td style="text-align: left;">
                  {{  number_format(($nominal_extra/1000),0,',','.') }}
                </td>
            @endforeach


            <td>
              <?php
                        $payment = $detail->payment_type;
                        if($payment == 'BANK 1 - Debit' || $payment == 'BCA - Debit'){
                          $payment = 'B1 D';
                        }else if($payment == 'BANK 1 - Kredit' || $payment == 'BCA - Kredit'){
                          $payment = 'B1 C';
                        }else if($payment == 'BANK 2 - Debit' || $payment == 'Mandiri - Debit'){
                          $payment = 'B2 D';
                        }else if($payment == 'BANK 2 - Kredit' || $payment == 'Mandiri - Kredit'){
                          $payment = 'B2 C';
                        }else if($payment == 'BANK 1 - Transfer' || $payment == 'Transfer'){
                          $payment = 'B1 TRF';
                        }else if($payment == 'BANK 2 - Transfer'){
                          $payment = 'B2 TRF';
                        }else if($payment == 'BANK 1 - QRIS' || $payment == 'QRIS'){
                          $payment = 'B1 QRIS';
                        }else if($payment == 'BANK 2 - QRIS'){
                          $payment = 'B2 QRIS';
                        }
                ?>
              {{ $payment }} <br> {{ number_format($detail->total_payment,1,',','.') }}
              <?php $total_payment = $total_payment + $detail->total_payment;  ?>
            </td>
            <td style="text-align: left;">
              <div class="truncate">
              @foreach($report_data_product as $dio)
                  @if($dio->type_id==1 && $dio->category_id<>26 && $dio->invoice_no==$detail->invoice_no_full)
                      {{ $dio->product_abbr }} / {{ $dio->product_qty }}
                      <?php
                          $total_product_rp = $total_product_rp + $dio->sub_total;
                          $total_product_qty = $total_product_qty + $dio->product_qty;
                      ?>
                  @endif
              @endforeach
              </div>
            </td>
            <td style="text-align: left;">
              <div class="truncate">
              @foreach($report_data_product as $dio)
                  @if($dio->type_id==1 && $dio->category_id<>26 && $dio->invoice_no==$detail->invoice_no_full)
                      {{ number_format(($dio->sub_total/1000),1,',','.') }}
                      <?php
                          $total_drink_rp = $total_drink_rp + $dio->sub_total;
                          $total_drink_qty = $total_drink_qty + $dio->product_qty;
                      ?>
                  @endif
              @endforeach
              </div>
            </td>
            <td style="text-align: left;">
              <div class="truncate">
              @foreach($report_data_product as $dio)
                  @if($dio->type_id==1 && $dio->category_id==26 && $dio->invoice_no==$detail->invoice_no_full)
                  {{ $dio->product_abbr }} / {{ $dio->product_qty }} / {{ number_format(($dio->sub_total/1000),1,',','.') }} <br>
                  @endif
              @endforeach
              </div>
            </td>
            <td style="text-align: left;"><div class="truncate">{{ $detail->voucher_code }}</div></td>
          </tr>
          <?php 
          $counter++;
          ?>
          @endforeach

          <tr>
            <th scope="col" width="2%" colspan="5">SUB TOTAL</th>
            @foreach($counter_service as $serv)
                  <th  scope="col">
                  {{   number_format(($serv->sum_val/1000),0,',','.') }} / {{   number_format(($serv->sum_qty),0,',','.') }}
                  </th>
            @endforeach
            @foreach($counter_extra as $serv)
                  <th  scope="col" >
                    {{   number_format(($serv->sum_val/1000),0,',','.') }} / {{   number_format(($serv->sum_qty),0,',','.') }}
                  </th>
            @endforeach
            <th scope="col">{{  number_format(($total_payment),1,',','.') }}</th>
            <th scope="col">{{  number_format(($total_product_qty),0,',','.') }}</th>
            <th scope="col">{{  number_format(($total_product_rp/1000),0,',','.') }}</th>
            <th scope="col">{{  number_format(($total_drink_rp/1000),1,',','.') }} / {{  number_format(($total_drink_qty),0,',','.') }}</th>
            <th  style="text-align: left;">
              <div class="truncate">
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
              @php echo "<br>"; @endphp 
              @php echo "Keluar :<br>"; @endphp 
              @foreach($petty_datas as $petty_data)
                  @if($petty_data->type == 'Produk - Keluar')
                    {{ $petty_data->abbr }} / ({{ $petty_data->qty }})  @php echo "<br>"; @endphp                       
                  @endif    
              @endforeach
              @php echo "<br>"; @endphp 

              @php echo "Masuk :<br>"; @endphp     
              @foreach($petty_datas as $petty_data)
                  @if($petty_data->type == 'Produk - Masuk')
                    {{ $petty_data->abbr }} / ({{ $petty_data->qty }})  @php echo "<br>"; @endphp                      
                  @endif    
              @endforeach
              </div>
            </th>
          </tr>

          <tr style="background-color:#FFA726;color:white;">
            <th scope="col" colspan="5">JUMLAH</th>
            <th  scope="col" colspan="<?= count($counter_service) ?>">
              {{  number_format(($total_service_rp/1000),0,',','.') }} / {{  number_format(($total_service_qty),0,',','.') }}
            </th>
            <th  scope="col" colspan="<?= count($counter_extra) ?>">
              {{  number_format(($total_extra_rp/1000),0,',','.') }} / {{  number_format(($total_extra_qty),0,',','.') }}
            </th>
            <th scope="col">{{  number_format(($total_payment),1,',','.') }}</th>
            <th scope="col" colspan="2">{{  number_format(($total_product_rp/1000),0,',','.') }} / {{  number_format(($total_product_qty),0,',','.') }}</th>
            <th scope="col">{{  number_format(($total_drink_rp/1000),1,',','.') }} / {{  number_format(($total_drink_qty),0,',','.') }}</th>
            <th>
              

            </th>
          </tr>

      </tbody>
    </table><br>

    <table width="<?= $width_table; ?>%">
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