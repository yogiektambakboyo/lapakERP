@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_department_edit')</h2>
        <div class="container mt-4">

            <form method="POST" action="{{ route('departments.update', $department->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ $department->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('departments.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection