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

    <button id="btn_export_xls" class="btn print printPageButton">Cetak XLS</button>
    <br>
    <br>

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
        <th scope="col"><div class="truncate">CHARGE LEBARAN</div></th>
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
          $total_cl_rp = 0;
          $total_cl_qty = 0;
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
                        if($dio->sub_total>1){
                          $nominal_service = $nominal_service + ($dio->sub_total - $dio->charge_lebaran);
                        }else{
                          $nominal_service = $nominal_service + ($dio->sub_total);
                        }
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
                      if($nominal_service==0){
                        echo number_format((($nominal_service)/1000),0,',','.');
                      }else{
                        echo number_format((($nominal_service)/1000),0,',','.');
                      }
                      
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


            <td style="text-align: left;">
               @php
                 if($detail->count_cl>0){
                    $total_cl_rp = $total_cl_rp + $detail->cl;
                    $total_cl_qty = $total_cl_qty + $detail->count_cl;
                 }
               @endphp
              {{  number_format(($detail->cl/1000),0,',','.') }}
            </td>

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
                      {{ $dio->product_abbr }} / {{ $dio->product_qty }} <br>
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
                      {{ number_format(($dio->sub_total/1000),1,',','.') }}  <br>
                      
                  @endif
              @endforeach
              </div>
            </td>
            <td style="text-align: left;">
              <div class="truncate">
              @foreach($report_data_product as $dio)
                  @if($dio->type_id==1 && $dio->category_id==26 && $dio->invoice_no==$detail->invoice_no_full)
                  {{ $dio->product_abbr }} / {{ $dio->product_qty }} / {{ number_format(($dio->sub_total/1000),1,',','.') }} <br>
                  <?php
                          $total_drink_rp = $total_drink_rp + $dio->sub_total;
                          $total_drink_qty = $total_drink_qty + $dio->product_qty;
                      ?>
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
                  {{   number_format((($serv->sum_val-$serv->sum_cl)/1000),0,',','.') }} / {{  number_format(($serv->sum_qty),0,',','.') }}
                  </th>
            @endforeach
            @foreach($counter_extra as $serv)
                  <th  scope="col" >
                    {{   number_format(($serv->sum_val/1000),0,',','.') }} / {{   number_format(($serv->sum_qty),0,',','.') }}
                  </th>
            @endforeach
            <th scope="col">{{  number_format(($total_cl_rp/1000),0,',','.') }} / {{  number_format(($total_cl_qty),0,',','.') }}</th>
            <th scope="col">{{  number_format(($total_payment),1,',','.') }}</th>
            <th scope="col">{{  number_format(($total_product_qty),0,',','.') }}</th>
            <th scope="col">{{  number_format(($total_product_rp/1000),1,',','.') }}</th>
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
              {{  number_format((($total_service_rp-$total_cl_rp)/1000),0,',','.') }} / {{  number_format(($total_service_qty),0,',','.') }}
            </th>
            @if(count($counter_extra)>0)
              <th  scope="col" colspan="<?= count($counter_extra) ?>">
                {{  number_format(($total_extra_rp/1000),0,',','.') }} / {{  number_format(($total_extra_qty),0,',','.') }}
              </th>
            @endif
            <th  scope="col" >
              {{  number_format(($total_cl_rp/1000),0,',','.') }} / {{  number_format(($total_cl_qty),0,',','.') }}
            </th>
            <th scope="col">{{  number_format(($total_payment),1,',','.') }}</th>
            <th scope="col" colspan="2">{{  number_format(($total_product_rp/1000),1,',','.') }} / {{  number_format(($total_product_qty),0,',','.') }}</th>
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

  <!-- use version 0.19.3 -->
 <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
 <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>   
 <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>   
 <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/accounting.js/0.4.1/accounting.min.js" integrity="sha512-LW+1GKW2tt4kK180qby6ADJE0txk5/92P70Oh5YbtD7heFlC0qFFtacvSnHG4bNXmLnZq5hNb2V70r5DzS/U+g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
   
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
        filter_begin_date_in : "{{ $filter_begin_date }}",
        filter_end_date_in : "{{ $filter_begin_date }}",
        filter_branch_id_in: "{{ $filter_branch_id }}",
        export : 'Export API',
      };

      $('#btn_export_xls').on('click',function(){
        const res = axios.get(url,{ params }, {
                    headers: {}
                  }).then(resp => {
                    filter_begin_date = resp.data.filter_begin_date;
                    filter_branch_id = resp.data.filter_branch_id;

                    report_data = resp.data.report_data;
                    report_data_detail = resp.data.report_data_detail;
                    report_data_product = resp.data.report_data_product;
                    report_data_service = resp.data.report_data_service;
                    counter_service = resp.data.counter_service;
                    counter_extra = resp.data.counter_extra;
                    out_datas_total = resp.data.out_datas_total;
                    out_datas_total_drink = resp.data.out_datas_total_drink;
                    out_datas_total_other = resp.data.out_datas_total_other;
                    petty_datas = resp.data.petty_datas;
                    settings = resp.data.settings;

                    var beginnewformat = resp.data.beginnewformat;
                    var endnewformat = resp.data.endnewformat;

                    let data_filtered = [];

                    data_filtered = [];

                        let worksheet = workbook.addWorksheet("Laporan Harian");

                        /*Column headers*/
                        worksheet.getRow(3).values = [
                          'No', 
                          'Ruangan', 
                          'Nama',
                          'Jam Kerja',
                          'MU',
                        ];
                        var charCounter = "F";
                        var str_prefix = "";

                        for (let index = 0; index < counter_service.length; index++) {
                          const element = counter_service[index];
                          if(element.type_id==2){
                            if(index==46){
                              charCounter = "A";
                              str_prefix = "B";
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }if(index==21){
                              charCounter = "A";
                              str_prefix = "A";
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }else{
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }
                        
                            charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                          }
                        }

                        for (let index = 0; index < counter_extra.length; index++) {
                          const element = counter_extra[index];
                          if(element.type_id==8){
                            if(index+(counter_service.length)==46){
                              charCounter = "A";
                              str_prefix = "B";
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }else if(index+(counter_service.length)==21){
                              charCounter = "A";
                              str_prefix = "A";
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }else{
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }
                        
                            charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                          }
                        }

                        var len_after = (counter_service.length)+(counter_extra.length)+6;
                        var str_prefix = "";

                        if(len_after>52){
                          str_prefix = "B";
                        }else if(len_after>26){
                          str_prefix = "A";
                        }

                        worksheet.getCell(str_prefix+charCounter+"3").value = "Charge Lebaran";
                        worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        if(len_after>52){
                          str_prefix = "B";
                        }else if(len_after>26){
                          str_prefix = "A";
                        }

                        charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                        worksheet.getCell(str_prefix+charCounter+"3").value = "Bayar";
                        worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        if(len_after>52){
                          str_prefix = "B";
                        }else if(len_after>26){
                          str_prefix = "A";
                        }

                        charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                        worksheet.getCell(str_prefix+charCounter+"3").value = "Produk";
                        worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        if(len_after>52){
                          str_prefix = "B";
                        }else if(len_after>26){
                          str_prefix = "A";
                        }

                        charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                        worksheet.getCell(str_prefix+charCounter+"3").value = "Rp.";
                        worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        if(len_after>52){
                          str_prefix = "B";
                        }else if(len_after>26){
                          str_prefix = "A";
                        }

                        charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                        worksheet.getCell(str_prefix+charCounter+"3").value = "Minuman";
                        worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        if(len_after>52){
                          str_prefix = "B";
                        }else if(len_after>26){
                          str_prefix = "A";
                        }


                        charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);

                        if(charCounter == "["){
                          charCounter = "A";
                          str_prefix = "A";
                        }
                        worksheet.getCell(str_prefix+charCounter+"3").value = "Keterangan";
                        worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                        worksheet.mergeCells('A1', 'E1');
                        worksheet.getCell('A1').value = 'Cabang : '+report_data_detail[0].branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('F1', 'J1');
                        worksheet.getCell('F1').value = 'Tgl : '+beginnewformat;
                        worksheet.getCell('F1').alignment = { vertical: 'middle', horizontal: 'center' };


                        worksheet.columns = [
                          { key: 'no', width: 12 },
                          { key: 'branch_room', width: 15 },
                          { key: 'customers_name', width: 18 },
                          { key: 'work_time', width: 15 },
                          { key: 'assigned_to_name', width: 10 },
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


                        let counter = 4;
                        let counterx = 1;
                        let charCounters = "F";
                        let total_product_rp = 0;
                        let total_product_qty = 0;
                        let total_service_rp = 0;
                        let total_service_qty = 0;
                        let total_extra_rp = 0;
                        let total_extra_qty = 0;
                        let total_drink_rp = 0;
                        let total_drink_qty = 0;
                        let total_payment = 0;
                        let total_cl = 0;
                        for (let index = 0; index < report_data.length; index++) {
                          const rowElement = report_data[index];
                            let value_sd = 0;
                            let executed_at = "";
                            charCounters = "F";

                            for (let index = 0; index < report_data_detail.length; index++) {
                              const element = report_data_detail[index];
                              if(element.type_id==2 && element.executed_at != '' && element.executed_at != null && element.invoice_no==rowElement.invoice_no_full){
                                console.log(element.executed_at);
                                executed_at = executed_at + ' \n ' + moment(element.executed_at, "HH:mm").format("HH:mm") + ' - ' + moment(element.executed_at, "HH:mm").add(element.product_conversion, 'minutes').format("HH:mm");
                              }
                            }

                            if(rowElement.shift_name=='SHIFT 1 PAGI' && counter>3){
                              worksheet.getCell('B'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'fea8ff'}};
                            }

                            worksheet.getCell('A'+counter).value = counterx;
                            worksheet.getCell('B'+counter).value = rowElement.branch_room + '\n' + rowElement.invoice_no;
                            worksheet.getCell('C'+counter).value = rowElement.customers_name;
                            worksheet.getCell('D'+counter).value = executed_at;
                            worksheet.getCell('E'+counter).value = rowElement.assigned_to_name;


                            var str_prefix = "";
                            for (let index = 0; index < counter_service.length; index++) {
                              const element = counter_service[index];
                              var nominal_service = 0;
                              var nominal_discount = 0;
                              //charCounters = "F";

                              for (let index_x = 0; index_x < report_data_service.length; index_x++) {
                                const d_element = report_data_service[index_x];

                                if(d_element.type_id==2 && element.product_id==d_element.product_id && d_element.invoice_no==rowElement.invoice_no_full){
                                  if(parseFloat(d_element.sub_total>1)){
                                    nominal_service = nominal_service + parseFloat(d_element.sub_total);
                                  }else{
                                    nominal_service = nominal_service + (parseFloat(d_element.sub_total)-parseFloat(d_element.charge_lebaran));
                                  }
                                  total_service_rp = total_service_rp + parseFloat(d_element.sub_total);
                                  total_service_qty = total_service_qty + parseFloat(d_element.product_qty);
                                }
                              }

                              if(index==46){
                                charCounters = "A";
                                str_prefix = "B";
                                if(nominal_service==0){
                                  worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed(parseFloat(nominal_service/1000), 0);
                                }else{
                                  worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed((parseFloat(nominal_service)/1000), 0);
                                }
                              }else if(index==21){
                                charCounters = "A";
                                str_prefix = "A";
                                if(nominal_service==0){
                                  worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed(parseFloat(nominal_service/1000), 0);
                                }else{
                                  worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed(parseFloat((parseFloat(nominal_service)/1000), 0);
                                }
                              }else{
                                if(nominal_service==0){
                                  worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed(parseFloat(nominal_service/1000), 0);
                                }else{
                                  worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed(parseFloat((parseFloat(nominal_service))/1000), 0);
                                }
                              }
                          
                              charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                            }



                            var str_prefix = "";
                            if(counter_service.length>52){
                              str_prefix = "B";
                            }else if(counter_service.length>=21){
                              str_prefix = "A";
                            }
                            for (let index = 0; index < counter_extra.length; index++) {
                              const element = counter_extra[index];
                              var nominal_extra = 0;
                              var nominal_discount = 0;
                              //charCounters = "F";

                              for (let index_x = 0; index_x < report_data_service.length; index_x++) {
                                const d_element = report_data_service[index_x];

                                if(d_element.type_id==8 && element.product_id==d_element.product_id && d_element.invoice_no==rowElement.invoice_no_full){
                                  nominal_extra = nominal_extra + parseFloat(d_element.sub_total);
                                  total_extra_rp = total_extra_rp + parseFloat(d_element.sub_total);
                                  total_extra_qty = total_extra_qty + parseFloat(d_element.product_qty);
                                }
                              }


                              if((index+parseInt(counter_service.length))==46){
                                charCounters = "A";
                                str_prefix = "B";
                                worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed(parseFloat(nominal_extra/1000), 0);
                              }else if((index+parseInt(counter_service.length))==21){
                                str_prefix = "A";
                                charCounters = "A";
                                worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed(parseFloat(nominal_extra/1000), 0);
                              }else{
                                worksheet.getCell(str_prefix+charCounters+counter).value = accounting.toFixed(parseFloat(nominal_extra/1000), 0);
                              }
                          
                              charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                            }

                            var len_after = (counter_service.length)+(counter_extra.length)+5;
                            var str_prefix = "";

                            if(len_after>52){
                              str_prefix = "B";
                            }else if(len_after>26){
                              str_prefix = "A";
                            }

                            if(charCounters == "["){
                                charCounters = "A";
                                str_prefix = "A";
                            }
                            worksheet.getCell(str_prefix+charCounters+counter).value = accounting.formatNumber(parseFloat(rowElement.cl/1000), 0, ".", ",");


                            var payment = rowElement.payment_type;
                            if(payment == 'BANK 1 - Debit' || payment == 'BCA - Debit'){
                              payment = 'B1 D';
                            }else if(payment == 'BANK 1 - Kredit' || payment == 'BCA - Kredit'){
                              payment = 'B1 C';
                            }else if(payment == 'BANK 2 - Debit' || payment == 'Mandiri - Debit'){
                              payment = 'B2 D';
                            }else if(payment == 'BANK 2 - Kredit' || payment == 'Mandiri - Kredit'){
                              payment = 'B2 C';
                            }else if(payment == 'BANK 1 - Transfer' || payment == 'Transfer'){
                              payment = 'B1 TRF';
                            }else if(payment == 'BANK 2 - Transfer'){
                              payment = 'B2 TRF';
                            }else if(payment == 'BANK 1 - QRIS' || payment == 'QRIS'){
                              payment = 'B1 QRIS';
                            }else if(payment == 'BANK 2 - QRIS'){
                              payment = 'B2 QRIS';
                            }

                            charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);


                            worksheet.getCell(str_prefix+charCounters+counter).value = payment + ' \n '+ accounting.formatNumber(parseFloat(rowElement.total_payment), 1, ".", ",");
                            total_payment = total_payment + parseFloat(rowElement.total_payment);
                            total_cl = total_cl + parseFloat(rowElement.cl);
                            worksheet.getCell(str_prefix+charCounters+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                            var nominal_product = 0;
                            var str_product = "";
                            var str_product_rp = "";

                            for (let index = 0; index < report_data_product.length; index++) {
                              const element = report_data_product[index];

                              if(element.type_id==1 && element.category_id!=26 && element.invoice_no==rowElement.invoice_no_full){
                                nominal_product = nominal_product + parseFloat(element.sub_total);
                                total_product_rp = total_product_rp + parseFloat(element.sub_total);
                                total_product_qty = total_product_qty + parseFloat(element.product_qty);
                                str_product = str_product + element.product_abbr + '/' + element.product_qty + ' \n ';
                                str_product_rp = str_product_rp + total_product_rp + ' \n ';
                              }
                            }

                            var nominal_drink = 0;
                            var str_drink = "";

                            for (let index = 0; index < report_data_product.length; index++) {
                              const element = report_data_product[index];

                              if(element.type_id==1 && element.category_id==26 && element.invoice_no==rowElement.invoice_no_full){
                                nominal_drink = nominal_drink + parseFloat(element.sub_total);
                                total_drink_rp = total_drink_rp + parseFloat(element.sub_total);
                                total_drink_qty = total_drink_qty + parseFloat(element.product_qty);
                                str_drink = str_drink + element.product_abbr + '/' + element.product_qty+ '/' + accounting.formatNumber(parseFloat(element.sub_total/1000), 1, ".", ",") + ' \n ';
                              }
                            }

                            charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                            worksheet.getCell(str_prefix+charCounters+counter).value = str_product;
                            worksheet.getCell(str_prefix+charCounters+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                            charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                            worksheet.getCell(str_prefix+charCounters+counter).value = accounting.formatNumber(parseFloat(str_product_rp/1000), 1, ".", ",");
                            worksheet.getCell(str_prefix+charCounters+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                            charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                            worksheet.getCell(str_prefix+charCounters+counter).value = str_drink;
                            worksheet.getCell(str_prefix+charCounters+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                            

                            charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                            if(charCounters == "["){
                                charCounters = "A";
                                str_prefix = "A";
                            }

                            worksheet.getCell(str_prefix+charCounters+counter).value = rowElement.voucher_code;
                            worksheet.getCell(str_prefix+charCounters+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                            if(charCounters == "["){
                                charCounters = "A";
                                str_prefix = "A";
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

                           
                            counterx++;
                         
                        }

                        worksheet.getRow((report_data.length+4)).font = { bold: true };
                        worksheet.mergeCells('A'+(report_data.length+4), 'E'+(report_data.length+4));
                        worksheet.getCell('A'+(report_data.length+4)).value = 'SUB TOTAL ';
                        worksheet.getCell('A'+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'center' };



                        worksheet.getRow((report_data.length+5)).font = { bold: true };
                        
                        worksheet.mergeCells('A'+(report_data.length+5), 'E'+(report_data.length+5));
                        worksheet.getCell('A'+(report_data.length+5)).value = 'JUMLAH ';
                        worksheet.getCell('A'+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('A'+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        var letter_until = 'F';
                        var str_pref = '';
                        for (let index = 0; index < (counter_service.length); index++) {
                          worksheet.getCell(letter_until+(report_data.length+4)).value = ''+accounting.formatNumber(parseFloat(counter_service[index].sum_val/1000), 0, ".", ",")+'/'+accounting.formatNumber(parseFloat(counter_service[index].sum_qty), 0, ".", ",");
                          worksheet.getCell(letter_until+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'center' };
                        
                          if(index==19){
                            letter_until = 'A';
                            str_pref = 'A';
                          }else{
                            letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);
                          }
                          
                        }

                        if(counter_service.length>0){
                          letter_until = String.fromCharCode(letter_until.charCodeAt(0) - 1);
                        }
                        worksheet.mergeCells('F'+(report_data.length+5), str_pref+letter_until+(report_data.length+5));
                        worksheet.getCell('F'+(report_data.length+5)).value = ''+accounting.formatNumber(parseFloat(total_service_rp/1000), 0, ".", ",")+'/'+accounting.formatNumber(parseFloat(total_service_qty), 0, ".", ",");
                        worksheet.getCell('F'+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('F'+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);
                        var letter_until_start = letter_until;
                        for (let index = 0; index < (counter_extra.length); index++) {
                          console.log(letter_until+(report_data.length+4));
                          worksheet.getCell(letter_until+(report_data.length+4)).value = ''+accounting.formatNumber(parseFloat(counter_extra[index].sum_val/1000), 0, ".", ",")+'/'+accounting.formatNumber(parseFloat(counter_extra[index].sum_qty), 0, ".", ",");
                          worksheet.getCell(letter_until+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'center' };
                        
                          if((counter_service.length+index)==35){
                            letter_until = 'A';
                            str_pref = 'B';
                          }else if((counter_service.length+index)==19){
                            letter_until = 'A';
                            str_pref = 'A';
                          }else{
                            letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);
                          }
                        }

                        if(counter_extra.length>0){
                          letter_until = String.fromCharCode(letter_until.charCodeAt(0) - 1);
                          worksheet.mergeCells(str_pref+letter_until_start+(report_data.length+5), str_pref+letter_until+(report_data.length+5));
                          worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).value = ''+accounting.formatNumber(parseFloat(total_extra_rp/1000), 0, ".", ",")+'/'+accounting.formatNumber(parseFloat(total_extra_qty), 0, ".", ",");
                          worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                          worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                          letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);
                        }
                        
                        
                        var letter_until_start = letter_until;
                        console.log(str_pref+letter_until_start+(report_data.length+4));    

                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+4)).value = ''+accounting.formatNumber(parseFloat(total_cl/1000), 0, ".", ",");
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).value = ''+accounting.formatNumber(parseFloat(total_cl/1000), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);
                        letter_until_start = letter_until;

                        console.log(str_pref+letter_until_start+(report_data.length+4));    


                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+4)).value = ''+accounting.formatNumber(parseFloat(total_payment), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).value = ''+accounting.formatNumber(parseFloat(total_payment), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);
                        letter_until_start = letter_until;  

                        worksheet.mergeCells(str_pref+letter_until_start+(report_data.length+4), str_pref+letter_until+(report_data.length+4));
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+4)).value = ''+accounting.formatNumber(parseFloat(total_product_qty), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'center' };

                      
                        worksheet.mergeCells(str_pref+letter_until_start+(report_data.length+5), str_pref+letter_until+(report_data.length+5));
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).value = ''+accounting.formatNumber(parseFloat(total_product_qty), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);
                        letter_until_start = letter_until;  

                        worksheet.mergeCells(str_pref+letter_until_start+(report_data.length+4), str_pref+letter_until+(report_data.length+4));
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+4)).value = ''+accounting.formatNumber(parseFloat(total_product_rp/1000), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'center' };

                      
                        worksheet.mergeCells(str_pref+letter_until_start+(report_data.length+5), str_pref+letter_until+(report_data.length+5));
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).value = ''+accounting.formatNumber(parseFloat(total_product_rp/1000), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell(str_pref+letter_until_start+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};



                        letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);

                        worksheet.getCell(str_pref+letter_until+(report_data.length+4)).value = ''+accounting.formatNumber(parseFloat(total_drink_rp/1000), 1, ".", ",")+'/'+accounting.formatNumber(parseFloat(total_drink_qty), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell(str_pref+letter_until+(report_data.length+5)).value = ''+accounting.formatNumber(parseFloat(total_drink_rp/1000), 1, ".", ",")+'/'+accounting.formatNumber(parseFloat(total_drink_qty), 1, ".", ",");
                        worksheet.getCell(str_pref+letter_until+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell(str_pref+letter_until+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        letter_until = String.fromCharCode(letter_until.charCodeAt(0) + 1);

                        var str_out = "";
                        for (let idx = 0; idx < out_datas_total_drink.length; idx++) {
                          const element = out_datas_total_drink[idx];
                          str_out = str_out + element.abbr + "/" + element.qty + "/" + accounting.formatNumber(parseFloat(element.total/1000), 1, ".", ",") + '\n';
                        }

                        for (let idx = 0; idx < out_datas_total_other.length; idx++) {
                          const element = out_datas_total_other[idx];
                          str_out = str_out + element.abbr + "/" + element.qty + "/" + accounting.formatNumber(parseFloat(element.total/1000), 1, ".", ",") + '\n';
                        }

                        for (let idx = 0; idx < out_datas_total.length; idx++) {
                          const element = out_datas_total[idx];
                          str_out = str_out + element.abbr + "/" + element.qty + "/" + accounting.formatNumber(parseFloat(element.total/1000), 1, ".", ",") + '\n';
                        }

                        str_out = str_out + '\n';
                        str_out = str_out + 'Keluar : \n';
                        for (let idx = 0; idx < petty_datas.length; idx++) {
                          const element = petty_datas[idx];
                          if(element.type="Produk - Keluar"){
                            str_out = str_out + element.abbr + "/" + element.qty + '\n';
                          }
                        }

                        str_out = str_out + '\n';
                        str_out = str_out + 'Masuk : \n';
                        for (let idx = 0; idx < petty_datas.length; idx++) {
                          const element = petty_datas[idx];
                          if(element.type="Produk - Masuk"){
                            str_out = str_out + element.abbr + "/" + element.qty + '\n';
                          }
                        }

                        if(letter_until == "["){
                          letter_until = "A";
                          str_pref = "A";
                        }


                        worksheet.getCell(str_pref+letter_until+(report_data.length+4)).value = str_out;
                        worksheet.getCell(str_pref+letter_until+(report_data.length+4)).alignment = { vertical: 'middle', horizontal: 'left' };
                        worksheet.getCell(str_pref+letter_until+(report_data.length+4)).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };


                        worksheet.getCell(str_pref+letter_until+(report_data.length+5)).value = '';
                        worksheet.getCell(str_pref+letter_until+(report_data.length+5)).alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell(str_pref+letter_until+(report_data.length+5)).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                        worksheet.eachRow({ includeEmpty: true }, function(row, rowNumber) {
                          row.eachCell({ includeEmpty: true }, function(cell, colNumber) {
                            cell.border = borderStyles;
                          });
                        });


                    // Loop Terapist

                    //XLSX.writeFile(workbook, "Presidents.xlsx", { compression: true });


                  
                    let filename = "Report_CloseDay_"+(Math.floor(Date.now() / 1000)+".xlsx");
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