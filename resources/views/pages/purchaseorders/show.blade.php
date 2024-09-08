@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Purchase Order')

@section('content')
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Purchase Order {{ $purchase->purchase_no }}</h4></div>
      <div class="">
        <a target="_blank" href="{{ route('purchaseorders.print', $purchase->id) }}" class="btn btn-warning">@lang('general.lbl_print') </a>
        <a id="btn_list_rec" target="_blank" href="{{ route('receiveorders.search') }}/?filter_begin_date=2022-01-01&filter_end_date=2035-01-01&filter_branch_id=%25&search={{ $purchase->purchase_no }}&submit=Search" class="btn btn-danger">List @lang('general.lbl_receive') </a>
        <a id="btn_rec" target="_blank" href="{{ route('receiveorders.createfrompo', $purchase->purchase_no) }}" class="btn btn-primary">@lang('general.lbl_receive') @lang('general.product') </a>
        <a href="{{ route('purchaseorders.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="row mb-3">
          <div class="col-md-12">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_dated_mmddYYYY')</label>
              <div class="col-md-2">
                <input type="text" 
                name="dated"
                id="dated"
                class="form-control" 
                value="{{ substr(explode(" ",$purchase->dated)[0],8,2) }}-{{ substr(explode(" ",$purchase->dated)[0],5,2) }}-{{ substr(explode(" ",$purchase->dated)[0],0,4) }}"
                required disabled/>
                @if ($errors->has('purchase_date'))
                          <span class="text-danger text-left">{{ $errors->first('purchase_date') }}</span>
                      @endif
              </div>

              <label class="form-label col-form-label col-md-1">Shipto</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="branch_id" id="branch_id" required disabled>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"  {{ $purchase->branch_id == $branch->id ? 'selected' : '' }}>{{ $branch->remark }} </option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-1">Supplier</label>
              <div class="col-md-4">
                <select class="form-control" 
                    name="supplier_id" id="supplier_id" required disabled>
                    <option value="">Select Suppliers</option>
                    @foreach($suppliers as $supplier)
                        <option value="{{ $supplier->id }}" {{ $purchase->supplier_id == $supplier->id ? 'selected' : '' }} >{{ $supplier->id }} - {{ $supplier->name }} </option>
                    @endforeach
                </select>
              </div>
            </div>

            <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
            <div class="row mb-3">
              
            </div>
            

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>@lang('general.product')</th>
                  <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                  <th scope="col" width="10%">@lang('general.lbl_price')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                  <th scope="col" width="5%">Disc</th>
                  <th scope="col" width="10%">Total</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty') @lang('general.lbl_receive') </th>

              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
            
            <br>
            <div class="row mb-3">
              <div class="col-md-6">
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-3">@lang('sidebar.MataUang')</label>
                  <div class="col-md-2">
                    <input type="hidden" name="curr_def" id="curr_def" value="{{ $branchs[0]->currency }}">
                    <select class="form-select" name="currency" id="currency" disabled>
                        @php
                        $selected = "";
                        $curr = $purchase->currency;

                        for ($i=0; $i < count($currency); $i++) { 
                          if($currency[$i]->remark == $curr){
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
                    <input type="number" class="form-control kurs  d-none" id="kurs" value="1" name="kurs" readonly>
                  </div>
                  <label class="form-label col-form-label col-md-2 kurs d-none">{{ $branchs[0]->currency }}</label>
                  

                  @if ($errors->has('currency'))
                      <span class="text-danger text-left">{{ $errors->first('currency') }}</span>
                  @endif
                </div>

                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-3">@lang('general.lbl_remark')</label>
                  <div class="col-md-7">
                    <input type="text" 
                    name="remark"
                    id="remark" readonly
                    class="form-control" 
                    value="{{ old('remark') }}"/>
                    </div>
                </div>
              </div>


              <div class="col-md-6">
                <div class="col-md-12">
                  <div class="col-auto text-end">
                    <label class="col-md-4">Sub Total</label>
                    <label class="col-md-4" id="sub-total"> {{ number_format(($purchase->total-$purchase->total_vat),0,',','.') }}</label>
                  </div>
                </div>
                <div class="col-md-12">
                  <div class="col-auto text-end">
                    <label class="col-md-4">@lang('general.lbl_tax')</label>
                    <label class="col-md-4" id="vat-total">{{ number_format($purchase->total_vat,0,',','.') }}</label>
                  </div>
                </div>
                <div class="col-md-12">
                  <div class="col-auto text-end">
                    <label id="lbl_total"  class="col-md-4 h3">Total ({{ $purchase->currency }})</label>
                    <label class="col-md-4  h3" id="result-total">{{ number_format($purchase->total,0,',','.') }}</label>
                  </div>
                </div>
              </div>
            </div>

            
          <div class="col-md-12">
          </div>
        </div>
    </div>
  </div>
@endsection

@push('scripts')
    <script type="text/javascript">
      var productList = [];
      var orderList = [];
      var order_total = 0;
         
      $(function () {
          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          $('#currency').on('change', function(){
            if($('#currency').find(':selected').val() == $('#curr_def').val()){
              $('.kurs').addClass('d-none');
              $('#kurs').val("1");
            }else{
              $('.kurs').removeClass('d-none');
              $('#label-kurs').text("Kurs 1 "+$('#currency').find(':selected').val()+" = ");
            }
            $('#lbl_total').text("Total ("+$('#currency').find(':selected').val()+")");
          });

          //$('#lbl_total').text("Total ("+$('#curr_def').val()+")");
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          
          $('#invoice_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });

        
          var url = "{{ route('purchaseorders.getdocdata',$purchase->purchase_no) }}";
          const resGetPO = axios.get(url, {
            headers: {
                'Content-Type': 'application/json'
              }
          }).then(resp => {
                for(var i=0;i<resp.data.length;i++){
                    var product = {
                          "id"          : resp.data[i]["product_id"],
                          "abbr"        : resp.data[i]["abbr"],
                          "remark"      : resp.data[i]["remark"],
                          "uom"         : resp.data[i]["uom"],
                          "qty"         : resp.data[i]["qty"],
                          "qty_rec"         : resp.data[i]["qty_rec"],
                          "disc"         : resp.data[i]["discount"],
                          "total"       : resp.data[i]["subtotal"],
                          "total_vat"       : resp.data[i]["subtotal_vat"],
                          "price"       : resp.data[i]["price"]
                    }

                    orderList.push(product);
                }

                var counter_rec = 0;
                for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];

                  table.row.add( {
                   "id"           : obj["id"],
                    "remark"      : obj["remark"],
                    "uom"         : obj["uom"],
                    "price"       : obj["price"],
                    "qty"         : obj["qty"],
                    "disc"         : obj["disc"],
                    "total"       : obj["total"],
                    "qty_rec"       : obj["qty_rec"],
                  }).draw(false);
                  order_total = order_total + (parseFloat(orderList[i]["total_vat"]));

                  counter_rec = counter_rec + parseFloat(obj["qty_rec"]);
                }


                if(counter_rec>0){
                  $('#btn_list_rec').removeClass("d-none");
                  //$('#btn_rec').addClass("d-none");

                }else{
                  $('#btn_list_rec').addClass("d-none");
                  //$('#btn_rec').removeClass("d-none");
                }

                $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

          });
      });

        var table = $('#order_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            ''
          }],
          columns: [
            { data: 'remark' },
            { data: 'uom' },
            { data: 'price' },
            { data: 'qty' },
            { data: 'disc' },
            { data: 'total' },
            { data: 'qty_rec' },
        ],
        }); 
    </script>
@endpush
