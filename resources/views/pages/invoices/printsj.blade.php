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
          <tr style="text-align: center;height: 30px;background-color:#007C78;">
            <td style="text-align: left;padding:15px;">
              
              <!-- <img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="150px"><br> -->
              <label style="font-size:18px;">{{ $settings[0]->company_name }}</label><br>
              <label style="font-size:15px;">{{ $invoiceDetails[0]->branch_name }}</label><br>
              <label style="font-size:13px;">{{ $invoiceDetails[0]->branch_address }}</label></td>
            <td style="width: 50%;font-size:24px;"><p style="color: #212121;">@lang('general.lbl_delivery_note')</p></td>
          </tr>
          <tr style="background-color:#777B73;height:5px;">
            <td colspan="2" style="height:5px;"><br></td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 50px">
            <td style="text-align: left;font-size:13px;padding-left:10px;width:30%;vertical-align: text-top;">        
              <label style="font-weight: bold;">@lang('general.lbl_customer') :</label><br>
              <label>{{ $customers[0]->name }}</label><br>
              <label>{{ $customers[0]->address }}</label><br>
              <label>{{ $customers[0]->phone_no }}</label><br>
            </td>
            <td style="text-align: left;padding:10px;width:10%;vertical-align: text-top;">        
              
            </td>
            <td style="text-align: right;width: 20%;font-size:13px;vertical-align: text-top;">
              <label>@lang('general.lbl_dated')  :</label><br>
              <label>@lang('general.lbl_invoice_no')  :</label><br>
            </td>
            <td style="text-align: left;width: 32%;font-size:13px;padding-left:10px;vertical-align: text-top;">
              <label>{{ substr(explode(" ",$invoice->dated)[0],8,2) }}-{{substr(explode(" ",$invoice->dated)[0],5,2) }}-{{ substr(explode(" ",$invoice->dated)[0],0,4) }}</label><br>
              <label>{{ $invoice->invoice_no }}</label><br>
            </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 245%">
        <thead>
        <tr style="background-color:#007C78;">
            <th>@lang('general.product')</th>
            <th scope="col" width="10%">@lang('general.lbl_uom')</th>
            <th scope="col" width="5%">@lang('general.lbl_qty')</th>
        </tr>
        </thead>
        <tbody>
          @foreach($invoiceDetails as $invoiceDetail)
              <tr>
                  <td style="text-align: left;font-size:14px;">{{ $invoiceDetail->product_name }}</th>
                  <td style="text-align: center;left;font-size:14px;">{{ $invoiceDetail->uom }}</td>
                  <td style="text-align: center;left;font-size:14px;">{{ number_format($invoiceDetail->qty,0,',','.') }}</td>
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
            <td style="text-align: left;width:70%;">Catatan : </td>
          </tr>
          <tr>
            <th style="text-align: left;width:70%;">{{ $invoice->payment_type }} @if($invoice->total_payment>=$invoice->total)  {{ "Lunas" }}   @endif</th>
          </tr>
          <tr>
            <th style="text-align: left;width:70%;"></th>
          </tr>
          <tr>
            <th style="text-align: left;width:70%;"></th>
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