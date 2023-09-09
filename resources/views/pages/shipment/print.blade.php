<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Shipment</title>
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
              <label>{{ 'KAKIKU PUSAT' }}</label><br>
              <label>{{ 'JL. KELAPA SAWIT IX BG 3 NO.1' }}</label></td>
            <td style="width: 50%;font-size:30px;"><p style="color: #212121;">Pengiriman Pesanan</p></td>
          </tr>
          <tr style="background-color: chocolate;">
            <td colspan="2"><br></td>
          </tr>
        </tbody>
      </table>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 50px">
            <td style="text-align: left;padding-left:10px;width:7%;vertical-align: text-top;"> 
              <label>Penerima</label><br>
              <label>Alamat</label><br>       
              <label>Nama Kurir</label><br>       
            </td>
            <td style="text-align: left;padding:10px;width:35%;vertical-align: text-top;">        
              <label>{{ $doc_data->branch_name }}</label><br>
              <label>{{ $doc_data->address }}</label><br>   
              <label>{{ $doc_data->shipper_name }}</label><br>   
            </td>
            <td style="text-align: right;width: 50%;font-size:15px;width:15%;vertical-align: text-top;">
              <label>@lang('general.lbl_dated')  :</label><br>
              <label>Document No  :</label><br>
            </td>
            <td style="text-align: left;width: 50%;font-size:15px;width:15%;padding-left:10px;vertical-align: text-top;">
              <label>{{ substr(explode(" ",$doc_data->dated)[0],8,2) }}-{{substr(explode(" ",$doc_data->dated)[0],5,2) }}-{{ substr(explode(" ",$doc_data->dated)[0],0,4) }}</label><br>
              <label>{{ $doc_data->doc_no }}</label><br>
            </td>
          </tr>
        </tbody>
      </table>

      <table class="table table-striped" id="order_table" width="100%">
        <thead>
        <tr style="background-color:#FFA726;color:white;">
            <th width="3%">No</th>
            <th width="20%">PO No</th>
            <th width="78%">@lang('general.product')</th>
            <th scope="col" width="8%">@lang('general.lbl_qty')</th>
            <th scope="col" width="10%">@lang('general.lbl_uom')</th>
        </tr>
        </thead>
        <tbody>
          <?php $counter = 1; ?>
          @foreach($data_details as $invoiceDetail)
              <tr>
                  <td style="text-align: left;">{{ $counter++; }}</th>
                  <td style="text-align: left;">{{ $invoiceDetail->po_no }}</th>
                    <td style="text-align: left;">{{ $invoiceDetail->product_name }}</th>
                  <td style="text-align: center;">{{ number_format($invoiceDetail->qty,0,',','.') }}</td>
                  <td style="text-align: center;">{{ $invoiceDetail->uom }}</td>
              </tr>
          @endforeach

          @if (count($data_details)<5)
              @for($i=0;$i<(5-count($data_details));$i++)
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
            <td style="text-align: left;width:70%;">Catatan : {{ $doc_data->remark }}</td>
          </tr>
        </tbody>
      </table> 
      <table class="table table-striped" id="order_table" width="100%">
        <thead>
        </thead>
        <tbody>
          <tr>
            <td style="text-align: center;width:50%;">Pemohon </td>
            <td style="text-align: center;width:50%;">Gudang </td>
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
            <td style="text-align: center;width:50%;">( {{ $users->name }} )</td>
            <td style="text-align: center;width:50%;">( ............................ )</td>
          </tr>
        </tbody>
      </table> 
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: left;background-color:#white;">
            <td style="width: 100%;font-size:10px;font-style: italic;">
              <label>Printed at : {{ \Carbon\Carbon::now()->add('7 hours') }}</label>
            </td>
          </tr>
        </tbody>
      </table>
   </body> 
</html> 