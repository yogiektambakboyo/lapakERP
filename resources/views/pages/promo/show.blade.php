@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Lot Number')

@section('content')
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_lotnumber') : {{ $order->doc_no }}</h4></div>
      <div class="">
        <button id="btn_sync" class="btn btn-danger">@lang('general.lbl_sync')</button>
        <a href="{{ route('lotnumber.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
      </div>
    </div>
    <div class="panel-body bg-white text-black">
      

        <div class="row mb-3">
          <div class="col-md-12">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_product')   </label>
              <div class="d-none">
                <select class="d-none" name="branch_id" id="branch_id">
                  <option value="d">d</option>
                </select>
              </div>
              <div class="col-md-3">
                <input type="hidden" name="lot_no" id="lot_no" value="{{ $order->doc_no }}">
                <input type="hidden" name="branch_idv" id="branch_idv" value="{{ $order->branch_id }}">
                <input type="hidden" name="product_id" id="product_id" value="{{ $order->product_id }}">
               
                <input type="text" 
                name="order_date"
                id="order_date"
                class="form-control" 
                value="{{ $order->remark }}" readonly/>
                @if ($errors->has('order_date'))
                          <span class="text-danger text-left"></span>
                      @endif
              </div>
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_qty_available')   </label>
              <div class="col-md-1">
                <input type="text" 
                name="order_date"
                id="order_date"
                class="form-control" 
                value="{{ $order->qty_available }}" readonly/>
                @if ($errors->has('order_date'))
                          <span class="text-danger text-left"></span>
                      @endif
              </div>
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_qty_on_hand')   </label>
              <div class="col-md-1">
                <input type="text" 
                name="order_date"
                id="order_date"
                class="form-control" 
                value="{{ $order->qty_onhand }}" readonly/>
                @if ($errors->has('order_date'))
                          <span class="text-danger text-left"></span>
                      @endif
              </div>
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_qty_allocated')   </label>
              <div class="col-md-1">
                <input type="text" 
                name="order_date"
                id="order_date"
                class="form-control" 
                value="{{ $order->qty_allocated }}" readonly/>
                @if ($errors->has('order_date'))
                          <span class="text-danger text-left"></span>
                      @endif
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_transaction_in')</strong></div>
            </br>

            <table class="table table-striped" id="in_table">
              <thead>
              <tr>
                  <th>@lang('general.lbl_doc_no')</th>
                  <th scope="col" width="20%">@lang('general.lbl_dated')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
              </tr>
              </thead>
              <tbody>
                @foreach($in as $in_loop)
                    <tr>
                        <td>{{ $in_loop->doc_no }}</td>
                        <td>{{ substr(explode(" ",$in_loop->dated)[0],8,2) }}-{{ substr(explode(" ",$in_loop->dated)[0],5,2) }}-{{ substr(explode(" ",$in_loop->dated)[0],0,4) }}</td>
                        <td>{{ $in_loop->qty }}</td>
                    </tr>
                @endforeach
                
              </tbody>
            </table>
          </div>

          <div class="col-md-6">
            <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_transaction_out')</strong></div>
            </br>

            <table class="table table-striped" id="out_table">
              <thead>
              <tr>
                  <th>@lang('general.lbl_doc_no')</th>
                  <th scope="col" width="20%">@lang('general.lbl_dated')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                  <th scope="col" width="15%">@lang('general.lbl_served')</th>  
              </tr>
              </thead>
              <tbody>
                @foreach($out as $out_loop)
                    <tr>
                        <td>{{ $out_loop->doc_no }}</td>
                        <td>{{ substr(explode(" ",$out_loop->dated)[0],8,2) }}-{{ substr(explode(" ",$out_loop->dated)[0],5,2) }}-{{ substr(explode(" ",$out_loop->dated)[0],0,4) }}</td>
                        <td>{{ $out_loop->qty_order }}</td>
                        <td>{{ $out_loop->qty_served }}</td>
                    </tr>
                @endforeach
                
              </tbody>
            </table>
          </div>

        </div>
    </div>
  </div>
@endsection

@push('scripts')
    <script type="text/javascript">
          $('#btn_sync').on('click', function(){
          
              const json = JSON.stringify({
                    doc_no : $('#lot_no').val(),
                    branch_id : $('#branch_idv').val(),
                    product_id : $('#product_id').val(),
                  }
                );
                const res = axios.post("{{ route('lotnumber.update_lotno') }}", json, {
                  headers: {
                    // Overwrite Axios's automatically set Content-Type
                    'Content-Type': 'application/json'
                  }
                }).then(resp => {
                      if(resp.data.status=="success"){
                          location.reload();
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
        });
    </script>
@endpush

