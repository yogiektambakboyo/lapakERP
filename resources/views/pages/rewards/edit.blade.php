@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Ubah Rewards')

@section('content')
<form method="POST" action="{{ route('rewards.update', [$product->id]) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Rewards - {{ $product->remark }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('rewards.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>

        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Rewards Name</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ $product->remark }}"/>
              </div>
           </div>
         

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_date_start')</label>
            <div class="col-md-8">
              <input type="text" 
              name="dated_start"
              id="dated_start"
              class="form-control" 
              value="{{ Carbon\Carbon::parse($product->dated_start)->format('d-m-Y') }}"/>
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
                value="{{ Carbon\Carbon::parse($product->dated_end)->format('d-m-Y') }}"/>
                @if ($errors->has('dated_end'))
                        <span class="text-danger text-left">{{ $errors->first('dated_end') }}</span>
                    @endif
            </div>
          </div>


          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Point</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="point" value="{{ $product->point }}"/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Quota</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="quota" value="{{ $product->quota }}"/>
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
