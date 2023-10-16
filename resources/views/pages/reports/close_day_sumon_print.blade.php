<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Close Day Summary Monthly</title>
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

      <button id="printPageButton" onClick="window.print();"  class="btn print">Cetak Laporan</button>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <td style="width: 20%;">Periode : {{ $period_selected_in[0]->remark }} s/d {{ $period_selected_out[0]->remark }}</td>
              <td style="width: 30%;">Laporan Close Day Summary</td>
              <td style="width: 30%;">Cabang  : {{ count((array)$report_data)>0?$report_data[0]->branch_name:"" }}</td>
          </tr>
        </tbody>
      </table>

  
      {{-- Area Looping --}}
  
      <table class="table table-striped nowrap" id="example"  style="width: 100%">
        <thead>
        <tr>
          <th style="text-align: center;background-color:#FFA726;" scope="col" width="8%">@lang('general.lbl_dated')</th>
          <th style="text-align: center;background-color:#FFA726;"  scope="col">@lang('general.service')</th>     
          <th style="text-align: center;background-color:#FFA726;"  scope="col">@lang('general.product')</th>    
          <th style="text-align: center;background-color:#FFA726;"  scope="col">@lang('general.lbl_drink')</th>     
          <th style="text-align: center;background-color:#FFA726;"  scope="col">Extra</th>    
          <th style="text-align: center;background-color:#FFA726;"  scope="col">Charge Lebaran</th>    
          <th style="text-align: center;background-color:#FFA726;"  scope="col">@lang('general.lbl_cash')</th>     
          <th style="text-align: center;background-color:#FFA726;"  scope="col">B1 - D</th>    
          <th style="text-align: center;background-color:#FFA726;"  scope="col">B1 - K</th>    
          <th style="text-align: center;background-color:#FFA726;"  scope="col">B2 - D</th>    
          <th style="text-align: center;background-color:#FFA726;"  scope="col">B2 - K</th> 
          <th style="text-align: center;background-color:#FFA726;"  scope="col">B1 - QRIS</th> 
          <th style="text-align: center;background-color:#FFA726;"  scope="col">B2 - QRIS</th> 
          <th style="text-align: center;background-color:#FFA726;"  scope="col">B1 - Tnsfr</th> 
          <th style="text-align: center;background-color:#FFA726;"  scope="col">B2 - Tnsfr</th> 
          <th style="text-align: center;background-color:#FFA726;"  scope="col">Cases</th> 
          <th  style="text-align: center;background-color:#FFA726;"  scope="col">Total Pendapatan</th>    
        </tr>
        </thead>
          <?php 
              $total_service = 0;
              $total_product = 0;
              $total_drink = 0;
              $total_extra = 0;
              $total_lebaran = 0;
              $total_cash = 0;
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
                <tr>
                    <td>{{ $rdata->period  }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_service,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_product,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_drink,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_extra,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_lebaran,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_cash,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_b1d,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_b1c,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_b2d,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_b2c,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_b1q,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_b2q,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_b1t,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_b2t,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->qty_service,0,',','.') }}</td>
                    <td style="text-align: right;">{{ number_format($rdata->total_all,0,',','.') }}</td>                  
                </tr>
                <?php 
                    $total_service = $total_service + $rdata->total_service;
                    $total_product = $total_product + $rdata->total_product;
                    $total_drink = $total_drink + $rdata->total_drink;
                    $total_extra = $total_extra + $rdata->total_extra;
                    $total_lebaran = $total_lebaran + $rdata->total_lebaran;
                    $total_cash = $total_cash + $rdata->total_cash;
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
            @endforeach
            <tr>
              <th>Grand Total</th>
              <th style="text-align: right;">{{ number_format($total_service,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_product,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_drink,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_extra,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_lebaran,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_cash,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_b1d,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_b1c,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_b2d,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_b2c,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_b1q,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_b2q,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_b1t,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_b2t,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($qty_service,0,',','.') }}</th>                
              <th style="text-align: right;">{{ number_format($total_all,0,',','.') }}</th>                
          </tr>
        </tbody>
    </table>
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