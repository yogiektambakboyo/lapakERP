@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'New Voucher')

@section('content')
<form method="POST" action="{{ route('voucher.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Add New Voucher</h1>
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
                <label class="form-label col-form-label col-md-2">Voucher Name</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" name="remark" value="{{ old('remark') }}" required/>
                </div>
             </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Voucher Code</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" name="voucher_code" value="{{ old('voucher_code') }}" required/>
                </div>
             </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_product_name')</label>
                <div class="col-md-8">
                  <select class="form-control" 
                  name="product_id">
                  <option value="">@lang('general.lbl_productselect')</option>
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
                    name="branch_id">
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
                <input type="text" class="form-control" name="value" value="{{ old('value') }}" required/>
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

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;

          $('#dated_start').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#dated_start').val(formattedToday);


          $('#dated_end').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#dated_end').val(formattedToday);

       
    </script>
@endpush