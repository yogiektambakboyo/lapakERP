@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Sales Order')

@section('content')
<form method="POST" action="{{ route('orders.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_order_no') : {{ $order->order_no }}</h4></div>
      <div class="">
        <a href="{{ route('orders.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
      </div>
    </div>
    <div class="panel-body bg-white text-black">
      

        <div class="row mb-3">
          <div class="col-md-4">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated')   </label>
              <div class="col-md-8">
                <input type="text" 
                name="order_date"
                id="order_date"
                class="form-control" 
                value="{{ substr(explode(" ",$order->dated)[0],8,2) }}-{{ substr(explode(" ",$order->dated)[0],5,2) }}-{{ substr(explode(" ",$order->dated)[0],0,4) }}" readonly/>
                @if ($errors->has('order_date'))
                          <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                      @endif
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_remark')</label>
              <div class="col-md-8">
                <input type="text" 
                name="remark"
                id="remark"
                class="form-control" 
                value="{{ $order->remark }}" readonly/>
                </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_customer')</label>
              <div class="col-md-8">
                <input type="hidden" name="curr_def" id="curr_def" value="{{ $branchs[0]->currency }}">
                <select class="form-control" 
                    name="customer_id" id="customer_id" readonly>
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}" {{ ($customer->id == $order->customers_id) 
                          ? 'selected'
                          : ''}}>{{ $customer->id }} - {{ $customer->name }} ({{ $customer->remark }})</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_payment')</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="payment_type" id="payment_type">
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($payment_type as $value)
                        <option value="{{ $value }}" {{ ($value == $order->payment_type ) 
                          ? 'selected'
                          : ''}}>{{ $value }}</option>
                    @endforeach
                </select>
              </div>
            </div>

          </div>

          <div class="col-md-4">
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-6">@lang('general.lbl_nominal_payment')</label>
                <div class="col-md-6">
                  <input type="text" id="payment_nominal" name="payment_nominal" readonly class="form-control" value="{{ $order->payment_nominal }}"/>
                </div>
              </div>
  
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-4">@lang('general.lbl_charge')</label>
                <div class="col-md-8">
                  <h2 class="text-end"><label id="order_charge">{{ $order->payment_nominal>0?$order->payment_nominal-$order->total:"0" }}</label></h2>
                </div>
              </div>
  
          </div>

          <div class="col-md-12">
            <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
            </br>

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>@lang('general.product')</th>
                  <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                  <th scope="col" width="10%">@lang('general.lbl_price')</th>
                  <th scope="col" width="5%">@lang('general.lbl_discount')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                  <th scope="col" width="15%">Total</th>  
                  <th scope="col" width="15%">@lang('general.lbl_terapist')</th>  
              </tr>
              </thead>
              <tbody>
                @foreach($orderDetails as $orderDetail)
                    <tr>
                        <th scope="row">{{ $orderDetail->product_name }}</th>
                        <td>{{ $orderDetail->uom }}</td>
                        <td>{{ number_format($orderDetail->price, 0, ',', '.') }}</td>
                        <td>{{ number_format(($orderDetail->discount), 0, ',', '.') }}</td>
                        <td>{{ $orderDetail->qty }}</td>
                        <td>{{ number_format($orderDetail->total, 0, ',', '.') }}</td>
                        <td>{{ $orderDetail->assigned_to }}</td>
                    </tr>
                @endforeach
              </tbody>
            </table> 
            
            <div class="row mb-3">
              <div class="col-md-6">
                <div class="row mb-3">
                    
                </div>
            </div>

            
            <div class="col-md-6">
              <div class="col-md-12">
                <div class="col-auto text-end">
                  <label class="col-md-4">Sub Total</label>
                  <label class="col-md-4" id="sub-total">{{ number_format(($order->total-$order->tax), 0, ',', '.') }}</label>
                </div>
              </div>
              <div class="col-md-12">
                <div class="col-auto text-end">
                  <label class="col-md-4">@lang('general.lbl_tax')</label>
                  <label class="col-md-4" id="vat-total">0</label>
                </div>
              </div>
              <div class="col-md-12">
                <div class="col-auto text-end">
                  <label id="lbl_total"  class="col-md-4 h3">Total</label>
                  <label class="col-md-4 h3" id="result-total">{{ number_format($order->total, 0, ',', '.') }}</label>
                </div>
              </div>
            </div>

          </div>
        </div>
    </div>
  </div>
</form>
@endsection

@push('scripts')
    <script type="text/javascript">
      $('#lbl_total').text("Total ("+$('#curr_def').val()+")");
    </script>
@endpush
