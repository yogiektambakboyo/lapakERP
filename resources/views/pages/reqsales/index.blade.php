@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Pengajuan Akun')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Pengajuan Akun</h2>

        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>

                <div class="col-md-10"> 	
                    
                </div>
            </div>
            <div class="col-md-2">
            </div>
        </div>
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="table_datatable">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col">Nama</th>
                <th scope="col" width="15%">Alamat</th>
                <th scope="col" width="12%">Email</th>
                <th scope="col" width="12%">No HP</th>
                <th scope="col" colspan="" width="1%" class="nex"></th> 
                <th scope="col" colspan="" width="1%" class="nex"></th> 
            </tr>
            </thead>
            <tbody>
                @php $counter=1; @endphp
                @foreach($sales as $seller)
                    <tr>
                        <th scope="row">{{ $counter }}</th>
                        <td>{{ $seller->name }}</td>
                        <td>{{ $seller->address }}</td>
                        <td>{{ $seller->username }}</td>
                        <td>{{ $seller->phone }}</td>
                        <td>
                            <a onclick="showConfirmApprove({{ $seller->id }}, '{{ $seller->name }}')" class="btn btn-success btn-sm ">Setujui</a>
                        </td>
                        <td>
                            <a onclick="showConfirmReject({{ $seller->id }}, '{{ $seller->name }}')" class="btn btn-danger btn-sm  ">Tolak</a>
                        </td>
                    </tr>
                    @php $counter++; @endphp
                @endforeach
            </tbody>
        </table>

        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('sales.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                <option value="">@lang('general.lbl_allbranch')</option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
                        </div>
                    </form>
                </div>
            </div>
            </div>
          </div>

        <div class="d-flex">
            {!! $sales->links() !!}
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

          

          let table = new DataTable('#table_datatable',{
            layout: {
                topStart: {
                    buttons: ['copyHtml5', 'excelHtml5', 'csvHtml5', 'pdfHtml5']
                }
            }   
          });

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

          function showConfirmReject(id,data){
            Swal.fire({
            title: "@lang('general.lbl_sure')",
            text: "Anda akan menolak pengajuan "+data+" !",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
            confirmButtonText: "Ya, Tolak"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('reqsales.reject','XX') }}";
                    var lastvalurl = "XX";
                    url = url.replace(lastvalurl, id)
                    const res = axios.get(url, {}, {
                        headers: {
                            'Content-Type': 'application/json'
                        }
                        }).then(
                            resp => {
                                if(resp.data.status=="success"){
                                    Swal.fire({
                                        title: 'Ditolak',
                                        text: "Data pengajuan berhasil ditolak ",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                                        confirmButtonText: "@lang('general.lbl_close') "
                                        }).then((result) => {
                                            window.location.href = "{{ route('reqsales.index') }}"; 
                                        })
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
                                    });
                            }
                        });
                    }
                })
        }

        function showConfirmApprove(id,data){
            Swal.fire({
            title: "@lang('general.lbl_sure')",
            text: "Anda akan menyetujui pengajuan "+data+" !",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
            confirmButtonText: "Ya, Setujui"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('reqsales.approve','XX') }}";
                    var lastvalurl = "XX";
                    url = url.replace(lastvalurl, id)
                    const res = axios.get(url, {}, {
                        headers: {
                            'Content-Type': 'application/json'
                        }
                        }).then(
                            resp => {
                                if(resp.data.status=="success"){
                                    Swal.fire({
                                        title: 'Disetujui',
                                        text: "Data pengajuan berhasil disetujui",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                                        confirmButtonText: "@lang('general.lbl_close') "
                                        }).then((result) => {
                                            window.location.href = "{{ route('reqsales.index') }}"; 
                                        })
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
                                    });
                            }
                        });
                    }
                })
        }
    </script>
@endpush
