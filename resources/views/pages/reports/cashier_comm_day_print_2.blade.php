<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Komisi Kasir</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
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
          #printPageButton {
            display: none;
          }
        }
      </style>
   </head> 
   <body> 

      <button id="printPageButton" onClick="window.print();"  class="btn print">Cetak Laporan Komisi</button>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <td style="width: 40%;">Laporan Komisi Kasir</td>
              <td style="width: 30%;">Cabang  : {{ count((array)$report_data_detail_t)>0?$report_data_detail_t[0]->branch_name:"" }}</td>
          </tr>
        </tbody>
      </table>

  
      {{-- Area Looping --}}
  
      <table class="table table-striped" style="width: 100%">
        <thead>
          <tr style="background-color:#FFA726;color:white;">
            <th rowspan="2">Tgl</th>
            <th rowspan="2">No Faktur</th>
            <th colspan="5">Produk</th>
            <th rowspan="2">Extra Charge</th>
            <th colspan="2">Total</th>
          </tr>
          <tr style="background-color:#FFA726;color:white;">
            <th>Jenis</th>
            <th scope="col" width="5%">Harga</th>
            <th scope="col" width="5%">Komisi</th>
            <th scope="col" width="7%">Jml</th>
            <th scope="col">T Komisi</th>
            <th scope="col" width="8%">Pendapatan</th>
            <th scope="col" width="8%">Pendapatan (s/d)</th>
          </tr>
        </thead>
        <tbody>
          @foreach($report_data_detail_t as $report_data_detail_ts)

            <tr>
              <td style="text-align: left;vertical-align:top;">{{ $report_data_detail_ts->dated }}</td>
              <td style="text-align: left;vertical-align:top;">
                @php  
                if (str_contains($report_data_detail_ts->invoice_no, "##")) {
                  $invoice_no = explode("##",$report_data_detail_ts->invoice_no);
                  foreach ($invoice_no as $value) {
                    echo $value==""?"":$value."<br>";
                  }
                }else{
                  echo $report_data_detail_ts->invoice_no;
                }
                
              @endphp
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
                  echo $report_data_detail_ts->commisions_extra;
                }
              @endphp
              </td>
              <td style="vertical-align:top;">
                {{ number_format($report_data_detail_ts->total,0,',','.') }}
              </td>
              <td style="vertical-align:top;">
                  @php  $tot=0; @endphp
                  @foreach($report_data_com_from1 as $report_data_com_from1s)
                            @php 
                                    $date1 = \Carbon\Carbon::createFromFormat('d-m-Y', $report_data_com_from1s->dated);
                                    $date2 = \Carbon\Carbon::createFromFormat('d-m-Y', $report_data_detail_ts->dated);
                      
                                    
                                    $result = $date1->lte($date2);
                                    if($result){
                                      $tot=$tot+$report_data_com_from1s->total; 
                                    }
                            @endphp
                  @endforeach
                  {{ number_format($tot,0,',','.') }}
              </td>

               
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
   
<script type="text/javascript">
   //window.print();
</script>
</html> 