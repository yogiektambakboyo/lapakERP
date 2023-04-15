<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Print SPK</title>
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
          <tr style="text-align: center;height: 40px;background-color:#FFA726;">
            <td style="text-align: left;padding:10px;">
              <img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="130px"><br> 
            </td>
            <td style="width: 50%;font-size:10px;">
              <table style="width: 100%">
                <tbody>
                  <tr style="text-align: center">
                    <td style="text-align: left;padding:10px;width:5%">
                      <label style="font-weight: bold;">Cabang</label><label></label><br>
                      <label style="font-weight: bold;">Tanggal</label><br>
                      <label style="font-weight: bold;">SPK No</label><br>
                    </td>
                    <td style="text-align: left;width: 80%;font-size:10px;">
                      <label> {{ $customers[0]->branch_name }}</label><br>
                      <label> {{ substr(explode(" ",$invoice->dated)[0],8,2) }}-{{substr(explode(" ",$invoice->dated)[0],5,2) }}-{{ substr(explode(" ",$invoice->dated)[0],0,4) }}</label><br>
                      <label> {{ $invoice->invoice_no }}</label><br>
                    </td>
                  </tr>
                </tbody>
              </table>
              
            </td>
          </tr>
        </tbody>
      </table>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 70px">
            <td style="text-align: left;font-size:15px;width:20%;vertical-align: text-top;">
              <label style="">Nama Tamu </label><br>
            </td>
            <td style="text-align: left;width: 80%;font-size:15px;padding-left:10px;vertical-align: text-top;">
              <label>{{ $invoiceDetails[0]->customers_name }}</label><br>
            </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 70px">
            <td style="text-align: left;font-size:15px;width:20%;vertical-align: text-top;">
              <label style="">Nama Terapis </label><br>
            </td>
            <td style="text-align: left;width: 80%;font-size:15px;padding-left:10px;vertical-align: text-top;">
              @php
                $lastassg = "";
                $c = 1;
                $tmpInvDetail = $invoiceDetails;
                $arrTerapist = [];
                for ($i = 0; $i < count($tmpInvDetail); $i++){
                  if($tmpInvDetail[$i]->assigned_to!=''){
                    array_push($arrTerapist, $tmpInvDetail[$i]->assigned_to);
                  }
                }
                $arrTerapist = array_unique($arrTerapist);
              @endphp
              @foreach ($arrTerapist as $Terapist)
                  @if ($Terapist!=$lastassg)
                        <label>{{ $c }}. {{ $Terapist }}</label><br>
                        @php
                        $c++;
                        $lastassg = $Terapist;
                        @endphp
                    @endif                  
              @endforeach
            </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 70px">
            <td style="text-align: left;font-size:15px;width:20%;vertical-align: text-top;">
              <label style="">Ruangan </label><br>
            </td>
            <td style="text-align: left;width: 80%;font-size:15px;padding-left:10px;vertical-align: text-top;">
              <label>{{ $customers[0]->room_name }}</label><br>
            </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 70px">
            <td style="text-align: left;font-size:15px;width:20%;vertical-align: text-top;">
              <label style="">Perawatan </label><br>
            </td>
            <td style="text-align: left;width: 80%;font-size:15px;padding-left:10px;vertical-align: text-top;">
              @php
              $c = 1;
              @endphp
              @for ($i = 0; $i < count($invoiceDetails); $i++)
                  @if (($invoiceDetails[$i]->type_id==2)||($invoiceDetails[$i]->type_id==8))
                    <label>{{ $c }}. {{ $invoiceDetails[$i]->product_name }}</label><br>
                    @php
                    $c++;
                    @endphp
                  @endif
                  
              @endfor

            </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 70px">
            <td style="text-align: left;font-size:15px;width:20%;vertical-align: text-top;">
              <label style="">Produk </label><br>
            </td>
            <td style="text-align: left;width: 80%;font-size:15px;padding-left:10px;vertical-align: text-top;">
              @php
              $c = 1;
              @endphp
              @for ($j = 0; $j < count($invoiceDetails); $j++)
              @if (($invoiceDetails[$j]->type_id!=2)&&($invoiceDetails[$j]->type_id!=8))
                    <label>{{ $c }}. {{ $invoiceDetails[$j]->product_name }}</label><br>
                    @php
                    $c++;
                    @endphp
                  @endif
              @endfor
            </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 70px">
            <td style="text-align: left;font-size:15px;width:20%;vertical-align: text-top;">
              <label style="">Waktu Perawatan </label><br>
            </td>
            <td style="text-align: left;width: 80%;font-size:15px;padding-left:10px;vertical-align: text-top;">
              @php
              $c = 1;
              //$sumconversion = 0;
              for ($i=0; $i <  count($invoiceDetails); $i++) { 
                if (($invoiceDetails[$i]->type_id==2)&&($invoiceDetails[$i]->executed_at!='')){
                   echo '<label>'.($c).'. '.\Carbon\Carbon::parse($invoiceDetails[$i]->executed_at)->format("H:i").'-'.\Carbon\Carbon::parse($invoiceDetails[$i]->executed_at)->add($invoiceDetails[$i]->conversion." minutes")->format("H:i").' ('.$invoiceDetails[$i]->uom.') </label><br>';
                   $c++;
                }
              }
              @endphp
            </td>
          </tr>
        </tbody>
      </table>

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;height: 70px">
            <td style="text-align: left;font-size:15px;width:20%;vertical-align: text-top;">
              <label>Catatan </label><br>
            </td>
            <td style="text-align: left;width: 80%;font-size:15px;padding-left:10px;vertical-align: text-top;">
              <label>{{ $invoice->remark }}</label><br>
            </td>
          </tr>
        </tbody>
      </table>


      <table style="width: 100%">
        <tbody>
          <tr style="text-align: left;background-color:#white;">
            <td style="width: 45%;font-size:10px;">
              <label>TTD Terapis</label>
            </td>
            <td style="width: 5%;font-size:10px;">
            </td>
            <td style="width: 45%;font-size:10px;">
              <label>TTD Konsumen</label>
            </td>
          </tr>
          <tr style="text-align: left;background-color:#white;">
            <td style="width: 45%;font-size:10px;height: 50px;border-width:1px;">
            </td>
            <td style="width: 5%;font-size:10px;">
            </td>
            <td style="width: 45%;font-size:10px;height: 50px;border-width:1px;">
            </td>
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