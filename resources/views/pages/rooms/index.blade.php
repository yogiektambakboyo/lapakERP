@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Rooms</h2>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    Manage your rooms here.
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('rooms.create') }}" class="btn btn-primary btn-sm float-right">Add rooms</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th scope="col" width="5%">#</th>
                <th scope="col" width="15%">Branch</th>
                <th scope="col" width="15%">Name</th>
                <th scope="col" colspan="3" width="1%"></th> 
            </tr>
            </thead>
            <tbody>
                @foreach($rooms as $room)
                    <tr>
                        <th>{{ $room->id }}</th>
                        <td>{{ $room->branch_name }}</td>
                        <td>{{ $room->remark }}</td>
                        <td><a href="{{ route('rooms.edit', $room->id) }}" class="btn btn-info btn-sm">Edit</a></td>
                        <td>
                            {!! Form::open(['method' => 'DELETE','route' => ['rooms.destroy', $room->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Delete', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $rooms->links() !!}
        </div>

    </div>
@endsection
