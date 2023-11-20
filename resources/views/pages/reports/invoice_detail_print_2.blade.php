<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Summary Perawatan</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          padding: 2px;
          font-size: 12px;
          border: 1px solid #ddd;
          border-collapse: collapse;
        }
        td, th {
            border: .01px solid black;
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
        $width_table = 100 + (((count($counter_service)+count($counter_salon)+count($counter_extra)+count($counter_drink)+count($counter_product))-14)*6);
      }
    ?>

    <button id="btn_export_xls"  class="btn print printPageButton">Cetak XLS</button>
    <br>
    <br>
    <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;">Cabang  : {{ count($report_data_detail)>0?$report_data_detail[0]->branch_name:"" }}</td>
            <td colspan="2" style="width: 50%;">Laporan Summary Perawatan</td>
          </tr>
          <tr style="background-color: chocolate;">
          </tr>
          <tr>
            <td colspan="3">
            </td>
          </tr>
        </tbody>
      </table>

      <br>

      <table class="table table-striped" id="service_table"  width="<?= $width_table; ?>%">
        <thead>
          <tr style="background-color:#FFA726;color:white;">
            <th scope="col" width="100px" rowspan="2">Tgl</th>
            <th scope="col" width="100px" rowspan="2">Qty W</th>
            <th scope="col" width="100px" rowspan="2">Qty P</th>
            <th scope="col" width="100px" rowspan="2">Qty</th>
            <th scope="col" colspan="<?= count($counter_service); ?>">
              <div class="">Perawatan</div>
            </th>
            <th scope="col" width="100px" rowspan="2" >Cases Perawatan</th>
            <th scope="col" colspan="<?= count($counter_salon); ?>">
              <div class="">Salon</div>
            </th>
            <th scope="col" width="100px" rowspan="2">Cases Salon</th>
            <th scope="col" colspan="<?= count($counter_extra); ?>">
              <div class="">Extra</div>
            </th>
            <th scope="col" width="100px" rowspan="2">Cases Extra</th>
            <th scope="col" colspan="<?= count($counter_product); ?>">
              <div class="">Produk</div>
            </th>
            <th scope="col" width="100px" rowspan="2">Cases Produk</th>
            <th scope="col" colspan="<?= count($counter_drink); ?>">
              <div class="">Minuman</div>
            </th>
            <th scope="col" width="100px" rowspan="2">Cases Minuman</th>


          </tr>
          <tr style="background-color:#FFA726;color:white;">
            @foreach($counter_service as $serv)
                  <th  scope="col">
                    <div class="">{{  $serv->product_abbr }}</div>
                  </th>
            @endforeach
            @foreach($counter_salon as $ext)
                  <th  scope="col">
                    <div class="">{{  $ext->product_abbr }}</div>
                  </th>
            @endforeach
            @foreach($counter_extra as $ext)
                  <th  scope="col">
                    <div class="">{{  $ext->product_abbr }}</div>
                  </th>
            @endforeach
            @foreach($counter_product as $ext)
                  <th  scope="col">
                    <div class="">{{  $ext->product_abbr }}</div>
                  </th>
            @endforeach
            @foreach($counter_drink as $ext)
                  <th  scope="col">
                    <div class="">{{  $ext->product_abbr }}</div>
                  </th>
            @endforeach


          </tr>
        </thead>
        <tbody>
          @php
            $total_qty = 0;
            $total_service_qty = 0; 
            $counter = 0;   
            $counterall = 0;   
            $counter_spk = 0;
            $divider_page = 17;
            $c_p=0; 
            $t_p=0; 
            $c_pn=0;

          @endphp

            @foreach($report_data as $detail)
                  <tr>
                      <td style="text-align: left;">{{ $detail->dated }}</td>
                      <td style="text-align: left;">{{ $detail->qty_w }}</td>
                      <td style="text-align: left;">{{ $detail->qty_p }}</td>
                      <td style="text-align: left;">{{ ($detail->qty_p+$detail->qty_w) }}</td>

                      @foreach($counter_service as $serv)
                        <?php $total_service_qty=0; ?>
                          @foreach($report_data_service as $dio)
                              @if($dio->dated==$detail->dated && $dio->product_id==$serv->product_id)
                                  <?php
                                    $total_service_qty = $total_service_qty + $dio->qty_total;
                                  ?>
                              @endif
                          @endforeach
                            <td style="text-align: left;">
                              <?php
                                  echo number_format(($total_service_qty),0,',','.');
                              ?>
                              
                            </td>
                      @endforeach

                      <td style="text-align: center;">{{ $detail->qty_total }}</td>

                      @foreach($counter_salon as $ext)
                        <?php $total_salon_qty=0; ?>
                          @foreach($report_data_service as $dio)
                              @if($dio->dated==$detail->dated && $dio->product_id==$ext->product_id)
                                  <?php
                                    $total_salon_qty = $total_salon_qty + $dio->qty_total;
                                  ?>
                              @endif
                          @endforeach
                            <td style="text-align: left;">
                              <?php
                                  echo number_format(($total_salon_qty),0,',','.');
                              ?>
                              
                            </td>
                      @endforeach
                  
                      <td style="text-align: center;">{{ $detail->qty_total_salon }}</td>

                      @foreach($counter_extra as $ext)
                        <?php $total_extra_qty=0; ?>
                          @foreach($report_data_service as $dio)
                              @if($dio->dated==$detail->dated && $dio->product_id==$ext->product_id)
                                  <?php
                                    $total_extra_qty = $total_extra_qty + $dio->qty_total;
                                  ?>
                              @endif
                          @endforeach
                            <td style="text-align: left;">
                              <?php
                                  echo number_format(($total_extra_qty),0,',','.');
                              ?>
                              
                            </td>
                      @endforeach
                      <td style="text-align: center;">{{ $detail->qty_total_extra }}</td>

                      @foreach($counter_product as $ext)
                        <?php $total_product_qty=0; ?>
                          @foreach($report_data_service as $dio)
                              @if($dio->dated==$detail->dated && $dio->product_id==$ext->product_id)
                                  <?php
                                    $total_product_qty = $total_product_qty + $dio->qty_total;
                                  ?>
                              @endif
                          @endforeach
                            <td style="text-align: left;">
                              <?php
                                  echo number_format(($total_product_qty),0,',','.');
                              ?>
                              
                            </td>
                      @endforeach
                      <td style="text-align: center;">{{ $detail->qty_total_product }}</td>

                      @foreach($counter_drink as $ext)
                        <?php $total_drink_qty=0; ?>
                          @foreach($report_data_service as $dio)
                              @if($dio->dated==$detail->dated && $dio->product_id==$ext->product_id)
                                  <?php
                                    $total_drink_qty = $total_drink_qty + $dio->qty_total;
                                  ?>
                              @endif
                          @endforeach
                            <td style="text-align: left;">
                              <?php
                                  echo number_format(($total_drink_qty),0,',','.');
                              ?>
                              
                            </td>
                      @endforeach
                      <td style="text-align: center;">{{ $detail->qty_total_drink }}</td>

                </tr>
                @php
                 $counter++;
                 $counterall++;
                @endphp
           @endforeach
                <tr>
                  <th>JUMLAH</th>
                  <th scope="col" width="100px">{{ number_format($report_data_total[0]->qty_w,0,',','.') }}</th>
                  <th scope="col" width="100px">{{ number_format($report_data_total[0]->qty_p,0,',','.') }}</th>
                  <th scope="col" width="100px">{{ number_format(($report_data_total[0]->qty_p+$report_data_total[0]->qty_w),0,',','.') }}</th>
                  
                  @foreach($counter_service as $serv)
                  <th  scope="col">
                    <?php
                        echo number_format(($serv->sum_qty),0,',','.');
                    ?>
                  </th>
                  @endforeach

                  <th scope="col" width="100px">{{ number_format($report_data_total[0]->qty_total,0,',','.') }}</th>

                  @foreach($counter_salon as $serv)
                  <th  scope="col">
                    <?php
                        echo number_format(($serv->sum_qty),0,',','.');
                    ?>
                  </th>
                  @endforeach

                  <th scope="col" width="100px">{{ number_format($report_data_total[0]->qty_total_salon,0,',','.') }}</th>

                  @foreach($counter_extra as $ext)
                  <th  scope="col">
                    <?php
                        echo number_format(($ext->sum_qty),0,',','.');
                    ?>
                  </th>
                  @endforeach

                  
                  
                  <th scope="col" width="100px">{{ number_format($report_data_total[0]->qty_total_extra,0,',','.') }}</th>

                  @foreach($counter_product as $ext)
                  <th  scope="col">
                    <?php
                        echo number_format(($ext->sum_qty),0,',','.');
                    ?>
                  </th>
                  @endforeach
                  <th scope="col" width="100px">{{ number_format($report_data_total[0]->qty_total_product,0,',','.') }}</th>

                  @foreach($counter_drink as $ext)
                  <th  scope="col">
                    <?php
                        echo number_format(($ext->sum_qty),0,',','.');
                    ?>
                  </th>
                  @endforeach
                  <th scope="col" width="100px">{{ number_format($report_data_total[0]->qty_total_drink,0,',','.') }}</th>
                </tr>
        </tbody>
      </table>

      <br>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: left;background-color:#white;">
            <td style="width: 100%;font-size:10px;font-style: italic;">
              <label>Printed at : {{ \Carbon\Carbon::now() }}</label>
            </td>
          </tr>
        </tbody>
      </table>


          <input type="hidden" name="filter_begin_date" id="filter_begin_date" value="{{ $filter_begin_date }}">
          <input type="hidden" name="filter_begin_end" id="filter_begin_end" value="{{ $filter_begin_end }}">
          <input type="hidden" name="filter_branch_id" id="filter_branch_id" value="{{ $filter_branch_id }}">

   </body> 

   <!-- use version 0.19.3 -->
   <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
   <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>   
   <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/accounting.js/0.4.1/accounting.min.js" integrity="sha512-LW+1GKW2tt4kK180qby6ADJE0txk5/92P70Oh5YbtD7heFlC0qFFtacvSnHG4bNXmLnZq5hNb2V70r5DzS/U+g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

   <script type="text/javascript">
    //window.print();
    //const workbook = XLSX.utils.book_new();

    const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Kakiku System Apps';
    workbook.created = new Date();
    //workbook.modified = new Date();

    function nextChar(c) {
        return String.fromCharCode(c.charCodeAt(0) + 1);
    }
  
    $(document).ready(function() {
      var url = "{{ route('reports.invoicedetail.search') }}";
      const params = {
        filter_begin_date_in : "{{ $filter_begin_date }}",
        filter_end_date_in : "{{ $filter_begin_end }}",
        filter_branch_id_in: "{{ $filter_branch_id }}",
        export : 'Export Total APIs',
      };

      $('#btn_export_xls').on('click',function(){
        const res = axios.get(url,{ params }, {
                    headers: {}
                  }).then(resp => {
                    report_datas = resp.data.report_data;
                    report_data_total = resp.data.report_data_total;
                    report_data_total = resp.data.report_data_total;
                    
                    counter_service = resp.data.counter_service;
                    counter_extra = resp.data.counter_extra;
                    report_data_service = resp.data.report_data_service;
                    report_data_detail = resp.data.report_data_detail;
                    report_data_detail_total = resp.data.report_data_detail_total;

                    var beginnewformat = resp.data.filter_begin_date;
                    var endnewformat = resp.data.filter_begin_end;

                    let worksheet = workbook.addWorksheet("Worksheet");

                        worksheet.mergeCells('A1', 'E1');
                        worksheet.getCell('A1').value = 'Cabang : '+report_data_detail[0].branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('K1', 'O1');
                        worksheet.getCell('K1').value = 'Tgl : '+beginnewformat+' sd '+endnewformat;
                        worksheet.getCell('K1').alignment = { vertical: 'middle', horizontal: 'center' };



                        worksheet.getCell('A3').value = 'Tgl';
                        worksheet.getCell('A3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('B3').value = 'Qty Wanita';
                        worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('C3').value = 'Qty Pria';
                        worksheet.getCell('C3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('D3').value = 'Qty';
                        worksheet.getCell('D3').alignment = { vertical: 'middle', horizontal: 'center' };


                        var charCounter = "E";
                        var str_prefix = "";

                        for (let index = 0; index < counter_service.length; index++) {
                          const element = counter_service[index];
                          if(element.type_id==2){
                            if(index==48){
                              str_prefix = "B";
                              charCounter = "A";
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }else if(index==22){
                              str_prefix = "A";
                              charCounter = "A";
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }else{
                              worksheet.getCell(str_prefix+charCounter+"3").value = element.product_abbr;
                              worksheet.getCell(str_prefix+charCounter+"3").fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                            }
                        
                            charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                          }
                        }

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
                        worksheet.getCell('A3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('B3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('C3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('D3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('E3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                      
                    // Loop Terapist
                    
                    // End loop header

                    if(charCounter=='['){
                      str_prefix = "A";
                      charCounter = "A";
                    }
                    worksheet.getCell(str_prefix+charCounter+'3').value = 'Case Perawatan';
                    worksheet.getCell(str_prefix+charCounter+'3').alignment = { vertical: 'middle', horizontal: 'center' };
                    worksheet.getCell(str_prefix+charCounter+'3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                    charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                    if(charCounter=='['){
                      str_prefix = "A";
                      charCounter = "A";
                    }
                    worksheet.getCell(str_prefix+charCounter+'3').value = 'Case Salon';
                    worksheet.getCell(str_prefix+charCounter+'3').alignment = { vertical: 'middle', horizontal: 'center' };
                    worksheet.getCell(str_prefix+charCounter+'3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                    charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                    console.log(charCounter);
                    if(charCounter=='['){
                      str_prefix = "A";
                      charCounter = "A";
                    }
                    worksheet.getCell(str_prefix+charCounter+'3').value = 'Case Extra';
                    worksheet.getCell(str_prefix+charCounter+'3').alignment = { vertical: 'middle', horizontal: 'center' };
                    worksheet.getCell(str_prefix+charCounter+'3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                    charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                    if(charCounter=='['){
                      str_prefix = "A";
                      charCounter = "A";
                    }
                    worksheet.getCell(str_prefix+charCounter+'3').value = 'Case Produk';
                    worksheet.getCell(str_prefix+charCounter+'3').alignment = { vertical: 'middle', horizontal: 'center' };
                    worksheet.getCell(str_prefix+charCounter+'3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                    charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                    console.log(charCounter);
                    if(charCounter=='['){
                      str_prefix = "A";
                      charCounter = "A";
                    }
                    worksheet.getCell(str_prefix+charCounter+'3').value = 'Case Minuman';
                    worksheet.getCell(str_prefix+charCounter+'3').alignment = { vertical: 'middle', horizontal: 'center' };
                    worksheet.getCell(str_prefix+charCounter+'3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                    var countery = 4;
                    report_datas.forEach(element => {
                         worksheet.getCell('A'+countery).value = element.dated;
                         worksheet.getCell('A'+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                         worksheet.getCell('B'+countery).value = element.qty_w;
                         worksheet.getCell('B'+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                         worksheet.getCell('C'+countery).value = element.qty_p;
                         worksheet.getCell('C'+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                         worksheet.getCell('D'+countery).value = (element.qty_w+element.qty_p);
                         worksheet.getCell('D'+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                         var charCounters = "E";
                        var str_prefix = "";


                        var total_service_qty = 0;

                         for (let index = 0; index < counter_service.length; index++) {
                            const elementd = counter_service[index];
                          //charCounters = "F";
                          total_service_qty = 0;

                          for (let index_x = 0; index_x < report_data_service.length; index_x++) {
                            const d_element = report_data_service[index_x];

                            if(d_element.dated==element.dated && elementd.product_id==d_element.product_id ){
                              total_service_qty = total_service_qty + parseFloat(d_element.qty_total);
                            }
                          }

                          if(index==48){
                            charCounters = "A";
                            str_prefix = "B";
                            worksheet.getCell(str_prefix+charCounters+countery).value = accounting.toFixed(parseFloat(total_service_qty), 0);
                          }else if(index==22){
                            charCounters = "A";
                            str_prefix = "A";
                            worksheet.getCell(str_prefix+charCounters+countery).value = accounting.toFixed(parseFloat(total_service_qty), 0);
                          }else{
                            worksheet.getCell(str_prefix+charCounters+countery).value = accounting.toFixed(parseFloat(total_service_qty), 0);
                          }
                      
                          charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                        }
                        

                        worksheet.getCell(str_prefix+charCounters+countery).value = (element.qty_total);
                        worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                        charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                        if(charCounters=='['){
                          str_prefix = "A";
                          charCounters = "A";
                        }
                        worksheet.getCell(str_prefix+charCounters+countery).value = (element.qty_total_salon);
                        worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                        charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                        if(charCounters=='['){
                          str_prefix = "A";
                          charCounters = "A";
                        }
                        worksheet.getCell(str_prefix+charCounters+countery).value = (element.qty_total_extra);
                        worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                        
                        charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                        if(charCounters=='['){
                          str_prefix = "A";
                          charCounters = "A";
                        }
                        worksheet.getCell(str_prefix+charCounters+countery).value = (element.qty_total_product);
                        worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                        charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                        if(charCounters=='['){
                          str_prefix = "A";
                          charCounters = "A";
                        }
                        worksheet.getCell(str_prefix+charCounters+countery).value = (element.qty_total_drink);
                        worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                        countery++;

                    });
                    // End loop header


                    worksheet.getCell('A'+countery).value = 'JUMLAH';
                    worksheet.getCell('A'+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('B'+countery).value = report_data_total[0].qty_w;
                    worksheet.getCell('B'+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('C'+countery).value = report_data_total[0].qty_p;
                    worksheet.getCell('C'+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('D'+countery).value = (report_data_total[0].qty_w+report_data_total[0].qty_p);
                    worksheet.getCell('D'+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getRow(countery).font = { bold: true };

                    var charCounters = "E";
                        var str_prefix = "";
                    for (let index = 0; index < counter_service.length; index++) {
                            const elementd = counter_service[index];
                          //charCounters = "F";
                          total_service_qty = 0;

                          if(index==48){
                            charCounters = "A";
                            str_prefix = "B";
                            worksheet.getCell(str_prefix+charCounters+countery).value = accounting.toFixed(parseFloat(elementd.sum_qty), 0);
                            worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                          }else if(index==22){
                            charCounters = "A";
                            str_prefix = "A";
                            worksheet.getCell(str_prefix+charCounters+countery).value = accounting.toFixed(parseFloat(elementd.sum_qty), 0);
                            worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                          }else{
                            worksheet.getCell(str_prefix+charCounters+countery).value = accounting.toFixed(parseFloat(elementd.sum_qty), 0);
                            worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          }
                      
                          charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                        }
                        
                    worksheet.getCell(str_prefix+charCounters+countery).value = report_data_total[0].qty_total;
                    worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                    charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                    if(charCounters=='['){
                      str_prefix = "A";
                      charCounters = "A";
                    }
                    worksheet.getCell(str_prefix+charCounters+countery).value = report_data_total[0].qty_total_salon;
                    worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                    if(charCounters=='['){
                      str_prefix = "A";
                      charCounters = "A";
                    }
                    worksheet.getCell(str_prefix+charCounters+countery).value = report_data_total[0].qty_total_extra;
                    worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                    
                    charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                    if(charCounters=='['){
                      str_prefix = "A";
                      charCounters = "A";
                    }
                    worksheet.getCell(str_prefix+charCounters+countery).value = report_data_total[0].qty_total_product;
                    worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    charCounters = String.fromCharCode(charCounters.charCodeAt(0) + 1);
                    if(charCounters=='['){
                      str_prefix = "A";
                      charCounters = "A";
                    }
                    worksheet.getCell(str_prefix+charCounters+countery).value = report_data_total[0].qty_total_drink;
                    worksheet.getCell(str_prefix+charCounters+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    let filename = "Report_Summary_Faktur_"+(Math.floor(Date.now() / 1000)+".xlsx");
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