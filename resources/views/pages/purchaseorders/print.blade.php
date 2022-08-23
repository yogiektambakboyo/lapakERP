<!DOCTYPE html> 

<html>  
   <head> 
      <meta charset = "utf-8"> 
      <title>Purchase</title>
   </head> 
  
   <body> 
      
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Purchase Order {{ $purchase->purchase_no }}</h4></div>
      <div class="">
        <a href="{{ route('purchaseorders.print', $purchase->id) }}" class="btn btn-warning">Print</a>
        <a href="{{ route('purchaseorders.index') }}" class="btn btn-default">Back</a>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="row mb-3">
          <div class="col-md-12">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">Date (mm/dd/YYYY)</label>
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
                    <option value="">Select Branch</option>
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
                        <option value="{{ $supplier->id }}" {{ $purchase->supplier_id == $supplier->id ? 'selected' : '' }} >{{ $supplier->id }} - {{ $supplier->name }} </option>
                    @endforeach
                </select>
              </div>

                <label class="form-label col-form-label col-md-1">Remark</label>
                <div class="col-md-2">
                  <input type="text" 
                  name="remark"
                  id="remark"
                  class="form-control" 
                  value="{{ $purchase->remark }}" disabled/>
                  </div>
            </div>

            <div class="panel-heading bg-teal-600 text-white"><strong>Order List</strong></div>
            <div class="row mb-3">
              
            </div>
            

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>Product Code</th>
                  <th scope="col" width="10%">UOM</th>
                  <th scope="col" width="10%">Price</th>
                  <th scope="col" width="5%">Qty</th>
                  <th scope="col" width="10%">Total</th>
              </tr>
              </thead>
              <tbody>
                @foreach($purchaseDetails as $purchaseDetail)
                    <tr>
                        <th scope="row">{{ $purchaseDetail->product_name }}</th>
                        <td>{{ $purchaseDetail->uom }}</td>
                        <td>{{ $purchaseDetail->price }}</td>
                        <td>{{ $purchaseDetail->qty }}</td>
                        <td>{{ $purchaseDetail->total }}</td>
                    </tr>
                @endforeach
              </tbody>
            </table> 
            
            
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2"><h1>Total {{ $purchase->total}}</h1></label>
            </div>
          <div class="col-md-12">
          </div>
        </div>
    </div>
  </div>

   </body> 
</html> 