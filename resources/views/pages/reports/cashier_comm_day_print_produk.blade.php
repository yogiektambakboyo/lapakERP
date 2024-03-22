<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Komisi Kasir Produk</title>
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
          padding: 2px;
          font-size: 14px;
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

      <button id="printPageButton" onClick="window.print();"  class="btn print printPageButton">Cetak Laporan Komisi</button>
      <button id="btn_export_xls" class="btn btn-primary btn-sm print printPageButton  mt-1 print mb-2">Cetak XLS</button>
    
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <td style="width: 40%;">LAPORAN KOMISI PRODUK KASIR</td>
              <td style="width: 40%;">{{ $filter_begin_date." s/d ".$filter_begin_end }}</td>
              <td style="width: 30%;">CABANG  : {{ count((array)$report_data)>0?$report_data[0]->branch_name:"" }}</td>
          </tr>
        </tbody>
      </table>

  
      {{-- Area Looping --}}

          <table class="table table-striped" style="width: 100%" id="example">
            <thead>
              <tr style="background-color:#FFA726;color:rgb(3, 3, 3);">
                <th  style="background-color: #FFA726" rowspan="2">TGL</th>
                <th rowspan="2" style="background-color: #FFA726">JENIS</th>
                <th rowspan="2" style="background-color: #FFA726">QTY</th>
                <th rowspan="2" style="background-color: #FFA726">HARGA</th>
                <th rowspan="2" style="background-color: #FFA726">MODAL</th>
                <th rowspan="2" style="background-color: #FFA726">TOTAL REVENUE</th>
                <th rowspan="2" style="background-color: #FFA726">TOTAL MODAL</th>
                <th colspan="2" style="background-color: #FFA726">KOMISI TERAPIS</th>
                <th colspan="2" style="background-color: #FFA726">KOMISI KASIR</th>
                <th rowspan="2" style="background-color: #FFA726">LABA PUSAT</th>
              </tr>
              <tr style="background-color:#FFA726;color:rgb(3, 3, 3);">
                <th style="background-color: #FFA726">@</th>
                <th style="background-color: #FFA726">TOTAL</th>
                <th style="background-color: #FFA726">@</th>
                <th style="background-color: #FFA726">TOTAL</th>
              </tr>
            </thead>
            <tbody>
                @php    
                  $total_qty_t = 0;    
                  $total_price_t = 0;    
                  $total_modal_t = 0;    
                  $total_modal_qty_t = 0;    
                  $total_total_t = 0;    
                  $total_commisions_c_t = 0;    
                  $total_commisions_tp_t = 0;    
                  $total_base_commision_c_t = 0;  
                  $total_base_commision_tp_t =  0;
                  $total_qty_t = 0;    
                  $total_final_t = 0;    
                @endphp

              @foreach ($report_data as $data)

                @php
                  $counter = 0;    
                  $total_qty = 0;    
                  $total_price = 0; 
                  $total_modal = 0;    
                  $total_modal_qty = 0;    
                  $total_total = 0;    
                  $total_final = 0;    
                  $total_commisions_c = 0;    
                  $total_commisions_tp = 0;    
                  $total_base_commision_c = 0;    
                  $total_base_commision_tp = 0;    
                  $total_qty = 0;  
                  $abb_last = "";  
                @endphp

                @foreach ($report_detail as $rdata)
                  @if($rdata->branch_id == $data->branch_id && $rdata->dated == $data->dated)

                    @if ($counter == 0)
                      <tr>
                        <td>{{ $data->dated }}</td>
                        <td>{{ $rdata->abbr }}</td>
                        <td>{{ number_format($rdata->qty,0,',','.') }}</td>
                        <td>{{ number_format($rdata->price,0,',','.') }}</td>
                        <td>{{ number_format($rdata->modal ,0,',','.')}}</td>
                        <td>{{ number_format($rdata->total,0,',','.') }}</td>
                        <td>{{ number_format($rdata->modal*$rdata->qty,0,',','.') }}</td>
                        <td>{{ number_format($rdata->base_commision_tp,0,',','.') }}</td>
                        <td>{{ number_format($rdata->commisions_tp,0,',','.') }}</td>
                        <td>{{ number_format($rdata->base_commision,0,',','.') }}</td>
                        <td>{{ number_format($rdata->commisions,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total-($rdata->commisions_tp+$rdata->commisions+($rdata->modal*$rdata->qty)),0,',','.') }}</td>
                      </tr>
                    @else
                          @if($abb_last == $rdata->abbr)
                                <tr>
                                  <td></td>
                                  <td>{{ $rdata->abbr }}</td>
                                  <td>0</td>
                                  <td>0</td>
                                  <td>0</td>
                                  <td>0</td>
                                  <td>0</td>
                                  <td>0</td>
                                  <td>0</td>
                                  <td>{{ number_format($rdata->base_commision,0,',','.') }}</td>
                                  <td>{{ number_format($rdata->commisions,0,',','.') }}</td>
                                  <td>{{ number_format($rdata->commisions*-1,0,',','.') }}</td>
                                </tr>
                          @else
                              <tr>
                                <td></td>
                                <td>{{ $rdata->abbr }}</td>
                                <td>{{ number_format($rdata->qty,0,',','.') }}</td>
                                <td>{{ number_format($rdata->price,0,',','.') }}</td>
                                <td>{{ number_format($rdata->modal,0,',','.') }}</td>
                                <td>{{ number_format($rdata->total,0,',','.') }}</td>
                                <td>{{ number_format($rdata->modal*$rdata->qty,0,',','.') }}</td>
                                <td>{{ number_format($rdata->base_commision_tp,0,',','.') }}</td>
                                <td>{{ number_format($rdata->commisions_tp ,0,',','.')}}</td>
                                <td>{{ number_format($rdata->base_commision,0,',','.') }}</td>
                                <td>{{ number_format($rdata->commisions,0,',','.') }}</td>
                                <td>{{ number_format($rdata->total-($rdata->commisions_tp+$rdata->commisions+($rdata->modal*$rdata->qty)),0,',','.') }}</td>
                              </tr>
                          @endif
                      
                    @endif
                      
                    @php
                      $counter++;  
                      

                      if($abb_last == $rdata->abbr){
                        $total_base_commision_c = $rdata->base_commision + $total_base_commision_c;    
                        $total_commisions_c = $rdata->commisions + $total_commisions_c;  
                        $total_final = $total_final + (-1*$rdata->commisions); 
                      }else{
                        $total_qty = $rdata->qty + $total_qty;    
                        $total_price = $rdata->price + $total_price;    
                        $total_total = $rdata->total + $total_total;  
                        $total_modal = $total_modal + ($rdata->modal);  
                        $total_modal_qty = $total_modal_qty + ($rdata->modal*$rdata->qty);  
                        $total_base_commision_c = $rdata->base_commision + $total_base_commision_c;    
                        $total_commisions_c = $rdata->commisions + $total_commisions_c;  
                        $total_base_commision_tp = $rdata->base_commision_tp + $total_base_commision_tp;    
                        $total_commisions_tp = $rdata->commisions_tp + $total_commisions_tp; 
                        $total_final = $total_final + ($rdata->total-($rdata->commisions_tp+$rdata->commisions+($rdata->modal*$rdata->qty))); 
                      }

                      $abb_last = $rdata->abbr;

                      


                      $total_qty_t = $rdata->qty + $total_qty_t;    
                      $total_price_t = $rdata->price + $total_price_t;    
                      $total_total_t = $rdata->total + $total_total_t; 
                      $total_modal_t = $total_modal_t + ($rdata->modal);
                      $total_modal_qty_t = $total_modal_qty_t + ($rdata->qty * $rdata->modal);

                      $total_base_commision_c_t = $rdata->base_commision + $total_base_commision_c_t;    
                      $total_commisions_c_t = $rdata->commisions + $total_commisions_c_t;   

                      $total_base_commision_tp_t = $rdata->base_commision_tp + $total_base_commision_tp_t;    
                      $total_commisions_tp_t = $rdata->commisions_tp + $total_commisions_tp_t;  
                      $total_final_t = $total_final_t + ($rdata->total-($rdata->commisions_tp+$rdata->commisions+($rdata->modal*$rdata->qty)));
                    @endphp
                  @endif
                @endforeach

                <tr>
                  <th colspan="2" style="background-color: #abadac">SUB TOTAL</th>
                  <th class="d-none"></th>
                  <th style="background-color: #abadac">{{ number_format($total_qty,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_price,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_modal,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_total,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_modal_qty,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_base_commision_tp,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_commisions_tp,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_base_commision_c,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_commisions_c,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_final,0,',','.') }}</th>
                </tr>
                  
              @endforeach

              <tr>
                <th colspan="2" style="background-color: #FFA726">TOTAL</th>
                <th class="d-none"></th>
                <th style="background-color: #FFA726">{{ number_format($total_qty_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_price_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_modal_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_total_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_modal_qty_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_base_commision_tp_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_commisions_tp_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_base_commision_c_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_commisions_c_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_final_t,0,',','.') }}</th>
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
    $(document).ready(function() {
      new DataTable('#example',{
        "ordering": false,
        "paging" : false,
        info: false,
        columnDefs: [
        { 
          targets: [1,3,4,5,6,7,8,9,10,11], 
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

 
    });

   
</script>
<script type="text/javascript">
  //window.print();
  const workbook = new ExcelJS.Workbook();
   workbook.creator = 'Kakiku System Apps';
   workbook.created = new Date();

   let report_data_detail_t = [];
   let report_data_com_from1 = [];
   let report_data_terapist = [];

   $(document).ready(function() {
     var url = "{{ route('reports.cashier.search') }}";
     const params = {
       filter_begin_date_in : "{{ $filter_begin_date }}",
       filter_end_date_in : "{{ $filter_begin_end }}",
       filter_branch_id_in: "{{ $filter_branch_id }}",
       export : 'Export Sum Lite Produk API',
     };

     $('#btn_export_xls').on('click',function(){
       const res = axios.get(url,{ params }, {
                   headers: {}
                 }).then(resp => {
                   report_detail = resp.data.report_detail;
                   report_data = resp.data.report_data;

                   var beginnewformat = resp.data.beginnewformat;
                   var endnewformat = resp.data.endnewformat;

                   let data_filtered = [];

                   data_filtered = [];

                       let worksheet = workbook.addWorksheet("Commision Cashier");

                       /*Column headers*/
                      
                       worksheet.mergeCells('A1', 'E1');
                       worksheet.getCell('A1').value = 'Cabang : '+report_data[0].branch_name;
                       worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('F1', 'L1');
                       worksheet.getCell('F1').value = 'Tgl : '+beginnewformat+' sd '+endnewformat;
                       worksheet.getCell('F1').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('A3', 'A4');
                       worksheet.getCell('A3').value = 'TGL';
                       worksheet.getCell('A3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('B3', 'B4');
                       worksheet.getCell('B3').value = 'JENIS';
                       worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('C3', 'C4');
                       worksheet.getCell('C3').value = 'QTY';
                       worksheet.getCell('C3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('D3', 'D4');
                       worksheet.getCell('D3').value = 'HARGA';
                       worksheet.getCell('D3').alignment = { vertical: 'middle', horizontal: 'center' };   
                       
                       worksheet.mergeCells('E3', 'E4');
                       worksheet.getCell('E3').value = 'MODAL';
                       worksheet.getCell('E3').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.mergeCells('F3', 'F4');
                       worksheet.getCell('F3').value = 'TOTAL REVENUE';
                       worksheet.getCell('F3').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.mergeCells('G3', 'G4');
                       worksheet.getCell('G3').value = 'TOTAL MODAL';
                       worksheet.getCell('G3').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.mergeCells('H3', 'I3');
                       worksheet.getCell('H3').value = 'KOMISI TERAPIS';
                       worksheet.getCell('H3').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.getCell('H4').value = '@';
                       worksheet.getCell('H4').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.getCell('I4').value = 'TOTAL';
                       worksheet.getCell('I4').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.mergeCells('J3', 'K3');
                       worksheet.getCell('J3').value = 'KOMISI KASIR';
                       worksheet.getCell('J3').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.getCell('J4').value = '@';
                       worksheet.getCell('J4').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.getCell('K4').value = 'TOTAL';
                       worksheet.getCell('K4').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.mergeCells('L3', 'L4');
                       worksheet.getCell('L3').value = 'LABA PUSAT';
                       worksheet.getCell('L3').alignment = { vertical: 'middle', horizontal: 'center' };   


                       

                       worksheet.getRow(1).font = { bold: true };
                       worksheet.getRow(2).font = { bold: true };
                       worksheet.getRow(3).font = { bold: true };
                       worksheet.getRow(4).font = { bold: true };
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


                       let counter = 5;
                       var ctx = 0;
                       var total_qty_t = 0;    
                       var total_price_t = 0;    
                       var total_modal_t = 0;    
                       var total_modal_qty_t = 0;    
                       var total_total_t = 0;    
                       var total_commisions_c_t = 0;    
                       var total_commisions_tp_t = 0;    
                       var total_base_commision_c_t = 0;  
                       var total_base_commision_tp_t =  0;
                       var total_qty_t = 0;    
                       var total_final_t = 0;  
                       for (let index = 0; index < report_data.length; index++) {
                         const rowElement = report_data[index];
                         let value_sd = 0;

                           
                          ctx = 0;
                          total_qty = 0;    
                          total_price = 0; 
                          total_modal = 0;    
                          total_modal_qty = 0;    
                          total_total = 0;    
                          total_final = 0;    
                          total_commisions_c = 0;    
                          total_commisions_tp = 0;    
                          total_base_commision_c = 0;    
                          total_base_commision_tp = 0;    
                          total_qty = 0;  

                          for (let idx = 0; idx < report_detail.length; idx++) {
                            const rowElementDetail = report_detail[idx];

                            if(rowElementDetail.branch_id == rowElement.branch_id && rowElementDetail.dated == rowElement.dated){
                                
                                if(ctx == 0){
                                  worksheet.getCell('A'+counter).value = rowElement.datedformat;
                                  worksheet.getCell('B'+counter).value = rowElementDetail.abbr;
                                  worksheet.getCell('C'+counter).value = rowElementDetail.qty;
                                  worksheet.getCell('D'+counter).value = rowElementDetail.price;
                                  worksheet.getCell('E'+counter).value = rowElementDetail.modal;
                                  worksheet.getCell('F'+counter).value = rowElementDetail.total;
                                  worksheet.getCell('G'+counter).value = parseFloat(rowElementDetail.modal) * parseFloat(rowElementDetail.qty);
                                  worksheet.getCell('H'+counter).value = rowElementDetail.base_commision_tp;
                                  worksheet.getCell('I'+counter).value = rowElementDetail.commisions_tp;
                                  worksheet.getCell('J'+counter).value = rowElementDetail.base_commision;
                                  worksheet.getCell('K'+counter).value = rowElementDetail.commisions;
                                  worksheet.getCell('L'+counter).value = parseFloat(rowElementDetail.total) - ((parseFloat(rowElementDetail.modal) * parseFloat(rowElementDetail.qty))+parseFloat(rowElementDetail.commisions_tp)+parseFloat(rowElementDetail.commisions_tp));
                                  
                                  ctx++;

                                  worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('I'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('J'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('K'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('L'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
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
                                  worksheet.getCell('K'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('L'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                                }else{
                                  worksheet.getCell('A'+counter).value = "";
                                  worksheet.getCell('B'+counter).value = rowElementDetail.abbr;
                                  worksheet.getCell('C'+counter).value = rowElementDetail.qty;
                                  worksheet.getCell('D'+counter).value = rowElementDetail.price;
                                  worksheet.getCell('E'+counter).value = rowElementDetail.modal;
                                  worksheet.getCell('F'+counter).value = rowElementDetail.total;
                                  worksheet.getCell('G'+counter).value = parseFloat(rowElementDetail.modal) * parseFloat(rowElementDetail.qty);
                                  worksheet.getCell('H'+counter).value = rowElementDetail.base_commision_tp;
                                  worksheet.getCell('I'+counter).value = rowElementDetail.commisions_tp;
                                  worksheet.getCell('J'+counter).value = rowElementDetail.base_commision;
                                  worksheet.getCell('K'+counter).value = rowElementDetail.commisions;
                                  worksheet.getCell('L'+counter).value = parseFloat(rowElementDetail.total) - ((parseFloat(rowElementDetail.modal) * parseFloat(rowElementDetail.qty))+parseFloat(rowElementDetail.commisions_tp)+parseFloat(rowElementDetail.commisions_tp));
                                    
                                  ctx++;
                                  worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('I'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('J'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('K'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('L'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
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
                                  worksheet.getCell('K'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('L'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                                }

                               total_qty = parseFloat(rowElementDetail.qty) + total_qty;    
                               total_price = parseFloat(rowElementDetail.price) + total_price;    
                               total_total = parseFloat(rowElementDetail.total) + total_total;  
                               total_modal = total_modal+ parseFloat(rowElementDetail.modal);  
                               total_modal_qty = total_modal_qty + (parseFloat(rowElementDetail.modal)*parseFloat(rowElementDetail.qty));  
                               total_base_commision_c = parseFloat(rowElementDetail.base_commision) + total_base_commision_c;    
                               total_commisions_c = parseFloat(rowElementDetail.commisions) + total_commisions_c;  
                               total_base_commision_tp =  parseFloat(rowElementDetail.base_commision_tp) + total_base_commision_tp;    
                               total_commisions_tp = parseFloat(rowElementDetail.commisions_tp) + total_commisions_tp; 
                               total_final = total_final + (parseFloat(rowElementDetail.total)-(parseFloat(rowElementDetail.commisions_tp)+parseFloat(rowElementDetail.commisions)+(parseFloat(rowElementDetail.modal)*parseFloat(rowElementDetail.qty)))); 
                                


                                total_qty_t = parseFloat(rowElementDetail.qty) + total_qty_t;    
                                total_price_t = parseFloat(rowElementDetail.price) + total_price_t;    
                                total_total_t = parseFloat(rowElementDetail.total) + total_total_t; 
                                total_modal_t = (total_modal_t + parseFloat(rowElementDetail.modal));
                                total_modal_qty_t = total_modal_qty_t + (parseFloat(rowElementDetail.qty) * parseFloat(rowElementDetail.modal));

                                total_base_commision_c_t = parseFloat(rowElementDetail.base_commision) +  total_base_commision_c_t;    
                                total_commisions_c_t = parseFloat(rowElementDetail.commisions) + total_commisions_c_t;   

                                total_base_commision_tp_t = (parseFloat(rowElementDetail.base_commision_tp) + total_base_commision_tp_t);    
                                total_commisions_tp_t = parseFloat(rowElementDetail.commisions_tp) + total_commisions_tp_t;  
                                total_final_t = total_final_t + (parseFloat(rowElementDetail.total)-(parseFloat(rowElementDetail.commisions_tp)+parseFloat(rowElementDetail.commisions)+(parseFloat(rowElementDetail.modal)*parseFloat(rowElementDetail.qty))));
                                
                                
                              }

                            }
                          
                    

                          worksheet.getCell('A'+counter).value = "SUB TOTAL";
                          worksheet.getCell('B'+counter).value = "";
                          worksheet.getCell('C'+counter).value = total_qty;
                          worksheet.getCell('D'+counter).value = total_price;
                          worksheet.getCell('E'+counter).value = total_modal;
                          worksheet.getCell('F'+counter).value = total_total;
                          worksheet.getCell('G'+counter).value = total_modal_qty;
                          worksheet.getCell('H'+counter).value = total_base_commision_tp;
                          worksheet.getCell('I'+counter).value = total_commisions_tp;
                          worksheet.getCell('J'+counter).value = total_base_commision_c;
                          worksheet.getCell('K'+counter).value = total_commisions_c;
                          worksheet.getCell('L'+counter).value = total_final;

                          worksheet.getRow(counter).font = { bold: true };
                          worksheet.getCell('A'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('B'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('C'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('D'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('E'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('F'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('G'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('H'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('I'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('J'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('K'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('L'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};

                          counter++;


                         
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

                      worksheet.getCell('A'+counter).value = "GRAND TOTAL";
                      worksheet.getCell('B'+counter).value = "";
                      worksheet.getCell('C'+counter).value = total_qty_t;
                      worksheet.getCell('D'+counter).value = total_price_t;
                      worksheet.getCell('E'+counter).value = total_modal_t;
                      worksheet.getCell('F'+counter).value = total_total_t;
                      worksheet.getCell('G'+counter).value = total_modal_qty_t;
                      worksheet.getCell('H'+counter).value = total_base_commision_tp_t;
                      worksheet.getCell('I'+counter).value = total_commisions_tp_t;
                      worksheet.getCell('J'+counter).value = total_base_commision_c_t;
                      worksheet.getCell('K'+counter).value = total_commisions_c_t;
                      worksheet.getCell('L'+counter).value = total_final_t;

                      worksheet.getRow(counter).font = { bold: true };
                      worksheet.getCell('A'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('B'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('C'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('D'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('E'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('F'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('G'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('H'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('I'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('J'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('K'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('L'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                      worksheet.eachRow({ includeEmpty: true }, function(row, rowNumber) {
                             row.eachCell({ includeEmpty: true }, function(cell, colNumber) {
                               cell.border = borderStyles;
                             });
                           });



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