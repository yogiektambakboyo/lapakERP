<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Pendapatan - {{ count((array)$report_data)>0?$report_data[0]->branch_name:"" }} Tgl : {{ Carbon\Carbon::parse($begindate)->format('d-m-Y') }} s/d {{ Carbon\Carbon::parse($enddate)->format('d-m-Y') }}</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css" rel="stylesheet"/>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
      <link href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap.min.css" rel="stylesheet"/>
      <link href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css" rel="stylesheet"/>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          padding: 1px;
          font-size: 12px;
        }
        td, th {
            border: .01px solid black;
        }
        div{
          padding:1px;
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

      <button id="printPageButton" onClick="window.print();"  class="btn btn-secondary btn-sm mt-1 print mb-2">Cetak Laporan</button>
      <button id="btn_export_xls" class="btn btn-primary btn-sm print printPageButton  mt-1 print mb-2">Cetak XLS</button>
      <br>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <td style="width: 20%;">TGL : {{ Carbon\Carbon::parse($begindate)->format('d-m-Y') }} s/d {{ Carbon\Carbon::parse($enddate)->format('d-m-Y') }}</td>
              <td style="width: 30%;">LAPORAN PENDAPATAN</td>
              <td style="width: 20%;">CABANG  : {{ count((array)$report_data)>0?$report_data[0]->branch_name:"" }}</td>
          </tr>
        </tbody>
      </table>
      <br>

  
      {{-- Area Looping --}}
  
      <table class="table table-striped" id="example"  style="width: 100%">
        <thead>
            <tr>
                <th style="text-align: center;background-color:#FFA726;" rowspan="2" scope="col" width="8%">TANGGAL</th>
                <th style="text-align: center;background-color:#FFA726;" scope="col" rowspan="2">PERAWATAN <?= $report_total[0]->total_salon>0?' & SALON':''; ?></th>       
                <th style="text-align: center;background-color:#FFA726;" scope="col" rowspan="2">PRODUK, MINUMAN & EXTRA CHARGE</th>      
                <th style="text-align: center;background-color:#FFA726;" scope="col" rowspan="2">TUNAI 1</th>      
                <th style="text-align: center;background-color:#FFA726;" scope="col" rowspan="2">TUNAI 2</th>      
                <th style="text-align: center;background-color:#FFA726;" scope="col" colspan="4">BANK 1</th>       
                <th style="text-align: center;background-color:#FFA726;" scope="col" colspan="4">BANK 2</th>       
            </tr>
            <tr>   
              <th style="text-align: center;background-color:#FFA726;"  scope="col">D</th>    
              <th style="text-align: center;background-color:#FFA726;"  scope="col">K</th>  
              <th style="text-align: center;background-color:#FFA726;"  scope="col">T</th>  
              <th style="text-align: center;background-color:#FFA726;"  scope="col">Q</th>  
              <th style="text-align: center;background-color:#FFA726;"  scope="col">D</th>    
              <th style="text-align: center;background-color:#FFA726;"  scope="col">K</th>    
              <th style="text-align: center;background-color:#FFA726;"  scope="col">T</th>  
              <th style="text-align: center;background-color:#FFA726;"  scope="col">Q</th>  
            </tr>
        </thead>
          <?php 
              $total_service = 0;
              $total_salon = 0;
              $total_ojek = 0;
              $total_tambahan = 0;
              $total_product = 0;
              $total_drink = 0;
              $total_extra = 0;
              $total_lebaran = 0;
              $total_cash = 0;
              $total_cash_1 = 0;
              $total_cash_2 = 0;
              $total_b1d = 0;
              $total_b1c = 0;
              $total_b2d = 0;
              $total_b2c = 0;
              $total_b1q = 0;
              $total_b2q = 0;
              $total_b1t = 0;
              $total_b2t = 0;
              $qty_service = 0;
              $total_all = 0;
          ?>
        <tbody>
            @foreach($report_data as $rdata)
            <?php 
                    $total_service = $total_service + $rdata->total_service;
                    $total_product = $total_product + $rdata->total_product;
                    $total_ojek = $total_ojek + $rdata->total_ojek;
                    $total_tambahan = $total_tambahan + $rdata->total_tambahan;
                    $total_extra = $total_extra + $rdata->total_extra;
                    $total_lebaran = $total_lebaran + $rdata->total_lebaran;
                    $total_cash = $total_cash + $rdata->total_cash;
                    $total_cash_1 = $total_cash_1 + $rdata->total_cash_1;
                    $total_cash_2 = $total_cash_2 + $rdata->total_cash_2;
                    $total_b1d = $total_b1d + $rdata->total_b1d;
                    $total_b1c = $total_b1c + $rdata->total_b1c;
                    $total_b2d = $total_b2d + $rdata->total_b2d;
                    $total_b2c = $total_b2c + $rdata->total_b2c;
                    $total_b1q = $total_b1q + $rdata->total_b1q;
                    $total_b2q = $total_b2q + $rdata->total_b2q;
                    $total_b1t = $total_b1t + $rdata->total_b1t;
                    $total_b2t = $total_b2t + $rdata->total_b2t;
                    $qty_service = $qty_service + $rdata->qty_service;
                    $total_all = $total_all + $rdata->total_all;
                ?>
                <tr>
                  <td rowspan="4">{{ Carbon\Carbon::parse($rdata->dated)->format('d-m-Y')  }}</td>
                  <td style="text-align: right;">{{ number_format($rdata->total_service,0,',','.') }}</td>
                  <td style="text-align: right;">{{ number_format($rdata->total_product,0,',','.') }}</td>
                  <td style="text-align: right;">{{ number_format($rdata->total_cash_1,0,',','.') }}</td>
                  <td style="text-align: right;">{{ number_format($rdata->total_cash_2,0,',','.') }}</td>
                  <td style="text-align: right;">{{ number_format($rdata->total_b1d,0,',','.') }}</td>
                  <td style="text-align: right;">{{ number_format($rdata->total_b1c,0,',','.') }}</td>  
                  <td style="text-align: right;">{{ number_format($rdata->total_b1t,0,',','.') }}</td>  
                  <td style="text-align: right;">{{ number_format($rdata->total_b1q,0,',','.') }}</td>  
                  <td style="text-align: right;">{{ number_format($rdata->total_b2d,0,',','.') }}</td>
                  <td style="text-align: right;">{{ number_format($rdata->total_b2c,0,',','.') }}</td>                    
                  <td style="text-align: right;">{{ number_format($rdata->total_b2t,0,',','.') }}</td>                    
                  <td style="text-align: right;">{{ number_format($rdata->total_b2q,0,',','.') }}</td>                    
                </tr>  

               
                 <tr>
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;"  rowspan="2" colspan="2">{{ number_format($rdata->total_service+$rdata->total_product,0,',','.') }}</td>
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;"  colspan="2">{{ number_format($rdata->total_cash_1+$rdata->total_cash_2,0,',','.') }}</td>
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;" colspan="4">{{ number_format($rdata->total_b1d+$rdata->total_b1c+$rdata->total_b1t+$rdata->total_b1q,0,',','.') }}</td>         
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;"  class="d-none"></td>
                  <td style="text-align: right;" colspan="4">{{ number_format($rdata->total_b2d+$rdata->total_b2c+$rdata->total_b2t+$rdata->total_b2q,0,',','.') }}</td>         
                </tr>

               <tr>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;"  class="d-none"></td>
                <td style="text-align: right;" colspan="11">{{ number_format($rdata->total_cash_1+$rdata->total_cash_2+$rdata->total_b1d+$rdata->total_b1c+$rdata->total_b1t+$rdata->total_b1q+$rdata->total_b2d+$rdata->total_b2c+$rdata->total_b2t+$rdata->total_b2q,0,',','.') }}</td>         
              </tr>

                <tr>
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;" colspan="2">{{ number_format($total_service+$total_product,0,',','.') }}</td>
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;" colspan="2">{{ number_format($total_cash_1+$total_cash_2,0,',','.') }}</td>
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;" colspan="4">{{ number_format($total_b1d+$total_b1c+$total_b1t+$total_b1q,0,',','.') }}</td>         
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;"  class="d-none"></td>
                  <td style="text-align: right;background-color:#a0a0a0;" colspan="4">{{ number_format($total_b2d+$total_b2c+$total_b2t+$total_b2q,0,',','.') }}</td>         
                </tr>
                

                
            @endforeach

           
              
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
   
    <!-- use version 0.19.3 -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>  
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script> 
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>   
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap.min.js"></script>   
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>   
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/accounting.js/0.4.1/accounting.min.js" integrity="sha512-LW+1GKW2tt4kK180qby6ADJE0txk5/92P70Oh5YbtD7heFlC0qFFtacvSnHG4bNXmLnZq5hNb2V70r5DzS/U+g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <script type="text/javascript">
    //window.print();
    //const workbook = XLSX.utils.book_new();

    new DataTable('#example',{
      "ordering": false,
      "paging" : false,
      info: false,
      columnDefs: [
      { 
        targets: [1,2,3,4,5,6,7,8,9,10,11,12], 
        render: function ( data, type, row, meta ) {
          return type === 'export' ?
                    data.replaceAll('.','') :
                    data;
        }
      }
    ],
      searching: false,
        dom: 'Bfrtip',
        buttons: [
            
        ]
    });
    </script>

<script type="text/javascript">
  //window.print();
  //const workbook = XLSX.utils.book_new();

  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'Kakiku System Apps';
  workbook.created = new Date();
  //workbook.modified = new Date();

  $(document).ready(function() {
    var url = "{{ route('reports.closeday.search') }}";
    var branchxx = "{{ $branchx }}";
    const params = {
      filter_begin_date_in : "{{ $begindate }}",
      filter_end_date_in : "{{ $enddate }}",
      filter_branch_id_in: "{{ $branchx }}",
      filter_terapist_in: "%",
      export : 'Export Sum Pendapatan API',
    };

    $('#btn_export_xls').on('click',function(){
      const res = axios.get(url,{ params }, {
                  headers: {}
                }).then(resp => {
                  report_data = resp.data.report_data;

                  var beginnewformat = resp.data.beginnewformat;
                  var endnewformat = resp.data.endnewformat;

                  let data_filtered = [];

                  // Loop Terapist
                      data_filtered = [];

                      let worksheet = workbook.addWorksheet("DATA");

                      /*Column headers*/
                      
                      worksheet.mergeCells('A1', 'E1');
                      worksheet.getCell('A1').value = 'Cabang : '+report_data[0].branch_name;
                      worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };


                      worksheet.mergeCells('F1', 'M1');
                      worksheet.getCell('F1').value = 'Tgl : '+resp.data.beginnewformat+' sd '+resp.data.endnewformat;
                      worksheet.getCell('F1').alignment = { vertical: 'middle', horizontal: 'center' }; 


                      
                      worksheet.mergeCells('A3', 'A4');
                      worksheet.getCell('A3').value = 'TANGGAL';
                      worksheet.getCell('A3').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.mergeCells('B3', 'B4');
                      
                      if(branchxx == "21" ||branchxx == "23" || branchxx == "24"){
                        worksheet.getCell('B3').value = 'PERAWATAN & SALON';
                      }else{
                        worksheet.getCell('B3').value = 'PERAWATAN';
                      }
                      worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.mergeCells('C3', 'C4');
                      worksheet.getCell('C3').value = 'PRODUK, MINUMAN & EXTRA CHARGE';
                      worksheet.getCell('C3').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.mergeCells('D3', 'D4');
                      worksheet.getCell('D3').value = 'TUNAI 1';
                      worksheet.getCell('D3').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.mergeCells('E3', 'E4');
                      worksheet.getCell('E3').value = 'TUNAI 2';
                      worksheet.getCell('E3').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.mergeCells('F3', 'I3');
                      worksheet.getCell('F3').value = 'BANK 1';
                      worksheet.getCell('F3').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.getCell('F4').value = 'D';
                      worksheet.getCell('F4').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.getCell('G4').value = 'K';
                      worksheet.getCell('G4').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.getCell('H4').value = 'T';
                      worksheet.getCell('H4').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.getCell('I4').value = 'Q';
                      worksheet.getCell('I4').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.mergeCells('J3', 'M3');
                      worksheet.getCell('J3').value = 'BANK 2';
                      worksheet.getCell('J3').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.getCell('J4').value = 'D';
                      worksheet.getCell('J4').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.getCell('K4').value = 'K';
                      worksheet.getCell('K4').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.getCell('L4').value = 'T';
                      worksheet.getCell('L4').alignment = { vertical: 'middle', horizontal: 'center' };

                      worksheet.getCell('M4').value = 'Q';
                      worksheet.getCell('M4').alignment = { vertical: 'middle', horizontal: 'center' };

                  

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

                      worksheet.getCell('A4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('B4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('C4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('D4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('E4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('F4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('G4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('H4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('I4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('J4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('K4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('L4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('M4').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                      let counter = 5;
                      let value_sd_until = 0;
                      var total_service = 0;
                      var total_salon = 0;
                      var total_ojek = 0;
                      var total_tambahan = 0;
                      var total_product = 0;
                      var total_drink = 0;
                      var total_extra = 0;
                      var total_lebaran = 0;
                      var total_cash = 0;
                      var total_cash_1 = 0;
                      var total_cash_2 = 0;
                      var total_b1d = 0;
                      var total_b1c = 0;
                      var total_b2d = 0;
                      var total_b2c = 0;
                      var total_b1q = 0;
                      var total_b2q = 0;
                      var total_b1t = 0;
                      var total_b2t = 0;
                      var qty_service = 0;
                      var total_all = 0;
                      
                      for (let index = 0; index < report_data.length; index++) {
                        var rowElement = report_data[index];

                        total_service = total_service + parseFloat((rowElement.total_service));
                        total_product = total_product + parseFloat(rowElement.total_product);
                        total_ojek = total_ojek + parseFloat(rowElement.total_ojek);
                        total_tambahan = total_tambahan + parseFloat(rowElement.total_tambahan);
                        total_extra = total_extra + parseFloat(rowElement.total_extra);
                        total_lebaran = total_lebaran + parseFloat(rowElement.total_lebaran);
                        total_cash = total_cash + parseFloat(rowElement.total_cash);
                        total_cash_1 = total_cash_1 + parseFloat(rowElement.total_cash_1);
                        total_cash_2 = total_cash_2 + parseFloat(rowElement.total_cash_2);
                        total_b1d = total_b1d + parseFloat(rowElement.total_b1d);
                        total_b1c = total_b1c + parseFloat(rowElement.total_b1c);
                        total_b2d = total_b2d + parseFloat(rowElement.total_b2d);
                        total_b2c = total_b2c + parseFloat(rowElement.total_b2c);
                        total_b1q = total_b1q + parseFloat(rowElement.total_b1q);
                        total_b2q = total_b2q + parseFloat(rowElement.total_b2q);
                        total_b1t = total_b1t + parseFloat(rowElement.total_b1t);
                        total_b2t = total_b2t + parseFloat(rowElement.total_b2t);
                        qty_service = qty_service + parseFloat(rowElement.qty_service);
                        total_all = total_all + parseFloat(rowElement.total_all);

                        worksheet.mergeCells('A'+counter, 'A'+(counter+3));
                        worksheet.getCell('A'+counter).value = rowElement.datedformat;

                        worksheet.getCell('B'+counter).value = (rowElement.total_service);
                        worksheet.getCell('C'+counter).value = (rowElement.total_product);
                        worksheet.getCell('D'+counter).value = (rowElement.total_cash_1);
                        worksheet.getCell('E'+counter).value = (rowElement.total_cash_2);
                        worksheet.getCell('F'+counter).value = (rowElement.total_b1d);
                        worksheet.getCell('G'+counter).value = (rowElement.total_b1c);
                        worksheet.getCell('H'+counter).value = (rowElement.total_b1t);
                        worksheet.getCell('I'+counter).value = (rowElement.total_b1q);
                        worksheet.getCell('J'+counter).value = (rowElement.total_b2d);
                        worksheet.getCell('K'+counter).value = (rowElement.total_b2c);
                        worksheet.getCell('L'+counter).value = (rowElement.total_b2t);
                        worksheet.getCell('M'+counter).value = (rowElement.total_b2q);
                        counter++;

                        worksheet.mergeCells('B'+counter, 'C'+(counter+1));
                        worksheet.getCell('B'+counter).value = (parseFloat(rowElement.total_service)+parseFloat(rowElement.total_product));

                        worksheet.mergeCells('D'+counter, 'E'+counter);
                        worksheet.getCell('D'+counter).value = parseFloat(rowElement.total_cash_1)+parseFloat(rowElement.total_cash_2);

                        worksheet.mergeCells('F'+counter, 'I'+counter);
                        worksheet.getCell('F'+counter).value = parseFloat(rowElement.total_b1d)+parseFloat(rowElement.total_b1c)+parseFloat(rowElement.total_b1t)+parseFloat(rowElement.total_b1q);

                        worksheet.mergeCells('J'+counter, 'M'+counter);
                        worksheet.getCell('J'+counter).value = parseFloat(rowElement.total_b2d)+parseFloat(rowElement.total_b2c)+parseFloat(rowElement.total_b2t)+parseFloat(rowElement.total_b2q);
                      
                        counter++;

                        worksheet.mergeCells('D'+counter, 'M'+counter);
                        worksheet.getCell('D'+counter).value = parseFloat(rowElement.total_cash_1)+parseFloat(rowElement.total_cash_2)+parseFloat(rowElement.total_b1d)+parseFloat(rowElement.total_b1c)+parseFloat(rowElement.total_b1t)+parseFloat(rowElement.total_b1q)+parseFloat(rowElement.total_b2d)+parseFloat(rowElement.total_b2c)+parseFloat(rowElement.total_b2t)+parseFloat(rowElement.total_b2q);

                        counter++;

                        worksheet.mergeCells('B'+counter, 'C'+(counter));
                        worksheet.getCell('B'+counter).value = (total_service+total_product);

                        worksheet.mergeCells('D'+counter, 'E'+counter);
                        worksheet.getCell('D'+counter).value = total_cash_1+total_cash_2;

                        worksheet.mergeCells('F'+counter, 'I'+counter);
                        worksheet.getCell('F'+counter).value = total_b1d+total_b1c+total_b1t+total_b1q;

                        worksheet.mergeCells('J'+counter, 'M'+counter);
                        worksheet.getCell('J'+counter).value = total_b2d+total_b2c+total_b2t+total_b2q;
                      
                        worksheet.getCell('B'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('C'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('D'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('E'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('F'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('G'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('H'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('I'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('J'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('K'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('L'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};
                        worksheet.getCell('M'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'a0a0a0'}};

                        

                          /**
                           * worksheet.addRow({
                            tanggal : rowElement.datedformat, 
                            perawatan : (rowElement.total_service-rowElement.total_tambahan), 
                            perawatan_sd : total_service, 
                            produk : rowElement.total_product, 
                            produk_sd : total_product, 
                            ojek : parseFloat(rowElement.total_ojek) + parseFloat(rowElement.total_tambahan), 
                            ojek_sd : total_ojek, 
                            extra : parseFloat(rowElement.total_extra), 
                            extra_sd : total_extra, 
                            total_all : parseFloat(rowElement.total_all), 
                            total_all_sd : total_all, 
                          });
                          **/


                          worksheet.getCell('B'+counter).alignment = { wrapText: true };
                          worksheet.getCell('C'+counter).alignment = { wrapText: true };
                          worksheet.getCell('D'+counter).alignment = { wrapText: true };
                          worksheet.getCell('E'+counter).alignment = { wrapText: true };
                          worksheet.getCell('F'+counter).alignment = { wrapText: true };
                          worksheet.getCell('H'+counter).alignment = { wrapText: true };
                          worksheet.getCell('I'+counter).alignment = { wrapText: true };
                          worksheet.getCell('J'+counter).alignment = { wrapText: true };
                          worksheet.getCell('K'+counter).alignment = { wrapText: true };                        
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


                      counter++;

                      

                  

                  //XLSX.writeFile(workbook, "Presidents.xlsx", { compression: true });


                
                  let filename = "Report_Pendapatan_Terapist_"+(Math.floor(Date.now() / 1000)+".xlsx");
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