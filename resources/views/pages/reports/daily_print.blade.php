<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Harian</title>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          padding: 2px;
        }
        td, th {
            border: .01px solid black;
        }
        div{
          padding:2px;
        }
        @page { margin:0px; }
      </style>
   </head> 
   <body> 

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
            <td colspan="2" style="width: 50%;">Laporan Harian</td>
          </tr>
          <tr style="background-color: chocolate;">
            <td>Tanggal : {{ Carbon\Carbon::parse(count($report_datas)>0?$report_datas[0]->dated:"")->format('d-m-Y')  }}</td>
            <td>Cabang  : {{ count($report_datas)>0?$report_datas[0]->branch_name:"" }}</td>
            <td>Shift   : All </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr>
            <td style="width: 25%;vertical-align:top;">

              <table class="table table-striped" id="service_table">
                <thead>
                <tr style="background-color:#FFA726;color:white;">
                    <th>Perawatan</th>
                    <th scope="col" width="10%">@lang('general.lbl_price')</th>
                    <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                    <th scope="col" width="10%">Total</th>
                </tr>
                </thead>
                <tbody>
                  @php
                    $total_qty = 0;
                    $total_service = 0; 
                    $counter = 0;   
                    $counter_spk = 0;
                  @endphp
                  @foreach($report_datas as $report_data)
                      @if($report_data->type_id==2)
                        <tr>
                            <td style="text-align: left;">{{ $report_data->abbr }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->price,0,',','.') }}</td>
                            <td style="text-align: center;">{{ number_format($report_data->qty,0,',','.') }}</td>
                            <td style="text-align: right;">{{ number_format($report_data->total,0,',','.') }}</td>
                        </tr>
                        @php
                          $total_service = $total_service + $report_data->total; 
                          $counter++;   
                          $total_qty = $total_qty + $report_data->qty;
                        @endphp
                      @endif
                  @endforeach

                  @foreach($payment_datas as $payment_data)
                        @php
                          $counter_spk = $counter_spk + $payment_data->qty_payment;
                        @endphp
                  @endforeach
        
                  @if ($counter<15)
                      @for($i=0;$i<(15-$counter);$i++)
                        <tr>
                            <td style="text-align: left;"><br></th>
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                            <td style="text-align: center;"> </td>
                        </tr>
                      @endfor
                  @endif
      
                </tbody>
              </table>
              

            </td>
        

          </tr>
          <tr>
            <th colspan="2" style="text-align: center;">TTD Kasir<br><br><br>( . . . . . . . . . )</th>
            <th colspan="2" style="text-align: center;">TTD Penerima<br><br><br>( . . . . . . . . . )</th>
          </tr>
        </tbody>
      </table>

       
   </body> 
</html> 