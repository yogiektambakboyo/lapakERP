@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Laporan - Serah Terima')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Laporan - Serah Terima</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-8">
                    Manage your report here.
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('reports.terapist.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="Find Terapist.." value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="Search" name="submit"></div>   
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">Filter</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="Export Excel" name="export"></div>  
                    </form>
                </div>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="6%">Dated</th>
                <th>Invoice No</th>
                <th scope="col" width="17%">Product</th>
                <th scope="col" width="15%">Name</th>
                <th scope="col" width="5%">Price</th>
                <th scope="col" width="4%">Qty</th>
                <th scope="col" width="8%">Total</th>  
                <th scope="col" width="10%">Type Commission</th>   
                <th scope="col" width="12%">Base Commission</th>
                <th scope="col" width="12%">Total Commission</th>    
            </tr>
            </thead>
            <tbody>

                @foreach($report_data as $user)
                    <tr>
                        <th scope="row">{{ $user->dated }}</th>
                        <td>{{ $user->invoice_no }}</td>
                        <td>{{ $user->abbr }}</td>
                        <td>{{ $user->name }}</td>
                        <td>{{ $user->price }}</td>
                        <td>{{ $user->qty }}</td>
                        <td>{{ $user->total }}</td>
                        <td>{{ $user->com_type }}</td>
                        <td>{{ $user->base_commision }}</td>
                        <td>{{ $user->commisions }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
           
        </div>

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">Filter Data</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('reports.closeshift.getdata') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Branch</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label col-form-label col-md-4">Date</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_begin_date"
                            id="filter_begin_date"
                            class="form-control" 
                            value="{{ old('filter_begin_date') }}" required/>
                            @if ($errors->has('filter_begin_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_begin_date') }}</span>
                                @endif
                        </div>

                       
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Shift</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                            name="filter_shift" id="filter_shift">
                            @foreach($shifts as $shift)
                                <option value="{{ $shift->id }}">{{ $shift->remark }} ( {{ $shift->time_start }} - {{ $shift->time_end }}) </option>
                            @endforeach
                        </select>
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">Apply</button>
                        </div>
                    </form>
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

          var myModal = new bootstrap.Modal(document.getElementById('modal-filter'));
          myModal.show();

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
                    var url = "{{ route('invoices.destroy','XX') }}";
                    var lastvalurl = "XX";
                    console.log(url);
                    url = url.replace(lastvalurl, id)
                    const res = axios.delete(url, {}, {
                        headers: {
                            // Overwrite Axios's automatically set Content-Type
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
                                            window.location.href = "{{ route('invoices.index') }}"; 
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