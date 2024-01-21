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
                      
                    @php
                      $counter++;  
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
              {
                  extend: 'copyHtml5',
                  exportOptions: { 
                    orthogonal: 'export',
                    columns: ':visible'
                  }
              },
              {
                  extend: 'excelHtml5',
                  exportOptions: { 
                    orthogonal: 'export',
                    columns: ':visible'
                  }
              },
          ]
      });

 
    });

   
</script>
</html> 