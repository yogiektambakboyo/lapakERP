@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Buffer Stok')

@section('content')
<form method="POST" action="{{ route('bufferstock.update', [$product->id]) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Edit - Buffer Stock</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('bufferstock.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>

        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">

            
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_service_name')</label>
              <div class="col-md-8">
                <select class="form-control" 
                name="product_id" disabled>
                <option value="">@lang('general.serviceselect')</option>
                @foreach($products as $productx)
                    <option value="{{ $productx->id }}"  {{ ($productx->id == $product->product_id) 
                      ? 'selected'
                      : '' }}>{{  $productx->remark }}</option>
                @endforeach
              </select>
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
            <label class="form-label col-form-label col-md-2">Jumlah</label>
            <div class="col-md-8">
              <input type="hidden" class="form-control" name="id" value="{{ $product->id }}"/>
              <input type="text" class="form-control" name="qty" value="{{ $product->qty }}"/>
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
