<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Print QR</title>
      <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
      <style>
        body {background-color: whitesmoke;}
        h1   {color: blue;}
        p    {color: red;}
        #header_inv { column-count: 2}
        table, th, td {
          border: 0.5px inset black;
          padding: 3px;
          font-size: 10px;
          page-break-inside:auto;
          page-break-inside:avoid; page-break-after:auto;
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
          table { page-break-inside:auto }
          tr    { page-break-inside:avoid; page-break-after:auto }
          thead { display:table-header-group }
          tfoot { display:table-footer-group }
        }
      </style>
   </head> 
   <body> 
    <table class="table table-striped" id="example">
        <thead>
        <tr>
            @for ($i = 0; $i < 13; $i++)
                <th scope="col" width="2%"> QR - {{ $i+1 }}</th>    
            @endfor
        </tr>
        </thead>
        <tbody>

            @php
             $counter = 0;    
            @endphp
            @for ($j = 0; $j < count($products)/13; $j++)
                <tr>
                    @for ($i = 0; $i < 13; $i++)
                        @if(count($products)>$counter)
                            <td style="text-align:center;">{{ $products[$counter]->barcode }}<br>{!! QrCode::size(35)->generate($products[$counter]->barcode); !!} </td>
                            @php
                                $counter++;    
                            @endphp
                        @else
                            <td></td>
                        @endif
                    @endfor
                </tr>
            @endfor
        </tbody>
    </table>
   </body> 
</html> 