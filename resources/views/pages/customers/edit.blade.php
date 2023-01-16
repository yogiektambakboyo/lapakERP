@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_edit_customer')</h2>
        <div class="container mt-4">

            <form method="POST" action="{{ route('customers.update', $customer->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ $customer->name }}" 
                        type="text" 
                        class="form-control" 
                        name="name" 
                        placeholder="@lang('general.lbl_name')"  required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">@lang('general.lbl_address')</label>
                    <input value="{{ $customer->address }}" 
                        type="text" 
                        class="form-control" 
                        name="address" 
                        placeholder="@lang('general.lbl_address')"  required>

                    @if ($errors->has('address'))
                        <span class="text-danger text-left">{{ $errors->first('address') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">@lang('general.lbl_phoneno')</label>
                    <input value="{{ $customer->phone_no }}" 
                        type="text" 
                        class="form-control" 
                        name="phone_no" 
                        placeholder="@lang('general.lbl_phoneno')"  required>

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
                                <option value="{{ $branch->id }}"  @if($branch->id == $customer->branch_id) selected @endif>{{  $branch->remark }}</option>
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
                                <option value="{{ $seller->id }}"  @if($seller->id == $customer->sales_id) selected @endif>{{  $seller->name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="city" class="form-label">@lang('general.lbl_city')</label>
                    <input value="{{ $customer->city }}" 
                        type="text" 
                        class="form-control" 
                        name="city" 
                        placeholder="@lang('general.lbl_city')" >

                    @if ($errors->has('city'))
                        <span class="text-danger text-left">{{ $errors->first('city') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="credit_limit" class="form-label">@lang('general.lbl_credit_limit')</label>
                    <input value="{{  $customer->credit_limit }}" 
                        type="text" 
                        class="form-control" 
                        name="credit_limit" 
                        placeholder="@lang('general.lbl_credit_limit')" >

                    @if ($errors->has('credit_limit'))
                        <span class="text-danger text-left">{{ $errors->first('credit_limit') }}</span>
                    @endif
                </div>


                <div class="mb-3">
                    <label for="longitude" class="form-label">@lang('general.lbl_longitude')</label>
                    <input value="{{  $customer->longitude }}" 
                        type="text" 
                        class="form-control" 
                        name="longitude" 
                        placeholder="@lang('general.lbl_longitude')" >

                    @if ($errors->has('longitude'))
                        <span class="text-danger text-left">{{ $errors->first('longitude') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="latitude" class="form-label">@lang('general.lbl_latitude')</label>
                    <input value="{{  $customer->latitude }}" 
                        type="text" 
                        class="form-control" 
                        name="latitude" 
                        placeholder="@lang('general.lbl_latitude')" >

                    @if ($errors->has('latitude'))
                        <span class="text-danger text-left">{{ $errors->first('latitude') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">@lang('general.lbl_email')</label>
                    <input value="{{  $customer->email }}" 
                        type="text" 
                        class="form-control" 
                        name="email" 
                        placeholder="@lang('general.lbl_email')" >

                    @if ($errors->has('email'))
                        <span class="text-danger text-left">{{ $errors->first('email') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="handphone" class="form-label">@lang('general.lbl_handphone')</label>
                    <input value="{{  $customer->handphone }}" 
                        type="text" 
                        class="form-control" 
                        name="handphone" 
                        placeholder="@lang('general.lbl_handphone')" >

                    @if ($errors->has('handphone'))
                        <span class="text-danger text-left">{{ $errors->first('handphone') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="whatsapp_no" class="form-label">@lang('general.lbl_whatsapp_no')</label>
                    <input value="{{  $customer->whatsapp_no }}" 
                        type="text" 
                        class="form-control" 
                        name="whatsapp_no" 
                        placeholder="@lang('general.lbl_whatsapp_no')" >

                    @if ($errors->has('whatsapp_no'))
                        <span class="text-danger text-left">{{ $errors->first('whatsapp_no') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="citizen_id" class="form-label">@lang('general.lbl_citizen_id')</label>
                    <input value="{{  $customer->citizen_id }}" 
                        type="text" 
                        class="form-control" 
                        name="citizen_id" 
                        placeholder="@lang('general.lbl_citizen_id')" >

                    @if ($errors->has('citizen_id'))
                        <span class="text-danger text-left">{{ $errors->first('citizen_id') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="tax_id" class="form-label">@lang('general.lbl_tax_id')</label>
                    <input value="{{  $customer->tax_id }}" 
                        type="text" 
                        class="form-control" 
                        name="tax_id" 
                        placeholder="@lang('general.lbl_tax_id')" >

                    @if ($errors->has('tax_id'))
                        <span class="text-danger text-left">{{ $errors->first('tax_id') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="contact_person" class="form-label">@lang('general.lbl_contactperson')</label>
                    <input value="{{  $customer->contact_person }}" 
                        type="text" 
                        class="form-control" 
                        name="contact_person" 
                        placeholder="@lang('general.lbl_contactperson')" >

                    @if ($errors->has('contact_person'))
                        <span class="text-danger text-left">{{ $errors->first('contact_person') }}</span>
                    @endif
                </div>
                
                <div class="mb-3">
                    <label for="type" class="form-label">@lang('general.lbl_type')</label>
                    <input value="{{  $customer->type }}" 
                        type="text" 
                        class="form-control" 
                        name="type" 
                        placeholder="@lang('general.lbl_type')" >

                    @if ($errors->has('type'))
                        <span class="text-danger text-left">{{ $errors->first('type') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="clasification" class="form-label">@lang('general.lbl_clasification')</label>
                    <input value="{{  $customer->type }}" 
                        type="text" 
                        class="form-control" 
                        name="clasification" 
                        placeholder="@lang('general.lbl_clasification')" >

                    @if ($errors->has('clasification'))
                        <span class="text-danger text-left">{{ $errors->first('clasification') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="contact_person_job_position" class="form-label">@lang('general.lbl_contact_person_job_position')</label>
                    <input value="{{  $customer->contact_person_job_position }}" 
                        type="text" 
                        class="form-control" 
                        name="contact_person_job_position" 
                        placeholder="@lang('general.lbl_contact_person_job_position')" >

                    @if ($errors->has('contact_person_job_position'))
                        <span class="text-danger text-left">{{ $errors->first('contact_person_job_position') }}</span>
                    @endif
                </div>
                <div class="mb-3">
                    <label for="contact_person_level" class="form-label">@lang('general.lbl_contact_person_level')</label>
                    <input value="{{  $customer->contact_person_level }}" 
                        type="text" 
                        class="form-control" 
                        name="contact_person_level" 
                        placeholder="@lang('general.lbl_contact_person_level')" >

                    @if ($errors->has('contact_person_level'))
                        <span class="text-danger text-left">{{ $errors->first('contact_person_level') }}</span>
                    @endif
                </div>

               <div class="row mb-3">

                    <div class="col-md-6">
                        <label class="form-label col-form-label col-md-4">@lang('general.lbl_visit_day')</label>
                        <div class="form-check">
                            <input class="form-check-input"   name="input_day" type="radio" value="Monday" id="input_day_mon"  @if($customer->visit_day == "Monday") checked @endif>
                            <label class="form-check-label" for="input_day_mon">Senin</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"  name="input_day"  type="radio" value="Tuesday" id="input_day_tue"  @if($customer->visit_day == "Tuesday") checked @endif>
                            <label class="form-check-label" for="input_day_tue">Selasa</label>
                        </div>

                        <div class="form-check">
                            <label class="form-check-label" for="input_day_wed">Rabu</label>
                            <input class="form-check-input"   name="input_day" type="radio" value="Wednesday" id="input_day_wed"   @if($customer->visit_day == "Wednesday") checked @endif>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"  name="input_day"  type="radio" value="Thursday" id="input_day_thu"   @if($customer->visit_day == "Thursday") checked @endif>
                        <label class="form-check-label" for="input_day_thu">Kamis</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"  name="input_day"  type="radio" value="Friday" id="input_day_fri"  @if($customer->visit_day == "Friday") checked @endif>
                            <label class="form-check-label" for="input_day_fri">Jum'at</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"  name="input_day"  type="radio" value="Saturday" id="input_day_sab"  @if($customer->visit_day == "Saturday") checked @endif>
                            <label class="form-check-label" for="input_day_sab">Sabtu</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input"   name="input_day" type="radio" value="Sunday" id="input_day_sun"  @if($customer->visit_day == "Sunday") checked @endif>
                            <label class="form-check-label" for="input_day_sun">Minggu</label>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label col-form-label col-md-4">@lang('general.lbl_visit_week')</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="1" id="input_week_1"  @if(str_contains($customer->visit_week,"1")) checked @endif>
                            <label class="form-check-label" for="input_week_1">
                            Minggu 1
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="2" id="input_week_2"  @if(str_contains($customer->visit_week,"2")) checked @endif>
                            <label class="form-check-label" for="input_week_2">
                            Minggu 2
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="3" id="input_week_3"  @if(str_contains($customer->visit_week,"3")) checked @endif>
                            <label class="form-check-label" for="input_week_3">
                            Minggu 3
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="4" id="input_week_4"  @if(str_contains($customer->visit_week,"4")) checked @endif>
                            <label class="form-check-label" for="input_week_4">
                            Minggu 4
                            </label>
                        </div>
                    </div>

                    <input type="hidden" id="input_week" name="input_week" value="{{  $customer->input_week }}">

               </div>


           
                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('customers.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection