@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Period')

@section('content')
<form method="POST" action="{{ route('period.update', $product->period_no) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Periode #{{ $product->period_no }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('period.index') }}" class="btn btn-default">@lang('general.lbl_back')</a>
            </div>
          </div>
        </div>

        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_name')</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ $product->remark }}" readonly />
                <input type="hidden" class="form-control" name="input_period_no" value="{{ $product->period_no }}" />
              </div>
          </div>

          <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Status Tutup</label>
              <div class="col-md-8">
                <select name="input_close_trans" id="input_close_trans" class="form-control">
                  <option value="1" {{ $product->close_trans=="1"?"selected":"0" }}>1</option>
                  <option value="0" {{ $product->close_trans=="0"?"selected":"0" }}>0</option>
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

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;
    </script>
@endpush
