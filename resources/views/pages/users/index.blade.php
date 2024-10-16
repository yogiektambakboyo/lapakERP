@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Users')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('user.title')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('user.label')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('users.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="@lang('user.label_search')" value="{{ $request->search }}"></div>
                        <input type="hidden" class="form-control  form-control-sm" name="filter_branch_id" value="{{ $request->filter_branch_id }}">
                        <input type="hidden" name="filter_job_id" value="{{ $request->filter_job_id }}">
                        <input type="hidden" name="filter_enddate" value="{{ $request->filter_end_date }}">
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="@lang('user.btn_search')" name="src"></div>   
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">@lang('user.btn_filter')</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('user.btn_export')" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('users.create') }}" class="btn btn-primary float-right {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  @lang('user.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th>@lang('user.lbl_name')</th>
                <th scope="col" width="15%">@lang('user.lbl_appaccess')</th>
                <th scope="col" width="15%">@lang('general.lbl_active')</th>
                <th scope="col" width="2%">@lang('user.lbl_action')</th>   
                <th scope="col" width="2%"></th>
                <th scope="col" width="2%"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($users as $key => $user)
                    <tr>
                        <td>{{ $user->name }}</td>
                        <td>
                            @foreach($user->roles as $role)
                                <span class="badge bg-primary">{{ $role->name }}</span>
                            @endforeach
                        </td>
                        <td>{{ $user->active }}</td>
                        <td><a href="{{ route('users.show', $user->id) }}" class="btn btn-warning btn-sm {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('user.lbl_show')</a></td>
                        <td><a href="{{ route('users.edit', $user->id) }}" class="btn btn-info btn-sm {{ $act_permission->allow_edit==1?'':'d-none' }}">@lang('user.lbl_edit')</a></td>
                        <td>
                            <a onclick="showConfirm({{ $user->id }}, '{{ $user->remark }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">@lang('user.lbl_delete')</a>
                        </td>

                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $users->links() !!}
        </div>

        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('user.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('users.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('user.lbl_branch')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                <option value="">@lang('user.lbl_allbranch')</option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label col-form-label col-md-4">@lang('user.lbl_jobtitle')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_job_id" id="filter_job_id">
                                <option value="">@lang('user.lbl_alljobtitle')</option>
                                @foreach($jobtitles as $jobtitle)
                                    <option value="{{ $jobtitle->id }}">{{ $jobtitle->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-6">@lang('user.lbl_joindatebefore')</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_end_date"
                            id="filter_end_date"
                            class="form-control" 
                            value="{{ old('filter_end_date') }}" required/>
                            @if ($errors->has('filter_end_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_end_date') }}</span>
                                @endif
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">@lang('user.lbl_apply')</button>
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
            cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
            confirmButtonText: "@lang('general.lbl_sure_delete')"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('users.destroy','XX') }}";
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
                                        text: "@lang('general.lbl_msg_delete_title') ",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                                        confirmButtonText: "@lang('general.lbl_close') "
                                        }).then((result) => {
                                            window.location.href = "{{ route('users.index') }}"; 
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
