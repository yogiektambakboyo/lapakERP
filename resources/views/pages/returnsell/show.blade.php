@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Sales Invoice')

@section('content')
<form method="POST" action=""  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_return_sell')  {{ $invoice->return_sell_no }}</h4></div>
      <div class="">
        <a href="{{ route('returnsell.print', $invoice->id) }}" class="btn btn-warning">@lang('general.lbl_print') </a>
        <a href="{{ route('returnsell.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-4">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated_mmddYYYY')</label>
              <div class="col-md-8">
                <input type="text" 
                name="order_date"
                id="order_date"
                class="form-control" 
                value="{{ $invoice->dated }}" readonly/>
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
                value="{{ $invoice->remark }}" readonly/>
                </div>
            </div>
          </div>

          <div class="col-md-8">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">Ref No.</label>
              <div class="col-md-3">
                <input type="text" class="form-control" value="{{ $invoice->ref_no }}" id="scheduled" disabled>
              </div>
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_customer')</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="customer_id" id="customer_id" readonly>
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}" {{ ($customer->id == $invoice->customers_id) 
                          ? 'selected'
                          : ''}}>{{ $customer->id }} - {{ $customer->name }} ({{ $customer->remark }})</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
            
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_nominal_payment')</label>
                <div class="col-md-2">
                  <input type="text" 
                  id="payment_nominal"
                  name="payment_nominal"
                  class="form-control" 
                  value="{{ $invoice->payment_nominal }}" readonly/>
                  </div>

                  <label class="form-label col-form-label col-md-1">@lang('general.lbl_charge')</label>
                  <div class="col-md-3">
                    <h2 class="text-end"><label id="order_charge">Rp. @if($invoice->payment_nominal-$invoice->total>0)
                      {{ number_format(($invoice->payment_nominal-$invoice->total), 0, ',', '.') }}
                      @else {{ 0 }}
                    @endif</label></h2>
                  </div>
                
            </div>
          </div>

          <div class="col-md-12">
            <div class="panel-heading bg-teal-600 text-white"><strong>Product List</strong></div>
            <br>

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>@lang('general.product')</th>
                  <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                  <th scope="col" width="10%">@lang('general.lbl_price')</th>
                  <th scope="col" width="5%">@lang('general.lbl_discount')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                  <th scope="col" width="15%">Total</th>  
              </tr>
              </thead>
              <tbody>
                @foreach($orderDetails as $orderDetail)
                    <tr>
                        <th scope="row">{{ $orderDetail->product_name }}</th>
                        <td>{{ $orderDetail->uom }}</td>
                        <td>{{ number_format($orderDetail->price, 0, ',', '.') }}</td>
                        <td>{{ number_format($orderDetail->discount, 0, ',', '.') }}</td>
                        <td>{{ $orderDetail->qty }}</td>
                        <td>{{ number_format($orderDetail->total, 0, ',', '.') }}</td>
                    </tr>
                @endforeach
              </tbody>
            </table> 
            
            <div class="row mb-3">
              <div class="col-md-6">
                <div class="row mb-3">
                    <label class="form-label col-form-label col-md-3" id="label-voucher">Voucher</label>
                    <br>
                    <div class="col-md-5">
                      <input type="text" class="form-control" id="input-apply-voucher" value="{{ $invoice->voucher_code }}" disabled>
                    </div>
                </div>
              </div>


              <div class="col-md-6">
                <div class="col-md-12">
                  <div class="col-auto text-end">
                    <label class="col-md-2"><h2>Sub Total </h2></label>
                    <label class="col-md-8" id="sub-total"> <h3>Rp. {{ number_format($invoice->total-$invoice->tax, 0, ',', '.') }}</h3></label>
                  </div>
                </div>
                <div class="col-md-12">
                  <div class="col-auto text-end">
                    <label class="col-md-2"><h2>@lang('general.lbl_tax') </h2></label>
                    <label class="col-md-8" id="vat-total"> <h3>Rp. {{ number_format($invoice->tax, 0, ',', '.') }}</h3></label>
                  </div>
                </div>
                <div class="col-md-12">
                  <div class="col-auto text-end">
                    <label class="col-md-2"><h1>Total </h1></label>
                    <label class="col-md-8 display-5" id="result-total"> <h1>Rp. {{ number_format($invoice->total, 0, ',', '.') }}</h1></label>
                  </div>
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
    </script>
@endpush
@push('scripts')
    <script type="text/javascript">
      $(function () {
          $('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
      });
</script>
@endpush