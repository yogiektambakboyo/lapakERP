<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Komisi Terapist</title>
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
    <button id="btn_export_xls" class="btn print printPageButton">Cetak XLS</button>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <th style="width: 40%;">Laporan Komisi Terapist</th>
              <td style="width: 16%;font-size:10px;font-style: italic;">
                <label>Printed at : {{ \Carbon\Carbon::now() }}</label>
              </td>
          </tr>
        </tbody>
      </table>     

      <?php
          foreach($report_data_terapist as $report_data_terapistx){ 
      ?>
            
            {{-- Area Looping --}}
            <table class="table table-striped" style="width: 100%">
              <thead>
                <tr style="background-color:#FFA726;color:black;">
                  <th colspan="7">Cabang : {{ $report_data_terapistx->branch_name  }}</th>
                  <th colspan="8">Mitra Usaha : {{ $report_data_terapistx->name  }}</th>
                </tr>
                <tr style="background-color:#FFA726;color:black;">
                  <th rowspan="2" width="6%">Tgl</th>
                  <th rowspan="2" width="5%">No Faktur</th>
                  <th colspan="3">Perawatan</th>
                  <th colspan="2">Poin</th>
                  <th colspan="5">Produk</th>
                  <th rowspan="2" width="5%">Extra Charge</th>
                  <th colspan="2">Total</th>
                </tr>
                <tr style="background-color:#FFA726;color:black;">
                  <th width="10%">Jenis</th>
                  <th scope="col" width="5%">Total</th>
                  <th scope="col" width="5%">Komisi</th>
                  <th scope="col" width="3%">P</th>
                  <th scope="col" width="5%">Nilai</th>
                  <th width="8%">Jenis</th>
                  <th scope="col" width="5%">Harga</th>
                  <th scope="col" width="5%">Komisi</th>
                  <th scope="col" width="4%">Jml</th>
                  <th scope="col" width="6%">T Komisi</th>
                  <th scope="col" width="8%">Pendapatan</th>
                  <th scope="col" width="8%">Pendapatan (s/d)</th>
                </tr>
              </thead>
              <tbody>
                    @foreach($report_data_detail_t as $report_data_detail_ts)
                    {{-- Loop Foreach --}}
                        <?php if($report_data_detail_ts->id==$report_data_terapistx->id&&$report_data_detail_ts->branch_name==$report_data_terapistx->branch_name){ ?>
                          <tr>
                            <td style="text-align: left;vertical-align:top;">{{ Carbon\Carbon::parse($report_data_detail_ts->dated)->format('d-m-Y') }}</td>
                            <td style="text-align: left;vertical-align:top;">
                              @php  
                                $inv = explode("##",$report_data_detail_ts->invoice_no);
                                foreach ($inv as $value) {
                                  echo $value."<br>";
                                }
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->abbr, "##")) {
                                  $abbr = explode("##",$report_data_detail_ts->abbr);
                                  foreach ($abbr as $value) {
                                    echo $value==""?"":$value."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->abbr;
                                }
                                
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->total_abbr, "##")) {
                                  $total_abbr = explode("##",$report_data_detail_ts->total_abbr);
                                  foreach ($total_abbr as $value) {
                                    echo $value==""?"":number_format($value,0,',','.')."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->total_abbr==""?"":number_format($report_data_detail_ts->total_abbr,0,',','.');
                                }
                                
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->total_commisions, "##")) {
                                  $total_commisions = explode("##",$report_data_detail_ts->total_commisions);
                                  foreach ($total_commisions as $value) {
                                    echo $value==""?"":number_format($value,0,',','.')."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->total_commisions==""?"":number_format($report_data_detail_ts->total_commisions,0,',','.');
                                }
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->total_point_qty, "##")) {
                                  $total_point_qty = explode("##",$report_data_detail_ts->total_point_qty);
                                  foreach ($total_point_qty as $value) {
                                    echo $value==""?"":number_format($value,0,',','.')."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->total_point_qty==""?"":number_format($report_data_detail_ts->total_point_qty,0,',','.');
                                }
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              {{ number_format($report_data_detail_ts->total_point,0,',','.') }}
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->product_abbr, "##")) {
                                  $product_abbr = explode("##",$report_data_detail_ts->product_abbr);
                                  foreach ($product_abbr as $value) {
                                    echo $value==""?"":$value."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->product_abbr;
                                }
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->product_price, "##")) {
                                  $product_price = explode("##",$report_data_detail_ts->product_price);
                                  foreach ($product_price as $value) {
                                    echo $value==""?"":number_format($value,0,',','.')."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->product_price;
                                }
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->product_base_commision, "##")) {
                                  $product_base_commision = explode("##",$report_data_detail_ts->product_base_commision);
                                  foreach ($product_base_commision as $value) {
                                    echo $value==""?"":number_format($value,0,',','.')."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->product_base_commision;
                                }
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->product_qty, "##")) {
                                  $product_qty = explode("##",$report_data_detail_ts->product_qty);
                                  foreach ($product_qty as $value) {
                                    echo $value==""?"":number_format($value,0,',','.')."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->product_qty;
                                }
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                                if (str_contains($report_data_detail_ts->product_commisions, "##")) {
                                  $product_commisions = explode("##",$report_data_detail_ts->product_commisions);
                                  foreach ($product_commisions as $value) {
                                    echo $value==""?"":number_format($value,0,',','.')."<br>";
                                  }
                                }else{
                                  echo $report_data_detail_ts->product_commisions;
                                }
                              @endphp
                            </td>
                            <td style="vertical-align:top;">
                              @php  
                              if (str_contains($report_data_detail_ts->commisions_extra, "##")) {
                                $commisions_extra = explode("##",$report_data_detail_ts->commisions_extra);
                                foreach ($commisions_extra as $value) {
                                  echo $value==""?"":number_format($value,0,',','.')."<br>";
                                }
                              }else{
                                echo $report_data_detail_ts->commisions_extra==""?"":number_format($report_data_detail_ts->commisions_extra,0,',','.');
                              }
                            @endphp
                            </td>
                            <td style="vertical-align:top;">
                              {{ number_format($report_data_detail_ts->total,0,',','.') }}
                            </td>
                            <td style="vertical-align:top;">
                                @php  $tot=0; @endphp
                                @foreach($report_data_com_from1 as $report_data_com_from1s)
                                    @if($report_data_detail_ts->id == $report_data_com_from1s->id && $report_data_detail_ts->id==$report_data_terapistx->id && $report_data_detail_ts->branch_name==$report_data_terapistx->branch_name)
                                          @php 
                                                  $date1 = \Carbon\Carbon::createFromFormat('Y-m-d', $report_data_com_from1s->dated);
                                                  $date2 = \Carbon\Carbon::createFromFormat('Y-m-d', $report_data_detail_ts->dated); 
                                                  
                                                  $result = $date1->lte($date2);
                                                  if($result){
                                                    $tot=$tot+$report_data_com_from1s->total; 
                                                  }
                                          @endphp
                                    @endif
                                @endforeach
                                {{ number_format($tot,0,',','.') }}
                              </td>  
                            </tr>
                        <?php } ?>
                    {{-- End Loop Foreach --}}
                    @endforeach
              </tbody>
            </table>
            
              <div class="pagebreak"> </div>

          {{-- End Area Looping --}}


          <?php } ?>

          <input type="text" name="filter_begin_date" id="filter_begin_date" value="{{ $filter_begin_date }}">
          <input type="text" name="filter_begin_end" id="filter_begin_end" value="{{ $filter_begin_end }}">
          <input type="text" name="filter_branch_id" id="filter_branch_id" value="{{ $filter_branch_id }}">
          <input type="text" name="filter_terapist_in" id="filter_terapist_in" value="{{ $filter_terapist_in }}">
   </body> 
   <!-- use version 0.19.3 -->
   <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
   <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>   
   <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
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
        export : 'Export Sum Lite API',
      };

      $('#btn_export_xls').on('click',function(){
        const res = axios.get(url,{ params }, {
                    headers: {}
                  }).then(resp => {
                    report_data_detail_t = resp.data.report_data_detail_t;
                    report_data_com_from1 = resp.data.report_data_com_from1;
                    report_data_terapist = resp.data.report_data_terapist;

                    var beginnewformat = resp.data.beginnewformat;
                    var endnewformat = resp.data.endnewformat;

                    let data_filtered = [];

                    // Loop Terapist
                    report_data_terapist.forEach(element => {
                        data_filtered = [];

                        let worksheet = workbook.addWorksheet(element.name);

                        /*Column headers*/
                        worksheet.getRow(3).values = [
                          'Tgl', 
                          'No Faktur', 
                          'Jenis', 
                          'Total',
                          'Komisi',
                          'Poin',
                          'Nilai',
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
                        worksheet.getCell('A1').value = 'Cabang : '+element.branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('F1', 'J1');
                        worksheet.getCell('F1').value = 'Mitra Usaha : '+element.name;
                        worksheet.getCell('F1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('K1', 'O1');
                        worksheet.getCell('K1').value = 'Tgl : '+beginnewformat+' sd '+endnewformat;
                        worksheet.getCell('K1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('A2', 'A3');
                        worksheet.getCell('A2').value = 'Tgl';
                        worksheet.getCell('A2').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('B2', 'B3');
                        worksheet.getCell('B2').value = 'No Faktur';
                        worksheet.getCell('B2').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };
                        worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('C2', 'E2');
                        worksheet.getCell('C2').value = 'Perawatan';
                        worksheet.getCell('C2').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('F2', 'G2');
                        worksheet.getCell('F2').value = 'Poin';
                        worksheet.getCell('F2').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('H2', 'L2');
                        worksheet.getCell('H2').value = 'Produk';
                        worksheet.getCell('H2').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('M2', 'M3');
                        worksheet.getCell('M2').value = 'Extra Charge';
                        worksheet.getCell('M2').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('N2', 'O2');
                        worksheet.getCell('N2').value = 'Total';
                        worksheet.getCell('N2').alignment = { vertical: 'middle', horizontal: 'center' };                        

                        worksheet.columns = [
                          { key: 'dated', width: 12 },
                          { key: 'invoice_no', width: 15 },
                          { key: 'abbr', width: 20 },
                          { key: 'total_abbr', width: 10 },
                          { key: 'total_commisions', width: 10 },
                          { key: 'total_point_qty', width: 10 },
                          { key: 'total_point', width: 10 },
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
                        worksheet.getCell('K1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('L1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('M1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('N1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('O1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

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
                        worksheet.getCell('K2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('L2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('M2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('N2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('O2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

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

                        let counter = 3;
                        for (let index = 0; index < report_data_detail_t.length; index++) {
                          const rowElement = report_data_detail_t[index];
                          if(rowElement.name == element.name ){
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
                              invoice_no : rowElement.invoice_no, 
                              abbr                : ((rowElement.abbr.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              total_abbr          : ((rowElement.total_abbr.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              total_commisions    : ((rowElement.total_commisions.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              total_point_qty     : ((rowElement.total_point_qty.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              total_point         : rowElement.total_point, 
                              product_abbr        : ((rowElement.product_abbr.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll('####','##').replaceAll('##','\n'), 
                              product_price       : ((rowElement.product_price.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll('####','##').replaceAll("####","##").replaceAll('##','\n'), 
                              product_base_commision : ((rowElement.product_base_commision.replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####", "##")).replaceAll('##','\n'), 
                              product_qty         : ((rowElement.product_qty.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              product_commisions  : ((rowElement.product_commisions.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              commisions_extra    : ((rowElement.commisions_extra.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
                              total : rowElement.total, 
                              totalx : value_sd, 
                            });
                            worksheet.getCell('B'+counter).alignment = { wrapText: true };
                            worksheet.getCell('C'+counter).alignment = { wrapText: true };
                            worksheet.getCell('D'+counter).alignment = { wrapText: true };
                            worksheet.getCell('E'+counter).alignment = { wrapText: true };
                            worksheet.getCell('F'+counter).alignment = { wrapText: true };
                            worksheet.getCell('H'+counter).alignment = { wrapText: true };
                            worksheet.getCell('I'+counter).alignment = { wrapText: true };
                            worksheet.getCell('J'+counter).alignment = { wrapText: true };
                            worksheet.getCell('K'+counter).alignment = { wrapText: true };
                            worksheet.getCell('L'+counter).alignment = { wrapText: true };
                            worksheet.getCell('M'+counter).alignment = { wrapText: true };                            
                            counter++;
                            worksheet.getCell('B'+counter).alignment = { wrapText: true };
                            worksheet.getCell('C'+counter).alignment = { wrapText: true };
                            worksheet.getCell('D'+counter).alignment = { wrapText: true };
                            worksheet.getCell('E'+counter).alignment = { wrapText: true };
                            worksheet.getCell('F'+counter).alignment = { wrapText: true };
                            worksheet.getCell('H'+counter).alignment = { wrapText: true };
                            worksheet.getCell('I'+counter).alignment = { wrapText: true };
                            worksheet.getCell('J'+counter).alignment = { wrapText: true };
                            worksheet.getCell('K'+counter).alignment = { wrapText: true };
                            worksheet.getCell('L'+counter).alignment = { wrapText: true };
                            worksheet.getCell('M'+counter).alignment = { wrapText: true }; 

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
                        }

                        
                    });

                    //XLSX.writeFile(workbook, "Presidents.xlsx", { compression: true });


                  
                    let filename = "Report_Commission_Terapist_"+(Math.floor(Date.now() / 1000)+".xlsx");
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

    
 </script>
</html> 