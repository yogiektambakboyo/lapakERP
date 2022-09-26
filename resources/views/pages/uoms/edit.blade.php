@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Uoms')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit Uoms</h2>
        <div class="lead">
            Editing Uoms
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('uoms.update', $uom->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input value="{{ $uom->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
                <button type="submit" class="btn btn-primary">Save uoms</button>
                <a href="{{ route('uoms.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection