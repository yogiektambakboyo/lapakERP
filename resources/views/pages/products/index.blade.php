@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Products')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Products</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    Manage your products here.
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('products.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="Find Product.." value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="Search" name="submit"></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="Export Excel" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('products.create') }}" class="btn btn-primary float-right"><span class="fa fa-plus-circle"></span>  Add new product</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th>Name</th>
                <th scope="col" width="15%">Category</th>
                <th scope="col" width="10%">Brand</th>
                <th scope="col" width="5%">Type</th>
                <th scope="col" width="2%">Action</th>   
                <th scope="col" width="2%"></th>
                <th scope="col" width="2%"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($products as $product)
                    <tr>
                        <th scope="row">{{ $product->id }}</th>
                        <td>{{ $product->product_name }}</td>
                        <td>{{ $product->product_category }}</td>
                        <td>{{ $product->product_brand }}</td>
                        <td>{{ $product->product_type }}</td>
                        <td><a href="{{ route('products.show', $product->id) }}" class="btn btn-warning btn-sm">Show</a></td>
                        <td><a href="{{ route('products.edit', $product->id) }}" class="btn btn-info btn-sm {{ $act_permission->allow_edit==1?'':'d-none' }} ">Edit</a></td>
                        <td>
                            <a onclick="showConfirm({{ $product->id }}, '{{ $product->product_name }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">Delete</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $products->links() !!}
        </div>

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">Filter Data</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                ...
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Apply</button>
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
          let mm = today.getMonth() + 1;
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;

          $('#filter_begin_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_begin_date').val(formattedToday);


          $('#filter_end_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_end_date').val(formattedToday);

          function showConfirm(id,data){
            Swal.fire({
            title: 'Are you sure?',
            text: "You will delete document "+data+" !",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('products.destroy','XX') }}";
                    var lastvalurl = "XX";
                    url = url.replace(lastvalurl, id)
                    const res = axios.delete(url, {}, {
                        headers: {
                            'Content-Type': 'application/json'
                        }
                        }).then(
                            resp => {
                                if(resp.data.status=="success"){
                                    Swal.fire({
                                        title: 'Deleted!',
                                        text: 'Your data has been deleted.',
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33',
                                        confirmButtonText: 'Close'
                                        }).then((result) => {
                                            window.location.href = "{{ route('products.index') }}"; 
                                        })
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
                                    });
                            }
                        });
                    }
                })
        }
    </script>
@endpush
