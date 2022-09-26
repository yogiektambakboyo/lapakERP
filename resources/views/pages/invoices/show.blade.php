@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Sales Order')

@section('content')
<form method="POST" action="{{ route('orders.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Sales Invoice {{ $invoice->invoice_no }}</h4></div>
      <div class="">
        <a href="{{ route('invoices.edit', $invoice->id) }}" class="btn btn-info">Edit</a>
        <a href="{{ route('invoices.index') }}" class="btn btn-default">Back</a>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-4">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">Date (mm/dd/YYYY)</label>
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
              <label class="form-label col-form-label col-md-4">Remark</label>
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
              <label class="form-label col-form-label col-md-1">Customer</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="customer_id" id="customer_id" readonly>
                    <option value="">Select Customers</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}" {{ ($customer->id == $invoice->customers_id) 
                          ? 'selected'
                          : ''}}>{{ $customer->id }} - {{ $customer->name }} ({{ $customer->remark }})</option>
                    @endforeach
                </select>
              </div>
              <label class="form-label col-form-label col-md-1">Schedule</label>
              <div class="col-md-3">

                  <div class="input-group">
                    <input type="text" class="form-control" value="{{ $room->remark }} - {{ $invoice->scheduled_at }}" id="scheduled" disabled>
                    <button type="button" class="btn btn-indigo" data-bs-toggle="modal" data-bs-target="#modal-scheduled" >
                      <span class="fas fa-calendar-days"></span>
                    </button>
                  </div>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Type Payment</label>
              <div class="col-md-2">
                <select class="form-control" 
                      name="payment_type" id ="payment_type" readonly>
                      <option value="">Select Payment</option>
                      @foreach($payment_type as $value)
                          <option value="{{ $value }}" {{ ($invoice->payment_type == $value) 
                            ? 'selected'
                            : ''}}>{{ $value }}</option>
                      @endforeach
                  </select>
              </div>

                <label class="form-label col-form-label col-md-2">Nominal Payment</label>
                <div class="col-md-2">
                  <input type="text" 
                  id="payment_nominal"
                  name="payment_nominal"
                  class="form-control" 
                  value="{{ $invoice->payment_nominal }}" readonly/>
                  </div>

                  <label class="form-label col-form-label col-md-1">Charge</label>
                  <div class="col-md-3">
                    <h2 class="text-end"><label id="order_charge">Rp. {{ number_format(($invoice->payment_nominal-$invoice->total), 2, ',', '.') }}</label></h2>
                  </div>
                
            </div>
          </div>

          <div class="col-md-12">
            <div class="panel-heading bg-teal-600 text-white"><strong>Invoice List</strong></div>
            </br>

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>Product</th>
                  <th scope="col" width="10%">UOM</th>
                  <th scope="col" width="10%">Price</th>
                  <th scope="col" width="5%">Discount</th>
                  <th scope="col" width="5%">Qty</th>
                  <th scope="col" width="15%">Total</th>  
                  <th scope="col" width="15%">Assigned To</th>  
                  <th scope="col" width="15%">Referral By</th>  
              </tr>
              </thead>
              <tbody>
                @foreach($orderDetails as $orderDetail)
                    <tr>
                        <th scope="row">{{ $orderDetail->product_name }}</th>
                        <td>{{ $orderDetail->uom }}</td>
                        <td>{{ number_format($orderDetail->price, 2, ',', '.') }}</td>
                        <td>{{ $orderDetail->discount }}</td>
                        <td>{{ $orderDetail->qty }}</td>
                        <td>{{ number_format($orderDetail->total, 2, ',', '.') }}</td>
                        <td>{{ $orderDetail->assigned_to }}</td>
                        <td>{{ $orderDetail->referral_by }}</td>
                    </tr>
                @endforeach
              </tbody>
            </table> 
            
            
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2"><h1>Total</h1></label>
              <div class="col-md-10">
                <h1 class="display-5 text-end"><label id="order-total">Rp. {{ number_format($invoice->total, 2, ',', '.') }}</label></h1>
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
