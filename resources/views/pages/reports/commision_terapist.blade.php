@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Reports - Commision Terapist')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Reports - Commision Terapist</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-2">
                    Manage your report here.
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('reports.terapist.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="Find Terapist.." value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="Search" name="submit"></div>   
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">Filter</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="Export Excel" name="export"></div>  
                    </form>
                </div>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="6%">Dated</th>
                <th>Invoice No</th>
                <th scope="col" width="17%">Product</th>
                <th scope="col" width="15%">Name</th>
                <th scope="col" width="5%">Price</th>
                <th scope="col" width="4%">Qty</th>
                <th scope="col" width="8%">Total</th>  
                <th scope="col" width="10%">Type Commission</th>   
                <th scope="col" width="12%">Base Commission</th>
                <th scope="col" width="12%">Total Commission</th>    
            </tr>
            </thead>
            <tbody>

                @foreach($report_data as $user)
                    <tr>
                        <th scope="row">{{ $user->dated }}</th>
                        <td>{{ $user->invoice_no }}</td>
                        <td>{{ $user->abbr }}</td>
                        <td>{{ $user->name }}</td>
                        <td>{{ $user->price }}</td>
                        <td>{{ $user->qty }}</td>
                        <td>{{ $user->total }}</td>
                        <td>{{ $user->com_type }}</td>
                        <td>{{ $user->base_commision }}</td>
                        <td>{{ $user->commisions }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
           
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