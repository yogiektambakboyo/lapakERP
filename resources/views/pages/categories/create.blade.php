@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New UOM')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Add new Category</h2>
        <div class="lead">
            Add new Category.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('categories.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="remark" class="form-label">Name</label>
                    <input value="{{ old('remark') }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('remark'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <button type="submit" class="btn btn-primary">Save Category</button>
                <a href="{{ route('categories.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection