@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'New Brand')

@section('content')
<form method="POST" action="{{ route('servicesbrand.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>@lang('general.lbl_add_brand_new')</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('servicesbrand.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
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
                <input type="text" class="form-control" name="remark" value="{{ old('remark') }}" />
              </div>
          </div>
          </div>
        </div>
    </div>
@endsection
