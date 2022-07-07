@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Departments')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Departments</h2>

        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    Manage your departments here.
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('departments.create') }}" class="btn btn-primary btn-sm float-right">Add Departments</a>
            </div>
        </div>
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col">Name</th>
                <th scope="col" colspan="3" width="1%"></th> 
            </tr>
            </thead>
            <tbody>
                @foreach($departments as $department)
                    <tr>
                        <th scope="row">{{ $department->id }}</th>
                        <td>{{ $department->remark }}</td>
                        <td><a href="{{ route('departments.edit', $department->id) }}" class="btn btn-info btn-sm">Edit</a></td>
                        <td>
                            {!! Form::open(['method' => 'DELETE','route' => ['departments.destroy', $department->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Delete', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

    </div>
@endsection
