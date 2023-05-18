<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Invoice</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          border: 0px inset black;
          padding: 5px;
        }
        div{
          padding:5px;
        }
        @page { margin:0px; }
        button.btn.print::before {
          font-family: fontAwesome;
          content: "\f02f\00a0";
        }
        @media print {
          #printPageButton {
            display: none;
          }
        }
      </style>
   </head> 
   <body> 

    <button id="printPageButton" onClick="window.print();"  class="btn print">Cetak Faktur</button>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 30px;background-color:#FFA726;">
            <td style="text-align: left;padding:15px;">
              
              <img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="150px"><br>
              <label>{{ $invoiceDetails[0]->branch_name }}</label><br>
              <label>{{ $invoiceDetails[0]->branch_address }}</label></td>
            <td style="width: 40%;font-size:30px;"><p style="color: #212121;">@lang('general.lbl_invoice')</p></td>
          </tr>
          <tr style="background-color: chocolate;">
            <td colspan="2"><br></td>
          </tr>
        </tbody>
      </table>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 50px">
            <td style="text-align: left;padding-left:10px;width:30%;vertical-align: text-top;">        
              <label style="font-weight: bold;">@lang('general.lbl_customer') :</label><br>
              <label>{{ $customers[0]->name }}</label><br>
              <label>{{ $customers[0]->address }}</label><br>
              <label>{{ $customers[0]->phone_no }}</label><br>
            </td>
            <td style="text-align: left;padding:10px;width:5%;vertical-align: text-top;">        
              
            </td>
            <td style="text-align: right;width: 25%;font-size:15px;width:18%;vertical-align: text-top;">
              <label>@lang('general.lbl_dated')  :</label><br>
              <label>@lang('general.lbl_invoice_no')  :</label><br>
            </td>
            <td style="text-align: left;width: 37%;font-size:15px;padding-left:10px;vertical-align: text-top;">
              <label>{{ substr(explode(" ",$invoice->dated)[0],8,2) }}-{{substr(explode(" ",$invoice->dated)[0],5,2) }}-{{ substr(explode(" ",$invoice->dated)[0],0,4) }}</label><br>
              <label>{{ $invoice->invoice_no }}</label><br>
            </td>
          </tr>
        </tbody>
      </table>

      <table class="table table-striped" id="order_table" width="100%">
        <thead>
        <tr style="background-color:#FFA726;color:white;">
            <th>@lang('general.product')</th>
            <th scope="col" width="20%">@lang('general.lbl_uom')</th>
            <th scope="col" width="15%">@lang('general.lbl_price')</th>
            <th scope="col" width="5%">@lang('general.lbl_qty')</th>
            <th scope="col" width="10%">Disc.</th>
            <th scope="col" width="10%">Total</th>
        </tr>
        </thead>
        <tbody>
          @foreach($invoiceDetails as $invoiceDetail)
              <tr>
                  <td style="text-align: left;">{{ $invoiceDetail->product_name }}</th>
                  <td style="text-align: center;">{{ $invoiceDetail->uom }}</td>
                  <td style="text-align: center;">{{ number_format($invoiceDetail->price,0,',','.') }}</td>
                  <td style="text-align: center;">{{ number_format($invoiceDetail->qty,0,',','.') }}</td>
                  <td style="text-align: center;">{{ number_format($invoiceDetail->discount,0,',','.') }}</td>
                  <td style="text-align: right;">{{ number_format($invoiceDetail->total,0,',','.') }}</td>
              </tr>
          @endforeach

          @if (count($invoiceDetails)<5)
              @for($i=0;$i<(5-count($invoiceDetails));$i++)
                <tr>
                    <td style="text-align: left;"><br></th>
                    <td style="text-align: center;"> </td>
                    <td style="text-align: center;"> </td>
                    <td style="text-align: center;"> </td>
                    <td style="text-align: center;"> </td>
                    <td style="text-align: right;"> </td>
                </tr>
              @endfor
          @endif
        </tbody>
      </table> 

      <table class="table table-striped" id="order_table" width="100%">
        <thead>
        </thead>
        <tbody>
          <tr>
            <td style="text-align: left;width:55%;">Catatan : </td>
            <td style="text-align: right;width:20%;background-color:#FFA726;display: none; ">Sub Total</td>
            <td style="text-align: right;width:25%;background-color:#FFA726;display: none; ">Rp. {{ number_format(($invoice->total-$invoice->tax),0,',','.') }}</td>
          </tr>
          <tr>
            <th style="text-align: left;width:55%;">{{ $invoice->payment_type }} @if($invoice->total_payment>=$invoice->total)  {{ "Lunas" }}   @endif</th>
            <td style="text-align: right;width:20%;background-color:#FFA726;display: none; ">@lang('general.lbl_tax') </th>
            <td style="text-align: right;width:25%;background-color:#FFA726;display: none; ">Rp. {{ number_format($invoice->tax,0,',','.') }}</th>
          </tr>
          <tr>
            <th style="text-align: left;width:55%;"></th>
            <th style="text-align: right;width:20%;background-color:#FFA726;">Total</th>
            <th style="text-align: right;width:25%;background-color:#FFA726;">Rp. {{ number_format($invoice->total,0,',','.') }}</th>
          </tr>
          <tr>
            <th style="text-align: left;width:55%;"></th>
            <th style="text-align: right;width:20%;background-color:#FFA726;">@lang('general.lbl_payment') </th>
            <th style='text-align: right;width:25%;background-color:#FFA726; @if($invoice->payment_nominal-$invoice->total<0) {{ "color : red;" }} @endif'>Rp. {{ number_format($invoice->total_payment,0,',','.') }}</th>
          </tr>
        </tbody>
      </table> 
      <table class="table table-striped" id="order_table" width="100%">
        <thead>
        </thead>
        <tbody>
          <tr>
            <td style="text-align: center;width:50%;">@lang('general.lbl_cashier') </td>
            <td style="text-align: center;width:50%;">@lang('general.lbl_customer') </td>
          </tr>
          <tr>
            <th style="text-align: center;width:50%;"></th>
            <th style="text-align: center;width:50%;"></th>
          </tr>
          <tr>
            <th style="text-align: center;width:50%;"></th>
            <th style="text-align: center;width:50%;"></th>
          </tr>
          <tr>
            <td style="text-align: center;width:50%;">( {{ $invoice->name }} )</td>
            <td style="text-align: center;width:50%;">( {{ $invoice->customers_name }} )</td>
          </tr>
        </tbody>
      </table> 
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: left;background-color:#white;">
            <td style="width: 100%;font-size:10px;font-style: italic;">
              <label>Printed at : {{ \Carbon\Carbon::now() }}, Print No : {{ $invoice->printed_count }}</label>
            </td>
          </tr>
        </tbody>
      </table>
   </body> 
</html> 