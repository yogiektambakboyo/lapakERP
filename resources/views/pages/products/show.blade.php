@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Product')

@section('content')
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>@lang('general.product') #{{ $product->id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
                <a href="{{ route('products.index') }}" class="btn btn-default">@lang('general.lbl_back')</a>
            </div>
          </div>
        </div>
        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>@lang('general.lbl_information')</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_name')</label>
              <div class="col-md-8">
                <input type="text" class="form-control" value="{{ $product->product_name }}" readonly />
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_abbr')</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->abbr }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_type')</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_type }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_category')</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_category }}" readonly />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_brand')</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_brand }}" readonly />
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_uom')</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->product_uom }}" readonly />
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_barcode')</label>
            <div class="col-md-8">
              <input type="text" class="form-control" value="{{ $product->barcode }}" readonly />
            </div>
          </div>

          <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_photo')</label>
              <div class="col-md-2">
                <a href="/images/user-files/{{ $product->photo }}" target="_blank"><img src="/images/user-files/{{ $product->photo }}" width="100" height="100" class="rounded float-start"></a>
              </div>
              <div class="col-md-2">
                <a href="/images/user-files/{{ $product->photo_2 }}" target="_blank"><img src="/images/user-files/{{ $product->photo_2 }}" width="100" height="100" class="rounded float-start"></a>
              </div>
              <div class="col-md-2">
                <a href="/images/user-files/{{ $product->photo_3 }}" target="_blank"><img src="/images/user-files/{{ $product->photo_3 }}" width="100" height="100" class="rounded float-start"></a>
              </div>
              <div class="col-md-2">
                <a href="/images/user-files/{{ $product->photo_4 }}" target="_blank"><img src="/images/user-files/{{ $product->photo_4 }}" width="100" height="100" class="rounded float-start"></a>
              </div>
              <div class="col-md-2">
                <a href="/images/user-files/{{ $product->photo_5 }}" target="_blank"><img src="/images/user-files/{{ $product->photo_5 }}" width="100" height="100" class="rounded float-start"></a>
              </div>
          </div> 

          </div>
        </div>

        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>@lang('general.lbl_ingredient')</h4></div>
          <div class="panel-body bg-white text-black">
            
            <div class="row mb-3">     
              <div class="col-md-12">
                <table class="table table-striped" id="example">
                    <thead>
                    <tr>
                      <th scope="col">@lang('general.lbl_name')</th>
                      <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                      <th scope="col" width="10%">@lang('general.lbl_qty')</th>
                    </tr>
                    </thead>
                    <tbody>            
                      @foreach($ingredients as $ingredient)
                        <tr>
                            <th scope="row">{{ $ingredient->product_name }}</th>
                            <td>{{ $ingredient->uom_name }}</td>
                            <td>{{ $ingredient->qty }}</td>
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