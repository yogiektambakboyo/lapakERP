@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Types')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit Types</h2>
        <div class="lead">
            Editing Types
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('types.update', $type->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input value="{{ $type->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
                <button type="submit" class="btn btn-primary">Save types</button>
                <a href="{{ route('types.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection