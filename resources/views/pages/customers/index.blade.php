@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Customers')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Customers</h2>

        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    Manage your customers here.
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('customers.create') }}" class="btn btn-primary btn-sm float-right">Add Customers</a>
            </div>
        </div>
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col" width="7%">Branch</th>
                <th scope="col">Name</th>
                <th scope="col" width="5%">Address</th>
                <th scope="col" width="5%">Phone No</th>
                <th scope="col" colspan="3" width="1%"></th> 
            </tr>
            </thead>
            <tbody>
                @foreach($customers as $customer)
                    <tr>
                        <th scope="row">{{ $customer->id }}</th>
                        <td>{{ $customer->branch_name }}</td>
                        <td>{{ $customer->name }}</td>
                        <td>{{ $customer->address }}</td>
                        <td>{{ $customer->phone_no }}</td>
                        <td><a href="{{ route('customers.edit', $customer->id) }}" class="btn btn-info btn-sm">Edit</a></td>
                        <td>
                            {!! Form::open(['method' => 'DELETE','route' => ['customers.destroy', $customer->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Delete', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

    </div>
@endsection
