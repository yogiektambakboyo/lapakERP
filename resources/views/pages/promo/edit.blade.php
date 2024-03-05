@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Promo')

@section('content')
<form method="POST" action="{{ route('promo.update', [$product->branch_id,'0',$product->date_start,$product->date_end,$product->promo_id]) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Promo {{ $product->remarks }}</h1>
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
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Promo Name</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ $product->remarks }}" disabled/>
              </div>
           </div>
           

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_service_name')</label>
              <div class="col-md-8">
                <input class="form-control" value="{{ $product->product_name }}" disabled>
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="branch_id" disabled>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"   {{ ($product->branch_id == $branch->id) 
                          ? 'selected'
                          : '' }}>{{  $branch->remark }}</option>
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
              value="{{ Carbon\Carbon::parse($product->date_start)->format('d-m-Y') }}"/>
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
                type="date"
                class="form-control" 
                value="{{ Carbon\Carbon::parse($product->date_end)->format('d-m-Y') }}"/>
                @if ($errors->has('dated_end'))
                        <span class="text-danger text-left">{{ $errors->first('dated_end') }}</span>
                    @endif
            </div>
          </div>



          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Persentase Potongan Harga (%)</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="value_idx" value="{{ $product->value_idx }}" required/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Nilai Potongan Harga (Rp)</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="value" value="{{ $product->value }}" required/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Minimum Pembelian</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="moq" value="{{ $product->moq }}" required/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Hari Berlaku</label>
            <div class="col-md-8">
              <select class="form-control" 
              name="active_day" required >
              <option value="all" <?= $product->active_day=="all"?"selected":""; ?>>Setiap Hari</option>
              <option value="weekday" <?= $product->active_day=="weekday"?"selected":""; ?>>Senin - Jumat</option>
              <option value="weekend" <?= $product->active_day=="weekend"?"selected":""; ?>>Sabtu - Minggu</option>
          </select>
            </div>
         </div>

         <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Jam Berlaku</label>
            <div class="col-md-8">
              <select class="form-control" 
              name="active_time" required>
              <option value="all" <?= $product->active_time=="all"?"selected":""; ?>>24 Jam</option>
              <option value="officetime" <?= $product->active_time=="officetime"?"selected":""; ?>>08.00 - 17.00</option>
              <option value="noon" <?= $product->active_time=="noon"?"selected":""; ?>>10.00 - 17.00</option>
              <option value="happyhour" <?= $product->active_time=="happyhour"?"selected":""; ?>>09.00 - 15.00</option>
              <option value="night" <?= $product->active_time=="night"?"selected":""; ?>>17.01 - 23.59</option>
          </select>
            </div>
        </div>

        <div class="row mb-3">
          <label class="form-label col-form-label col-md-2">Tipe Tamu</label>
          <div class="col-md-8">
            <select class="form-control" 
            name="type_customer" required>
            <option value="all" <?= $product->type_customer=="all"?"selected":""; ?>>Semua</option>
            <option value="Sendiri" <?= $product->type_customer=="Sendiri"?"selected":""; ?>>Sendiri</option>
            <option value="Berdua" <?= $product->type_customer=="Berdua"?"selected":""; ?>>Berdua</option>
            <option value="Rombongan" <?= $product->type_customer=="Rombongan"?"selected":""; ?>>Rombongan</option>
        </select>
          </div>
      </div>

      <div class="row mb-3">
        <label class="form-label col-form-label col-md-2">Validasi Faktur</label>
        <div class="col-md-8">
          <select class="form-control" 
          name="linked_invoice" required>
          <option value="1" <?= $product->linked_invoice=="1"?"selected":""; ?>>Ya</option>
          <option value="0" <?= $product->linked_invoice=="0"?"selected":""; ?>>Tidak</option>
      </select>
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
          ///$('#dated_start').val(formattedToday);


          $('#dated_end').datepicker({
            dateFormat: 'dd-mm-yy',
              todayHighlight: true,
          });
          //$('#dated_end').val(formattedToday);

       
    </script>
@endpush
