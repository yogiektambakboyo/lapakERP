@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'New Product')

@section('content')
<form method="POST" action="{{ route('products.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>@lang('general.lbl_add_product_new')</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('products.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_name')</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ old('remark') }}" />
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_abbr')</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="abbr" value="{{ old('abbr') }}"  />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_type')</label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="type_id" required>
                    <option value="">@lang('general.lbl_typeselect')</option>
                    @foreach($productTypes as $productType)
                        <option value="{{ $productType->id }}">{{ $productType->abbr }}</option>
                    @endforeach
                </select>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_category')</label>
            <div class="col-md-8">
              <div class="col-md-8">
                <select class="form-control" 
                      name="category_id" required>
                      <option value="">@lang('general.lbl_categoryselect')</option>
                      @foreach($productCategorys as $productCategory)
                          <option value="{{ $productCategory->id }}">{{ $productCategory->remark }}</option>
                      @endforeach
                  </select>
              </div>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_brand')</label>
            <div class="col-md-8">
              <select class="form-control" 
                      name="brand_id" required>
                      <option value="">@lang('general.lbl_brandselect')</option>
                      @foreach($productBrands as $productBrand)
                          <option value="{{ $productBrand->id }}">{{ $productBrand->remark }}</option>
                      @endforeach
                  </select>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_uom')</label>
            <div class="col-md-8">
              <select class="form-control" 
                      name="uom_id" required>
                      <option value="">@lang('general.lbl_uomselect')</option>
                      @foreach($productUoms as $productUom)
                          <option value="{{ $productUom->id }}">{{ $productUom->remark }}</option>
                      @endforeach
                  </select>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_barcode')</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ old('barcode') }}" name="barcode" id="barcode" required />
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_photo')</label>
            <div class="col-md-5">
              <a href="/images/user-files/goods.png" target="_blank"><img  id="photo_preview" src="/images/user-files/goods.png" width="100" height="100" class="rounded float-start" alt="..."></a>
            </div>
            <div class="col-md-5">
              <a href="/images/user-files/goods.png" target="_blank"><img  id="photo_preview_2" src="/images/user-files/goods.png" width="100" height="100" class="rounded float-start" alt="..."></a>
            </div>

            <div class="col-md-2"></div>
              <div class="col-md-5">
                <input type="file" 
                      name="photo"  id="photo" onchange="previewFile(this);"
                      class="form-control mt-2"  />
              </div>
              <div class="col-md-5">
                <input type="file" 
                      name="photo_2"  id="photo_2" onchange="previewFile_2(this);"
                      class="form-control mt-2"  />
              </div>
          </div>

          </div>
        </div>
    </div>
@endsection

@push('scripts')
<script type="text/javascript">
    function previewFile(input){
        var file = $("#photo").get(0).files[0];
 
        if(file){
            var reader = new FileReader();
 
            reader.onload = function(){
                $("#photo_preview").attr("src", reader.result);
            }
 
            reader.readAsDataURL(file);
        }
    }

    function previewFile_2(input){
        var file = $("#photo_2").get(0).files[0];
 
        if(file){
            var reader = new FileReader();
 
            reader.onload = function(){
                $("#photo_preview_2").attr("src", reader.result);
            }
 
            reader.readAsDataURL(file);
        }
    }
</script>
@endpush
