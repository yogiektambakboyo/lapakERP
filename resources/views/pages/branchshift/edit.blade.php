@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit User Shift</h2>
        <div class="lead">
            Editing User Shift.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('branchshift.update', $branchshift->id) }}">
                @method('patch')
                @csrf
                
    
                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}" {{ ($branchshift->branch_id == $branch->id) 
                                    ? 'selected'
                                    : '' }}>{{  $branch->remark }}</option>
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
                                <option value="{{ $shift->id }}" {{ ($branchshift->shift_id == $shift->id) 
                                    ? 'selected'
                                    : '' }} >{{  $shift->remark }} ( {{  $shift->time_start }} - {{  $shift->time_end }})</option>
                            @endforeach
                        </select>
                    </div>
                </div>
           
                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('branchshift.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection