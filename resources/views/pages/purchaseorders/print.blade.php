<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Purchase</title>
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
      </style>
   </head> 
   <body> 

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 50px;background-color:#FFA726;">
            <td style="text-align: left;padding:15px;">
              
              <img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="180px"><br>
              <label>{{ $purchaseDetails[0]->branch_name }}</label><br>
              <label>{{ $purchaseDetails[0]->address }}</label></td>
            <td style="width: 50%;font-size:30px;"><p style="color: #212121;">Purchase Order</p></td>
          </tr>
          <tr style="background-color: chocolate;">
            <td colspan="2"><br></td>
          </tr>
        </tbody>
      </table>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 70px">
            <td style="text-align: left;padding:20px;width:20%;vertical-align: text-top;">        
              <label style="font-weight: bold;">Supplier :</label><br>
              <label>{{ $suppliers[0]->name }}</label><br>
              <label>{{ $suppliers[0]->address }}</label><br>
              <label>{{ $suppliers[0]->email }}</label><br>
              <label>{{ $suppliers[0]->handphone }}</label><br>
            </td>
            <td style="text-align: left;padding:20px;width:35%;vertical-align: text-top;">        
              <label style="font-weight: bold;">Shipto :</label><br>
              <label>{{ $purchaseDetails[0]->branch_name }}</label><br>
              <label>{{ $purchaseDetails[0]->address }}</label></td>
            </td>
            <td style="text-align: right;width: 50%;font-size:15px;width:15%;vertical-align: text-top;">
              <label>Date :</label><br>
              <label>Purchase No :</label><br>
              <label>Remark :</label><br>
            </td>
            <td style="text-align: left;width: 50%;font-size:15px;width:15%;padding-left:10px;vertical-align: text-top;">
              <label>{{ substr(explode(" ",$purchase->dated)[0],8,2) }}-{{substr(explode(" ",$purchase->dated)[0],5,2) }}-{{ substr(explode(" ",$purchase->dated)[0],0,4) }}</label><br>
              <label>{{ $purchase->purchase_no }}</label><br>
              <label>{{ $purchase->remark }}</label><br>
            </td>
          </tr>
        </tbody>
      </table>

      <table class="table table-striped" id="order_table" width="100%">
        <thead>
        <tr style="background-color:#FFA726;color:white;">
            <th>Product Code</th>
            <th scope="col" width="10%">UOM</th>
            <th scope="col" width="10%">Price</th>
            <th scope="col" width="5%">Qty</th>
            <th scope="col" width="10%">Total</th>
        </tr>
        </thead>
        <tbody>
          @foreach($purchaseDetails as $purchaseDetail)
              <tr>
                  <td style="text-align: left;">{{ $purchaseDetail->product_name }}</th>
                  <td style="text-align: center;">{{ $purchaseDetail->uom }}</td>
                  <td style="text-align: center;">{{ number_format($purchaseDetail->price,0,',','.') }}</td>
                  <td style="text-align: center;">{{ number_format($purchaseDetail->qty,0,',','.') }}</td>
                  <td style="text-align: right;">{{ number_format($purchaseDetail->total,0,',','.') }}</td>
              </tr>
          @endforeach

          @if (count($purchaseDetails)<5)
              @for($i=0;$i<(5-count($purchaseDetails));$i++)
                <tr>
                    <td style="text-align: left;"><br></th>
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
            <td style="text-align: left;width:70%;"></td>
            <td style="text-align: right;width:20%;background-color:#FFA726;">Sub Total</td>
            <td style="text-align: right;width:10%;background-color:#FFA726;">Rp. {{ number_format(($purchase->total-$purchase->total_vat),0,',','.') }}</td>
          </tr>
          <tr>
            <td style="text-align: left;width:70%;"></td>
            <td style="text-align: right;width:20%;background-color:#FFA726;">Tax</th>
            <td style="text-align: right;width:10%;background-color:#FFA726;">Rp. {{ number_format($purchase->total_vat,0,',','.') }}</th>
          </tr>
          <tr>
            <th style="text-align: left;width:70%;"></th>
            <th style="text-align: right;width:20%;background-color:#FFA726;">Total</th>
            <th style="text-align: right;width:10%;background-color:#FFA726;">Rp. {{ number_format($purchase->total,0,',','.') }}</th>
          </tr>
        </tbody>
      </table> 
   </body> 
</html> 