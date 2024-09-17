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
                        placeholder="@lang('general.lbl_phoneno')">

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
                    <label class="form-label">@lang('general.lbl_segment')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="segment_id">
                            <option value="">@lang('general.lbl_segmentselect')</option>
                            @foreach($segments as $segment)
                                <option value="{{ $segment->id }}">{{  $segment->remark }}</option>
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
                        placeholder="@lang('general.lbl_city')">

                    @if ($errors->has('city'))
                        <span class="text-danger text-left">{{ $errors->first('city') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="whatsapp_no" class="form-label">@lang('general.lbl_whatsapp_no')</label>
                    <input value="{{ old('whatsapp_no') }}" 
                        type="text" 
                        class="form-control" 
                        name="whatsapp_no" 
                        placeholder="@lang('general.lbl_whatsapp_no')">

                    @if ($errors->has('whatsapp_no'))
                        <span class="text-danger text-left">{{ $errors->first('whatsapp_no') }}</span>
                    @endif
                </div>
                

                <div class="mb-3">
                    <label for="external_code" class="form-label">@lang('general.lbl_external_code')</label>
                    <input value="{{ old('external_code') }}" 
                        type="text" 
                        class="form-control" 
                        name="external_code" 
                        placeholder="@lang('general.lbl_external_code')">

                    @if ($errors->has('external_code'))
                        <span class="text-danger text-left">{{ $errors->first('external_code') }}</span>
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