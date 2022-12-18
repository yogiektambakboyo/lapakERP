@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit branchs</h2>
        <div class="lead">
            Editing branchs.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('branchs.update', $branch->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ $branch->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="address" class="form-label">@lang('general.lbl_address')</label>
                    <input value="{{ $branch->address }}" 
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
                    <input value="{{ $branch->city }}" 
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
                    <input value="{{ $branch->abbr }}" 
                        type="text" 
                        class="form-control" 
                        name="abbr" 
                        placeholder="abbr" required>

                    @if ($errors->has('abbr'))
                        <span class="text-danger text-left">{{ $errors->first('abbr') }}</span>
                    @endif
                </div>

                <button type="submit" class="btn btn-primary">Save branch</button>
                <a href="{{ route('branchs.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection