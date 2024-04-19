<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Komisi Charge Lebaran</title>
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
          .pagebreak { page-break-before: always; } /* page-break-after works, as well */
        }
      </style>
   </head> 
   <body> 

    <button id="printPageButton" onClick="window.print();"  class="btn print printPageButton">Cetak Laporan Komisi</button>
    <button id="btn_export_xls" class="btn print printPageButton" style="display:none;">Cetak XLS</button>
    <button id="btn_export_xls" class="btn print printPageButton" style="display:none;">Cetak XLS</button>
    <button class="btn print printPageButton" id="btn_ex">Export XLS DETAIL PERAWATAN</button>
    <button class="btn print printPageButton" id="btn_ex_2">Export XLS TOTAL TERAPIS & KASIR</button>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <th style="width: 40%;">Laporan Charge Lebaran</th>
              <td style="width: 16%;font-size:10px;font-style: italic;">
                <label>Printed at : {{ \Carbon\Carbon::now() }}</label>
              </td>
          </tr>
        </tbody>
      </table>     
            
            {{-- Area Looping --}}
            <table class="table table-striped" id="table_ex" style="width:1800px">
              <thead>
                <tr style="background-color:#FFA726;color:black;">
                  <th colspan="7">Cabang : {{ count($report_data)>0?$report_data[0]->branch_name:'';  }}</th>
                </tr>
                <tr>
                  <td></td>
                </tr>
                <tr style="background-color:#FFA726;color:black;">
                  <th width="30px;" rowspan="2">NO</th>
                  <th scope="col"  style="width: 100px;"  rowspan="2">NAMA TERAPIS DAN KASIR</th>
                  @foreach ($dated_list as $dated_lists)
                      <th colspan="{{ $dated_lists->c_product }}">{{ $dated_lists->dated_format_m }}</th>
                        <th rowspan="2">SUB TOTAL</th>                        
                  @endforeach
                  <th rowspan="2">TOTAL</th>                        
                </tr>
                
                <tr style="background-color:#FFA726;color:black;">
                  @php $l_dated = ""; @endphp
                  @foreach ($service_list as $service_lists)
                      @if($l_dated != $service_lists->dated && $l_dated!="")
                          
                      @endif
                      <td>{{ $service_lists->abbr }}</td>
                      @php $l_dated = $service_lists->dated; @endphp
                  @endforeach
                </tr>
              </thead>
              <tbody>
                
                    <?php
                      $total_until = 0;
                      $counter = 1;
                    ?>

              @foreach ($report_data_terapist as $item)
                <tr style="">
                  <td  rowspan="2">@php echo $counter++; @endphp</td>
                  <td style="width: 300px">{{ $item->name }}</td>
                  @php $l_dated = "";$val_c=0;$val_all=0; @endphp
                  @foreach ($service_list as $service_lists)
                      @php $value = 0; @endphp
                      @if($l_dated != $service_lists->dated && $l_dated!="")
                          <th>{{ $val_c }}</th> 
                          @php $val_c=0; @endphp
                      @endif
                      @foreach ($report_data as $report_datas)
                          @if($report_datas->name == $item->name && $report_datas->dated==$service_lists->dated && $report_datas->product_id==$service_lists->product_id)
                             @php $value = $value + (int)(($report_datas->values_extra * $report_datas->qty)/1000); @endphp
                          @endif
                      @endforeach
                      <td>{{ $value }}</td>
                      @php $l_dated = $service_lists->dated;$val_c=$val_c+$value;$val_all=$val_all+$value; @endphp
                  @endforeach
                  <th>{{ $val_c }}</th> 
                  <th>{{ $val_all }}</th> 
                  
                </tr>
                <tr>
                  <td>{{ count($report_data_cashier)>0?$report_data_cashier[0]->cashier:''; }}</td>
                  @php $l_dated = "";$val_c=0;$val_all=0; @endphp
                  @foreach ($service_list as $service_lists)
                      @php $value = 0; @endphp
                      @if($l_dated != $service_lists->dated && $l_dated!="")
                          <th>{{ $val_c }}</th> 
                          @php $val_c=0; @endphp
                      @endif
                      @foreach ($report_data_c as $report_datas)
                          @if($report_datas->name == $item->name && $report_datas->dated==$service_lists->dated && $report_datas->product_id==$service_lists->product_id)
                             @php $value = $value + (int)(($report_datas->values_extra * $report_datas->qty)/1000); @endphp
                          @endif
                      @endforeach
                      <td>{{ $value }}</td>
                      @php $l_dated = $service_lists->dated;$val_c=$val_c+$value;$val_all=$val_all+$value; @endphp
                  @endforeach
                  <th>{{ $val_c }}</th> 
                  <th>{{ $val_all }}</th> 
                </tr>
              @endforeach

              <tr style="">
                <td colspan="2">TERAPIS</td>
                @php $tot_t = 0; @endphp
                @foreach ($dated_list as $dated_lists)
                    <th colspan="{{ $dated_lists->c_product }}"></th>
                    <th>{{ number_format($dated_lists->charge_lebaran/1000,0,".",",") }} </th>  
                    @php $tot_t = $tot_t + $dated_lists->charge_lebaran; @endphp
                @endforeach
                <th>{{ number_format($tot_t/1000,0,".",",") }}</th>  
              </tr>

              <tr style="">
                <td colspan="2">KASIR</td>
                @php $tot_t = 0; @endphp
                @foreach ($dated_list_c as $dated_lists)
                    <th colspan="{{ $dated_lists->c_product }}"></th>
                    <th>{{ number_format($dated_lists->charge_lebaran/1000,0,".",",") }} </th>  
                    @php $tot_t = $tot_t + $dated_lists->charge_lebaran; @endphp
                @endforeach
                <th>{{ number_format($tot_t/1000,0,".",",") }}</th>  
              </tr>

              <tr style="">
                <td colspan="2">GRAND TOTAL</td>
                @php $tot_t = 0;$c_cl=0; @endphp

                @for ($i=0;$i<count($dated_list);$i++)
                    <th colspan="{{ $dated_list[$i]->c_product }}"></th>
                    @php $c_cl=0; @endphp
                    @for ($j=0;$j<count($dated_list_c);$j++)
                      @php 
                        if($dated_list[i]->dated == $dated_list_c[i]->dated){
                          $c_cl = $dated_list_c[j]->charge_lebaran;
                        }
                      @endphp
                    @endfor
                    <th>{{ number_format(($dated_list[$i]->charge_lebaran+$c_cl)/1000,0,".",",") }} </th>  
                    @php $tot_t = $tot_t + ($dated_list[$i]->charge_lebaran+$c_cl); @endphp
                @endfor
                <th>{{ number_format($tot_t/1000,0,".",",") }}</th>  
              </tr>
              </tbody>
            </table>
            
              <div class="pagebreak"> </div>

          {{-- End Area Looping --}}

          </br>

          <table class="table table-striped"  id="table_t"  style="width:450px">
            <thead>
              <tr style="background-color:#FFA726;color:black;">
                <th colspan="{{ count($dated_list)+3 }}">TOTAL TERAPIS</th>
              </tr>
              <tr style="background-color:#FFA726;color:black;">
                <th width="20px;">NO</th>
                <th scope="col">NAMA TERAPIS</th>
                @foreach ($dated_list as $dated_lists)
                      <th   style="width: 30px;">{{ $dated_lists->dated_number }}</th>                        
                @endforeach
                <th  style="width: 30px;">TOTAL</th>                        
              </tr>
            </thead>
            <tbody>
              
                  <?php
                    $total_until = 0;
                    $counter = 1;
                  ?>

            @foreach ($report_data_terapist as $item)
              <tr style="">
                <td>@php echo $counter++;$val = 0 ; @endphp</td>
                <td style="width: 100px">{{ $item->name }}</td>
                @foreach ($dated_list as $dated_lists)
                  @php $value = 0; @endphp
                  @foreach ($report_data_terapist_det as $report_data_terapist_dets)
                      @if($report_data_terapist_dets->dated == $dated_lists->dated && $report_data_terapist_dets->user_id==$item->user_id)
                        @php $value = (int)(($report_data_terapist_dets->charge_lebaran)/1000); @endphp
                      @endif
                  @endforeach
                  <td>{{ $value }}</td> 
                  @php
                      $val = $val + $value;
                  @endphp
                @endforeach   
                <th>{{ $val }}</th> 
              </tr>
            @endforeach

            <tr style="">
              <td colspan="2">GRAND TOTAL</td>
              @php $tot_t = 0; @endphp
              @foreach ($dated_list as $dated_lists)
                  <th>{{ number_format($dated_lists->charge_lebaran/1000,0,".",",") }} </th>  
                  @php $tot_t = $tot_t + $dated_lists->charge_lebaran; @endphp
              @endforeach
              <th>{{ number_format($tot_t/1000,0,".",",") }}</th>  
            </tr>

            
            </tbody>
          </table>


        </br>

        <table class="table table-striped" id="table_c" style="width:450px">
          <thead>
            <tr style="background-color:#FFA726;color:black;">
              <th colspan="{{ count($dated_list)+3 }}">TOTAL KASIR</th>
            </tr>
            <tr style="background-color:#FFA726;color:black;">
              <th width="20px;">NO</th>
              <th scope="col">NAMA KASIR</th>
              @foreach ($dated_list as $dated_lists)
                    <th style="width: 30px;">{{ $dated_lists->dated_number }}</th>                        
              @endforeach
              <th  style="width: 30px;">TOTAL</th>                        
            </tr>
          </thead>
          <tbody>
            
                <?php
                  $total_until = 0;
                  $counter = 1;
                ?>

          @foreach ($report_data_cashier_s as $item)
            <tr style="">
              <td>@php echo $counter++;$val = 0 ; @endphp</td>
              <td style="width: 100px">{{ $item->name }}</td>
              @foreach ($dated_list as $dated_lists)
                @php $value = 0; @endphp
                @foreach ($report_data_cashier_det as $report_data_terapist_dets)
                    @if($report_data_terapist_dets->dated == $dated_lists->dated)
                      @php $value = (($report_data_terapist_dets->charge_lebaran/(count($report_data_cashier)>0?$report_data_cashier[0]->c_count:1))/1000); @endphp
                    @endif
                @endforeach
                <td>{{ number_format($value,1,',','.') }}</td> 
                @php
                    $val = $val + $value;
                @endphp
              @endforeach   
              <th>{{ $val }}</th> 
            </tr>
          @endforeach

          <tr style="">
            <td colspan="2">GRAND TOTAL</td>
            @php $tot_t = 0; @endphp
            @foreach ($dated_list_c as $dated_lists)
                <th>{{ number_format($dated_lists->charge_lebaran/1000,0,".",",") }} </th>  
                @php $tot_t = $tot_t + $dated_lists->charge_lebaran; @endphp
            @endforeach
            <th>{{ number_format($tot_t/1000,0,".",",") }}</th>  
          </tr>

          
          </tbody>
        </table>


          <input type="hidden" name="filter_begin_date" id="filter_begin_date" value="{{ $filter_begin_date }}">
          <input type="hidden" name="filter_begin_end" id="filter_begin_end" value="{{ $filter_begin_end }}">
          <input type="hidden" name="filter_branch_id" id="filter_branch_id" value="{{ $filter_branch_id }}">
          <input type="hidden" name="filter_terapist_in" id="filter_terapist_in" value="{{ $filter_terapist_in }}">
   </body> 
   <!-- use version 0.19.3 -->
   <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
   <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>   
   <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
   <!-- use xlsx.full.min.js from version 0.20.2 -->
    <script lang="javascript" src="https://cdn.sheetjs.com/xlsx-0.20.2/package/dist/xlsx.full.min.js"></script>
   <script type="text/javascript">
    //window.print();
    //const workbook = XLSX.utils.book_new();

    const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Kakiku System Apps';
    workbook.created = new Date();
    //workbook.modified = new Date();

    $(document).ready(function() {
      var url = "{{ route('reports.terapistdaily.search') }}";
      const params = {
        filter_begin_date_in : "{{ $filter_begin_date }}",
        filter_end_date_in : "{{ $filter_begin_end }}",
        filter_branch_id_in: "{{ $filter_branch_id }}",
        filter_terapist_in: "{{ $filter_terapist_in }}",
        export : 'Export Sum Charge API',
      };

      $('#btn_export_xls').on('click',function(){
        const res = axios.get(url,{ params }, {
                    headers: {}
                  }).then(resp => {
                  
                    var service_list = resp.data.service_list;
                    var dated_list_c = resp.data.dated_list_c;
                    var dated_list = resp.data.dated_list;
                    var report_data = resp.data.report_data;
                    var report_data_c = resp.data.report_data_c;
                    var report_data_terapist = resp.data.report_data_terapist;
                    var report_data_terapist_det = resp.data.report_data_terapist_det;
                    var report_data_cashier = resp.data.report_data_cashier;
                    var report_data_cashier_s = resp.data.report_data_cashier_s;
                    var filter_begin_date = resp.data.filter_begin_date;
                    var filter_begin_end = resp.data.filter_begin_end;
                    var filter_branch_id = resp.data.filter_branch_id;
                    var filter_terapist_in = resp.data.filter_terapist_in;
                    var begindate_f = resp.data.begindate_f;
                    var enddate_f = resp.data.enddate_f;

                    let data_filtered = [];
                    let worksheet = workbook.addWorksheet("DATA");

                    worksheet.getRow(1).values = ['LAPORAN EXTRA CHARGE LEBARAN'];
                    worksheet.getRow(3).values = ['Cabang',report_data[0].branch_name,'','','','Tgl',begindate_f,'-',enddate_f];

                    worksheet.getRow(1).font = { bold: true };
                    worksheet.getRow(3).font = { bold: true };
                    worksheet.getRow(5).font = { bold: true };

                    worksheet.mergeCells('A5', 'A6');
                    worksheet.getCell('A5').value = 'No';
                    worksheet.getCell('A5').alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.mergeCells('B5', 'B6');
                    worksheet.getCell('B5').value = 'NAMA TERAPIS DAN KASIR';
                    worksheet.getCell('B5').alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('A1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                    worksheet.getCell('A3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                    worksheet.getCell('B3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                    worksheet.getCell('F3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                    worksheet.getCell('G3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                    worksheet.getCell('H3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                    worksheet.getCell('I3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                    worksheet.getCell('A5').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                    worksheet.getCell('B5').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                    var charCounter = "C";
                    var rowCounter = 5;
                    var str_prefix = "";
                    var counterC = 3;

                    for (let index = 0; index < dated_list.length; index++) {
                        const rowElement = dated_list[index];
                        if(index==46){
                          charCounter = "A";
                          str_prefix = "B";
                        }else if(index==24){
                          charCounter = "A";
                          str_prefix = "A";
                        }
                        worksheet.getCell(str_prefix+charCounter+5).value = rowElement.dated_format_m;
                        worksheet.getCell(str_prefix+charCounter+5).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell(str_prefix+charCounter+5).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                        charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                        counterC = counterC + 1;

                        if(charCounter=="["){
                          charCounter = "A";
                          str_prefix = "A";
                        }
                    }

                    rowCounter++;
                    charCounter = "C";
                    str_prefix = "";
                    l_dated = "";

                    for (let index = 0; index < service_list.length; index++) {
                        const rowElement = service_list[index];
                        if(index==46){
                          str_prefix = "B";
                        }else if(index==24){
                          str_prefix = "A";
                        }

                        if(l_dated!="" && l_dated!=rowElement.dated){
                          worksheet.getCell(str_prefix+charCounter+rowCounter).value = "SUB TOTAL";
                          worksheet.getCell(str_prefix+charCounter+rowCounter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                          worksheet.getCell(str_prefix+charCounter+rowCounter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                          charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                        counterC = counterC + 1;
                        }

                        l_dated = rowElement.dated;

                        

                        worksheet.getCell(str_prefix+charCounter+rowCounter).value = rowElement.abbr;
                        worksheet.getCell(str_prefix+charCounter+rowCounter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell(str_prefix+charCounter+rowCounter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                        charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                        counterC = counterC + 1;

                        if(charCounter=="["){
                          charCounter = "A";
                        }
                    }

                    charCounter = "A";
                    str_prefix = "";
                    rowCounter++;

                    for (let index = 0; index < report_data_terapist.length; index++) {
                        charCounter = "A";
                       
                        const rowElement = report_data_terapist[index];
                        worksheet.getCell(str_prefix+charCounter+rowCounter).value = index+1;
                        worksheet.getCell(str_prefix+charCounter+rowCounter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                        charCounter = String.fromCharCode(charCounter.charCodeAt(0) + 1);
                        counterC = counterC + 1;

                        if(charCounter=="["){
                          charCounter = "A";
                          str_prefix = "A";
                        }

                        worksheet.getCell(str_prefix+charCounter+rowCounter).value = rowElement.name;
                        worksheet.getCell(str_prefix+charCounter+rowCounter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                        rowCounter++;
                        
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
                  
                    let filename = "Report_Commission_Charge_Lebaran_"+(Math.floor(Date.now() / 1000)+".xlsx");
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

    let report_data_detail_t = [];
    let report_data_com_from1 = [];
    let report_data_terapist = [];

    function html_table_to_excel(type, cmd)
    {
        if(cmd==1){
          var data_ex = document.getElementById('table_ex');

          var file = XLSX.utils.table_to_book(data_ex, {sheet: "GABUNGAN"});
          XLSX.write(file, { bookType: type, bookSST: true, type: 'base64' });
          let filename = "Report_Commission_Charge_Lebaran_GABUNGAN_"+(Math.floor(Date.now() / 1000));
          XLSX.writeFile(file, filename +"." + type);
        }else{
          var data_t = document.getElementById('table_t');
          var data_c = document.getElementById('table_c');

          let worksheet_tmp2 = XLSX.utils.table_to_sheet(data_t);
          let worksheet_tmp3 = XLSX.utils.table_to_sheet(data_c);

          let b = XLSX.utils.sheet_to_json(worksheet_tmp2, { header: 1 })
          let c = XLSX.utils.sheet_to_json(worksheet_tmp3, { header: 1 })
              
          //a = a.concat(['']).concat(b).concat(['']).concat(c)
          b = b.concat(['']).concat(c)
            
          let worksheet_2 = XLSX.utils.json_to_sheet(b, { skipHeader: true })
          
          const new_workbook = XLSX.utils.book_new()
          XLSX.utils.book_append_sheet(new_workbook, worksheet_2, "worksheet_2")

          let filename_s = "Report_Commission_Charge_Lebaran_PISAH_"+(Math.floor(Date.now() / 1000));
          XLSX.writeFile(new_workbook, filename_s +"." + type)
        }
        


        
    }

    $('#btn_ex').on('click',function(){
      html_table_to_excel('xlsx',1);
    });
    $('#btn_ex_2').on('click',function(){
      html_table_to_excel('xlsx',2);
    });
 </script>
</html> 