@extends('layouts.default', ['appSidebarSearch' => true])

@section('title',' New Product Price')

@section('content')
<form method="POST" action="{{ route('productsprice.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-8">
            <h1>@lang('general.lbl_add_price_new')</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-2">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('productsprice.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
          <br>
        </div>

        <br>
      
        <div class="panel text-white">
          <div class="panel text-white">
            <div class="panel-heading bg-teal-600"><h4></h4></div>
            <div class="panel-body bg-white text-black">
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_product_name')</label>
                <div class="col-md-8">
                  <select class="form-control" 
                  name="product_id">
                  <option value="">@lang('general.productselect')</option>
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
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_price')</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="price" value="{{ old('product_price') }}"/>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_price') Beli</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="price_buy" value="{{ old('product_price_buy') }}" {{ $branchs_hq>=1?'':'readonly' }}/>
              </div>
            </div>

            </div>
          </div>
        </div>
    </div>
@endsection
