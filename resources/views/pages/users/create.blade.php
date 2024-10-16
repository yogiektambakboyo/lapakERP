@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Users')

@section('content')

<form method="POST" action="{{ route('users.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-8">
            <h1>@lang('user.lbl_add_new_user')</h1>
          </div>
          <div class="col-md-4">
            <div class="mt-4">
                <button type="button"  id="btn_import" class="btn btn-warning"  data-bs-toggle="modal" data-bs-target="#modal-add-customer">@lang('user.lbl_import')</button>
                <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
                <a href="{{ route('users.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
    </br>
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>@lang('user.lbl_employee_info')</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_name')</label>
                <div class="col-md-8">
                  <input type="hidden" name="date_ymd" id="date_ymd" value="<?= md5(date('Y-m-d')) ?>">
                  <input type="text" id="name"  name="name" class="form-control" value="{{ old('name') }}"  required/>
                </div>
            </div>
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Employee ID</label>
                <div class="col-md-8">
                  <input type="text" id="employee_id" name="employee_id"  class="form-control" value="{{ old('employee_id') }}"   required />
                </div>
            </div>
            
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('user.lbl_select_branch')</label>
              <div class="col-md-8">
                <select class="multiple-select2 form-control" 
                      name="branch_id[]" required multiple="multiple">
                      <option value="">@lang('general.lbl_branchselect')</option>
                      @foreach($branchs as $branch)
                          <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                      @endforeach
                  </select>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Email</label>
              <div class="col-md-8">
                <input type="text" 
                name="email" id="email" required
                class="form-control" 
                value="{{ old('email') }}"  />
                @if ($errors->has('email'))
                  <span class="text-danger text-left">{{ $errors->first('email') }}</span>
                @endif
              </div>
            </div>
          
          
          </div>
        </div>

        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>@lang('user.lbl_account')</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">User Name</label>
              <div class="col-md-8">
                <input type="text" 
                class="form-control"
                name="username" id="username"
                value="{{ old('username') }}"  required/>
                @if ($errors->has('username'))
                    <span class="text-danger text-left">{{ $errors->first('username') }}</span>
                @endif
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('user.lbl_password')</label>
              <div class="col-md-8">
                <input type="text" 
                class="form-control"
                name="password" id="password"
                value="{{ old('password') }}"  required/>
                @if ($errors->has('password'))
                    <span class="text-danger text-left">{{ $errors->first('password') }}</span>
                @endif
              </div>
            </div>
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('user.lbl_app_access')</label>
                <div class="col-md-8">
                    <select class="form-control" 
                        name="role" required>
                        <option value="">@lang('user.lbl_select_access')</option>
                        @foreach($roles as $role)
                            <option value="{{ $role->id }}" {{ ($role->id==old('role') ) 
                              ? 'selected'
                              : '' }}>{{ $role->name }}</option>
                        @endforeach
                    </select>
                    @if ($errors->has('role'))
                        <span class="text-danger text-left">{{ $errors->first('role') }}</span>
                    @endif
                </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Status</label>
              <div class="col-md-8">
                <input type="checkbox" name="active" id="active" value="{{ old('active') }}" checked> <label for="active">@lang('general.lbl_active')</label>
              </div>
            </div>
          </div>
        </div>
    </div>
</form>

<div class="modal fade" id="modal-add-customer" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog">
  <div class="modal-content">
      <div class="modal-header">
      <h5 class="modal-title" id="staticBackdropLabel">@lang('user.lbl_import')</h5>
      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        
        <div class="container mt-4">
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_name')</label>
            <div class="col-md-10">
              <select class="form-control" 
                    name="dialog_name" id ="dialog_name" required>
                    <option value="">@lang('user.lbl_select_user')</option>
                </select>
            </div>
        </div>

      </div>
      <div class="modal-footer">
      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
      <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_apply_user">@lang('general.lbl_apply')</button>
      </div>
  </div>
  </div>
</div>

@endsection
@push('scripts')
<script type="text/javascript">
    var list_user = [];
    $('#btn_apply_user').on('click', function(){
        var recid = $('#dialog_name').find(':selected').val();
        console.log(recid);
        for (let index = 0; index < list_user.length; index++) {
          const element = list_user[index];

          if(element.RecId == recid){
          console.log(element.RecId);

            $('#employee_id').val(element.RecId);
            $('#email').val(element.email);
            $('#username').val(element.email);
            $('#password').val(atob(element.passkey));
            $('#name').val((element.FirstName+" "+element.LastName));
          }
        }
    });
    $('#btn_import').on('click', function(){
            const json = JSON.stringify({
                  token_val : $('#date_ymd').val()
                }
              );
              const res = axios.post("{{ route('home.list_user') }}", json, {
                headers: {
                  'Content-Type': 'application/json',
                },
              }).then(resp => {
                    if(resp.data.status=="success"){
                        if(resp.data.data.length > 0){
                          list_user = resp.data.data;
                          for (let index = 0; index < resp.data.data.length; index++) {
                            const element = resp.data.data[index];

                            var option_data = {
                              id: element.RecId,
                              text: element.FirstName + " " +element.LastName + " (" +element.Position + ")"
                            };

                            var newOption = new Option(option_data.text, option_data.id, false, false);
                            $('#dialog_name').append(newOption);
                            
                          }

                          $('#dialog_name').trigger('change');

                        }
                        
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
    });
</script>
@endpush
