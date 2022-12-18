@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit company</h2>
        <div class="lead">
            Editing company.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('company.update', $company->id) }}"   enctype="multipart/form-data">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input value="{{ $company->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="address" class="form-label">Address</label>
                    <input value="{{ $company->address }}" 
                        type="text" 
                        class="form-control" 
                        name="address" 
                        placeholder="Address" required>

                    @if ($errors->has('address'))
                        <span class="text-danger text-left">{{ $errors->first('address') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="city" class="form-label">City</label>
                    <input value="{{ $company->city }}" 
                        type="text" 
                        class="form-control" 
                        name="city" 
                        placeholder="city" required>

                    @if ($errors->has('city'))
                        <span class="text-danger text-left">{{ $errors->first('city') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="abbr" class="form-label">Email</label>
                    <input value="{{ $company->email }}" 
                        type="text" 
                        class="form-control" 
                        name="email" 
                        placeholder="email" required>

                    @if ($errors->has('email'))
                        <span class="text-danger text-left">{{ $errors->first('email') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="abbr" class="form-label">Phone No</label>
                    <input value="{{ $company->phone_no }}" 
                        type="text" 
                        class="form-control" 
                        name="phone_no" 
                        placeholder="phone_no" required>

                    @if ($errors->has('abbr'))
                        <span class="text-danger text-left">{{ $errors->first('phone_no') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <div class="col-md-12">
                        <label for="abbr" class="form-label">Icon File</label>
                    </div>
                    <div class="col-md-12">
                        <a href="/images/user-files/{{ $company->icon_file }}" target="_blank"><img id="photo_preview" src="/images/user-files/{{ $company->icon_file }}" width="100" height="100" class="rounded float-start" alt="..."></a>
                    </div>
                    <div class="col-md-12">
                        <input 
                        type="file" 
                        class="form-control" 
                        name="icon_file" id="icon_file" onchange="previewFile(this);"
                        placeholder="icon_file">
                    </div>
                    @if ($errors->has('abbr'))
                        <span class="text-danger text-left">{{ $errors->first('icon_file') }}</span>
                    @endif
                </div>

                <button type="submit" class="btn btn-primary">Save company</button>
                <a href="{{ route('company.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection
@push('scripts')
<script type="text/javascript">
    function previewFile(input){
        var file = $("#icon_file").get(0).files[0];
 
        if(file){
            var reader = new FileReader();
 
            reader.onload = function(){
                $("#photo_preview").attr("src", reader.result);
            }
 
            reader.readAsDataURL(file);
        }
    }
</script>
@endpush