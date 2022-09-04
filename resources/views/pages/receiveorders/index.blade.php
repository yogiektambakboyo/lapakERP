@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Sales Order')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Receive Order</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    Manage your receive order here.
                </div>
                <div class="col-md-8"> 	
                    <form action="{{ route('receiveorders.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="Find Purchase Order.." value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="Search" name="submit"></div>   
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">Filter</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="Export Excel" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('receiveorders.create') }}" class="btn btn-primary float-right {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  Add new RO</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col" width="10%">Branch</th>
                <th>Receive No</th>
                <th scope="col" width="8%">Dated</th>
                <th scope="col" width="15%">Supplier</th>
                <th scope="col" width="10%">Total</th>
                <th scope="col" width="2%">Action</th>   
                <th scope="col" width="2%"></th>
                <th scope="col" width="2%"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($receives as $receive)
                    <tr>
                        <th scope="row">{{ $receive->id }}</th>
                        <td>{{ $receive->branch_name }}</td>
                        <td>{{ $receive->receive_no }}</td>
                        <td>{{ $receive->dated }}</td>
                        <td>{{ $receive->customer }}</td>
                        <td>{{ $receive->total }}</td>
                        <td><a href="{{ route('receiveorders.show', $receive->id) }}" class="btn btn-warning btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">Show</a></td>
                        <td><a href="{{ route('receiveorders.edit', $receive->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }} ">Edit</a></td>
                        <td class=" {{ $act_permission->allow_delete==1?'':'d-none' }}">
                            <a onclick="showConfirm({{ $receive->id }}, '{{ $receive->receive_no }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">Delete</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $receives->links() !!}
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
                var url = "{{ route('receiveorders.destroy','XX') }}";
                var lastvalurl = "XX";
                console.log(url);
                url = url.replace(lastvalurl, id)
                const res = axios.delete(url, {}, {
                    headers: {
                        // Overwrite Axios's automatically set Content-Type
                        'Content-Type': 'application/json'
                    }
                    }).then(resp => {
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
                                    window.location.href = "{{ route('receiveorders.index') }}"; 
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
                            }
                            );
                        }
                    });
            }
            })
        }
    </script>
@endpush