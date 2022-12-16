<div class="dropdown-menu dropdown-menu-end me-1">
	<a href="{{ route('users.edit', auth()->user()->id ) }}" class="dropdown-item">@lang('home.profile')</a>
	<div class="dropdown-divider"></div>
	@auth
		<a href="{{ route('logout.perform') }}" class="dropdown-item">@lang('home.logout')</a>
	@endauth
</div>