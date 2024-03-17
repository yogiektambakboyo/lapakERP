@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Ubah Password')

@section('content')
<form method="post" action="{{ route('users.updatepassword', $user->id) }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Profile User #{{ $user->id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
                <button type="submit" id="btn-save" class="btn btn-info">Update</button>
                <a href="{{ route('home.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
          
        </div>
        <br>
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Keamanan Akun</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_name')</label>
                <div class="col-md-8">
                  <input type="hidden" class="form-control" name="username" value="{{ $user->username }}"  />
                  <input type="text" class="form-control" value="{{ $user->name }}"  readonly/>
                </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch') *</label>
              <div class="col-md-8">
                <input type="hidden" id="hide_val" class="form-control" value="{{ $user->branch_name }}"  />
                <select class="form-control" id="branch_id" disabled
                     multiple="multiple">
                      <option value="">@lang('general.lbl_branchselect')</option>
                      @foreach($branchs as $branch)
                          <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                      @endforeach
                  </select>
              </div>
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">User Name *</label>
              <div class="col-md-8">
                <input type="text" 
                class="form-control" readonly
                value="{{ $user->username }}">
                @if ($errors->has('username'))
                    <span class="text-danger text-left">{{ $errors->first('username') }}</span>
                @endif
              </div>
            </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Password Baru *</label>
            <div class="col-md-8">
              <input type="text" 
              name="password"
              id="password"
              class="form-control" 
              value="" required/>
              @if ($errors->has('password'))
                        <span class="text-danger text-left">{{ $errors->first('password') }}</span>
                    @endif
            </div>
          </div>


          </div>
        </div>
    </div>
</form>
@endsection
@push('scripts')
<script type="text/javascript">
</script>
@endpush