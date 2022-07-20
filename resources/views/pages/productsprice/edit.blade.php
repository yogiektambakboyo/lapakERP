@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Product')

@section('content')
<form method="POST" action="{{ route('productsprice.update', [$product->branch_id,$product->id]) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Product {{ $product->product_name }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">Save</button>
              <a href="{{ route('productsprice.index') }}" class="btn btn-default">Cancel</a>
            </div>
          </div>
        </div>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Product Name</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ $product->product_name }}" disabled/>
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Branch</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="branch_name" value="{{ $product->branch_name }}"  disabled/>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Price</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="price" value="{{ $product->product_price }}"/>
            </div>
          </div>
          </div>
        </div>
    </div>
@endsection
