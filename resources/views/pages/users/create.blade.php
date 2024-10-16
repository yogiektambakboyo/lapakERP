@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Users')

@section('content')
<form method="POST" action="{{ route('users.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Add New User</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
                <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
                <a href="{{ route('users.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>
    </br>
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Employee Info</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_name')</label>
                <div class="col-md-8">
                  <input type="text" name="name" class="form-control" value="{{ old('name') }}"  required/>
                </div>
            </div>
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Employee ID</label>
                <div class="col-md-8">
                  <input type="text" name="employee_id"  class="form-control" value="{{ old('employee_id') }}"   required />
                </div>
            </div>
            
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
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
                name="email" required
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
          <div class="panel-heading bg-teal-600"><h4>Account</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">User Name</label>
              <div class="col-md-8">
                <input type="text" 
                class="form-control"
                name="username" 
                value="{{ old('username') }}"  required/>
                @if ($errors->has('username'))
                    <span class="text-danger text-left">{{ $errors->first('username') }}</span>
                @endif
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Password</label>
              <div class="col-md-8">
                <input type="text" 
                class="form-control"
                name="password" 
                value="{{ old('password') }}"  required/>
                @if ($errors->has('password'))
                    <span class="text-danger text-left">{{ $errors->first('password') }}</span>
                @endif
              </div>
            </div>
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">App Accesss</label>
                <div class="col-md-8">
                    <select class="form-control" 
                        name="role" required>
                        <option value="">Select role</option>
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
                <input type="checkbox" name="active" id="active" value="{{ old('active') }}" checked> <label for="active">Active</label>
              </div>
            </div>
          </div>
        </div>
    </div>
</form>
@endsection
@push('scripts')
<script type="text/javascript">
    function previewFile(input){
        var file = $("#photo").get(0).files[0];
 
        if(file){
            var reader = new FileReader();
 
            reader.onload = function(){
                $("#photo_preview").attr("src", reader.result);
            }
 
            reader.readAsDataURL(file);
        }
    }

    function previewFileNetizen(input){
        var file = $("#photo_netizen_ids").get(0).files[0];
 
        if(file){
            var reader = new FileReader();
 
            reader.onload = function(){
                $("#photo_netizen_preview").attr("src", reader.result);
            }
 
            reader.readAsDataURL(file);
        }
    }
</script>
@endpush
