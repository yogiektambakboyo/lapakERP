@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Product')

@section('content')
<form method="POST" action="{{ route('products.update', $product->id) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Product #{{ $product->id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">Save</button>
              <a href="{{ route('products.index') }}" class="btn btn-default">Cancel</a>
            </div>
          </div>
        </div>

        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Name</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ $product->product_name }}" />
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Abbr</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="abbr" value="{{ $product->abbr }}"  />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Type</label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="type_id" required>
                    <option value="">Select Type</option>
                    @foreach($productTypes as $productType)
                        <option value="{{ $productType->id }}"   {{ ($product->type_id == $productType->id) 
                          ? 'selected'
                          : ''}} >{{ $productType->remark }}</option>
                    @endforeach
                </select>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Category</label>
            <div class="col-md-8">
              <div class="col-md-8">
                <select class="form-control" 
                      name="category_id" required>
                      <option value="">Select Category</option>
                      @foreach($productCategorys as $productCategory)
                          <option value="{{ $productCategory->id }}"  {{ ($product->category_id == $productCategory->id) 
                            ? 'selected'
                            : ''}} >{{ $productCategory->remark }}</option>
                      @endforeach
                  </select>
              </div>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Brand</label>
            <div class="col-md-8">
              <select class="form-control" 
                      name="brand_id" required>
                      <option value="">Select Brand</option>
                      @foreach($productBrands as $productBrand)
                          <option value="{{ $productBrand->id }}"  {{ ($product->brand_id == $productBrand->id) 
                            ? 'selected'
                            : ''}}  >{{ $productBrand->remark }}</option>
                      @endforeach
                  </select>
            </div>
          </div>
          <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Photo</label>
              <div class="col-md-8">
                <a href="/images/user-files/{{ $product->photo }}" target="_blank"><img src="/images/user-files/{{ $product->photo }}" width="100" height="100" class="rounded float-start"></a>
              </div>
          </div> 

          </div>
        </div>
    </div>
@endsection
