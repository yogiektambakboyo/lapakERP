@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'New Voucher')

@section('content')
<form method="POST" action="{{ route('voucher.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Buat Voucher Baru</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('voucher.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
        <br>
      
        <div class="panel text-white">
          <div class="panel text-white">
            <div class="panel-heading bg-teal-600"><h4></h4></div>
            <div class="panel-body bg-white text-black">
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Nama Voucher</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" name="remark" value="{{ old('remark') }}" required/>
                </div>
             </div>
              <div class="row mb-3 d-none">
                <label class="form-label col-form-label col-md-2">Kode Voucher Terakhir</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" name="voucher_code" value="{{ $last_voucher }}" disabled/>
                </div>
             </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Prefix</label>
              <div class="col-md-8">
                <input type="text" class="form-control gen-ex" id="prefix" name="prefix" value="" placeholder="Masukkan huruf awal kode voucher"/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Angka Awal</label>
              <div class="col-md-8">
                <input type="number" class="form-control gen-ex" id="begin_digit" name="begin_digit" value="" required/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Digit Voucher</label>
              <div class="col-md-8">
                <input type="number" class="form-control gen-ex" id="digit" name="digit" value="4" required/>
              </div>
            </div>

             <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Jumlah Voucher</label>
              <div class="col-md-8">
                <input type="number" class="form-control gen-ex" id="qty_voucher_code" name="qty_voucher_code" value="1" placeholder="Masukkan jumlah voucher yang akan dibuat" required/>
              </div>
           </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_service_name')</label>
                <div class="col-md-8">
                  <select class="form-control multiple-select2 " 
                  name="product_id[]" required  multiple="multiple">
                  <option value="%">Semua Perawatan</option>
                  @foreach($products as $product)
                      <option value="{{ $product->id }}">{{  $product->remark }}</option>
                  @endforeach
              </select>
                </div>
             </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="branch_id" required>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                    @endforeach
                </select>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_date_start')</label>
              <div class="col-md-8">
                <input type="text" 
                name="dated_start"
                id="dated_start"
                class="form-control" 
                value="{{ old('dated_start') }}" required/>
                @if ($errors->has('dated_start'))
                        <span class="text-danger text-left">{{ $errors->first('dated_start') }}</span>
                    @endif
              </div>

            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_date_end')</label>
              <div class="col-md-8">
                  <input type="text" 
                  name="dated_end"
                  id="dated_end"
                  class="form-control" 
                  value="{{ old('dated_end') }}" required/>
                  @if ($errors->has('dated_end'))
                          <span class="text-danger text-left">{{ $errors->first('dated_end') }}</span>
                      @endif
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Persentase Potongan Harga (%)</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="value_idx" value="0" required/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Nilai Potongan Harga (Rp)</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="value" value="0" required/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Minimum Pembelian</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="moq" value="1" required/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Pakai Berulang</label>
              <div class="col-md-8">
                <select name="unlimeted" class="form-control" id="unlimeted">
                  <option value="0">Tidak</option>
                  <option value="1">Ya</option>
                </select>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Harga Jual Voucher (Rp)</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="price" value="0" required/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-12 fst-italic fw-light" id="lbl_example">Contoh Hasil : </label>
            </div>


            </div>
          </div>
        </div>
    </div>
@endsection


@push('scripts')
    <script type="text/javascript">
          const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday =  dd + '-' + mm + '-' + yyyy;
          const formattedNextYear =  dd + '-' + mm + '-' + yyyy1;

          $('#dated_start').datepicker({
              dateFormat: 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#dated_start').val(formattedToday);


          $('#dated_end').datepicker({
            dateFormat: 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#dated_end').val(formattedToday);

          $(".gen-ex").on('change', function(){
            var s1 = "Contoh Hasil : ";
            var s2 = $('#prefix').val()+("0000000"+$('#begin_digit').val()).substr((-1*$('#digit').val()),$('#digit').val());
            var s3 = $('#prefix').val()+("0000000"+((parseInt($('#begin_digit').val())-1)+parseInt($('#qty_voucher_code').val()))).substr((-1*$('#digit').val()),$('#digit').val());
            $('#lbl_example').text(s1+" "+s2+" s/d "+s3);
          });

       
    </script>
@endpush