@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Promo Baru')

@section('content')
<form method="POST" action="{{ route('promo.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Buat Promo Baru</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('promo.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
        <br>
      
        <div class="panel text-white">
          <div class="panel text-white">
            <div class="panel-heading bg-teal-600"><h4></h4></div>
            <div class="panel-body bg-white text-black">
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Nama Promo</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" name="remark" value="{{ old('remark') }}" required/>
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
              <label class="form-label col-form-label col-md-2">Hari Berlaku</label>
              <div class="col-md-8">
                <select class="form-control" 
                name="active_day" required >
                <option value="all">Setiap Hari</option>
                <option value="weekday">Senin - Jumat</option>
                <option value="weekend">Sabtu - Minggu</option>
            </select>
              </div>
           </div>

           <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Jam Berlaku</label>
              <div class="col-md-8">
                <select class="form-control" 
                name="active_time" required>
                <option value="all">24 Jam</option>
                <option value="officetime">08.00 - 17.00</option>
                <option value="happyhour">09.00 - 15.00</option>
                <option value="night">17.01 - 23.59</option>
            </select>
              </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Tipe Tamu</label>
            <div class="col-md-8">
              <select class="form-control" 
              name="type_customer" required>
              <option value="all">Semua</option>
              <option value="Sendiri">Sendiri</option>
              <option value="Berdua">Berdua</option>
              <option value="Rombongan">Rombongan</option>
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
              <label class="form-label col-form-label col-md-2">Validasi Faktur</label>
              <div class="col-md-8">
                <select class="form-control" 
                name="linked_invoice" required>
                <option value="1">Ya</option>
                <option value="0">Tidak</option>
            </select>
              </div>
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

        

       
    </script>
@endpush