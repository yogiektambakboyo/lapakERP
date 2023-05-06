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
          #printPageButton {
            display: none;
          }
          .pagebreak { page-break-before: always; } /* page-break-after works, as well */
        }
      </style>
   </head> 
   <body> 

    <button id="printPageButton" onClick="window.print();"  class="btn print">Cetak Laporan Komisi</button>
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