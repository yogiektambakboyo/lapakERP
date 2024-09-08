<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Invoice</title>
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
      </style>
   </head> 
   <body> 

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 30px;background-color:#FFA726;">
            <td style="text-align: left;padding:15px;">
              
              <img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="150px"><br>
              <label>{{ $invoiceDetails[0]->branch_name }}</label><br>
              <label>{{ $invoiceDetails[0]->branch_address }}</label></td>
            <td style="width: 50%;font-size:30px;"><p style="color: #212121;">@lang('general.lbl_invoice')</p></td>
          </tr>
          <tr style="background-color: chocolate;">
            <td colspan="2"><br></td>
          </tr>
        </tbody>
      </table>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 50px">
            <td style="text-align: left;padding-left:10px;width:20%;vertical-align: text-top;">        
              <label style="font-weight: bold;">@lang('general.lbl_customer') :</label><br>
              <label>{{ $customers[0]->name }}</label><br>
              <label>{{ $customers[0]->address }}</label><br>
              <label>{{ $customers[0]->phone_no }}</label><br>
            </td>
            <td style="text-align: left;padding:10px;width:35%;vertical-align: text-top;">        
              
            </td>
            <td style="text-align: right;width: 50%;font-size:15px;width:15%;vertical-align: text-top;">
              <label>@lang('general.lbl_dated')  :</label><br>
              <label>@lang('general.lbl_invoice_no')  :</label><br>
            </td>
            <td style="text-align: left;width: 50%;font-size:15px;width:15%;padding-left:10px;vertical-align: text-top;">
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
            <th scope="col" width="10%">@lang('general.lbl_uom')</th>
            <th scope="col" width="10%">@lang('general.lbl_price')</th>
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
            <td style="text-align: left;width:70%;">@lang('general.lbl_note') : </td>
            <td style="text-align: right;width:20%;background-color:#FFA726;display: none; ">Sub Total</td>
            <td style="text-align: right;width:10%;background-color:#FFA726;display: none; ">{{ number_format(($invoice->total-$invoice->tax),0,',','.') }}</td>
          </tr>
          <tr>
            <th style="text-align: left;width:70%;">{{ $invoice->payment_type }} @if($invoice->total_payment>=$invoice->total)  {{ "Lunas" }}   @endif</th>
            <td style="text-align: right;width:20%;background-color:#FFA726;display: none; ">@lang('general.lbl_tax') </th>
            <td style="text-align: right;width:10%;background-color:#FFA726;display: none; ">{{ number_format($invoice->tax,0,',','.') }}</th>
          </tr>
          <tr>
            <th style="text-align: left;width:70%;"></th>
            <th style="text-align: right;width:20%;background-color:#FFA726;">Total ({{ $invoice->currency }})</th>
            <th style="text-align: right;width:10%;background-color:#FFA726;">{{ number_format($invoice->total,0,',','.') }}</th>
          </tr>
          <tr>
            <th style="text-align: left;width:70%;"></th>
            <th style="text-align: right;width:20%;background-color:#FFA726;">@lang('general.lbl_payment')  ({{ $invoice->currency }}) </th>
            <th style='text-align: right;width:10%;background-color:#FFA726; @if($invoice->payment_nominal-$invoice->total<0) {{ "color : red;" }} @endif'>{{ number_format($invoice->total_payment,0,',','.') }}</th>
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
              <label>Printed at : {{ \Carbon\Carbon::now()->add('7 hours') }}, Print No : {{ $invoice->printed_count }}</label>
            </td>
          </tr>
        </tbody>
      </table>
   </body> 
</html> 

<script type="text/javascript">
  window.print();
</script>