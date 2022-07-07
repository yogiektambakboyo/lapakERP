@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Branchs</h2>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-2">
                    Manage your branchs here.
                </div>
                <div class="col-md-4"> 	
                    <form action="{{ route('branchs.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-12"><input type="text" class="form-control  form-control-lg" name="search" placeholder="Find Branch.." value="{{ $keyword }}"></div>
                        <div class="col-12"><input type="submit" class="btn btn-secondary" value="Search" name="submit"></div>   
                        <div class="col-12"><input type="submit" class="btn btn-success" value="Export Excel" name="export"></div>   
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('branchs.create') }}" class="btn btn-primary float-right">Add Branchs</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col" width="15%">Name</th>
                <th scope="col">Address</th>
                <th scope="col">City</th>
                <th scope="col">Abbreviation</th> 
                <th scope="col" colspan="3" width="1%"></th> 
            </tr>
            </thead>
            <tbody>
                @foreach($branchs as $branch)
                    <tr>
                        <th>{{ $branch->id }}</th>
                        <td>{{ $branch->remark }}</td>
                        <td>{{ $branch->address }}</td>
                        <td>{{ $branch->city }}</td>
                        <td>{{ $branch->abbr }}</td>
                        <td><a href="{{ route('branchs.edit', $branch->id) }}" class="btn btn-info btn-sm">Edit</a></td>
                        <td>
                            {!! Form::open(['method' => 'DELETE','route' => ['branchs.destroy', $branch->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Delete', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

    </div>
@endsection
