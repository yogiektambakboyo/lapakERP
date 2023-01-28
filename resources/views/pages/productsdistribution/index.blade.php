@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Products Distribution')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_product_distribution')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('productsdistribution.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="@lang('general.lbl_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="@lang('general.btn_search')" name="submit"></div>   
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">@lang('general.btn_filter')</a></div>    
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('productsdistribution.create') }}" class="btn btn-primary float-right  {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th>@lang('general.lbl_name')</th>
                <th scope="col" width="15%">@lang('general.lbl_branch')</th>
                <th scope="col" width="10%">@lang('general.lbl_active')</th>
                <th scope="col" width="2%">@lang('general.lbl_action')</th>   
                <th scope="col" width="2%"></th>
                <th scope="col" width="2%"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($products as $product)
                    <tr>
                        <td>{{ $product->product_name }}</td>
                        <td>{{ $product->branch_name }}</td>
                        <td>{{ $product->active }}</td>
                        <td><a href="{{ route('productsdistribution.edit', [$product->branch_id,$product->id]) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }}">@lang('general.lbl_edit')</a></td>
                        <td class="{{ $act_permission->allow_delete==1?'':'d-none' }}">
                            {!! Form::open(['method' => 'DELETE','route' => ['productsdistribution.destroy', [$product->branch_id,$product->id]],'style'=>'display:inline']) !!}
                            {!! Form::submit('Hapus', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $products->links() !!}
        </div>

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('productsdistribution.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                <option value="">@lang('general.lbl_allbranch')</option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
                        </div>
                    </form>
                </div>
            </div>
            </div>
        </div>

    </div>
@endsection