@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Product Commision By Year')

@section('content')
<form method="POST" action="{{ route('productscommisionbyyear.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Add new product commision by years</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">Save</button>
              <a href="{{ route('productscommisionbyyear.index') }}" class="btn btn-default">Cancel</a>
            </div>
          </div>
        </div>
      
        <div class="panel text-white">
          <div class="panel text-white">
            <div class="panel-heading bg-teal-600"><h4></h4></div>
            <div class="panel-body bg-white text-black">
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Product Name</label>
                <div class="col-md-8">
                  <select class="form-control" 
                  name="product_id">
                  <option value="">Select Product</option>
                  @foreach($products as $product)
                      <option value="{{ $product->id }}">{{  $product->remark }}</option>
                  @endforeach
              </select>
                </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Branch</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="branch_id">
                    <option value="">Select Branch</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Job Title</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="jobs_id">
                    <option value="">Select Jobs</option>
                    @foreach($jobs as $job)
                        <option value="{{ $job->id }}">{{  $job->remark }}</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Years</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="years">
                    <option value="">Select Years</option>
                    @foreach($years as $year)
                        <option value="{{ $year }}">{{  $year }}</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Values</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="values" value="{{ old('values') }}"/>
              </div>
            </div>
            </div>
          </div>
        </div>
    </div>
@endsection
