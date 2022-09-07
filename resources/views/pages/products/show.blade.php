@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Profile Users')

@section('content')
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Product #{{ $product->product_id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
                <a href="{{ route('products.edit', $product->product_id) }}" class="btn btn-info">Edit</a>
                <a href="{{ route('products.index') }}" class="btn btn-default">Back</a>
            </div>
          </div>
        </div>
        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Information</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Name</label>
              <div class="col-md-8">
                <input type="text" class="form-control" value="{{ $product->product_name }}" readonly />
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Abbr</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->abbr }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Type</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_type }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Category</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_category }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Brand</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_brand }}" readonly />
            </div>
          </div>
          </div>
        </div>

        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Ingredients</h4></div>
          <div class="panel-body bg-white text-black">
            
            <div class="row mb-3">
              <div class="col-md-4">
                <label class="form-label col-form-label">Product Name</label>
                <input type="hidden" 
                name="input_product_id"
                id="input_product_id"
                class="form-control" 
                value="{{ $product->product_id }}" required/>
                <select class="form-control" 
                  name="input_product_id_material" id="input_product_id_material" required>
                  <option value="">Select Product</option>
                  @foreach($products as $pd)
                      <option value="{{ $pd->id }}" {{ ($pd->id==old('input_product_id_material') ) 
                        ? 'selected'
                        : '' }}>{{ $pd->remark }}</option>
                  @endforeach
                </select>  
              </div>

              <div class="col-md-2">
                <label class="form-label col-form-label">UOM</label>
                <select class="form-control" 
                  name="input_uom" id="input_uom" required>
                  <option value="">Select UOM</option>
                  @foreach($uoms as $uom)
                      <option value="{{ $uom->id }}" {{ ($uom->id==old('input_uom') ) 
                        ? 'selected'
                        : '' }}>{{ $uom->remark }}</option>
                  @endforeach
                </select> 
              </div>

              <div class="col-md-2">
                <label class="form-label col-form-label">Qty</label>
                <input type="text" 
                name="input_qty"
                id="input_qty"
                class="form-control" 
                value="{{ old('input_qty') }}" required/>
                @if ($errors->has('input_qty'))
                          <span class="text-danger text-left">{{ $errors->first('input_qty') }}</span>
                      @endif
              </div>

              <div class="col-md-2">
                <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
                <a href="#" id="input_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>Add Ingredients</div></a>
              </div>



              <div class="col-md-12">
                <table class="table table-striped" id="example">
                    <thead>
                    <tr>
                        <th scope="col">Product Name</th>
                        <th scope="col" width="10%">UOM</th>
                        <th scope="col" width="10%">Qty</th>
                        <th scope="col" width="10%">Action</th>
                    </tr>
                    </thead>
                    <tbody>            
                      @foreach($ingredients as $ingredient)
                        <tr>
                            <th scope="row">{{ $ingredient->product_name }}</th>
                            <td>{{ $ingredient->uom_name }}</td>
                            <td>{{ $ingredient->qty }}</td>
                            <td><a href="#" onclick="deleteIngredients({{ $ingredient->product_id}},{{$ingredient->product_id_material }});" class="btn btn-danger btn-sm">Delete</a></td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
              </div>
            </div>

          </div>
        </div>

    </div>
@endsection

@push('scripts')
    <script type="text/javascript">
          const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;

          $('#input_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#input_date').val(formattedToday);


          $('#input_submit').on('click',function(){
          if($('#input_product_id_material option:selected').val()==''){
            $('#input_product_id_material').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose Product',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#input_uom option:selected').val()==''){
            $('#input_uom').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose uom',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#input_qty').val()==''){
            $('#input_qty').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose qty',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else{
            const json = JSON.stringify({
                input_product_id : $('#input_product_id').val(),
                input_product_id_material : $('#input_product_id_material').val(),
                input_uom : $('#input_uom').val(),
                input_qty : $('#input_qty').val(),
              }
            );
            const res = axios.post("{{ route('products.addingredients') }}", json, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){ 
                    window.location.reload(); 
                  }else{
                    Swal.fire(
                      {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Something went wrong - '+resp.data.message,
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                      }
                    );
                  }
            });
          }
        });


        function deleteIngredients(product_id,product_id_material){
            const jsonDelete = JSON.stringify({
                input_product_id : product_id,
                input_product_material : product_id_material, 
              }
            );
            const resDeleteExp = axios.post("{{ route('products.deleteingredients') }}", jsonDelete, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){
                    window.location.reload(); 
                  }else{
                    Swal.fire(
                      {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Something went wrong - '+resp.data.message,
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