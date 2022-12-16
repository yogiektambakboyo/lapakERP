@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', "Service")

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.service')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.label')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('services.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="@lang('general.label_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="@lang('general.btn_search')" name="submit"></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('services.create') }}" class="btn btn-primary float-right"><span class="fa fa-plus-circle"></span> @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th>@lang('general.lbl_name')</th>
                <th scope="col" width="15%">@lang('general.category')</th>
                <th scope="col" width="10%">@lang('general.brand')</th>
                <th scope="col" width="5%">@lang('general.tipe')</th>
                <th scope="col" width="2%">@lang('general.lbl_action')</th>   
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
                        <td><a href="{{ route('services.show', $product->id) }}" class="btn btn-warning btn-sm">@lang('general.lbl_show')</a></td>
                        <td><a href="{{ route('services.edit', $product->id) }}" class="btn btn-info btn-sm {{ $act_permission->allow_edit==1?'':'d-none' }} ">@lang('general.lbl_edit')</a></td>
                        <td>
                            <a onclick="showConfirm({{ $product->id }}, '{{ $product->product_name }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">@lang('general.lbl_delete')</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $products->links() !!}
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
            title: "@lang('general.lbl_sure')",
            text: "@lang('general.lbl_sure_title') "+data+" !",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: "@lang('general.lbl_sure_delete')",
            cancelButtonText: "@lang('general.lbl_cancel')"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('services.destroy','XX') }}";
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
                                        title: "@lang('general.lbl_msg_delete')",
                                        text: "@lang('general.lbl_msg_delete_title')",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33',
                                        confirmButtonText: "@lang('general.lbl_close')"
                                        }).then((result) => {
                                            window.location.href = "{{ route('services.index') }}"; 
                                        })
                                }else{
                                    Swal.fire(
                                    {
                                        position: 'top-end',
                                        icon: 'warning',
                                        text: "@lang('general.lbl_msg_failed') - "+resp.data.message,
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
