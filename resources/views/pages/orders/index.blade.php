@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Sales Order')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Sales Orders</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-2">
                    Manage your orders here.
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('orders.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="Find Orders.." value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="Search" name="submit"></div>   
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">Filter</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="Export Excel" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('orders.create') }}" class="btn btn-primary float-right {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  Add new order</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col" width="10%">Branch</th>
                <th>Order No</th>
                <th scope="col" width="8%">Dated</th>
                <th scope="col" width="15%">Customer</th>
                <th scope="col" width="10%">Total</th>
                <th scope="col" width="10%">Total Discount</th>
                <th scope="col" width="10%">Total Payment</th>
                <th scope="col" width="2%">Action</th>   
                <th scope="col" width="2%"></th>
                <th scope="col" width="2%"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($orders as $order)
                    <tr>
                        <th scope="row">{{ $order->id }}</th>
                        <td>{{ $order->branch_name }}</td>
                        <td>{{ $order->order_no }}</td>
                        <td>{{ $order->dated }}</td>
                        <td>{{ $order->customer }}</td>
                        <td>{{ $order->total }}</td>
                        <td>{{ $order->total_discount }}</td>
                        <td>{{ $order->total_payment }}</td>
                        <td><a href="{{ route('orders.show', $order->id) }}" class="btn btn-warning btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">Show</a></td>
                        <td><a href="{{ route('orders.edit', $order->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }} ">Edit</a></td>
                        <td class=" {{ $act_permission->allow_delete==1?'':'d-none' }}">
                            {!! Form::open(['method' => 'DELETE','route' => ['orders.destroy', $order->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Delete', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $orders->links() !!}
        </div>

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">Filter Data</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                ...
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Apply</button>
                </div>
            </div>
            </div>
        </div>

    </div>
@endsection