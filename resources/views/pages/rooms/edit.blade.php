@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Rooms')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit Rooms</h2>
        <div class="lead">
            Editing Rooms
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('rooms.update', $room->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input value="{{ $room->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
                
                <div class="row mb-3">
                    <label class="form-label col-form-label">Branch</label>
                    <div>
                      <select class="form-control" 
                            name="branch_id" required>
                            <option value="">Select Branch</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}"
                                    {{ ($room->branch_id == $branch->id) 
                                        ? 'selected'
                                        : '' }}>{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Save rooms</button>
                <a href="{{ route('rooms.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection