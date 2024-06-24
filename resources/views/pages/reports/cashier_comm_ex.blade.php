<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Komisi Khusus - CABANG  : {{ count((array)$report_data)>0?$report_data[0]->branch_name:"" }} {{ $filter_begin_date." s/d ".$filter_begin_end }}</title>
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
              <td style="width: 40%;">{{ $beginnewformat." s/d ".$endnewformat }}</td>
              <td style="width: 30%;">CABANG  : {{ count((array)$report_data)>0?$report_data[0]->branch_name:"" }}</td>
          </tr>
        </tbody>
      </table>

  
      {{-- Area Looping --}}

          <table class="table table-striped" style="width: 100%" id="example">
            <thead>
              <tr style="background-color:#FFA726;color:rgb(3, 3, 3);">
                <th  style="background-color: #FFA726">TGL</th>
                <th rowspan="0" style="background-color: #FFA726">NAMA</th>
                <th rowspan="0" style="background-color: #FFA726">NO FAKTUR</th>
                <th rowspan="0" style="background-color: #FFA726">JENIS</th>
                <th rowspan="0" style="background-color: #FFA726">QTY</th>
                <th rowspan="0" style="background-color: #FFA726">HARGA</th>
                <th rowspan="0" style="background-color: #FFA726">KOMISI DASAR</th>
                <th rowspan="0" style="background-color: #FFA726">KOMISI</th>
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
                  
                  $total_base_com = 0;
                  $total_base_com_qty = 0;
                  $total_base_com_t = 0;
                  $total_base_com_qty_t=0;

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
                  $total_base_com = 0;
                  $total_base_com_qty = 0;
                @endphp

                @foreach ($report_detail as $rdata)
                  @if($rdata->branch_id == $data->branch_id && $rdata->dated == $data->dated)

                    @if ($counter == 0)
                      <tr>
                        <td>{{ $rdata->datedformat }}</td>
                        <td>{{ $rdata->name }}</td>
                        <td>{{ $rdata->invoice_no }}</td>
                        <td>{{ $rdata->abbr }}</td>
                        <td>{{ number_format($rdata->qty,0,',','.') }}</td>
                        <td>{{ number_format($rdata->price,0,',','.') }}</td>
                        <td>{{ number_format($rdata->base_com ,0,',','.')}}</td>
                        <td>{{ number_format($rdata->base_com*$rdata->qty,0,',','.') }}</td>
                      </tr>
                    @else
                      <tr>
                        <td></td>
                        <td>{{ $rdata->name }}</td>
                        <td>{{ $rdata->invoice_no }}</td>
                        <td>{{ $rdata->abbr }}</td>
                        <td>{{ number_format($rdata->qty,0,',','.') }}</td>
                        <td>{{ number_format($rdata->price,0,',','.') }}</td>
                        <td>{{ number_format($rdata->base_com,0,',','.') }}</td>
                        <td>{{ number_format($rdata->base_com*$rdata->qty,0,',','.') }}</td>
                      </tr>
                    @endif
                      
                    @php
                      $counter++;  
                      $total_qty = $rdata->qty + $total_qty;    
                      $total_price = $rdata->price + $total_price;    
                      $total_total = $rdata->total + $total_total;  
                      $total_base_com = $rdata->base_com + ($total_base_com);
                      $total_base_com_qty = $total_base_com_qty + ($rdata->base_com*$rdata->qty);

                      $total_qty_t = $rdata->qty + $total_qty_t;    
                      $total_price_t = $rdata->price + $total_price_t;    
                      $total_total_t = $rdata->total + $total_total_t; 
                      $total_base_com_t = $rdata->base_com + $total_base_com_t;
                      $total_base_com_qty_t = ($rdata->base_com*$rdata->qty) + $total_base_com_qty_t;

                    @endphp
                  @endif
                @endforeach

                <tr>
                  <th colspan="4" style="background-color: #abadac">SUB TOTAL</th>
                  <th class="d-none"></th>
                  <th class="d-none"></th>
                  <th class="d-none"></th>
                  <th style="background-color: #abadac">{{ number_format($total_qty,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_price,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_base_com,0,',','.') }}</th>
                  <th style="background-color: #abadac">{{ number_format($total_base_com_qty,0,',','.') }}</th>
                </tr>
                  
              @endforeach

              <tr>
                <th colspan="4" style="background-color: #FFA726">TOTAL</th>
                <th class="d-none"></th>
                <th class="d-none"></th>
                <th class="d-none"></th>
                <th style="background-color: #FFA726">{{ number_format($total_qty_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_price_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_base_com_t,0,',','.') }}</th>
                <th style="background-color: #FFA726">{{ number_format($total_base_com_qty_t,0,',','.') }}</th>
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
          targets: [1,3,4,5,6,7], 
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
       export : 'Export Com API',
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
                      
                       worksheet.mergeCells('A1', 'D1');
                       worksheet.getCell('A1').value = 'Cabang : '+report_data[0].branch_name;
                       worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.mergeCells('E1', 'H1');
                       worksheet.getCell('E1').value = 'Tgl : '+beginnewformat+' sd '+endnewformat;
                       worksheet.getCell('E1').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.getCell('A3').value = 'TGL';
                       worksheet.getCell('A3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.getCell('B3').value = 'NAMA';
                       worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.getCell('C3').value = 'NO FAKTUR';
                       worksheet.getCell('C3').alignment = { vertical: 'middle', horizontal: 'center' };

                       worksheet.getCell('D3').value = 'JENIS';
                       worksheet.getCell('D3').alignment = { vertical: 'middle', horizontal: 'center' };   
                       
                       worksheet.getCell('E3').value = 'QTY';
                       worksheet.getCell('E3').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.getCell('F3').value = 'HARGA';
                       worksheet.getCell('F3').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.getCell('G3').value = 'KOMISI DASAR';
                       worksheet.getCell('G3').alignment = { vertical: 'middle', horizontal: 'center' };   

                       worksheet.getCell('H3').value = 'KOMISI';
                       worksheet.getCell('H3').alignment = { vertical: 'middle', horizontal: 'center' };   

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
                       
                       worksheet.getCell('A3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('B3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('C3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('D3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('E3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('F3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('G3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                       worksheet.getCell('H3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                     


                       let counter = 4;
                       var ctx = 0;
                       var total_qty_t = 0;    
                       var total_price_t = 0;    
                       var total_modal_t = 0;    
                       var total_modal_qty_t = 0;    
                       var total_total_t = 0;    
                       var total_base_com_t = 0;    
                       var total_base_com_qty_t = 0;  
                       
                      var total_qty = 0;    
                      var total_price = 0; 
                      var total_modal = 0;    
                      var total_modal_qty = 0;    
                      var total_total = 0;    
                      var total_final = 0;    
                      var total_base_com = 0;    
                      var total_commisions_tp = 0;    
                      var total_base_com_qty = 0;    

                       
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
                          total_base_com = 0;    
                          total_commisions_tp = 0;    
                          total_base_com_qty = 0;    

                          for (let idx = 0; idx < report_detail.length; idx++) {
                            const rowElementDetail = report_detail[idx];

                            if(rowElementDetail.branch_id == rowElement.branch_id && rowElementDetail.dated == rowElement.dated){
                                
                                if(ctx == 0){
                                  
                                  worksheet.getCell('A'+counter).value = rowElement.datedformat;
                                  worksheet.getCell('B'+counter).value = rowElementDetail.name;
                                  worksheet.getCell('C'+counter).value = rowElementDetail.invoice_no;
                                  worksheet.getCell('D'+counter).value = rowElementDetail.abbr;
                                  worksheet.getCell('E'+counter).value = rowElementDetail.qty;
                                  worksheet.getCell('F'+counter).value = rowElementDetail.price;
                                  worksheet.getCell('G'+counter).value = rowElementDetail.base_com;
                                  worksheet.getCell('H'+counter).value = (parseFloat(rowElementDetail.qty) * parseFloat(rowElementDetail.base_com));
                                  
                                  ctx++;

                                  worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  counter++;
                                  worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                                }else{
                                  worksheet.getCell('A'+counter).value = "";
                                  worksheet.getCell('B'+counter).value = rowElementDetail.name;
                                  worksheet.getCell('C'+counter).value = rowElementDetail.invoice_no;
                                  worksheet.getCell('D'+counter).value = rowElementDetail.abbr;
                                  worksheet.getCell('E'+counter).value = rowElementDetail.qty;
                                  worksheet.getCell('F'+counter).value = rowElementDetail.price;
                                  worksheet.getCell('G'+counter).value = rowElementDetail.base_com;
                                  worksheet.getCell('H'+counter).value = (parseFloat(rowElementDetail.qty) * parseFloat(rowElementDetail.base_com));

                                  ctx++;
                                  worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  counter++;
                                  worksheet.getCell('B'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('C'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('D'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('E'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('F'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('G'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };
                                  worksheet.getCell('H'+counter).alignment = { wrapText: true, vertical: 'top', horizontal: 'left' };

                                }

                               total_qty = parseFloat(rowElementDetail.qty) + total_qty;    
                               total_price = parseFloat(rowElementDetail.price) + total_price;    
                               total_total = parseFloat(rowElementDetail.total) + total_total;  
                               total_base_com = parseFloat(rowElementDetail.base_com) + total_base_com;    
                               total_base_com_qty = total_base_com_qty + (parseFloat(rowElementDetail.base_com) * parseFloat(rowElementDetail.qty));  
                                
                                total_qty_t = parseFloat(rowElementDetail.qty) + total_qty_t;    
                                total_price_t = parseFloat(rowElementDetail.price) + total_price_t;    
                                total_total_t = parseFloat(rowElementDetail.total) + total_total_t; 
                                total_base_com_t = parseFloat(rowElementDetail.base_com) + total_base_com_t;    
                               total_base_com_qty_t = total_base_com_qty_t + (parseFloat(rowElementDetail.base_com) * parseFloat(rowElementDetail.qty));  
                                
                                
                              }

                            }
                          
                    

                          worksheet.getCell('A'+counter).value = "SUB TOTAL";
                          worksheet.getCell('B'+counter).value = "";
                          worksheet.getCell('C'+counter).value = "";
                          worksheet.getCell('D'+counter).value = "";
                          worksheet.getCell('E'+counter).value = total_qty;
                          worksheet.getCell('F'+counter).value = total_total;
                          worksheet.getCell('G'+counter).value = total_base_com;
                          worksheet.getCell('H'+counter).value = total_base_com_qty;

                          worksheet.getRow(counter).font = { bold: true };
                          worksheet.getCell('A'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('B'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('C'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('D'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('E'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('F'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('G'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};
                          worksheet.getCell('H'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'abadac'}};

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
                      worksheet.getCell('C'+counter).value = "";
                      worksheet.getCell('D'+counter).value = "";
                      worksheet.getCell('E'+counter).value = total_qty_t;
                      worksheet.getCell('F'+counter).value = total_total_t;
                      worksheet.getCell('G'+counter).value = total_base_com_t;
                      worksheet.getCell('H'+counter).value = total_base_com_qty_t;

                      worksheet.getRow(counter).font = { bold: true };
                      worksheet.getCell('A'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('B'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('C'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('D'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('E'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('F'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('G'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                      worksheet.getCell('H'+counter).fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                      worksheet.eachRow({ includeEmpty: true }, function(row, rowNumber) {
                             row.eachCell({ includeEmpty: true }, function(cell, colNumber) {
                               cell.border = borderStyles;
                             });
                           });



                   // Loop Terapist

                   //XLSX.writeFile(workbook, "Presidents.xlsx", { compression: true });


                 
                   let filename = "Report_Commission_Cashier_Produk_Khusus_"+(Math.floor(Date.now() / 1000)+".xlsx");
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