@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Product Stock Begin')

@section('content')
<form method="POST" action="{{ route('reports.stock_begin.update', [$report_data[0]->start_cal,$report_data[0]->branch_id,$report_data[0]->product_id]) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>@lang('general.product') #{{ $report_data[0]->product_id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('reports.stock_begin.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>

        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_product_name')</label>
              <div class="col-md-8">
                {{ $report_data[0]->product_name }}
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Periode</label>
            <div class="col-md-8">
                {{ $report_data[0]->period_name }}
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
            <div class="col-md-8">
                {{ $report_data[0]->branch_name }}
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_qty')</label>
            <div class="col-md-8">
                <input type="hidden" class="form-control" name="product_id" value="{{ $report_data[0]->product_id }}"/>
                <input type="hidden" class="form-control" name="branch_id" value="{{ $report_data[0]->branch_id }}"/>
                <input type="hidden" class="form-control" name="dated" value="{{ $report_data[0]->dated }}"/>
              <input type="text" class="form-control" name="qty" value="{{ $report_data[0]->qty_stock }}"/>
            </div>
          </div>
          </div>
        </div>
    </div>
@endsection
