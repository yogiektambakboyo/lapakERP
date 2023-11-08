<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Summary Perawatan</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
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
        $width_table = 100 + ((count($counter_service)-14)*5);
      }
    ?>

    <button id="btn_export_xls"  class="btn print printPageButton">Cetak XLS</button>
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
          <th scope="col" width="10%">Tgl</th>
          <th scope="col" width="4%">Qty W</th>
          <th scope="col" width="4%">Qty P</th>
          <th scope="col" width="4%">Qty</th>
          @foreach($counter_service as $serv)
                <th  scope="col">
                  <div class="">{{  $serv->product_abbr }}</div>
                </th>
          @endforeach
          <th scope="col" width="4%">Cases</th>


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
                      <td style="text-align: left;">{{ $detail->dated }}</td>
                      <td style="text-align: left;">{{ $detail->qty_w }}</td>
                      <td style="text-align: left;">{{ $detail->qty_p }}</td>
                      <td style="text-align: left;">{{ ($detail->qty_p+$detail->qty_w) }}</td>

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
                     
                      <td style="text-align: left;">{{ $detail->qty_total }}</td>

                </tr>
                @php
                 $counter++;
                 $counterall++;
                @endphp
           @endforeach
                <tr>
                  <th>JUMLAH</th>
                  <th scope="col" width="5%">{{ number_format($report_data_total[0]->qty_w,0,',','.') }}</th>
                  <th scope="col" width="5%">{{ number_format($report_data_total[0]->qty_p,0,',','.') }}</th>
                  <th scope="col" width="5%">{{ number_format(($report_data_total[0]->qty_p+$report_data_total[0]->qty_w),0,',','.') }}</th>
                  
                  @foreach($counter_service as $serv)
                  <th  scope="col">
                    <?php
                        echo number_format(($serv->sum_qty),0,',','.');
                    ?>
                  </th>
                  @endforeach

                  <th scope="col" width="5%">{{ number_format($report_data_total[0]->qty_total,0,',','.') }}</th>
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

    function nextChar(c) {
        return String.fromCharCode(c.charCodeAt(0) + 1);
    }
  
    $(document).ready(function() {
      var url = "{{ route('reports.invoicedetail.search') }}";
      const params = {
        filter_begin_date_in : "{{ $filter_begin_date }}",
        filter_end_date_in : "{{ $filter_begin_end }}",
        filter_branch_id_in: "{{ $filter_branch_id }}",
        export : 'Export Total API',
      };

      $('#btn_export_xls').on('click',function(){
        const res = axios.get(url,{ params }, {
                    headers: {}
                  }).then(resp => {
                    report_datas = resp.data.report_datas;
                    dtt_raw_oneline = resp.data.dtt_raw_oneline;
                    report_data_terapist = resp.data.report_data_terapist;

                    var beginnewformat = resp.data.filter_begin_date;
                    var endnewformat = resp.data.filter_begin_end;

                    let worksheet = workbook.addWorksheet("Worksheet");

                        worksheet.mergeCells('A1', 'E1');
                        worksheet.getCell('A1').value = 'Cabang : '+report_datas[0].branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.mergeCells('K1', 'O1');
                        worksheet.getCell('K1').value = 'Tgl : '+beginnewformat+' sd '+endnewformat;
                        worksheet.getCell('K1').alignment = { vertical: 'middle', horizontal: 'center' };



                        worksheet.getCell('A3').value = 'Tgl';
                        worksheet.getCell('A3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('B3').value = 'Qty Wanita';
                        worksheet.getCell('B3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('C3').value = 'Qty Pria';
                        worksheet.getCell('C3').alignment = { vertical: 'middle', horizontal: 'center' };

                        worksheet.getCell('D3').value = 'Qty';
                        worksheet.getCell('D3').alignment = { vertical: 'middle', horizontal: 'center' };

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


                        var columnx  = 'E';
                        var columnadd  = '';
                    // Loop Terapist
                    dtt_raw_oneline.forEach(element => {
                        if(parseInt(element.total_324)>0){
                          worksheet.getCell(columnx+'3').value = 'VTT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);

                        }
                        if(parseInt(element.total_325)>0){
                          worksheet.getCell(columnx+'3').value = 'VFBT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_326)>0){
                          worksheet.getCell(columnx+'3').value = 'VFBR';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_327)>0){
                          worksheet.getCell(columnx+'3').value = 'VEBBSL';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_328)>0){
                          worksheet.getCell(columnx+'3').value = 'VEBBSSGT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_280)>0){
                          worksheet.getCell(columnx+'3').value = 'TH';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_281)>0){
                          worksheet.getCell(columnx+'3').value = 'FAC';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_282)>0){
                          worksheet.getCell(columnx+'3').value = 'BHC';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_283)>0){
                          worksheet.getCell(columnx+'3').value = 'ST';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_284)>0){
                          worksheet.getCell(columnx+'3').value = 'TT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_285)>0){
                          worksheet.getCell(columnx+'3').value = 'FR';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_286)>0){
                          worksheet.getCell(columnx+'3').value = 'HS';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_287)>0){
                          worksheet.getCell(columnx+'3').value = 'EC';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_289)>0){
                          worksheet.getCell(columnx+'3').value = 'FBT';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_290)>0){
                          worksheet.getCell(columnx+'3').value = 'AA';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_291)>0){
                          worksheet.getCell(columnx+'3').value = 'FBR';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_292)>0){
                          worksheet.getCell(columnx+'3').value = 'VSPA';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_293)>0){
                          worksheet.getCell(columnx+'3').value = 'BACK DRY';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_294)>0){
                          worksheet.getCell(columnx+'3').value = 'BACK';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_295)>0){
                          worksheet.getCell(columnx+'3').value = 'BCM';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_296)>0){
                          worksheet.getCell(columnx+'3').value = 'SLIMM & BREAST';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_297)>0){
                          worksheet.getCell(columnx+'3').value = 'SLIM';
                          worksheet.getCell(columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_298)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }
                          worksheet.getCell(columnadd+columnx+'3').value = 'BREAST';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_300)>0){

                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }
                          worksheet.getCell(columnadd+columnx+'3').value = 'EBBSL';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_301)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnadd+columnx+'3').value = 'EBBS';
                          worksheet.getCell(columnadd+columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_302)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'BODY BLCH.';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_304)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'BABSL';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_305)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'BABS';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_306)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'JFS';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_307)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'FOOT';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_308)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'FOOT EXPR.';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_310)>0){


                          worksheet.getCell(columnadd+columnx+'3').value = 'BCP';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_312)>0){


                          worksheet.getCell(columnadd+columnx+'3').value = 'LA';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };


                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_313)>0){


                          worksheet.getCell(columnadd+columnx+'3').value = 'MSU';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }


                        }
                        if(parseInt(element.total_315)>0){


                          worksheet.getCell(columnadd+columnx+'3').value = 'MB';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }


                        }
                        if(parseInt(element.total_317)>0){

                          worksheet.getCell(columnadd+columnx+'3').value = 'STEAM B';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_321)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'TP';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_316)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'ET';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_309)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'ETHC';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_318)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = '21:00';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_319)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = '22:00';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_oth)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+'3').value = 'OTHER';
                          worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }


                    });
                    // End loop header

                    worksheet.getCell(columnadd+columnx+'3').value = 'Case';
                    worksheet.getCell(columnadd+columnx+'3').alignment = { vertical: 'middle', horizontal: 'center' };

                
                    var countery = 4;
                    columnx = 'E';
                    columnadd = '';
                    report_datas.forEach(element => {
                         worksheet.getCell('A'+countery).value = element.dated;
                         worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                         worksheet.getCell('B'+countery).value = element.qty_w;
                         worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                         worksheet.getCell('C'+countery).value = element.qty_p;
                         worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                         worksheet.getCell('D'+countery).value = (element.qty_w+element.qty_p);
                         worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                        columnx = 'E';
                        columnadd = '';
                        dtt_raw_oneline.forEach(elementx => {
                          if(parseInt(elementx.total_324)>0){
                              if(parseInt(element.total_324)>0){
                                worksheet.getCell(columnx+countery).value = elementx.total_324;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }
                            nextChar(columnx);
                            columnx = nextChar(columnx);

                          }
                          if(parseInt(elementx.total_325)>0){
                            if(parseInt(element.total_325)>0){
                                worksheet.getCell(columnx+countery).value = element.total_325;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_326)>0){
                            if(parseInt(element.total_326)>0){
                                worksheet.getCell(columnx+countery).value = element.total_326;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }              

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_327)>0){
                            if(parseInt(element.total_327)>0){
                                worksheet.getCell(columnx+countery).value = element.total_327;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }   
                      
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_328)>0){
                            if(parseInt(element.total_328)>0){
                                worksheet.getCell(columnx+countery).value = element.total_328;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_280)>0){
                            if(parseInt(element.total_280)>0){
                                worksheet.getCell(columnx+countery).value = element.total_280;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_281)>0){
                            if(parseInt(element.total_281)>0){
                                worksheet.getCell(columnx+countery).value = element.total_281;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_282)>0){
                            if(parseInt(element.total_282)>0){
                                worksheet.getCell(columnx+countery).value = element.total_282;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_283)>0){
                            if(parseInt(element.total_283)>0){
                                worksheet.getCell(columnx+countery).value = element.total_283;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                          
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_284)>0){
                            if(parseInt(element.total_284)>0){
                                worksheet.getCell(columnx+countery).value = element.total_284;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }

                          if(parseInt(elementx.total_285)>0){
                            if(parseInt(element.total_285)>0){
                                worksheet.getCell(columnx+countery).value = element.total_285;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              

                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_286)>0){
                            if(parseInt(element.total_286)>0){
                                worksheet.getCell(columnx+countery).value = element.total_286;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_287)>0){
                            if(parseInt(element.total_287)>0){
                                worksheet.getCell(columnx+countery).value = element.total_287;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_289)>0){
                            if(parseInt(element.total_289)>0){
                                worksheet.getCell(columnx+countery).value = element.total_289;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_290)>0){
                            if(parseInt(element.total_290)>0){
                                worksheet.getCell(columnx+countery).value = element.total_290;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_291)>0){
                            if(parseInt(element.total_291)>0){
                                worksheet.getCell(columnx+countery).value = element.total_291;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_292)>0){
                            if(parseInt(element.total_292)>0){
                                worksheet.getCell(columnx+countery).value = element.total_292;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_293)>0){
                            if(parseInt(element.total_293)>0){
                                worksheet.getCell(columnx+countery).value = element.total_293;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_294)>0){
                            if(parseInt(element.total_294)>0){
                                worksheet.getCell(columnx+countery).value = element.total_294;
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_295)>0){
                            if(parseInt(element.total_295)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_295;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_296)>0){
                            if(parseInt(element.total_296)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_296;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_297)>0){
                            if(parseInt(element.total_297)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_297;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            nextChar(columnx);
                            columnx = nextChar(columnx);
                          }
                          if(parseInt(elementx.total_298)>0){
                            
                            if(parseInt(element.total_298)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_298;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  

                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                           
                          }
                          if(parseInt(elementx.total_300)>0){

                            if(parseInt(element.total_300)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_300;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_301)>0){
                            

                            if(parseInt(element.total_301)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_301;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_302)>0){
  

                            if(parseInt(element.total_302)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_302;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                            if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                          if(parseInt(elementx.total_304)>0){
    

                            if(parseInt(element.total_304)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_304;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_305)>0){
  

                            if(parseInt(element.total_305)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_305;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_306)>0){
 

                            if(parseInt(element.total_306)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_306;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_307)>0){
  

                            if(parseInt(element.total_307)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_307;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_308)>0){
   

                            if(parseInt(element.total_308)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_308;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_310)>0){
  

                            if(parseInt(element.total_310)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_310;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_312)>0){
 

                            if(parseInt(element.total_312)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_312;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_313)>0){
   
                            if(parseInt(element.total_313)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_313;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_315)>0){
      

                            if(parseInt(element.total_315)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_315;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_317)>0){
         

                            if(parseInt(element.total_317)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_317;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_321)>0){
      

                            if(parseInt(element.total_321)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_321;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnx+countery).value = '0';
                                worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                          if(parseInt(elementx.total_316)>0){
   

                            if(parseInt(element.total_316)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_316;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                          if(parseInt(elementx.total_309)>0){
      

                            if(parseInt(element.total_309)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_309;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_318)>0){
    

                            if(parseInt(element.total_318)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_318;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }
                          if(parseInt(elementx.total_319)>0){


                            if(parseInt(element.total_319)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_319;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                          if(parseInt(elementx.total_oth)>0){
                            if(parseInt(element.total_oth)>0){
                                worksheet.getCell(columnadd+columnx+countery).value = element.total_oth;
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }else{
                                worksheet.getCell(columnadd+columnx+countery).value = '0';
                                worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };
                              }  
                              if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                          }

                        });

                        worksheet.getCell(columnadd+columnx+countery).value = (element.qty_total);
                        worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                        countery++;

                    });
                    // End loop header


                    worksheet.getCell('A'+countery).value = 'JUMLAH';
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('B'+countery).value = dtt_raw_oneline[0].qty_w;
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('C'+countery).value = dtt_raw_oneline[0].qty_p;
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell('D'+countery).value = (dtt_raw_oneline[0].qty_w+dtt_raw_oneline[0].qty_p);
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    worksheet.getCell(columnadd+columnx+countery).value = dtt_raw_oneline[0].qty_total;
                    worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                    columnadd = "";
                    columnx = "E";
                    dtt_raw_oneline.forEach(element => {
                        if(parseInt(element.total_324)>0){
                          worksheet.getCell(columnx+countery).value = element.total_324;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);

                        }
                        if(parseInt(element.total_325)>0){
                          worksheet.getCell(columnx+countery).value = element.total_325;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_326)>0){
                          worksheet.getCell(columnx+countery).value = element.total_326;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_327)>0){
                          worksheet.getCell(columnx+countery).value = element.total_327;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_328)>0){
                          worksheet.getCell(columnx+countery).value = element.total_328;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_280)>0){
                          worksheet.getCell(columnx+countery).value = element.total_280;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_281)>0){
                          worksheet.getCell(columnx+countery).value = element.total_281;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_282)>0){
                          worksheet.getCell(columnx+countery).value = element.total_282;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_283)>0){
                          worksheet.getCell(columnx+countery).value = element.total_283;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_284)>0){
                          worksheet.getCell(columnx+countery).value = element.total_284;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_285)>0){
                          worksheet.getCell(columnx+countery).value = element.total_285;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_286)>0){
                          worksheet.getCell(columnx+countery).value = element.total_286;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_287)>0){
                          worksheet.getCell(columnx+countery).value = element.total_287;
                          worksheet.getCell(columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_289)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_289;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_290)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_290;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_291)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_291;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_292)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_292;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_293)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_293;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_294)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_294;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_295)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_295;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_296)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_296;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_297)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_297;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_298)>0){

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_298;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_300)>0){

   
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_300;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_301)>0){


                          worksheet.getCell(columnadd+columnadd+columnx+countery).value = element.total_301;
                          worksheet.getCell(columnadd+columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_302)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_302;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }

                        if(parseInt(element.total_304)>0){
                          worksheet.getCell(columnadd+columnx+countery).value = element.total_304;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_305)>0){

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_305;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_306)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_306;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_307)>0){

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_307;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_308)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_308;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_310)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_310;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_312)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_312;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };


                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_313)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_313;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }


                        }
                        if(parseInt(element.total_315)>0){


                          worksheet.getCell(columnadd+columnx+countery).value = element.total_315;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }


                        }
                        if(parseInt(element.total_317)>0){

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_317;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          if(columnx == "Z") {
                              columnx = "A";
                              columnadd = "A";
                            }else{
                              nextChar(columnx);
                              columnx = nextChar(columnx);
                            }
                        }
                        if(parseInt(element.total_321)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_321;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_316)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_316;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        if(parseInt(element.total_309)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_309;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_318)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_318;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_319)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_319;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }
                        if(parseInt(element.total_oth)>0){
                          if(columnx == "Z") {
                            columnx = "A";
                            columnadd = "A";
                          }

                          worksheet.getCell(columnadd+columnx+countery).value = element.total_oth;
                          worksheet.getCell(columnadd+columnx+countery).alignment = { vertical: 'middle', horizontal: 'center' };

                          nextChar(columnx);
                          columnx = nextChar(columnx);
                        }

                        worksheet.getRow(countery).font = { bold: true };



                    });


                    
                    // End loop header

                    let filename = "Report_Summary_Faktur_"+(Math.floor(Date.now() / 1000)+".xlsx");
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