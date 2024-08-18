<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Summary Perawatan</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <link href="/assets/css/jquery.dataTables.min.css" rel="stylesheet"/>
      <link href="/assets/css/bootstrap.min.css" rel="stylesheet"  >
      <link href="/assets/css/dataTables.bootstrap.min_.css" rel="stylesheet"/>
      <link href="/assets/css/buttons.dataTables.min.css" rel="stylesheet"/>
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

    <!-- <button id="btn_export_xls"  class="btn print printPageButton d-none">Cetak XLS</button> -->
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

            @if(count($counter_service)>0)
              <th scope="col" colspan="<?= count($counter_service); ?>">
                <div class="">Perawatan</div>
              </th>
            @endif
           
            <th scope="col" width="100px" rowspan="2" >Cases Perawatan</th>


            @if(count($counter_salon)>0)
              <th scope="col" colspan="{{ count($counter_salon) }}">
                <div class="">Salon</div>
              </th>
            @endif

            <th scope="col" width="100px" rowspan="2">Cases Salon</th>


            @if(count($counter_extra)>0)
              <th scope="col" colspan="{{ count($counter_extra) }}">
                <div class="">Extra</div>
              </th>
            @endif

            <th scope="col" width="100px" rowspan="2">Cases Extra</th>


            @if(count($counter_product)>0)
              <th scope="col" colspan="{{ count($counter_product) }}">
                <div class="">Produk</div>
              </th>
            @endif
            <th scope="col" width="100px" rowspan="2">Cases Produk</th>


            @if(count($counter_drink)>0)
            <th scope="col" colspan="{{ count($counter_drink) }}">
              <div class="">Minuman</div>
            </th>
            @endif

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
                      <td style="text-align: left;">
                        {{ $detail->dated }}
                      </td>
                      <td style="text-align: left;">
                        @foreach($report_gender as $gender)
                          @if($gender->dated==$detail->dated)
                              {{ $gender->qty_w }}
                          @endif
                        @endforeach
                        
                      </td>
                      <td style="text-align: left;">
                        @foreach($report_gender as $gender)
                          @if($gender->dated==$detail->dated)
                              {{ $gender->qty_p }}
                          @endif
                        @endforeach
                      </td>
                      <td style="text-align: left;">
                        @foreach($report_gender as $gender)
                          @if($gender->dated==$detail->dated)
                              {{ $gender->qty_w+$gender->qty_p }}
                          @endif
                        @endforeach
                      </td>

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
                  <th scope="col" width="100px">{{ number_format($report_gender_total[0]->qty_w,0,',','.') }}</th>
                  <th scope="col" width="100px">{{ number_format($report_gender_total[0]->qty_p,0,',','.') }}</th>
                  <th scope="col" width="100px">{{ number_format(($report_gender_total[0]->qty_p+$report_gender_total[0]->qty_w),0,',','.') }}</th>
                  
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
   <script src="/assets/js/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
   <script src="/assets/js/axios.min.js"></script>  
   <script src="/assets/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script> 
   <script src="/assets/js/jquery.dataTables.min_.js"></script>   
   <script src="/assets/js/dataTables.bootstrap.min.js"></script>   
   <script src="/assets/js/dataTables.buttons.min_.js"></script>   
   <script src="/assets/js/jszip.min.js"></script>   
   <script src="/assets/js/pdfmake.min.js"></script>   
   <script src="/assets/js/vfs_fonts.js"></script>   
   <script src="/assets/js/buttons.html5.min_.js"></script>   
   <script src="/assets/js/exceljs.min.js"></script>
   <script src="/assets/js/FileSaver.min.js"></script>
   <script src="/assets/js/accounting.min.js" integrity="sha512-LW+1GKW2tt4kK180qby6ADJE0txk5/92P70Oh5YbtD7heFlC0qFFtacvSnHG4bNXmLnZq5hNb2V70r5DzS/U+g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

   <script type="text/javascript">
    //window.print();
    //const workbook = XLSX.utils.book_new();

    new DataTable('#service_table',{
      "ordering": false,
      "paging" : false,
      info: false,
      searching: false,
        dom: 'Bfrtip',
        buttons: [
              'copyHtml5',
              'excelHtml5',
          ]
    });


  
 </script>
</html> 