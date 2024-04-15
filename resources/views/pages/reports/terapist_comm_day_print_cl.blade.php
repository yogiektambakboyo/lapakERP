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
    <button id="btn_export_xls" class="btn print printPageButton">Cetak XLS</button>
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
            <table class="table table-striped" style="width:1800px">
              <thead>
                <tr style="background-color:#FFA726;color:black;">
                  <th colspan="7">Cabang : {{ count($report_data)>0?$report_data[0]->branch_name:'';  }}</th>
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
                    <th>{{ number_format($dated_lists->charge_lebaran/1000,0,",",".") }} </th>  
                    @php $tot_t = $tot_t + $dated_lists->charge_lebaran; @endphp
                @endforeach
                <th>{{ number_format($tot_t/1000,0,",",".") }}</th>  
              </tr>

              <tr style="">
                <td colspan="2">KASIR</td>
                @php $tot_t = 0; @endphp
                @foreach ($dated_list_c as $dated_lists)
                    <th colspan="{{ $dated_lists->c_product }}"></th>
                    <th>{{ number_format($dated_lists->charge_lebaran/1000,0,",",".") }} </th>  
                    @php $tot_t = $tot_t + $dated_lists->charge_lebaran; @endphp
                @endforeach
                <th>{{ number_format($tot_t/1000,0,",",".") }}</th>  
              </tr>

              <tr style="">
                <td colspan="2">GRAND TOTAL</td>
                @php $tot_t = 0; @endphp

                @for ($i=0;$i<count($dated_list);$i++)
                    <th colspan="{{ $dated_list[$i]->c_product }}"></th>
                    <th>{{ number_format(($dated_list[$i]->charge_lebaran+$dated_list_c[$i]->charge_lebaran)/1000,0,",",".") }} </th>  
                    @php $tot_t = $tot_t + ($dated_list[$i]->charge_lebaran+$dated_list_c[$i]->charge_lebaran); @endphp
                @endfor
                <th>{{ number_format($tot_t/1000,0,",",".") }}</th>  
              </tr>
              </tbody>
            </table>
            
              <div class="pagebreak"> </div>

          {{-- End Area Looping --}}

          </br>

          <table class="table table-striped" style="width:450px">
            <thead>
              <tr style="background-color:#FFA726;color:black;">
                <th colspan="{{ count($dated_list)+3 }}">TOTAL TERAPIS</th>
              </tr>
              <tr style="background-color:#FFA726;color:black;">
                <th width="20px;">NO</th>
                <th scope="col">NAMA TERAPIS</th>
                @foreach ($dated_list as $dated_lists)
                      <th   style="width: 30px;">{{ $dated_lists->dm_number }}</th>                        
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
                  <th>{{ number_format($dated_lists->charge_lebaran/1000,0,",",".") }} </th>  
                  @php $tot_t = $tot_t + $dated_lists->charge_lebaran; @endphp
              @endforeach
              <th>{{ number_format($tot_t/1000,0,",",".") }}</th>  
            </tr>

            
            </tbody>
          </table>


        </br>

        <table class="table table-striped" style="width:450px">
          <thead>
            <tr style="background-color:#FFA726;color:black;">
              <th colspan="{{ count($dated_list)+3 }}">TOTAL KASIR</th>
            </tr>
            <tr style="background-color:#FFA726;color:black;">
              <th width="20px;">NO</th>
              <th scope="col">NAMA KASIR</th>
              @foreach ($dated_list as $dated_lists)
                    <th   style="width: 30px;">{{ $dated_lists->dm_number }}</th>                        
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
                <th>{{ number_format($dated_lists->charge_lebaran/1000,0,",",".") }} </th>  
                @php $tot_t = $tot_t + $dated_lists->charge_lebaran; @endphp
            @endforeach
            <th>{{ number_format($tot_t/1000,0,",",".") }}</th>  
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
                          'Charge Lebaran',
                          'Pendapatan',
                          'Pendapatan (s/d)',
                        ];


                        worksheet.mergeCells('A1', 'E1');
                        worksheet.getCell('A1').value = 'Cabang : '+element.branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('F1', 'J1');
                        worksheet.getCell('F1').value = 'Mitra Usaha : '+element.name+' ('+element.work_year+')';
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

                        worksheet.mergeCells('N2', 'N3');
                        worksheet.getCell('N2').value = 'Charge Lebaran';
                        worksheet.getCell('N2').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('O2', 'P2');
                        worksheet.getCell('O2').value = 'Total';
                        worksheet.getCell('O2').alignment = { vertical: 'middle', horizontal: 'center' };                        

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
                          { key: 'charge_lebaran', width: 13 },
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
                        worksheet.getCell('P1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

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
                        worksheet.getCell('P2').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

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

                        let counter = 3;
                        let value_sd_until = 0;
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

                            value_sd_until = value_sd;
                            
                            worksheet.addRow({
                              dated : rowElement.dated, 
                              invoice_no : ((rowElement.invoice_no.replaceAll("####", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
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
                              charge_lebaran    : ((rowElement.charge_lebaran.replaceAll("######", "##")).replaceAll("####", "##")).replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll("####","##").replaceAll('##','\n'), 
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
                            worksheet.getCell('N'+counter).alignment = { wrapText: true };                            
                            worksheet.getCell('O'+counter).alignment = { wrapText: true };                            
                            worksheet.getCell('P'+counter).alignment = { wrapText: true };                            
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
                            worksheet.getCell('N'+counter).alignment = { wrapText: true };                            
                            worksheet.getCell('O'+counter).alignment = { wrapText: true };                            
                            worksheet.getCell('P'+counter).alignment = { wrapText: true };   

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


                        counter++;

                        let report_data_detail_e_t = resp.data.report_data_detail_e_t;
                        for (let index = 0; index < report_data_detail_e_t.length; index++) {
                          const rowElement = report_data_detail_e_t[index];
                          if(rowElement.name == element.name ){
                              worksheet.getCell('A'+counter).value = "Total";
                              worksheet.getCell('A'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('A'+counter).alignment = { wrapText: true };
                              worksheet.getCell('B'+counter).value = rowElement.invoice;
                              worksheet.getCell('B'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('C'+counter).value = rowElement.service;
                              worksheet.getCell('C'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('D'+counter).value = rowElement.total_abbr;
                              worksheet.getCell('D'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('E'+counter).value = rowElement.total_commisions;
                              worksheet.getCell('E'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('F'+counter).value = rowElement.point_qty;
                              worksheet.getCell('F'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('G'+counter).value = rowElement.total_point;
                              worksheet.getCell('G'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.mergeCells('H'+counter, 'J'+counter);
                              worksheet.getCell('H'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                              worksheet.getCell('K'+counter).value = rowElement.product_qty;
                              worksheet.getCell('K'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('K'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('L'+counter).value = rowElement.product_commisions;
                              worksheet.getCell('L'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('L'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('M'+counter).value = rowElement.commisions_extra;
                              worksheet.getCell('M'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('M'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('N'+counter).value = rowElement.charge_lebaran;
                              worksheet.getCell('N'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('N'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('O'+counter).value = rowElement.total;
                              worksheet.getCell('O'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('O'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.getCell('P'+counter).value = value_sd_until;
                              worksheet.getCell('P'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                              worksheet.getCell('P'+counter).alignment = { wrapText: true, vertical: 'middle', horizontal: 'center' };

                              worksheet.eachRow({ includeEmpty: true }, function(row, rowNumber) {
                                  row.eachCell({ includeEmpty: true }, function(cell, colNumber) {
                                    cell.border = borderStyles;
                                  });
                                });
                
                          }
                        }

                        worksheet.getRow(counter).font = { bold: true };
                        

                        



                    });
                    // End loop terapist

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