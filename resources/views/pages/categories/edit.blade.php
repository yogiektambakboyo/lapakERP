@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Categories')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit Categories</h2>
        <div class="lead">
            Editing Categories
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('categories.update', $category->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input value="{{ $category->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
                <button type="submit" class="btn btn-primary">Save categories</button>
                <a href="{{ route('categories.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection