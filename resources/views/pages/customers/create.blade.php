@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Customer')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_customer_new')</h2>


        <div class="container mt-4">

            <form method="POST" action="{{ route('customers.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ old('name') }}" 
                        type="text" 
                        class="form-control" 
                        name="name" 
                        placeholder="@lang('general.lbl_name')" required>

                    @if ($errors->has('remark'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">@lang('general.lbl_address')</label>
                    <input value="{{ old('address') }}" 
                        type="text" 
                        class="form-control" 
                        name="address" 
                        placeholder="@lang('general.lbl_address')" required>

                    @if ($errors->has('address'))
                        <span class="text-danger text-left">{{ $errors->first('address') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">@lang('general.lbl_phoneno')</label>
                    <input value="{{ old('phone_no') }}" 
                        type="text" 
                        class="form-control" 
                        name="phone_no" 
                        placeholder="@lang('general.lbl_phoneno')" required>

                    @if ($errors->has('phone_no'))
                        <span class="text-danger text-left">{{ $errors->first('phone_no') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_seller')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="sales_id">
                            <option value="">@lang('general.lbl_sellerselect')</option>
                            @foreach($sellers as $seller)
                                <option value="{{ $seller->id }}">{{  $seller->name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="city" class="form-label">@lang('general.lbl_city')</label>
                    <input value="{{ old('city') }}" 
                        type="text" 
                        class="form-control" 
                        name="city" 
                        placeholder="@lang('general.lbl_city')" required>

                    @if ($errors->has('city'))
                        <span class="text-danger text-left">{{ $errors->first('city') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="credit_limit" class="form-label">@lang('general.lbl_credit_limit')</label>
                    <input value="{{ old('credit_limit') }}" 
                        type="text" 
                        class="form-control" 
                        name="city" 
                        placeholder="@lang('general.lbl_credit_limit')" required>

                    @if ($errors->has('credit_limit'))
                        <span class="text-danger text-left">{{ $errors->first('credit_limit') }}</span>
                    @endif
                </div>


                <div class="mb-3">
                    <label for="longitude" class="form-label">@lang('general.lbl_longitude')</label>
                    <input value="{{ old('longitude') }}" 
                        type="text" 
                        class="form-control" 
                        name="longitude" 
                        placeholder="@lang('general.lbl_longitude')" required>

                    @if ($errors->has('longitude'))
                        <span class="text-danger text-left">{{ $errors->first('longitude') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="latitude" class="form-label">@lang('general.lbl_latitude')</label>
                    <input value="{{ old('latitude') }}" 
                        type="text" 
                        class="form-control" 
                        name="latitude" 
                        placeholder="@lang('general.lbl_latitude')" required>

                    @if ($errors->has('latitude'))
                        <span class="text-danger text-left">{{ $errors->first('latitude') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">@lang('general.lbl_email')</label>
                    <input value="{{ old('credit_limit') }}" 
                        type="text" 
                        class="form-control" 
                        name="email" 
                        placeholder="@lang('general.lbl_email')" required>

                    @if ($errors->has('email'))
                        <span class="text-danger text-left">{{ $errors->first('email') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="handphone" class="form-label">@lang('general.lbl_handphone')</label>
                    <input value="{{ old('handphone') }}" 
                        type="text" 
                        class="form-control" 
                        name="handphone" 
                        placeholder="@lang('general.lbl_handphone')" required>

                    @if ($errors->has('handphone'))
                        <span class="text-danger text-left">{{ $errors->first('handphone') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="whatsapp_no" class="form-label">@lang('general.lbl_whatsapp_no')</label>
                    <input value="{{ old('whatsapp_no') }}" 
                        type="text" 
                        class="form-control" 
                        name="whatsapp_no" 
                        placeholder="@lang('general.lbl_whatsapp_no')" required>

                    @if ($errors->has('whatsapp_no'))
                        <span class="text-danger text-left">{{ $errors->first('whatsapp_no') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="citizen_id" class="form-label">@lang('general.lbl_citizen_id')</label>
                    <input value="{{ old('citizen_id') }}" 
                        type="text" 
                        class="form-control" 
                        name="citizen_id" 
                        placeholder="@lang('general.lbl_citizen_id')" required>

                    @if ($errors->has('citizen_id'))
                        <span class="text-danger text-left">{{ $errors->first('citizen_id') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="tax_id" class="form-label">@lang('general.lbl_tax_id')</label>
                    <input value="{{ old('tax_id') }}" 
                        type="text" 
                        class="form-control" 
                        name="tax_id" 
                        placeholder="@lang('general.lbl_tax_id')" required>

                    @if ($errors->has('tax_id'))
                        <span class="text-danger text-left">{{ $errors->first('tax_id') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="contact_person" class="form-label">@lang('general.lbl_contactperson')</label>
                    <input value="{{ old('contact_person') }}" 
                        type="text" 
                        class="form-control" 
                        name="contact_person" 
                        placeholder="@lang('general.lbl_contactperson')" required>

                    @if ($errors->has('contact_person'))
                        <span class="text-danger text-left">{{ $errors->first('contact_person') }}</span>
                    @endif
                </div>
                
                <div class="mb-3">
                    <label for="type" class="form-label">@lang('general.lbl_type')</label>
                    <input value="{{ old('type') }}" 
                        type="text" 
                        class="form-control" 
                        name="clasification" 
                        placeholder="@lang('general.lbl_type')" required>

                    @if ($errors->has('type'))
                        <span class="text-danger text-left">{{ $errors->first('type') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="contact_person_job_position" class="form-label">@lang('general.lbl_contact_person_job_position')</label>
                    <input value="{{ old('contact_person_job_position') }}" 
                        type="text" 
                        class="form-control" 
                        name="contact_person_job_position" 
                        placeholder="@lang('general.lbl_contact_person_job_position')" required>

                    @if ($errors->has('contact_person_job_position'))
                        <span class="text-danger text-left">{{ $errors->first('contact_person_job_position') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="contact_person_level" class="form-label">@lang('general.lbl_contact_person_level')</label>
                    <input value="{{ old('contact_person_level') }}" 
                        type="text" 
                        class="form-control" 
                        name="contact_person_level" 
                        placeholder="@lang('general.lbl_contact_person_level')" required>

                    @if ($errors->has('contact_person_level'))
                        <span class="text-danger text-left">{{ $errors->first('contact_person_level') }}</span>
                    @endif
                </div>

               <div class="row mb-3">

                    <div class="col-md-6">
                        <label class="form-label col-form-label col-md-4">@lang('general.lbl_visit_day')</label>
                        <div class="form-check">
                            <input class="form-check-input"   name="input_day" type="radio" value="Monday" id="input_day_mon">
                            <label class="form-check-label" for="input_day_mon">Senin</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"  name="input_day"  type="radio" value="Tuesday" id="input_day_tue">
                            <label class="form-check-label" for="input_day_tue">Selasa</label>
                        </div>

                        <div class="form-check">
                            <label class="form-check-label" for="input_day_wed">Rabu</label>
                            <input class="form-check-input"   name="input_day" type="radio" value="Wednesday" id="input_day_wed">
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"  name="input_day"  type="radio" value="Thursday" id="input_day_thu">
                        <label class="form-check-label" for="input_day_thu">Kamis</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"  name="input_day"  type="radio" value="Friday" id="input_day_fri">
                            <label class="form-check-label" for="input_day_fri">Jum'at</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"  name="input_day"  type="radio" value="Saturday" id="input_day_sab">
                            <label class="form-check-label" for="input_day_sab">Sabtu</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"   name="input_day" type="radio" value="Sunday" id="input_day_sun">
                            <label class="form-check-label" for="input_day_sun">Minggu</label>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label col-form-label col-md-4">@lang('general.lbl_visit_week')</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="1" id="input_week_1">
                            <label class="form-check-label" for="input_week_1">
                            Minggu 1
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="2" id="input_week_2">
                            <label class="form-check-label" for="input_week_2">
                            Minggu 2
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="3" id="input_week_3">
                            <label class="form-check-label" for="input_week_3">
                            Minggu 3
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="4" id="input_week_4">
                            <label class="form-check-label" for="input_week_4">
                            Minggu 4
                            </label>
                        </div>
                    </div>

                    <input type="hidden" id="input_week" name="input_week">

               </div>
                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('customers.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection

@push('scripts')
    <script type="text/javascript">
    
    $('#input_day_mon').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_tue').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_wed').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_thu').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_fri').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_sab').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_sun').on('change', function() {
            $('#input_day').val(this.value);
        });

        $('#input_week_1').on('change', function() {
            var weekchecked = "";
            if($('#input_week_1').is(':checked')){
                weekchecked = weekchecked + "1";
            }
            if($('#input_week_2').is(':checked')){
                weekchecked = weekchecked + "2";
            }
            if($('#input_week_3').is(':checked')){
                weekchecked = weekchecked + "3";
            }
            if($('#input_week_4').is(':checked')){
                weekchecked = weekchecked + "4";
            }
            $('#input_week').val(weekchecked);
        });
        $('#input_week_2').on('change', function() {
            var weekchecked = "";
            if($('#input_week_1').is(':checked')){
                weekchecked = weekchecked + "1";
            }
            if($('#input_week_2').is(':checked')){
                weekchecked = weekchecked + "2";
            }
            if($('#input_week_3').is(':checked')){
                weekchecked = weekchecked + "3";
            }
            if($('#input_week_4').is(':checked')){
                weekchecked = weekchecked + "4";
            }
            $('#input_week').val(weekchecked);
        });
        $('#input_week_3').on('change', function() {
            var weekchecked = "";
            if($('#input_week_1').is(':checked')){
                weekchecked = weekchecked + "1";
            }
            if($('#input_week_2').is(':checked')){
                weekchecked = weekchecked + "2";
            }
            if($('#input_week_3').is(':checked')){
                weekchecked = weekchecked + "3";
            }
            if($('#input_week_4').is(':checked')){
                weekchecked = weekchecked + "4";
            }
            $('#input_week').val(weekchecked);
        });
        $('#input_week_4').on('change', function() {
            var weekchecked = "";
            if($('#input_week_1').is(':checked')){
                weekchecked = weekchecked + "1";
            }
            if($('#input_week_2').is(':checked')){
                weekchecked = weekchecked + "2";
            }
            if($('#input_week_3').is(':checked')){
                weekchecked = weekchecked + "3";
            }
            if($('#input_week_4').is(':checked')){
                weekchecked = weekchecked + "4";
            }
            $('#input_week').val(weekchecked);
        });


    </script>
@endpush