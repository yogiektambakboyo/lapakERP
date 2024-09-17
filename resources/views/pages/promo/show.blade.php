@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Promo')

@section('content')
<form method="POST" action="{{ route('promo.update') }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Show Promo</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <a href="{{ route('promo.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
        <br>

      
        <div class="panel text-white">
          <div class="panel text-white">
            <div class="panel-heading bg-teal-600"><h4></h4></div>
            <div class="panel-body bg-white text-black">
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Promo Name</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" name="remark" value="{{ $promo->remark }}" readonly/>
                  <input type="hidden" class="form-control" name="id" value="{{ $promo->id }}" readonly/>
                </div>
             </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_product_name')</label>
                <div class="col-md-8">
                  <select class="form-control" 
                  name="product_id" disabled>
                  <option value="">@lang('general.lbl_productselect')</option>
                  @foreach($products as $product)
                      <option value="{{ $product->id }}" @if($product->id == $promo->product_id) {{ 'selected' }} @endif >{{  $product->remark }}</option>
                  @endforeach
              </select>
                </div>
             </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="branch_id" disabled>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}" @if($branch->id == $promo->branch_id) {{ 'selected' }} @endif>{{  $branch->remark }}</option>
                    @endforeach
                </select>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_date_start')</label>
              <div class="col-md-8">
                <input type="text" 
                name="dated_start"
                id="dated_start"
                class="form-control" 
                value="{{ $promo->dated_start }}" readonly/>
                @if ($errors->has('dated_start'))
                        <span class="text-danger text-left">{{ $errors->first('dated_start') }}</span>
                    @endif
              </div>

            </div>


            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_date_end')</label>
              <div class="col-md-8">
                  <input type="text" 
                  name="dated_end"
                  id="dated_end"
                  class="form-control" 
                  value="{{ $promo->dated_end }}" readonly/>
                  @if ($errors->has('dated_end'))
                          <span class="text-danger text-left">{{ $errors->first('dated_end') }}</span>
                      @endif
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Value (0-100%)</label>
              <div class="col-md-8">
                <input type="number" class="form-control" name="value_idx" value="{{ $promo->value_idx }}" readonly/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Value Nominal</label>
              <div class="col-md-8">
                <input type="number" class="form-control" name="value_nominal" value="{{ $promo->value_nominal }}" readonly/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Is Condition</label>
              <div class="col-md-8">
               <select name="is_term" class="form-control" id="is_term" disabled>
                <option value="0" @if($promo->is_term == "0") {{ 'selected' }} @endif>Tidak</option>
                <option value="1" @if($promo->is_term == "1") {{ 'selected' }} @endif>Ya</option>
               </select>
              </div>
            </div>

            </div>
          </div>
        </div>
    </div>
@endsection