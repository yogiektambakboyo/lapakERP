@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Branchs</h2>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-8">
                    Manage your branchs here.
                </div>
                <div class="col-md-8"> 	
                    <form action="{{ route('branchs.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-12"><input type="text" class="form-control  form-control-lg" name="search" placeholder="Find Branch . . ." value="{{ $keyword }}"></div>
                        <div class="col-12"><input type="submit" class="btn btn-secondary" value="Search" name="submit"></div>   
                        <div class="col-12"><input type="submit" class="btn btn-success" value="Export Excel" name="export"></div>   
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('branchs.create') }}" class="btn btn-primary float-right"><span class="fa fa-plus-circle"></span> Add Branchs</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col" width="15%">Name</th>
                <th scope="col">Address</th>
                <th scope="col">City</th>
                <th scope="col">Abbreviation</th> 
                <th scope="col" colspan="3" width="1%"></th> 
            </tr>
            </thead>
            <tbody>
                @foreach($branchs as $key => $branch)
                    <tr>
                        <th>{{ ++$key }}</th>
                        <td>{{ $branch->remark }}</td>
                        <td>{{ $branch->address }}</td>
                        <td>{{ $branch->city }}</td>
                        <td>{{ $branch->abbr }}</td>
                        <td><a href="{{ route('branchs.edit', $branch->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }} ">Edit</a></td>
                        <td>
                            <a onclick="showConfirm({{ $branch->id }}, '{{ $branch->remark }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">Delete</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

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
                    var url = "{{ route('branchs.destroy','XX') }}";
                    var lastvalurl = "XX";
                    console.log(url);
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
                                            window.location.href = "{{ route('branchs.index') }}"; 
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
