@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Shift')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Create Shift</h2>
        <div class="lead">
            Add new shift.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('shift.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="remark" class="form-label">Remark</label>
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
                    <label for="time_start" class="form-label">Time Start</label>
                    <input value="{{ old('time_start') }}" 
                        type="text" 
                        class="form-control" 
                        name="time_start" id="time_start"
                        placeholder="Time Start" required>

                    @if ($errors->has('time_start'))
                        <span class="text-danger text-left">{{ $errors->first('time_start') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="time_end" class="form-label">Time End</label>
                    <input value="{{ old('time_end') }}" 
                        type="text" 
                        class="form-control" 
                        name="time_end"  id="time_end"
                        placeholder="Time End" required>

                    @if ($errors->has('time_end'))
                        <span class="text-danger text-left">{{ $errors->first('time_end') }}</span>
                    @endif
                </div>

                <button type="submit" class="btn btn-primary">Save Shift</button>
                <a href="{{ route('shift.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection

@push('scripts')
    <script type="text/javascript">
          $('#time_start').timepicker({
                showMeridian : false
            });

            $('#time_end').timepicker({
                showMeridian : false
            });          
    </script>
@endpush