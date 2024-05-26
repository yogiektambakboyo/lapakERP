@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Ubah Alasan')

@section('content')
<form method="POST" action="{{ route('reason.update', [$product->id]) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Alasan #{{ $product->id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('reason.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>

        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Tipe</label>
              <div class="col-md-8">
                <select name="reason_type" id="reason_type" class="form-control">
                  <option value="leave">Izin Tidak Masuk</option>
                </select>
              </div>
           </div>

          <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Deskripsi</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ $product->remark }}"/>
              </div>
           </div>
          
        
        </div>
    </div>
@endsection
@push('scripts')
    <script type="text/javascript">
    </script>
@endpush
