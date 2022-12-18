@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Room')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Create Room</h2>
        <div class="lead">
            Add New Room.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('rooms.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="remark" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ old('remark') }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('remark'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="row mb-3">
                    <label class="form-label col-form-label">@lang('general.lbl_branch')</label>
                    <div>
                      <select class="form-control" 
                            name="branch_id" required>
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                  </div>


                <button type="submit" class="btn btn-primary">Save room</button>
                <a href="{{ route('rooms.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection