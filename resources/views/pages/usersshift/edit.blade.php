@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit User Shift</h2>
        <div class="lead">
            Editing User Shift.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('usersshift.update', $usershift->id) }}">
                @method('patch')
                @csrf
                
                <div class="mb-3">
                    <label class="form-label col-form-label col-md-12">@lang('general.lbl_dated_mmddYYYY')</label>
                    <div class="col-md-12">
                        <input type="text" 
                        name="dated"
                        id="dated"
                        class="form-control" 
                        value="{{ $usershift->dated }}" required/>
                        @if ($errors->has('dated'))
                                <span class="text-danger text-left">{{ $errors->first('dated') }}</span>
                            @endif
                    </div>
                </div>


                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}" {{ ($usershift->branch_id == $branch->id) 
                                    ? 'selected'
                                    : '' }}>{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">User</label>
                    <div class="col-md-12">
                        <select class="form-control" 
                            name="users_id">
                            <option value="">Select User</option>
                            @foreach($users as $user)
                                <option value="{{ $user->id }}" {{ ($usershift->users_id == $user->id) 
                                    ? 'selected'
                                    : '' }}>{{  $user->name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Shift</label>
                    <div class="col-md-12">
                        <select class="form-control" 
                            name="shift_id">
                            <option value="">Select Shift</option>
                            @foreach($shifts as $shift)
                                <option value="{{ $shift->id }}" {{ ($usershift->shift_id == $shift->id) 
                                    ? 'selected'
                                    : '' }} >{{  $shift->remark }} ( {{  $shift->time_start }} - {{  $shift->time_end }})</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">@lang('general.lbl_remark')</label>
                    <input value="{{ $usershift->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('remark'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
           
                <button type="submit" class="btn btn-primary">Save customer</button>
                <a href="{{ route('usersshift.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection