@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Profile Users')

@section('content')
<form method="POST" action="{{ route('products.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Add new product</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">Save</button>
              <a href="{{ route('products.index') }}" class="btn btn-default">Cancel</a>
            </div>
          </div>
        </div>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Name</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ old('remark') }}" />
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Abbr</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="abbr" value="{{ old('abbr') }}"  />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Type</label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="type_id" required>
                    <option value="">Select Type</option>
                    @foreach($productTypes as $productType)
                        <option value="{{ $productType->id }}">{{ $productType->remark }}</option>
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
                          <option value="{{ $productCategory->id }}">{{ $productCategory->remark }}</option>
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
                          <option value="{{ $productBrand->id }}">{{ $productBrand->remark }}</option>
                      @endforeach
                  </select>
            </div>
          </div>
          </div>
        </div>
    </div>
@endsection
