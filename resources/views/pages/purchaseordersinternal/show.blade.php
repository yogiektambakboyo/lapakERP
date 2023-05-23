@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Purchase Order')

@section('content')
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Purchase Order {{ $purchase->purchase_no }}</h4></div>
      <div class="">
        <a href="{{ route('purchaseordersinternal.print', $purchase->id) }}" class="btn btn-warning">@lang('general.lbl_print') </a>
        <a href="{{ route('purchaseordersinternal.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
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
                value="{{ substr(explode(" ",$purchase->dated)[0],5,2) }}/{{ substr(explode(" ",$purchase->dated)[0],8,2) }}/{{ substr(explode(" ",$purchase->dated)[0],0,4) }}"
                required disabled/>
                @if ($errors->has('purchase_date'))
                          <span class="text-danger text-left">{{ $errors->first('purchase_date') }}</span>
                      @endif
              </div>

              <label class="form-label col-form-label col-md-1">Shipto</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="branch_id" id="branch_id" required disabled>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"  {{ $purchase->branch_id == $branch->id ? 'selected' : '' }}>{{ $branch->remark }} </option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-1">Supplier</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="supplier_id" id="supplier_id" required disabled>
                    <option value="">Select Suppliers</option>
                    @foreach($suppliers as $supplier)
                        <option value="{{ $supplier->id }}" {{ $purchase->supplier_id == $supplier->id ? 'selected' : '' }} > {{ $supplier->name }} </option>
                    @endforeach
                </select>
              </div>

                <label class="form-label col-form-label col-md-1">@lang('general.lbl_remark')</label>
                <div class="col-md-2">
                  <input type="text" 
                  name="remark"
                  id="remark"
                  class="form-control" 
                  value="{{ $purchase->remark }}" disabled/>
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
              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
            
            <br>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-8 text-end"><h2>Sub Total </h2></label>
              <div class="col-md-4">
                <h3 class="text-end"><label id="sub-total">{{ number_format(($purchase->total-$purchase->total_vat),0,',','.') }}</label></h3>
              </div>

              <label class="form-label col-form-label col-md-9 text-end d-none"><h2>@lang('general.lbl_tax') </h2></label>
              <div class="col-md-3 d-none">
                <h3 class="text-end"><label id="vat-total">{{ number_format($purchase->total_vat,0,',','.') }}</label></h3>
              </div>

              <label class="form-label col-form-label col-md-8 text-end"><h1>Total</h1></label>
              <div class="col-md-4">
                <h1 class="display-5 text-end"><label id="order-total">Rp. 0</label></h1>
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

        
          var url = "{{ route('purchaseordersinternal.getdocdata',$purchase->purchase_no) }}";
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
                          "disc"         : resp.data[i]["discount"],
                          "total"       : resp.data[i]["subtotal"],
                          "total_vat"       : resp.data[i]["subtotal_vat"],
                          "price"       : resp.data[i]["price"]
                    }

                    orderList.push(product);
                }

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
                  }).draw(false);
                  order_total = order_total + (parseFloat(orderList[i]["total_vat"]));
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
        ],
        }); 
    </script>
@endpush
