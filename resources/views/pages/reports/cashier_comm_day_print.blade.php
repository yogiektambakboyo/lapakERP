<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Komisi Kasir</title>
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
        @page { margin:0px; }
      </style>
   </head> 
   <body> 

      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <td style="width: 40%;">Laporan Komisi Kasir</td>
              <td style="width: 30%;">Cabang  : {{ count($report_datas)>0?$report_datas[0]->branch_name:"" }}</td>
          </tr>
        </tbody>
      </table>

      


      {{-- Area Looping --}}
  
      <table class="table table-striped" style="width: 100%">
        <thead>
          <tr style="background-color:#FFA726;color:white;">
            <th rowspan="2">Tgl</th>
            <th rowspan="2">MU</th>
            <th rowspan="2">No Faktur</th>
            <th colspan="5">Produk</th>
            <th rowspan="2">Extra Charge</th>
            <th colspan="2">Total</th>
          </tr>
          <tr style="background-color:#FFA726;color:white;">
            <th>Jenis</th>
            <th scope="col" width="5%">Harga</th>
            <th scope="col" width="5%">Komisi</th>
            <th scope="col" width="7%">Jml</th>
            <th scope="col">T Komisi</th>
            <th scope="col" width="8%">Pendapatan</th>
            <th scope="col" width="8%">Pendapatan (s/d)</th>
          </tr>
        </thead>
        <tbody>
          @foreach($report_data_detail_t as $report_data_detail_ts)

            <tr>
              <td style="text-align: left;vertical-align:top;">{{ $report_data_detail_ts->dated }}</td>
              <td style="text-align: left;vertical-align:top;">{{ $report_data_detail_ts->name }}</td>
              <td style="text-align: left;vertical-align:top;">
                @foreach($report_data_detail_invs as $report_data_detail_inv)
                   @if($report_data_detail_ts->dated == $report_data_detail_inv->dated && $report_data_detail_ts->id == $report_data_detail_inv->id)
                      {{ $report_data_detail_inv->invoice_no }}<br>
                    @endif
                @endforeach
              </td>
              <td style="vertical-align:top;">
                @foreach($report_data_detail_invs as $report_data_detail_inv)
                   @if($report_data_detail_ts->dated == $report_data_detail_inv->dated && $report_data_detail_ts->id == $report_data_detail_inv->id)
                      @foreach($report_datas_detail as $report_data_detail)
                          @if($report_data_detail->type_id==1 && ($report_data_detail_inv->invoice_no==$report_data_detail->invoice_no ) && ($report_data_detail_inv->id==$report_data_detail->id))
                          {{ $report_data_detail->abbr }}<br>
                          @endif
                      @endforeach
                    @endif
                @endforeach
              </td>
              <td style="vertical-align:top;">
                @foreach($report_data_detail_invs as $report_data_detail_inv)
                   @if($report_data_detail_ts->dated == $report_data_detail_inv->dated && $report_data_detail_ts->id == $report_data_detail_inv->id)
                      @foreach($report_datas_detail as $report_data_detail)
                          @if($report_data_detail->type_id==1 && ($report_data_detail_inv->invoice_no==$report_data_detail->invoice_no ) && ($report_data_detail_inv->id==$report_data_detail->id))
                          {{ number_format($report_data_detail->price,0,',','.') }}<br>
                          @endif
                      @endforeach
                    @endif
                @endforeach
              </td>
              <td style="vertical-align:top;">
                @foreach($report_data_detail_invs as $report_data_detail_inv)
                   @if($report_data_detail_ts->dated == $report_data_detail_inv->dated && $report_data_detail_ts->id == $report_data_detail_inv->id)
                      @foreach($report_datas_detail as $report_data_detail)
                          @if($report_data_detail->type_id==1 && ($report_data_detail_inv->invoice_no==$report_data_detail->invoice_no ) && ($report_data_detail_inv->id==$report_data_detail->id))
                          {{ number_format($report_data_detail->base_commision,0,',','.') }}<br>
                          @endif
                      @endforeach
                    @endif
                @endforeach
              </td>
              <td style="vertical-align:top;">
                @foreach($report_data_detail_invs as $report_data_detail_inv)
                   @if($report_data_detail_ts->dated == $report_data_detail_inv->dated && $report_data_detail_ts->id == $report_data_detail_inv->id)
                      @foreach($report_datas_detail as $report_data_detail)
                          @if($report_data_detail->type_id==1 && ($report_data_detail_inv->invoice_no==$report_data_detail->invoice_no ) && ($report_data_detail_inv->id==$report_data_detail->id))
                          {{ number_format($report_data_detail->qty,0,',','.') }}<br>
                          @endif
                      @endforeach
                    @endif
                @endforeach
              </td>
              <td style="vertical-align:top;">
                @foreach($report_data_detail_invs as $report_data_detail_inv)
                   @if($report_data_detail_ts->dated == $report_data_detail_inv->dated && $report_data_detail_ts->id == $report_data_detail_inv->id)
                      @foreach($report_datas_detail as $report_data_detail)
                          @if($report_data_detail->type_id==1 && ($report_data_detail_inv->invoice_no==$report_data_detail->invoice_no ) && ($report_data_detail_inv->id==$report_data_detail->id))
                          {{ number_format($report_data_detail->commisions,0,',','.') }}<br>
                          @endif
                      @endforeach
                    @endif
                @endforeach
              </td>
              <td style="vertical-align:top;">
                @foreach($report_data_detail_invs as $report_data_detail_inv)
                   @if($report_data_detail_ts->dated == $report_data_detail_inv->dated && $report_data_detail_ts->id == $report_data_detail_inv->id)
                      @foreach($report_datas_detail as $report_data_detail)
                          @if($report_data_detail->type_id==8 && ($report_data_detail_inv->invoice_no==$report_data_detail->invoice_no ) && ($report_data_detail_inv->id==$report_data_detail->id))
                          {{ number_format($report_data_detail->commisions,0,',','.') }}<br>
                          @endif
                      @endforeach
                    @endif
                @endforeach
              </td>
              <td style="vertical-align:top;">
                @foreach($report_data_total as $report_data_totals)
                    @if($report_data_detail_ts->id == $report_data_totals->id && ($report_data_detail_ts->dated == $report_data_totals->dated))
                          {{ number_format($report_data_totals->total,0,',','.') }}<br>
                    @endif
                @endforeach
              </td>
              <td style="vertical-align:top;">
                  @php  $tot=0; @endphp
                  @foreach($report_data_com_from1 as $report_data_com_from1s)
                            @php 
                                    $date1 = \Carbon\Carbon::createFromFormat('Y-m-d', $report_data_com_from1s->dated);
                                    $date2 = \Carbon\Carbon::createFromFormat('Y-m-d', $report_data_detail_ts->dated);
                      
                                    
                                    $result = $date1->lte($date2);
                                    if($result){
                                      $tot=$tot+$report_data_com_from1s->total; 
                                    }
                            @endphp
                  @endforeach
                  {{ number_format($tot,0,',','.') }}
              </td>

               
              </tr>


          @endforeach

            
        </tbody>
      </table>
   </body> 
</html> 