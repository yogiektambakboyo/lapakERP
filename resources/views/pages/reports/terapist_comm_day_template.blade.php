<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Laporan Komisi Terapist</title>
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
          .pagebreak { page-break-before: always; } /* page-break-after works, as well */
        }
      </style>
   </head> 
   <body> 

    <button id="printPageButton" onClick="window.print();"  class="btn print printPageButton">Cetak Laporan Komisi</button>
    <button id="btn_export_xls" class="btn print printPageButton">Cetak XLS</button>
      <table style="width: 100%">
        <tbody>
          <tr style="text-align: center;background-color:#FFA726;">
              <td style="text-align: left; padding:2px;"><img src="data:image/png;base64,{{ base64_encode(file_get_contents(url("images/user-files/".$settings[0]->icon_file))) }}" width="80px"></td>
              <th style="width: 40%;">Laporan Komisi Terapist</th>
              <td style="width: 16%;font-size:10px;font-style: italic;">
                <label>Printed at : {{ \Carbon\Carbon::now() }}</label>
              </td>
          </tr>
        </tbody>
      </table>     
            
            {{-- Area Looping --}}
            <table class="table table-striped" style="width: 100%">
              <thead>
                <tr style="background-color:#FFA726;color:black;">
                  <th colspan="7">Cabang : {{ $report_data[0]->branch_name  }}</th>
                  <th colspan="15">Tgl : {{ date("d-m-Y", strtotime($filter_begin_date )) }} ~ {{ date("d-m-Y", strtotime($filter_begin_end )) }}</th>
                </tr>
                <tr style="text-align: center;background-color:#FFA726;">
                  <th>No</th>
                  <th>Nama</th>
                  <th>Posisi</th>
                  <th>Tahun</th>
                  <th>Poin</th>
                  <th>Total</th>
                  <th>Perawatan</th>
                  <th>Komisi Produk</th>
                  <th>Nilai Point</th>
                  <th>Extra Charge</th>
                  <th>Charge Lebaran</th>
                  <th>Komisi Menurut Cat Terapis</th>
                  <th>Selisih</th>
                  <th>Cases</th>
                  <th>Simpanan</th>
                  <th>Iuran Perbaikan</th>
                  <th>Denda</th>
                  <th>Potongan Kasbon</th>
                  <th>Komisi Yang Diterima</th>
                  <th>No. Rekening</th>
                  <th>A/N</th>
                  <th>Bank</th>
                </tr>
              </thead>
              <tbody>
                <?php $counter = 1; ?>
                    @foreach ($report_data as $item)
                    <tr>
                      <td><?= $counter++; ?></td>
                      <td>{{ $item->nama }}</td>
                      <td>{{ $item->posisi }}</td>
                      <td>{{ $item->tahun }}</td>
                      <td>{{ $item->point_qty }}</td>
                      <td>{{ number_format($item->total,0,',','.')  }}</td>
                      <td>{{ number_format($item->perawatan,0,',','.')  }}</td>
                      <td>{{ number_format($item->komisi_produk,0,',','.')  }}</td>
                      <td>{{ number_format($item->nilai_point,0,',','.')  }}</td>
                      <td>{{ number_format($item->extra_charge,0,',','.')  }}</td>
                      <td>{{ number_format($item->charge_lebaran,0,',','.')  }}</td>
                      <td></td>
                      <td></td>
                      <td>{{ $item->cases }}</td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                    </tr>
                    @endforeach
              </tbody>
            </table>
            
              <div class="pagebreak"> </div>

          <input type="hidden" name="filter_begin_date" id="filter_begin_date" value="{{ $filter_begin_date }}">
          <input type="hidden" name="filter_begin_end" id="filter_begin_end" value="{{ $filter_begin_end }}">
          <input type="hidden" name="filter_branch_id" id="filter_branch_id" value="{{ $filter_branch_id }}">
          <input type="hidden" name="filter_terapist_in" id="filter_terapist_in" value="{{ $filter_terapist_in }}">
   </body> 
   <!-- use version 0.19.3 -->
   <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
   <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>   
   <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
   <script type="text/javascript">
    //window.print();
    //const workbook = XLSX.utils.book_new();

    const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Kakiku System Apps';
    workbook.created = new Date();
    //workbook.modified = new Date();

    $(document).ready(function() {
      var url = "{{ route('reports.terapistdaily.search') }}";
      const params = {
        filter_begin_date_in : "{{ $filter_begin_date }}",
        filter_end_date_in : "{{ $filter_begin_end }}",
        filter_branch_id_in: "{{ $filter_branch_id }}",
        filter_terapist_in: "{{ $filter_terapist_in }}",
        export : 'Export Sum Template API',
      };

      $('#btn_export_xls').on('click',function(){
        const res = axios.get(url,{ params }, {
                    headers: {}
                  }).then(resp => {
                    report_data = resp.data.report_data;

                    var beginnewformat = resp.data.beginnewformat;
                    var endnewformat = resp.data.endnewformat;

                    let data_filtered = [];

                    // Loop Terapist
                        data_filtered = [];

                        let worksheet = workbook.addWorksheet("DATA");

                        /*Column headers*/
                        worksheet.getRow(3).values = [
                          'NO', 
                          'NAMA', 
                          'POSISI', 
                          'TAHUN',
                          'POIN',
                          'TOTAL',
                          'PERAWATAN',
                          'KOMISI PRODUK',
                          'NILAI POINT',
                          'EXTRA CHARGE',
                          'CHARGE LEBARAN',
                          'KOMISI MENURUT CAT TERAPIS',
                          'SELISIH',
                          'CASES',
                          'SIMPANAN',
                          'IURAN PERBAIKAN',
                          'DENDA',
                          'POTONGAN KASBON',
                          'KOMISI YANG DITERIMA',
                          'NO. REKENING',
                          'A/N',
                          'BANK'
                        ];

                        worksheet.mergeCells('A1', 'E1');
                        worksheet.getCell('A1').value = 'Cabang : '+report_data[0].branch_name;
                        worksheet.getCell('A1').alignment = { vertical: 'middle', horizontal: 'center' };


                        worksheet.mergeCells('K1', 'O1');
                        worksheet.getCell('K1').value = 'Tgl : '+beginnewformat+' sd '+endnewformat;
                        worksheet.getCell('K1').alignment = { vertical: 'middle', horizontal: 'center' };                 

                        //count(1) as no,b.name as nama,'TERAPIS' as posisi,u.work_year as tahun,sum(total) total,sum(total_commisions) as perawatan, 
                        //sum(product_commisions) as komisi_produk,sum(total_point) nilai_point,sum(commisions_extra) as extra_charge,'' as komisi_menurut_cat_terapis,'' as selisih,sum(service) as cases,
                        //'' as simpanan,'' as iuran_perbaikan,'' as denda, '' as potongan_kasbon,'' as komisi_yang_diterima,'' as no_rekening, '' as bank,sum(point_qty) point_qty

                        worksheet.columns = [
                          { key: 'no', width: 12 },
                          { key: 'nama', width: 30 },
                          { key: 'posisi', width: 20 },
                          { key: 'tahun', width: 10 },
                          { key: 'point_qty', width: 10 },
                          { key: 'total', width: 10 },
                          { key: 'perawatan', width: 10 },
                          { key: 'komisi_produk', width: 18 },
                          { key: 'nilai_point', width: 10 },
                          { key: 'extra_charge', width: 10 },
                          { key: 'charge_lebaran', width: 10 },
                          { key: 'komisi_menurut_cat_terapis', width: 10 },
                          { key: 'selisih', width: 10 },
                          { key: 'cases', width: 13 },
                          { key: 'simpanan', width: 12 },
                          { key: 'iuran_perbaikan', width: 20 },
                          { key: 'denda', width: 20 },
                          { key: 'potongan_kasbon', width: 20 },
                          { key: 'komisi_yang_diterima', width: 20 },
                          { key: 'no_rekening', width: 20 },
                          { key: 'an', width: 20 },
                          { key: 'bank', width: 20 },
                        ];

                        worksheet.getRow(1).font = { bold: true };
                        worksheet.getRow(2).font = { bold: true };
                        worksheet.getRow(3).font = { bold: true };
                        worksheet.getCell('A1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('B1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('C1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('D1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('E1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('G1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('H1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('I1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('J1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('K1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('L1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('M1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('N1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('O1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('P1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('Q1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('R1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('S1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('T1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('U1').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};


                        worksheet.getCell('A3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('B3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('C3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('D3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('E3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('F3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('G3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('H3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('I3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('J3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('K3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('L3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('M3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('N3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('O3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('P3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('Q3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('R3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('S3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('T3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};
                        worksheet.getCell('U3').fill = {type: 'pattern',pattern:'solid',fgColor:{argb:'FFA726'}};

                        let counter = 3;
                        let value_sd_until = 0;
                        for (let index = 0; index < report_data.length; index++) {
                          var rowElement = report_data[index];
                         

                          worksheet.addRow({
                              no : (index+1), 
                              nama : rowElement.nama, 
                              posisi            : rowElement.posisi, 
                              tahun          : rowElement.tahun, 
                              point_qty    : rowElement.point_qty, 
                              total     : rowElement.total, 
                              perawatan         : rowElement.perawatan, 
                              komisi_produk        : rowElement.komisi_produk, 
                              nilai_point       : rowElement.nilai_point, 
                              extra_charge : rowElement.extra_charge, 
                              charge_lebaran : rowElement.charge_lebaran, 
                              komisi_menurut_cat_terapis         : rowElement.komisi_menurut_cat_terapis, 
                              selisih  : rowElement.selisih, 
                              cases    : rowElement.cases, 
                              simpanan : '', 
                              iuran_perbaikan : '', 
                              denda : '', 
                              potongan_kasbon : '', 
                              komisi_yang_diterima : '', 
                              no_rekening : '', 
                              an : '', 
                              bank : '', 
                            });
                            worksheet.getCell('B'+counter).alignment = { wrapText: true };
                            worksheet.getCell('C'+counter).alignment = { wrapText: true };
                            worksheet.getCell('D'+counter).alignment = { wrapText: true };
                            worksheet.getCell('E'+counter).alignment = { wrapText: true };
                            worksheet.getCell('F'+counter).alignment = { wrapText: true };
                            worksheet.getCell('H'+counter).alignment = { wrapText: true };
                            worksheet.getCell('I'+counter).alignment = { wrapText: true };
                            worksheet.getCell('J'+counter).alignment = { wrapText: true };
                            worksheet.getCell('K'+counter).alignment = { wrapText: true };
                            worksheet.getCell('L'+counter).alignment = { wrapText: true };
                            worksheet.getCell('M'+counter).alignment = { wrapText: true };                            
                            counter++;
                            worksheet.getCell('B'+counter).alignment = { wrapText: true };
                            worksheet.getCell('C'+counter).alignment = { wrapText: true };
                            worksheet.getCell('D'+counter).alignment = { wrapText: true };
                            worksheet.getCell('E'+counter).alignment = { wrapText: true };
                            worksheet.getCell('F'+counter).alignment = { wrapText: true };
                            worksheet.getCell('H'+counter).alignment = { wrapText: true };
                            worksheet.getCell('I'+counter).alignment = { wrapText: true };
                            worksheet.getCell('J'+counter).alignment = { wrapText: true };
                            worksheet.getCell('K'+counter).alignment = { wrapText: true };
                            worksheet.getCell('L'+counter).alignment = { wrapText: true };
                            worksheet.getCell('M'+counter).alignment = { wrapText: true }; 

                            var borderStyles = {
                              top: { style: "thin" },
                              left: { style: "thin" },
                              bottom: { style: "thin" },
                              right: { style: "thin" }
                            };

                            worksheet.eachRow({ includeEmpty: true }, function(row, rowNumber) {
                              row.eachCell({ includeEmpty: true }, function(cell, colNumber) {
                                cell.border = borderStyles;
                              });
                            });
                          
                        }


                        counter++;
                        worksheet.getRow(counter).font = { bold: true };
                    

                    //XLSX.writeFile(workbook, "Presidents.xlsx", { compression: true });


                  
                    let filename = "Report_Commission_Terapist_"+(Math.floor(Date.now() / 1000)+".xlsx");
                    workbook.xlsx.writeBuffer()
                    .then(function(buffer) {
                      saveAs(
                        new Blob([buffer], { type: "application/octet-stream" }),
                        filename
                      );
                  });

                  });
      });
 
    });
 </script>
</html> 