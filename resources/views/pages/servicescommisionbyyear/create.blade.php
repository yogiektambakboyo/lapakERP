@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Product Commision By Year')

@section('content')
<form method="POST" action="{{ route('servicescommisionbyyear.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>@lang('general.lbl_commision_year_add')</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('servicescommisionbyyear.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
      
        <div class="panel text-white mt-3">
          <div class="panel text-white">
            <div class="panel-heading bg-teal-600"><h4></h4></div>
            <div class="panel-body bg-white text-black">
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_product_name')</label>
                <div class="col-md-8">
                  <select class="form-control trig" 
                  name="product_id" id="product_id">
                  <option value="">@lang('general.lbl_productselect')</option>
                  @foreach($products as $product)
                      <option value="{{ $product->id }}">{{  $product->remark }}</option>
                  @endforeach
              </select>
                </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
              <div class="col-md-8">
                <select class="form-control trig" 
                    name="branch_id" id="branch_id">
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_jobtitleselect')</label>
              <div class="col-md-8">
                <select class="form-control trig" 
                    name="jobs_id" id="jobs_id">
                    <option value="">@lang('general.lbl_jobtitleselect')</option>
                    @foreach($jobs as $job)
                        <option value="{{ $job->id }}">{{  $job->remark }}</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_years')</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="years" id="years">
                    <option value="">@lang('general.lbl_yearselect')</option>
                    @foreach($years as $year)
                        <option value="{{ $year }}">{{  $year }}</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_values')</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="values" value="{{ old('values') }}"/>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Charge Lebaran</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="values_extra" value="{{ old('values_extra') }}"/>
              </div>
            </div>

            </div>
          </div>
        </div>
    </div>
@endsection

@push('scripts')
    <script type="text/javascript">
      $('.trig').on('change', function(){
          const json = JSON.stringify({
                  product_id : $('#product_id').find(':selected').val(),
                  branch_id : $('#branch_id').find(':selected').val(),
                  jobs_id : $('#jobs_id').find(':selected').val(), 
                }
              );
              const res = axios.post("{{ route('servicescommisionbyyear.show_year') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                            $("#years > option").each(function() {
                                  if(this.value != ""){
                                    $("#years option[value=" + this.value + "]").removeAttr('disabled');
                                  }
                            });  

                        if(resp.data.data.length >= 1 ){
                          var list = resp.data.data;
                          list.forEach(element => {
                                $("#years > option").each(function() {
                                    if(this.value == element.years){
                                       $("#years option[value=" + this.value + "]").attr("disabled", true);;
                                    }
                                });                                
                          });
                        }
                    }else{
                      Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: "tai",
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                        }
                      );
                    }
              });
      });

      
    </script>
@endpush