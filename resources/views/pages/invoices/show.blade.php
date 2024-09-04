@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Sales Invoice')

@section('content')
<form method="POST" action=""  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_invoice')  {{ $invoice->invoice_no }}</h4></div>
      <div class="">
        <a target="_blank" href="{{ route('invoices.print', $invoice->id) }}" class="btn btn-warning"><i class="fas fa-print"></i> @lang('general.lbl_print') </a>
        <a target="_blank" href="{{ route('invoices.printsj', $invoice->id) }}" class="btn btn-success"><i class="fas fa-truck-fast"></i> @lang('general.lbl_printsj') </a>
        <a target="_blank" href="{{ route('invoices.printspk', $invoice->id) }}" class="btn btn-primary"><i class="fas fa-file-invoice"> </i>  @lang('general.lbl_printspk') </a>
        <a href="{{ route('invoices.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
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
              <label class="form-label col-form-label col-md-1 d-none">Ref No.</label>
              <div class="col-md-3 d-none">
                <input type="text" class="form-control" value="{{ $invoice->ref_no }}" id="ref_no" disabled>
              </div>
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_customer')</label>
              <div class="col-md-4">
                <select class="form-control" 
                    name="customer_id" id="customer_id" readonly>
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}" {{ ($customer->id == $invoice->customers_id) 
                          ? 'selected'
                          : ''}}>{{ $customer->id }} - {{ $customer->name }}</option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-2">@lang('general.lbl_nominal_payment')</label>
                <div class="col-md-2">
                  <input type="text" 
                  id="payment_nominal"
                  name="payment_nominal"
                  class="form-control" 
                  value="{{ $invoice->payment_nominal }}" readonly/>
                </div>

            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_type_payment')</label>
              <div class="col-md-4">
                <select class="form-control" 
                      name="payment_type" id ="payment_type" readonly>
                      <option value="">@lang('general.lbl_type_paymentselect')</option>
                      @foreach($payment_type as $value)
                          <option value="{{ $value }}" {{ ($invoice->payment_type == $value) 
                            ? 'selected'
                            : ''}}>{{ $value }}</option>
                      @endforeach
                  </select>
              </div>

                

                  <label class="form-label col-form-label col-md-1">@lang('general.lbl_charge')</label>
                  <div class="col-md-3">
                    <h2 class="text-end"><label id="order_charge" style='@if($invoice->payment_nominal-$invoice->total<0) {{ "color : red;" }} @endif'>
                      @if($invoice->payment_nominal-$invoice->total>0)
                      {{ number_format(($invoice->payment_nominal-$invoice->total), 0, ',', '.') }}
                      @else {{ number_format(($invoice->payment_nominal-$invoice->total), 0, ',', '.') }}
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
                  <label class="form-label col-form-label col-md-3">@lang('sidebar.MataUang')</label>
                  <div class="col-md-2">
                    <input type="hidden" name="curr_def" id="curr_def" value="{{ $branchs[0]->currency }}">
                    <select class="form-select" name="currency" id="currency">
                        @php
                        $selected = "";
                        $curr = "";
    
                        for ($i=0; $i < count($currency); $i++) { 
                           if($currency[$i]->remark == $invoice->currency){
                             $selected = "selected";
                           }else{
                            $selected = "";
                           }
                            echo '<option value="'.$currency[$i]->remark.'" '.$selected.'>'.$currency[$i]->remark.'</option>';
                        }   
                        @endphp
                    </select>
                  </div>
    
                  <label class="form-label col-form-label col-md-2 kurs d-none" id="label-kurs">Kurs</label>
                  <br>
                  <div class="col-md-3 kurs  d-none">
                    <input type="number" class="form-control kurs  d-none" id="kurs" value="{{ $invoice->kurs }}" name="kurs">
                  </div>
                  <label class="form-label col-form-label col-md-2 kurs d-none">{{ $branchs[0]->currency }}</label>
                  
    
                  @if ($errors->has('currency'))
                      <span class="text-danger text-left">{{ $errors->first('currency') }}</span>
                  @endif
                </div>
                
                <div class="row mb-3">
                    <label class="form-label col-form-label col-md-3" id="label-voucher">Voucher</label>
                    <br>
                    <div class="col-md-5">
                      <input type="text" class="form-control" id="input-apply-voucher" value="{{ $invoice->voucher_code }}" disabled>
                    </div>
                </div>
              </div>


              <div class="col-md-6">
                <div class="col-md-12  d-none">
                  <div class="col-auto text-end">
                  <input type="hidden" name="curr_def" id="curr_def" value="{{ $invoice->currency }}">

                    <label class="col-md-2"><h2>Sub Total </h2></label>
                    <label class="col-md-8" id="sub-total"> <h3>{{ number_format($invoice->total-$invoice->tax, 0, ',', '.') }}</h3></label>
                  </div>
                </div>
                <div class="col-md-12  d-none">
                  <div class="col-auto text-end">
                    <label class="col-md-2"><h2>@lang('general.lbl_tax') </h2></label>
                    <label class="col-md-8" id="vat-total"> <h3>{{ number_format($invoice->tax, 0, ',', '.') }}</h3></label>
                  </div>
                </div>
                <div class="col-md-12">
                  <div class="col-auto text-end">
                    <label id="lbl_total"  class="col-md-4 h3">Total</label>
                    <label class="col-md-7 h3" id="result-total"> {{ number_format($invoice->total, 0, ',', '.') }}</label>
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
      $(function () {

        $('#lbl_total').text("Total ("+$('#currency').find(':selected').val()+")");


          if($('#currency').find(':selected').val() == $('#curr_def').val()){
              $('.kurs').addClass('d-none');
              $('#kurs').val("1");
            }else{
              $('.kurs').removeClass('d-none');
              $('#label-kurs').text("Kurs 1 "+$('#currency').find(':selected').val()+" = ");
            }
          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
      });
</script>
@endpush