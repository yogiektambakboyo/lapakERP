@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Stock')

@section('content')
<form method="POST" action="{{ route('productsstock.update', [$product->branch_id,$product->product_id]) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>@lang('general.product') {{ $product->product_name }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('productsstock.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
      
        <div class="panel text-white mt-2">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_product_name') </label>
              <div class="col-md-8">
                <select class="form-control" 
                name="product_id" disabled>
                <option value="">@lang('general.lbl_productselect')</option>
                @foreach($products as $productx)
                    <option value="{{ $productx->id }}"  {{ ($productx->id == $product->product_id) 
                      ? 'selected'
                      : '' }}>{{  $productx->remark }}</option>
                @endforeach
              </select>
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch') </label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="branch_id" disabled>
                    <option value="">@lang('general.lbl_branchselect') </option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"   {{ ($product->branch_id == $branch->id) 
                          ? 'selected'
                          : '' }}>{{  $branch->remark }}</option>
                    @endforeach
                </select>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_qty') </label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="qty" value="{{ $product->qty }}"/>
            </div>
          </div>
          </div>
        </div>
    </div>
@endsection
