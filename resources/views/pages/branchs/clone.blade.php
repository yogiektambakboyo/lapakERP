@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Clone Branch')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_branch_clone')</h2>
        <div class="container mt-4">

                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch_source') *</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id_source" id="branch_id_source">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch_destination') *</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id_destination" id="branch_id_destination">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                  </div>
                <button type="submit" id="btn-save" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('branchs.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
        </div>

    </div>
@endsection

@push('scripts')
    <script type="text/javascript">
        $("#btn-save").on('click',function(){
            if($('#branch_id_source option:selected').val() == "" || $('#branch_id_destination option:selected').val()  ==""){
                Swal.fire(
                    {
                    position: 'top-end',
                    icon: 'warning',
                    text: "Cabang Sumber dan Cabang Tujuan tidak boleh kosong ",
                    showConfirmButton: false,
                    imageHeight: 30, 
                    imageWidth: 30,   
                    timer: 1500
                    }
                );
            }else if($('#branch_id_source option:selected').val() == $('#branch_id_destination option:selected').val()){
                Swal.fire(
                    {
                    position: 'top-end',
                    icon: 'warning',
                    text: "Cabang Sumber dan Cabang Tujuan tidak boleh sama ",
                    showConfirmButton: false,
                    imageHeight: 30, 
                    imageWidth: 30,   
                    timer: 1500
                    }
                );
            }else{
                const json = JSON.stringify({
                        branch_id_source : $('#branch_id_source option:selected').val(),
                        branch_id_destination : $('#branch_id_destination option:selected').val()
                    }
                );
                const res = axios.post("{{ route('branchs.clone_store') }}", json, {
                    headers: {
                    // Overwrite Axios's automatically set Content-Type
                    'Content-Type': 'application/json'
                    }
                }).then(resp => {
                        if(resp.data.status=="success"){
                            Swal.fire(
                                {
                                position: 'top-end',
                                icon: 'success',
                                text: "Duplikasi data cabang "+$('#branch_id_source option:selected').text()+" ke cabang "+$('#branch_id_destination option:selected').text()+" Berhasil",
                                showConfirmButton: false,
                                imageHeight: 30, 
                                imageWidth: 30,   
                                timer: 1500
                                }
                            );
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

    </script>
@endpush