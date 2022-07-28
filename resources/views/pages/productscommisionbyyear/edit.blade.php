@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Commision')

@section('content')
<form method="POST" action="{{ route('productscommisionbyyear.update', [$product->branch_id,$product->id]) }}"  enctype="multipart/form-data">
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
              <a href="{{ route('productscommisionbyyear.index') }}" class="btn btn-default">Cancel</a>
            </div>
          </div>
        </div>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Product Name</label>
              <div class="col-md-8">
                <select class="form-control" 
                name="product_id" disabled>
                <option value="">Select Product</option>
                @foreach($products as $productx)
                    <option value="{{ $productx->id }}"  {{ ($productx->id == $product->id) 
                      ? 'selected'
                      : '' }}>{{  $productx->remark }}</option>
                @endforeach
              </select>
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Branch</label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="branch_id" disabled>
                    <option value="">Select Branch</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"   {{ ($product->branch_id == $branch->id) 
                          ? 'selected'
                          : '' }}>{{  $branch->remark }}</option>
                    @endforeach
                </select>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Job Title</label>
            <div class="col-md-8">
              <select class="form-control" 
                  name="jobs_id" disabled>
                  <option value="">Select Jobs</option>
                  @foreach($jobs as $job)
                      <option value="{{ $job->id }}"  {{ ($product->jobs_id == $job->id) 
                        ? 'selected'
                        : '' }}>{{  $job->remark }}</option>
                  @endforeach
              </select>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Years</label>
            <div class="col-md-8">
              <select class="form-control" 
                  name="years" disabled>
                  <option value="">Select Years</option>
                  @foreach($years as $year)
                      <option value="{{ $year }}" {{ ($product->years == $year) 
                        ? 'selected'
                        : '' }} >{{  $year }}</option>
                  @endforeach
              </select>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Values</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="values" value="{{ $product->values }}"/>
            </div>
          </div>
          </div>
        </div>
    </div>
@endsection
