<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Harian</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          padding: 2px;
          font-size: 12px;
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
          .printPageButton {
            display: none;
          }
        }
      </style>
   </head> 
   <body> 

    <table class="table table-striped" id="service_table" width="100%">
      <thead>
      <tr style="background-color:#FFA726;color:white;">
        <th scope="col" width="2%">No</th>
        <th scope="col" width="6%" >Ruangan</th>
        <th width="7%" >Nama Tamu</th>
        <th scope="col" width="6%">Jam Kerja</th>
        <th width="5%" >MU</th>
        <th scope="col" width="4%">Bayar</th>
        <th scope="col" width="7%">Produk</th>
        <th scope="col" width="3%">Rp.</th>
        <th scope="col" width="7%">Minuman</th>
        <th width="15%">Keterangan</th>
      </tr>
      </thead>
      <tbody>
        
        <?php 
          $counter = 0;
          ?>
        @foreach($report_data as $detail)
        <tr>
            <td style="text-align: left;">{{ $counter+1 }}</td>
            <td style="text-align: left;@php if($detail->shift_name =='SHIFT 1 PAGI') {  echo 'background-color:#fea8ff;'; } @endphp">{{ $detail->branch_room }}<br>{{ $detail->invoice_no }}</td>
            <td style="text-align: left;">{{ $detail->customers_name }}</td>
            <td style="text-align: left;">
              @php
                  $c = 1;
                  $sumconversion = 0;
                  $lastsch = "";
              @endphp
              <?php

              ?>
              @foreach($report_data_detail as $dio)
                  @if($dio->type_id==2 && $dio->executed_at!='' && $dio->invoice_no==$detail->invoice_no_full)
                      {{ \Carbon\Carbon::parse($dio->executed_at)->format('H:i') }} - {{ \Carbon\Carbon::parse($dio->executed_at)->add($dio->product_conversion.' minutes')->format('H:i') }} <br>
                  @endif
              @endforeach
            </td>
            <td style="text-align: left;">{{ $detail->assigned_to_name }}</td>
          </tr>
          <?php 
          $counter++;
          ?>
          @endforeach
      </tbody>

        

   </body> 
</html> 