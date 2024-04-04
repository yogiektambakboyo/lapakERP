@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Komisi Poin - Tambah')

@section('content')
<form method="POST" action="{{ route('pointconvertion.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Tambah Nilai Poin</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('pointconvertion.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
      
        <div class="panel text-white mt-3">
          <div class="panel text-white">
            <div class="panel-heading bg-teal-600"><h4></h4></div>
            <div class="panel-body bg-white text-black">
              
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
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_point')</label>
              <div class="col-md-8">
                <input class="form-control" 
                    name="point" type="number" value="0"  required>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Komisi</label>
              <div class="col-md-8">
                <input class="form-control" 
                    name="point_value" type="number" value="0" required>
              </div>
            </div>

            </div>
          </div>
        </div>
    </div>
@endsection
