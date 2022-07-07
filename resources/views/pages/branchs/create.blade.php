@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Branch')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Add new Branch</h2>
        <div class="lead">
            Add new Branch.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('branchs.store') }}">
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

                <div class="mb-3">
                    <label for="address" class="form-label">Address</label>
                    <input value="{{ old('address') }}" 
                        type="text" 
                        class="form-control" 
                        name="address" 
                        placeholder="Address" required>

                    @if ($errors->has('address'))
                        <span class="text-danger text-left">{{ $errors->first('address') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="city" class="form-label">City</label>
                    <input value="{{ old('city') }}" 
                        type="text" 
                        class="form-control" 
                        name="city" 
                        placeholder="city" required>

                    @if ($errors->has('city'))
                        <span class="text-danger text-left">{{ $errors->first('city') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="abbr" class="form-label">Abbreviation</label>
                    <input value="{{ old('abbr') }}" 
                        type="text" 
                        class="form-control" 
                        name="abbr" 
                        placeholder="abbr" required>

                    @if ($errors->has('abbr'))
                        <span class="text-danger text-left">{{ $errors->first('abbr') }}</span>
                    @endif
                </div>

                <button type="submit" class="btn btn-primary">Save branch</button>
                <a href="{{ route('branchs.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection