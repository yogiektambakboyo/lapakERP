@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Profile Users')

@section('content')
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Product #{{ $product->product_id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
                <a href="{{ route('products.edit', $product->product_id) }}" class="btn btn-info">Edit</a>
                <a href="{{ route('products.index') }}" class="btn btn-default">Back</a>
            </div>
          </div>
        </div>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Name</label>
              <div class="col-md-8">
                <input type="text" class="form-control" value="{{ $product->product_name }}" readonly />
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Abbr</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->abbr }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Type</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_type }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Category</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_category }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Brand</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_brand }}" readonly />
            </div>
          </div>
          </div>
        </div>
    </div>
@endsection
