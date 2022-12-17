@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Company</h2>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-8">
                    Manage your company here.
                </div>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th scope="col" width="15%">Name</th>
                <th scope="col">Address</th>
                <th scope="col">City</th>
                <th scope="col">Email</th>
                <th scope="col">Phone No</th> 
                <th scope="col" colspan="3" width="1%"></th> 
            </tr>
            </thead>
            <tbody>
                    <tr>
                        <td>{{ $company->remark }}</td>
                        <td>{{ $company->address }}</td>
                        <td>{{ $company->city }}</td>
                        <td>{{ $company->email }}</td>
                        <td>{{ $company->phone_no }}</td>
                        <td><a href="{{ route('company.edit', $company->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }} ">@lang('general.lbl_edit')</a></td> 
                    </tr>
            </tbody>
        </table>

    </div>
@endsection
