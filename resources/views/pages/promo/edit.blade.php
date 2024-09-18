@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Promo')

@section('content')
<form method="POST" action="{{ route('promo.update') }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Edit Promo #{{ $promo->doc_no }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
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
                  <input type="text" class="form-control" name="remark" id="remark" value="{{ $promo->remark }}" required/>
                  <input type="hidden" class="form-control" name="id" id="id" value="{{ $promo->id }}" required/>
                  <input type="hidden" class="form-control" id="doc_no" name="doc_no" value="{{ $promo->doc_no }}" required/>
                </div>
             </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_product_name')</label>
                <div class="col-md-8">
                  <select class="form-control" 
                  name="product_id">
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
                    name="branch_id">
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
                value="{{ $promo->dated_start }}" required/>
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
                  value="{{ $promo->dated_end }}" required/>
                  @if ($errors->has('dated_end'))
                          <span class="text-danger text-left">{{ $errors->first('dated_end') }}</span>
                      @endif
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Value (0-100%)</label>
              <div class="col-md-8">
                <input type="number" class="form-control" name="value_idx" value="{{ $promo->value_idx }}" required/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Value Nominal</label>
              <div class="col-md-8">
                <input type="number" class="form-control" name="value_nominal" value="{{ $promo->value_nominal }}" required/>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Is Condition</label>
              <div class="col-md-8">
               <select name="is_term" class="form-control" id="is_term">
                <option value="0" @if($promo->is_term == "0") {{ 'selected' }} @endif>Tidak</option>
                <option value="1" @if($promo->is_term == "1") {{ 'selected' }} @endif>Ya</option>
               </select>
              </div>
            </div>

            

            <div id="layout_term" class="">
              <div class="row">
                <div class="col-md-10">
                  
                </div>
                <div class="col-md-2">
                  <input type="button" class="btn btn-sm btn-primary"  href="#modal-add-term" data-bs-toggle="modal" data-bs-target="#modal-add-term" value="@lang('general.lbl_addterm')">
                </div>
              </div>

              <div class="row">
                <div class="col-md-12">
                  <table id="table-term" class="table table-striped">
                    <thead>
                      <tr>
                        <th>@lang('general.lbl_product')</th>
                        <th>@lang('general.lbl_qty')</th>
                        <th>@lang('general.lbl_action')</th>
                      </tr>
                    </thead>
                    <tbody>
                      @php
                        for ($i=0; $i < count($promo_detail); $i++) { 
                          echo "<tr><td>".$promo_detail[$i]->remark."</td><td>".$promo_detail[$i]->qty."</td><td><input type='button' class='btn btn-sm btn-danger' onclick='deleteTerm(".$promo_detail[$i]->product_id.")' value='Delete'></td></tr>";
                        }    
                      @endphp
                      
                    </tbody>
                  </table>
                </div>
              </div>
            </div>


            <!-- Begin Modal Payment -->
            <div class="modal fade" id="modal-add-term" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_addterm')</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    
                    <div class="container mt-1">
                          <div class="row mb-3">
                              <label class="form-label col-form-label col-md-12">@lang('general.lbl_product_name')</label>
                              <div class="col-md-12">
                                <select class="form-control" 
                                    name="term_product_id" id="term_product_id"> 
                                    <option value="">@lang('general.lbl_productselect')</option>
                                    @foreach($products as $product)
                                        <option value="{{ $product->id }}" >{{  $product->remark }}</option>
                                    @endforeach
                                </select>
                              </div>
                          </div>
                          <div class="row mb-3">
                            <label for="term_qty" class="form-label  col-md-12">@lang('general.lbl_qty')</label>
                            <div class="col-md-12">
                              <input type="number" class="form-control  col-md-8" name="term_qty" id="term_qty" value="0" required>
                              @if ($errors->has('payment_cash'))
                                  <span class="text-danger text-left">{{ $errors->first('term_qty') }}</span>
                              @endif
                            </div>
                        </div>
                    </div>
        
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                    <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_save_term">@lang('general.lbl_save')</button>
                  </div>
              </div>
              </div>
            </div>


          <!-- End Modal Payment -->

            </div>
          </div>
        </div>
    </div>
@endsection


@push('scripts')
    <script type="text/javascript">
          var termList = [];
          var is_term = $('#is_term').find(':selected').val();
          if(is_term == "0"){
            $('#layout_term').addClass('d-none');
          }else{
            $('#layout_term').removeClass('d-none');
          }

          $('#is_term').on('change',function(){
            is_term = $('#is_term').find(':selected').val();
            if(is_term == "0"){
              $('#layout_term').addClass('d-none');
            }else{
              $('#layout_term').removeClass('d-none');
            }
          });

          $('#btn_save_term').on('click', function(){
            var product_id = $('#term_product_id').find(':selected').val();
            var product_name = $('#term_product_id').find(':selected').text();
            var qty = $('#term_qty').val();
            var isExist = 0;

            for (let index = 0; index < termList.length; index++) {
              const element = termList[index];
              if(element.product_id == product_id){
                isExist = 1;
              }
            }

            if(parseFloat(qty)>0 && product_id != "" && isExist == 0){
              const json = JSON.stringify({
                  product_id : product_id,
                  qty : qty,
                  doc_no : $('#doc_no').val(),
                }
              );
              const res = axios.post("{{ route('promo.storedetail') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                      var term = {
                            "product_id"    : product_id,
                            "product_name"  : product_name,
                            "qty"           : qty,
                      }

                      termList.push(term);
                      var cnt = "<tr><td>"+product_name+"</td><td>"+qty+"</td><td><input type='button' class='btn btn-sm btn-danger' onclick='deleteTerm("+product_id+")' value='Delete'></td></tr>";
                      $("#table-term tbody").append(cnt);
                    }else{
                      Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: "@lang('general.lbl_msg_failed')"+resp.data.message,
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                        }
                      );
                    }
              });

              
            }else{
              Swal.fire(
                  {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Term tidak valid',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                  });
            }
            
          });

          function deleteTerm(product_id){
            for (let index = 0; index < termList.length; index++) {
              const element = termList[index];
              if(element.product_id == product_id){
                termList.splice(index,1);
              }
            }

            const json = JSON.stringify({
                  product_id : product_id,
                  doc_no : $('#doc_no').val(),
                }
              );
              const res = axios.post("{{ route('promo.destroydetail') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                      $("#table-term tbody").empty()

                      for (let index = 0; index < termList.length; index++) {
                        const element = termList[index];
                        var cnt = "<tr><td>"+element.product_name+"</td><td>"+element.qty+"</td><td><input type='button' class='btn btn-sm btn-danger' onclick='deleteTerm("+element.product_id+")' value='Delete'></td></tr>";
                        $("#table-term tbody").append(cnt);
                      }

                    }else{
                      Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: "@lang('general.lbl_msg_failed')"+resp.data.message,
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                        }
                      );
                    }
              });

           
          }

       
    </script>
@endpush